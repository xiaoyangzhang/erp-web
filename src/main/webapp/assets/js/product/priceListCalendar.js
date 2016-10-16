
function calender(pid, cyear, cmonth, divid, exec, lid, did) {
    var d, d_date, d_day, d_month;
    //定义每月天数数组
    var monthdates = ["31", "28", "31", "30", "31", "30", "31", "31", "30", "31", "30", "31"]
    d = new Date();
    d_year = d.getYear();      //获取年份
    //判断闰月，把monthdates的二月改成29
    if (((d_year % 4 == 0) && (d_year % 100 != 0)) || (d_year % 400 == 0)) monthdates[1] = "29";

    if ((cyear != "") || (cmonth != "")) {
        //如果用户选择了月份和年份，则当前的时间改为用户设定
        d.setYear(cyear);
        d.setDate(1);
        d.setMonth(cmonth - 1);
    }
    d_month = d.getMonth();    //获取当前是第几个月
    d_year = d.getYear();      //获取年份
    d_date = d.getDate();      //获取日期

    //修正19XX年只显示两位的错误
    if (d_year < 2000) { d_year = d_year + 1900 }
    //===========输出日历===========
    var str;
    str = "<table cellspacing='0' cellpadding='0' id='calender'>";
    str += "<tr><td class='cal_title' colspan='7' >"
    str += changecal("premonth", pid, d_year, d_month, divid, exec, lid, did);
    str += d_year + "年" + (d_month * 1 + 1) + "月";
    str += changecal("nextmonth", pid, d_year, d_month, divid, exec, lid, did);
    str += "</td></tr>";
    str += "<tr id='week'><td>日</td><td>一</td><td>二</td><td>三</td><td>四</td><td>五</td><td>六</td></tr>";
    str += "<tr>";

    var firstday, lastday, totalcounts, firstspace, lastspace, monthdays;
    //需要显示的月份共有几天，可以用已定义的数组来获取
    monthdays = monthdates[d.getMonth()];

    //设定日期为月份中的第一天
    d.setDate(1);

    //需要显示的月份的第一天是星期几
    firstday = d.getDay();

    //1号前面需要补足的的空单元格的数
    firstspace = firstday;

    //设定日期为月份的最后一天
    d.setDate(monthdays);

    //需要显示的月份的最后一天是星期几
    lastday = d.getDay();

    //最后一天后面需要空单元格数
    lastspace = 6 - lastday;

    //前空单元格+总天数+后空单元格，用来控制循环
    totalcounts = firstspace * 1 + monthdays * 1 + lastspace * 1;


    //count：大循环的变量;f_space:输出前空单元格的循环变量;l_space:用于输出后空单元格的循环变量
    var count, flag, f_space, l_space;
    //flag：前空单元格输完后令flag=1不再继续做这个小循环
    flag = 0;
    for (count = 1; count <= totalcounts; count++) {
        //一开始flag=0，首先输出前空单元格，输完以后flag=1，以后将不再执行这个循环
        if (flag == 0) {
            if (firstspace != 0) {
                for (f_space = 1; f_space <= firstspace; f_space++) {
                    str += "<td> </td>";
                    if (f_space != firstspace) count++;
                }
                flag = 1;
                continue;
            }
        }

        if ((count - firstspace) <= monthdays) {
            //输出月份中的所有天数            
            curday = d_year + "," + (d_month * 1 + 1) + "," + (count - firstspace) + "|"
            linkday = d_year + "," + (d_month * 1 + 1) + "," + (count - firstspace)
            var today = new Date();
            if ((d_year == today.getYear()) && (d_month == today.getMonth()) && ((count - firstspace) == today.getDate())) {
                //将本地系统中的当前天数高亮
                str += "<td><div class='current'>" + (count - firstspace) + "</div></td>";
            } else {
                //不用高亮的部分,没有日志
                var ds1 = count - firstspace; if (parseInt(ds1) < 10) ds1 = "0" + ds1;
                var ds2 = d_month * 1 + 1; if (parseInt(ds2) < 10) ds2 = "0" + ds2;
                var dStr = d_year + "-" + ds2 + "-" + ds1;
                str += "<td class='lg_d' val='" + (count - firstspace) + "' lang='" + dStr + "'>" + (count - firstspace) + "<p class='calendar_price'>&nbsp;&nbsp;&nbsp;&nbsp;</p><p class='calendar_number'>&nbsp;&nbsp;&nbsp;&nbsp;</p></td>";
            }

            if (count % 7 == 0) {
                if (count < totalcounts) {
                    str += "</tr><tr>";
                } else {
                    str += "</tr>";
                }
            }
        } else {
            //如果已经输出了月份中的最后一天，就开始输出后空单元格补足
            for (l_space = 1; l_space <= lastspace; l_space++) {
                str += "<td> </td>";
                if (l_space != lastspace) count++;
            }
            continue;
        }
    }
    str += "</table>"

    document.getElementById(divid).innerHTML = str;
    var currentDate = d_year + '-' + (d_month * 1 + 1) + '-' + '01';
    if (exec.indexOf('0') > -1) getCalendarPrice(pid, divid, currentDate, exec, lid, did);
    if (exec.indexOf('1') > -1) getCalendarPrice(pid, divid, currentDate, exec, lid, did);
    if (exec.indexOf('2') > -1) setSelectOption(divid);
    if (exec.indexOf('3') > -1) getPriceSale(pid, divid, currentDate, exec, lid, did);
}

function setSelectOption(divID) {
    $("#" + divID + " td[class*='lg_d']").each(function () {
        $(this).bind("click", function () {
            var cls = $(this).attr("class");
            if (cls.indexOf("cal_active") > -1)
                $(this).removeClass("cal_active");
            else
                $(this).addClass("cal_active");
        });
    });
}
function getCalendarPrice(pid, divID, currentDate, exec, lid, did) {
    $.ajax({
        type: "POST",
        dataType: "text",
        url: '/ShareAjaxHandle/ProductDate.ashx',
        data: "st=calendarPrice&currentDate=" + currentDate + "&proID=" + pid + "&lineID=" + lid + "&departureID=" + did,
        success: function (data) {
            var jsonData = eval("(" + data + ")");
            for (var i = 0; i < jsonData.Head.length; i++) {
                var data = jsonData.Head[i];
                var dateAry = data.ProductDate.split('-');
                if (dateAry[2] == '01') dateAry[2] = '1'; if (dateAry[2] == '02') dateAry[2] = '2'; if (dateAry[2] == '03') dateAry[2] = '3';
                if (dateAry[2] == '04') dateAry[2] = '4'; if (dateAry[2] == '05') dateAry[2] = '5'; if (dateAry[2] == '06') dateAry[2] = '6';
                if (dateAry[2] == '07') dateAry[2] = '7'; if (dateAry[2] == '08') dateAry[2] = '8'; if (dateAry[2] == '09') dateAry[2] = '9';
                var curDay = parseInt(dateAry[2]);
                //alert(data.ProductDate + ',' + dateAry[2]+","+curDay);//8号parseInt后会是0？
                var tdID = "#" + divID + " td[val='" + curDay + "']";
                var lang = "结算价：<br/>成人：" + data.PriceAdultCost + "<br/>儿童：" + data.PriceChildCost + "<br/>";
                var lestN = parseInt(data.PersonPlan) - parseInt(data.PersonOrder);
                var lestCss = "calendar_number", bgCss = "cal_focus";
                var lestStr = "名额:" + data.remain;
                if (parseInt(data.FeeState) == 1) {//1为开班2为关班
                    if (parseInt(lestN) <= 0) { lestStr = "申请加位"; lestCss = "calendar_numberRed"; bgCss = "cal_focus"; }
                    if (parseInt(data.StopChk) == 1) { lestStr = "申请加位"; lestCss = "calendar_numberRed"; bgCss = "cal_focus"; }

                    var deductPriceAdultSale = parseInt(data.PriceAdultSale) - parseInt(data.deduct);
                    $(tdID).addClass(bgCss).html(curDay + '<p class="calendar_price">' + deductPriceAdultSale + '元' + '</p><p class="' + lestCss + '">' + lestStr + '</p>').attr("lang", lang).attr("ldata", data.ProductDate + "," + pid + "," + lestN + "," + lid + "," + did);
                    if (parseInt(lestN) > 0 && parseInt(data.StopChk) == 0) {
                        $(tdID).bind("click", function () {
                            if (exec.indexOf('js:') > -1) {
                                var jsM = exec.split(',')[1].split(':');
                                eval(jsM[1]);
                            }
                        });
                    }
                    if (lestStr == "申请加位") {

                        $(tdID).bind("click", function () {
                            opToOrderJin(this)
                        });
                    }
                }
                if (parseInt(data.FeeState) == 2)//1为开班2为关班
                {

                    $(tdID).addClass(bgCss).html(curDay + '<p class="calendar_price">已关班</p><p> </p>');
                }
                //if (lestStr == "截止报名") {
                //    $(tdID).bind("click", function () { showMessage("请重新选择其它日期！", 1); });
                //}
            }
            //$("#" + divID + " td[lang!='']").qtip({ content: { attr: 'lang'} });
        }
    });
}
//jin
function getPriceSale(pid, divID, currentDate, exec, lid, did) {
    $.ajax({
        type: "POST",
        dataType: "text",
        url: '/ShareAjaxHandle/ProductDate.ashx',
        data: "st=calendarPriceSale&currentDate=" + currentDate + "&proID=" + pid + "&lineID=" + lid + "&departureID=" + did,
        success: function (data) {
            var jsonData = eval("(" + data + ")");
            for (var i = 0; i < jsonData.Head.length; i++) {
                var data = jsonData.Head[i];
                var dateAry = data.ProductDate.split('-');
                if (dateAry[2] == '01') dateAry[2] = '1'; if (dateAry[2] == '02') dateAry[2] = '2'; if (dateAry[2] == '03') dateAry[2] = '3';
                if (dateAry[2] == '04') dateAry[2] = '4'; if (dateAry[2] == '05') dateAry[2] = '5'; if (dateAry[2] == '06') dateAry[2] = '6';
                if (dateAry[2] == '07') dateAry[2] = '7'; if (dateAry[2] == '08') dateAry[2] = '8'; if (dateAry[2] == '09') dateAry[2] = '9';
                var curDay = parseInt(dateAry[2]);
                //alert(data.ProductDate + ',' + dateAry[2]+","+curDay);//8号parseInt后会是0？
                var tdID = "#" + divID + " td[val='" + curDay + "']";
                var lang = "结算价：<br/>成人：" + data.PriceAdultSale + "<br/>儿童：" + data.PriceChildSale + "<br/>";
                var lestN = parseInt(data.PersonPlan) - parseInt(data.PersonOrder);
                var lestCss = "calendar_number", bgCss = "cal_focus";
                var lestStr = "名额:" + data.remain;
                if (parseInt(data.FeeState) == 1) //1为开班2为关班
                {
                    if (parseInt(lestN) <= 0) { lestStr = "申请加位"; lestCss = "calendar_numberRed"; bgCss = "cal_focus"; }
                    if (parseInt(data.StopChk) == 1) { lestStr = "申请加位"; lestCss = "calendar_numberRed"; bgCss = "cal_focus"; }

                    var deductPriceAdultSale = parseInt(data.PriceAdultSale) - parseInt(data.deduct);
                    $(tdID).addClass(bgCss).html(curDay + '<p class="calendar_price">' + deductPriceAdultSale + '元' + '</p><p class="' + lestCss + '">' + lestStr + '</p>').attr("lang", lang).attr("ldata", data.ProductDate + "," + pid + "," + lestN + "," + lid + "," + did);
                    if (parseInt(lestN) > 0 && parseInt(data.StopChk) == 0) {
                        $(tdID).bind("click", function () {
                            if (exec.indexOf('js:') > -1) {
                                var jsM = exec.split(',')[1].split(':');
                                eval(jsM[1]);
                            }
                        });
                    }
                    if (lestStr == "申请加位") {

                        $(tdID).bind("click", function () {
                            opToOrderJin(this)
                        });
                    }
                }
                if (parseInt(data.FeeState) == 2)//1为开班2为关班
                {

                    $(tdID).addClass(bgCss).html(curDay + '<p class="calendar_price">已关班</p><p> </p>');
                }
                //if (lestStr == "截止报名") {
                //    $(tdID).bind("click", function () { showMessage("请重新选择其它日期！", 1); });
                //}
            }
            //$("#" + divID + " td[lang!='']").qtip({ content: { attr: 'lang'} });
        }
    });
}

function opToOrderJin(tdObj) {
    var dinfo = $(tdObj).attr("ldata");//ProductDate,pid ,lestN ,lineid ,departureid
    var pAry = dinfo.split(',');
    //if (parseInt(pAry[2]) == 0) {
    //    alert('人数已满，请选择其它日期！');
    //    return;
    //}
    var ouWeb_SiteCity = $.cookies.get("WebSignCookie");
    if (ouWeb_SiteCity == null) Login();
    else {
        var url = "/TravelMarket/CustomerCenter/OrderManage/AdditionalSeatOrderAdd.aspx?oid=0&pid=" + pAry[1] + "&lineID=" + pAry[3] + "&departureID=" + pAry[4] + "&pdate=" + pAry[0] + "&v=" + (new Date()).getTime();
        window.open(url);
    }
}



function opToOrder(tdObj) {
    var dinfo = $(tdObj).attr("ldata");//ProductDate,pid ,lestN ,lineid ,departureid
    var pAry = dinfo.split(',');
    if (parseInt(pAry[2]) == 0) {
        $.warn('人数已满，请选择其它日期！');
        return;
    }
    var ouWeb_SiteCity = $.cookies.get("WebSignCookie");
    if (ouWeb_SiteCity == null) Login();
    else {
        var url = "/TravelMarket/CustomerCenter/OrderManage/ProductOrd.aspx?oid=0&pid=" + pAry[1] + "&lineID=" + pAry[3] + "&departureID=" + pAry[4] + "&pdate=" + pAry[0] + "&v=" + (new Date()).getTime();
        window.location = url;
    }
}


function opToOrderF(tdObj) {
    var dinfo = $(tdObj).attr("ldata");//ProductDate,pid ,lestN ,lineid ,departureid
    var pAry = dinfo.split(',');
    if (parseInt(pAry[2]) == 0) {
    	$.warn('人数已满，请选择其它日期！');
        return;
    }
    var ouWeb_SiteCity = $.cookies.get("WebSignCookie");
    if (ouWeb_SiteCity == null) Login();
    else {
        var url = "/TravelMarket/CustomerCenter/OrderManage/ProductOrd.aspx?oid=0&pid=" + pAry[1] + "&lineID=" + pAry[3] + "&departureID=" + pAry[4] + "&pdate=" + pAry[0] + "&v=" + (new Date()).getTime();
        window.open(url);
    }
}

function Login() { var winUrl = '/TravelMarket/TravelMarketLogin.aspx'; $.layer({ type: 2, title: ['登录', true], iframe: { src: encodeURI(winUrl) }, offset: ['50%', '50%'], area: ['450px', '300px'] }); }

document.writeln("<a id='aLSucc' href='' target='_blank'></a>");
function opCloseML(state) {
    var index = layer.getFrameIndex();
    if (state == '1') {
        var bro = navigator.userAgent;
        var isIE2 = bro.indexOf("MSIE") > 0 ? 'IE' : 'others';

        if (isIE2 == 'IE') {
            $("#aLSucc").attr("href", memberOrdUrl);
            $("#aLSucc").get(0).click();
        }
        else {
            window.open(memberOrdUrl);
        }

    }
}
function opCalender(pID, dID, lID) {
    //产品详细页面，显示日期
    calender(pID, "", "", "dviCalendar1", "3,js:opToOrder($(this));", lID, dID);
}
function opCalenderF(pID, dID, lID) {
    //产品详细页面，显示日期
    calender(pID, "", "", "dviCalendar1", "3,js:opToOrderF($(this));", lID, dID);
}