<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@include file="path.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="renderer" content="webkit">
<script type="text/javascript" src="<%=staticPath %>/assets/js/jquery-1.8.3.min.js"></script>
<%--<script type="text/javascript" src="<%=staticPath %>/assets/js/bootstrap.min.js"></script>--%>
<!--[if lt IE 9]>
	<script src="<%=staticPath %>/assets/js/css3-mediaqueries.js"></script>
<![endif]-->
<%-- <script src="<%=ctx %>/assets/js/jquery-1.8.3.js"></script>
 --%>
<!-- layer -->
<script type="text/javascript" src="<%=staticPath %>/assets/js/layer/layer.js"></script>
<script type="text/javascript" src="<%=staticPath %>/assets/js/layer/extend/layer.ext.js"></script>
<script type="text/javascript" src="<%=staticPath %>/assets/js/layer/extend/layer.component.ext.js"></script>
<script type="text/javascript" src="<%=staticPath %>/assets/js/layer/message.js?201511031"></script>

<script src="<%=staticPath %>/assets/js/jquery-ui/jquery-ui-1.9.2.custom.min.js"></script>

<script type="text/javascript" src="<%=staticPath %>/assets/js/frameTab.js?201510271"></script>

<script type="text/javascript" src="<%=staticPath %>/assets/js/jquery.autoTextarea.js"></script>
<!-- 验证 -->
<script src="<%=staticPath %>/assets/js/jquery.validate.min.js"></script>
 <%--<script src="<%=staticPath %>/assets/js/validate/numInput.js"></script>--%>
<script src="<%=staticPath %>/assets/js/validate/jquery-Validate_expand.js"></script>
<script src="<%=staticPath %>/assets/js/validate/messages_zh.min.js"></script>
<!-- 日期 -->
<script type="text/javascript" src="<%=staticPath %>/assets/js/My97DatePicker/WdatePicker.js"></script>
<!-- 表单 -->
<script type="text/javascript" src="<%=staticPath %>/assets/js/jquery-form.js"></script>
<!-- 通用函数 -->
<script type="text/javascript" src="<%=staticPath %>/assets/js/template.js"></script>
<script type="text/javascript" src="<%=staticPath %>/assets/js/ym-utils.js"></script>
<script type="text/javascript" src="<%=staticPath %>/assets/js/chinese.numeric.js"></script>
<script type="text/javascript" src="<%=staticPath %>/assets/js/utils/download.js"></script>
<script type="text/javascript" src="<%=staticPath %>/assets/js/underscore-min.js"></script>
<%--<link href="<%=staticPath%>/assets/css/bootstrap.css" rel="stylesheet" />
<%--<link href="<%=staticPath%>/assets/css/bootstrap-theme.css" rel="stylesheet" />--%>
<!-- 框架样式 -->
<link href="<%=staticPath %>/assets/css/buttons.css" rel="stylesheet" />
<link href="<%=staticPath %>/assets/css/reset.css" rel="stylesheet" />
<link href="<%=staticPath %>/assets/css/frame.css" rel="stylesheet" />

<link href="<%=staticPath %>/assets/css/common.css" rel="stylesheet" />
<link href="<%=staticPath%>/assets/css/product/product_label.css" rel="stylesheet" />
<link href="<%=staticPath%>/assets/css/sales/sale_textarea.css" rel="stylesheet" />
<!-- autoComplete -->
<link href="<%=staticPath%>/assets/css/supplier/supplier.css" rel="stylesheet" />  
<link rel="stylesheet" href="<%=staticPath %>/assets/css/jquery-ui/jquery-ui-1.9.2.custom.min.css">
<link rel="stylesheet" href="<%=staticPath%>/assets/css/pulldown.css"/>
<script type="text/javascript" src="<%=staticPath %>/assets/js/largetab.js"></script>
<script type="text/javascript" src="<%=staticPath %>/assets/js/jquery.freezeheader.js"></script>
    <script type="text/javascript">
    //下拉列表js 可放到公用js文件
    	$(function  () {
    		$(".btn-show").live("click",function  (e) {
   				$(this).parent(".tab-operate").toggleClass("open").closest("tr").siblings().find(".tab-operate").removeClass("open");
   				$(this).next(".btn-hide").find("a").click(function  () {
   					$(".tab-operate").removeClass("open");
   				});
   				//window.event? window.event.cancelBubble = true : e.stopPropagation();
				return false;
    		})
  			$("a.disabled").attr("href","javascript:void(0)");
  			
			$(document).click(function() {	
				$(".tab-operate").removeClass("open"); 
			});
		})

    </script>
       
<script type="text/javascript">
window.onload=function(){
	//js防止重复提交表单
	var submitFlag=false;
	var submitObj=null;
    $("form").submit(function(e){
    	if(submitFlag==false){
    		submitObj = $(this).find(":submit"); 
    		submitObj.attr("disabled","disabled");
	    	setTimeout(function(){submitObj.removeAttr("disabled");},1000);    			
	    	return true;
    	}
    	return false;
    });
}
		$(function () {
	        $(".w_textarea").autoTextarea({ minHeight: 70 });
//	        $(".w_textarea1").autoTextarea({ minHeight: 60 });
			//表格行点击变色
			$(".w_table tbody tr[class!='footer']").live("click",function () {
				$(this).addClass("active").siblings("tr").removeClass("active");
			})
	    });

	function newWindow(desc ,url) {
		top.addTab(desc, url);
	}
    function closeWindow() {
        var selected = $(top.document).find('#sysMenuTab li[class*="select"]').children('em');
        top.barClose(selected);
    }
//     function refreshWindow(title, url){
//         var selected = $(top.document).find('#sysMenuTab li[class="select"]');
//         selected.on('click', function(){
//             $(this).addClass("select").siblings().removeClass("select");
//             barActive(title);
//         });

//         var index = selected.attr('frmindex');
//         top.tabArray[index][2] = title;
//         selected.children('span').html(title);
//         window.location = url;
//     }
    function refreshWindow(title, url){
        //如果有url，则按url刷新title对应页，如没有url，则刷新title页
		if(url){
            var selected = $(top.document).find('#sysMenuTab li[class*="select"]');
            selected.on('click', function(){
                $(this).addClass("select").siblings().removeClass("select");
                barActive(title);
            });
            var index = selected.attr('frmindex');
            top.tabArray[index][2] = title;
            selected.children('span').html(title);
            //window.location = url;
            top.document.getElementById('mainFrame' + index).contentWindow.location=url;
            //$(top).find("#mainFrame"+index).attr("src",url);
		}else{
            var tabs = $(top.document).find('#sysMenuTab li').children('span');
            tabs.each(function(){
                if($(this).text() === title){
                    var index = $(this).parent().attr('frmindex');
                    top.document.getElementById('mainFrame' + index).contentWindow.location.reload(true);
                    //$('#mainFrame' + index, top).attr('src', $('#mainFrame' + index, top).attr('src'));
                }
            });
        }

    }
    var supplierMap = {
			'1':'toTravelagencyList.htm',
			'2':'toRestaurantList.htm',
			'3':'toHotelList.htm',
			'4':'toFleetList.htm',
			'5':'toScenicspotList.htm',
			'6':'toShoppingList.htm',
			'7':'toEntertainmentList.htm',
			'9':'toAirticketagentList.htm',
			'10':'toTrainticketagentList.htm',
			'11':'toGolfList.htm',
			'12':'toOtherList.htm',
			'15':'toInsuranceList.htm',
			'16':'toLocalTravelList.htm'
	};
    
    var lgTable = function(fixCols,tbWidth){
    	if(!fixCols){
    		fixCols=0;
    	}
		if(!tbWidth){
			return;
		}else{
			$(".LgTable").width(tbWidth);
		}
		var containerWidth = $(".p_container_sub").width();
		if(tbWidth <= containerWidth){
			$(".LgTable").removeClass("LgTable").css("width","100%");			
		}else{
			var dh = $(window).height()-$(".w_table").offset().top-65;
			FixTable("LgTable", fixCols, "auto", dh);	
		}
	}
    
    var fixHeader = function(cutHeight){
    	if(!cutHeight){
    		cutHeight = 80;
    	}
		var dh = $(window).height()-$(".w_table").offset().top-cutHeight;		
		var th = dh+"px";
		$("table.w_table").freezeHeader({ highlightrow: true,'height': th });	
    }
    
    /* 百度统计 */
    var _hmt = _hmt || [];
    (function() {
      var hm = document.createElement("script");
      hm.src = "//hm.baidu.com/hm.js?049f7397b8a8519aee23e94f0f816d2e";
      var s = document.getElementsByTagName("script")[0]; 
      s.parentNode.insertBefore(hm, s);
    })();
</script>
<script type="text/html" id="YihgErpWebLinkSelectProvince">
    <option value="">{{defaultLabel}}</option>
    {{each regions as region i }}
        <option value="{{region.id}}">{{region.name}}</option>
    {{/each}}
 </script> 

