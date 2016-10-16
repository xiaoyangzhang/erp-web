var tabCount = 50;   //总Tab数8个
var tabArray; //存储Tab的数组
var tabCurrentId = 0; //当前被激活的tab
var clickNum=new Array();//储存tab顺序

function barInit() {
    tabArray = new Array();
    for (var i = 0; i < tabCount; i++) {
        top.tabArray[i] = new Array(3); //iframe的id序号，是否显示(true/false)，菜单名称
        top.tabArray[i][0] = i;
        top.tabArray[i][1] = "false";
        top.tabArray[i][2] = "";
    }
    //printInfo();
    barNew('桌面', '');
}
function t(t) {
	var e = 0;
	return $(t).each(function() {
		e += $(this).outerWidth(!0)
	}), e
}

function e(e) {
	var a = t($(e).prevAll()),
		i = t($(e).nextAll()),
		n = t($(".content-tabs").children().not(".J_menuTabs")),
		s = $(".content-tabs").outerWidth(!0) - n,
		r = 0;
	if ($(".page-tabs-content").outerWidth() < s) r = 0;
	else if (i <= s - $(e).outerWidth(!0) - $(e).next().outerWidth(!0)) {
		if (s - $(e).next().outerWidth(!0) > i) {
			r = a;
			for (var o = e; r - $(o).outerWidth() > $(".page-tabs-content").outerWidth() - s;) r -= $(o).prev().outerWidth(), o = $(o).prev()
		}
	} else a > s - $(e).outerWidth(!0) - $(e).prev().outerWidth(!0) && (r = a - $(e).prev().outerWidth(!0));
	$(".page-tabs-content").animate({
		marginLeft: 0 - r + "px"
	}, "fast")
}
function addTab(menuName,menuUrl){
	if(menuName&&menuUrl){
		barNew(menuName,menuUrl);
	}else{
		alert("页签名称和链接不能为空");
	}
}

function barNew(menuName, menuUrl) {
    //若菜单存在，直接激活
    if (CheckIsExists(menuName)) {
        barActive(menuName,menuUrl);
        return;
    }

    //新增Tab
    var fid = -1;
    for (var i = 0; i < tabCount; i++) {
        if (top.tabArray[i][1] == "false") {
            fid = top.tabArray[i][0];
            top.tabArray[i][1] = "true";
            top.tabArray[i][2] = menuName;
            break;
        }
    }
    
    if (fid == -1) {
        $.warn('系统最多只能打开' + tabCount + '窗口！');
        return false;
    }

    var cont = "<li class='select J_menuTab' frmIndex='" + fid + "' lang='" + menuUrl + "'><span class='fl'>" + menuName + "</span>" + (fid == 0 ? "" : "<em class='icon del-icon'></em>") + "</li>";
    $("#sysMenuTab").append(cont);
    
	var ifr= "<iframe id='mainFrame"+fid+"' src='' frameborder='0' style='width: 100%; display: none;height:auto;'></iframe>"
	$(".right_Menu").append(ifr);
	onResize_AutoHeight();

    $("#mainFrame" + fid).attr("src", menuUrl);
    //新增Tab-绑定事件
    var $li = $("li[frmIndex=" + fid + "]");
    $li.live("click", function () {
        if ($("#mainFrame"+fid).attr("src")!=="") {
	        clickNum.push($("#mainFrame"+fid).attr("src"));
	        for (i=0;i<=clickNum.length;i++) {
				for (j=i+1;j<=clickNum.length;j++) {
					if (clickNum[i]==clickNum[j]) {
						clickNum.splice(i,1);
					}
				}
			}//去重       	
        }
        $(this).addClass("select").siblings().removeClass("select");   
        var name=$(this).find("span.fl").html();
        barActive(name);
    }).find(".del-icon").live('click', function (e) {
    	e.stopPropagation();
        barClose($(this));
    });

    //激活显示
    barActive(menuName,menuUrl);
}

function CheckIsExists(menuName) {
    var isExists = false;
    for (var i = 0; i < tabCount; i++) {
        if (top.tabArray[i][2] == menuName) {
            isExists = true;
            break;
        }
    }
    return isExists;
}


function barActive(menuName,menuUrl) {//激活Tab
    //printInfo();
    var barID = -1;
    for (var i = 0; i < tabCount; i++) {
        if (top.tabArray[i][2] == menuName) {
            barID = parseInt(top.tabArray[i][0]);
            break;
        }
    }
    tabCurrentId = barID;
   
    $("li[frmIndex=" + barID + "]").siblings().removeClass("select"); //tab样式切换到激活
    $("li[frmIndex=" + barID + "]").addClass("select");
    $("iframe[id*='mainFrame']").css("display", "none");
    $("#mainFrame" + barID).css("display", "block");
    
    if(menuUrl){
    	$("#mainFrame" + barID, top.document).attr("src", menuUrl);
    }
    if (menuUrl!=="") {
        clickNum.push(menuUrl);
        for (i=0;i<=clickNum.length;i++) {
			for (j=i+1;j<=clickNum.length;j++) {
				if (clickNum[i]==clickNum[j]) {
					clickNum.splice(i,1);
				}
			}
		}//去重       	
    }
}


function barClose(closeObj) {
    var frmIndex = $(closeObj).parent().attr("frmIndex"); //关闭的页面	    
	var mainFrame = document.getElementById("mainFrame" + frmIndex); //从置Url
	var $link=$(mainFrame).attr("src");
	for (i=0;i<=clickNum.length;i++) {
		if (clickNum[i]==$link) {
			clickNum.splice(i,1);
		}
	}
	if ($(closeObj).parent("li").hasClass("select")) {	

	    top.tabArray[frmIndex][1] = "false";
	    top.tabArray[frmIndex][2] = "";
	
	    $(closeObj).parent().remove();
	    $("#mainFrame" + frmIndex).remove();
	
	    //关闭同时激活之前的一个窗口
	    if (clickNum.length==0) {
	    	$("li[frmIndex=0]").click();
	    	$(".left_Menu dd a").removeClass("active");
	    } else{
		    $(".J_menuTab").each(function () {
		    	if ($(this).attr("lang")==clickNum[clickNum.length-1]) {
		    		$(this).click();
		    		e($(".J_menuTab.select"));  
		    	}
		    })	    	
	    }
	    
//	    var nextMenu = "";
//	    for (var i = frmIndex; i >= 0; i--) { //向前激活
//	        if (top.tabArray[i][2] != "") {
//	            nextMenu = top.tabArray[i][2];
//	            break;
//	        }
//	    }
//	
//	    if (nextMenu == "") {
//	        for (var i = frmIndex; i < tabCount; i++) { //向前激活
//	            if (top.tabArray[i][2] != "") {
//	                nextMenu = top.tabArray[i][2];
//	                break;
//	            }
//	        }
//	    }
//	    barActive(nextMenu);
		}else{  
			top.tabArray[frmIndex][1] = "false";
		    top.tabArray[frmIndex][2] = "";
		    $(closeObj).parent().remove();
		    $("#mainFrame" + frmIndex).remove();		    
//		    $(mainFrame).attr("src", "").css("display", "none");

		}
}



function printInfo() {
    var s = "";
    for (var i = 0; i < tabCount; i++) {
        s += top.tabArray[i][0] + "," + top.tabArray[i][1] + "," + top.tabArray[i][2] + "\r\n";
    }
    alert(s);
}

function setIfrimeHeight(docH) {
    //var wh = $(window).height();
    //docH = docH < wh ? wh : docH;
    //var frame = document.getElementById("mainFrame" + tabCurrentId);
    //$(frame).height(docH);
    alert('调用了:frameTab.js 方法：setIfrimeHeight');
    //由子窗品调用，用于消除iframe里的滚动条，把高度设置成与子页面一样   
    //子页面调用方式：window.onload = function () { window.parent.setIfrimeHeight($(document).height()); }
}

function onResize_AutoHeight() {
	//logo栏高度：45px    菜单Tab高度：47px
   /* var windowHeight;
    if (self.innerHeight) { // all except Explorer    
        windowHeight = self.innerHeight;
    } else {
        if (document.documentElement && document.documentElement.clientHeight) { // Explorer 6 Strict Mode    
            windowHeight = document.documentElement.clientHeight;
        } else {
            if (document.body) { // other Explorers    
                windowHeight = document.body.clientHeight;
            }
        }
    }
    
    var h = parseInt(windowHeight - 45 -47);
    $("iframe[id*='mainFrame']").css("height", h);*/
    //var wh = $(window).height();
    //var dh = $(document).height();
    //console.log('wh:'+wh+',dh:'+dh+',windowHeight:'+windowHeight);
	 var wh = $(window).height() - 45;
	    $(".left_Menu").height(wh);
	    $('.mbody iframe').height(wh-35);
}

/*
*/
function LeftNav() {
    //左侧菜单栏
    $(".left_Menu dt").toggle(function () {
        $(this).siblings("dd").slideDown(300)
        $(this).find("em").eq(0).removeClass("menu-icon").addClass("select")
        $(this).find("span").eq(0).addClass("select-word")
        $(this).find("em").eq(1).removeClass("sel-down").addClass("sel-up")
    }, function () {
        $(this).siblings("dd").slideUp(300)
        $(this).find("em").eq(0).addClass("menu-icon").removeClass("select")
        $(this).find("span").eq(0).removeClass("select-word")
        $(this).find("em").eq(1).addClass("sel-down").removeClass("sel-up")
    });

    $(".left_Menu dd a").attr("href", "javascript:void(0)").bind("click", function () {

        //$(this).closest("dl").find("a").removeClass("active");
    	$(".left_Menu").find("a").removeClass("active");
        $(this).addClass("active");

        barNew($(this).attr("title"), $(this).attr("lang"));
        e($(".J_menuTab.select"));  
    });
}

function headSlide() {
    //head下拉
    $(".sms").hover(function () {
        $(this).find(".newDown").stop().slideDown()
    }, function () {
        $(this).find(".newDown").stop().slideUp()
    })
    $(".name").hover(function () {
        $(this).find(".nameDown").stop().slideDown()
    }, function () {
        $(this).find(".nameDown").stop().slideUp()
    })
}

function get_MainContainerHeight(){
	var h = $(window).height() - 45 -35;
	//header=45px, menuTab=35px
	return h;
} 

setInterval("onResize_AutoHeight();", 5000);
