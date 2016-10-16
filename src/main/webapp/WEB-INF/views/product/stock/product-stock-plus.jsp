<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <title>库存设置</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <%@ include file="/WEB-INF/include/top.jsp" %>
     <link href="<%=staticPath %>/assets/css/product/product_price.css" rel="stylesheet" />
	 <script type="text/javascript">

     </script>
</head>
<body>
  <div class="p_container" >
	    <div class="p_container_sub">
	    	<p class="p_paragraph_title"><b>设置团期库存</b></p>
            <dl class="p_paragraph_content">
            	
	            <ul class="priceCalandar_List">
	             	<li class="li_year">
	             		<input  type="button" value="" class="left"><label class="year">2015</label><input type="button" value="" class="right">
	             	</li>
	             	<li><a href="#" lang="1" class="on">1</a></li>
	             	<li><a href="#" lang="2" >2</a></li>
	             	<li><a href="#" lang="3" >3</a></li>
	             	<li><a href="#" lang="4" >4</a></li>
	             	<li><a href="#" lang="5" >5</a></li>
	             	<li><a href="#" lang="6" >6</a></li>
	             	<li><a href="#" lang="7" >7</a></li>
	             	<li><a href="#" lang="8" >8</a></li>
	             	<li><a href="#" lang="9" >9</a></li>
	             	<li><a href="#" lang="10" >10</a></li>
	             	<li><a href="#" lang="11" >11</a></li>
	             	<li><a href="#" lang="12" >12</a></li>
	            </ul>
	            <form id="stockForm" method="post">
	            <!--库存设置-->
	            <div class="store-batch">
		            <div class="batch">
		            	<div class="batch-title">批量设置</div>
		            	<input type="radio" name="date" id="week" value="week" class="mt-20 mb-10 ml-10"/>按星期选择
		            	<div class="batch-week">
		            		<span><input type="checkbox" name="day" lang="1"/>星期一</span>
		            		<span><input type="checkbox" name="day" lang="2" />星期二</span>
		            		<span><input type="checkbox" name="day" lang="3" />星期三</span>
		            		<span><input type="checkbox" name="day" lang="4" />星期四</span>
		            		<span><input type="checkbox" name="day" lang="5"/>星期五</span>
		            		<span><input type="checkbox" name="day" lang="6" />星期六</span>
		            		<span><input type="checkbox" name="day" lang="0"/>星期日</span>
		            	</div>	
	            		<input type="radio" name="date" id="dateNum" value="dateNum" class="mt-20 mb-10 ml-10"/>按单双号选择
		            	<div class="batch-date">	            		
		            		<span><input type="checkbox" name="single" id="" value=""/>单号</span>
		            		<span><input type="checkbox" name="double" id="" value=""/>双号</span>
		            	</div>
		            	<div class="mt-10 ml-10 mb-20">
		            		设置库存为 <input type="text" name="ppNum" id="ppNum" value="" class="w-30"/> 人/每天
		            		<a href="javascript:;" class="ppNum button button-rounded button-primary button-tinier ml-10">确认</a>
		            	</div>
		            </div>
		            <div class="btn-box mt-10 ml-20">
		            	<input type="submit" class="button button-primary button-small" id="btnSave" value="保存" />
		            	<a class="button button-primary button-small" href="javascript:closeWindow()">关闭</a>
		            </div>	            	
	            </div>
	            <!--库存设置结束-->
	            <!--表格开始-->
	            
	            <div class="store-tab">
		            <table cellspacing="0" cellpadding="0" class="w_table" border="1" > 
			            <col width="5%"/><col width="25%" /><col width="40%" /><col width="30%" />
			            <thead>
			            	<tr>
			            		<th><input type="checkbox" name="" id="checkAll" value="" /></th>
			            		<th>日期</th>
			            		<th>计划收客人数</th>
			            		<th>已收人数</th>
			            	</tr>
			            </thead>
			            <tbody> 
			                <tr> 
				                <td><input type="checkbox" name="subbox" id="" value="" /></td>
				                <td>2015-12-01</td> 
				                <td><input type="text" name="" id="" value="" class="w-100"/></td> 
				                <td>0</td> 
			                </tr>
			            </tbody>
		      		</table>	            	
	            </div>
	            </form>
	            <!--表格结束-->
	            <div class="clear"></div>
            </dl>    
        </div>   	       
    </div>
</body>
<script type="text/javascript">	
	$(function(){
		fixHeader(30);
		var getMonthList = function(year, month) {
			var d = new Date(year, month, 0);
			var dayNum = (new Date(d.getTime())).getDate();
		    
			var rowStr = '<tr><td><input type="checkbox" name="subbox" lang="{0}" itemdate="{3}" date2="{2}" id="chk-{2}"/></td>' +
				'<td>{1}<input type="hidden" id="id-{2}" name="stockId" /></td>' +
				'<td><input type="text" id="stock-{2}" name="stockCount-{2}" class="w-100" tag="stock" receive="0"/></td>' + 
				'<td id="receive-{2}" tag="receive" class="peoplenum">0</td>' +
				'</tr>';
			var html = "",
				weekStr = "",
				dayStr = "",
				curDay; 
			for (var i = 1; i <= dayNum; i++) {
				var curDay = new Date(year, month-1, i);
				var curDayStr = formatDate(curDay.getFullYear(),curDay.getMonth()+1,curDay.getDate(),'');
				var curDayStr2 = formatDate(curDay.getFullYear(),curDay.getMonth()+1,curDay.getDate(),'-');
				var dayStr = i < 10 ? '0' + i : i;
				var weekStr = ' 周' + '日一二三四五六'.charAt(curDay.getDay());
				var weekNum = curDay.getDay();
				html+=$.format(rowStr,weekNum,dayStr + " " + weekStr,curDayStr,curDayStr2);
			};
			$(".w_table tbody tr").remove();
			$(".w_table tbody").append(html);
			
			//月份切换时，添加默认选中
			if ($("input[type='radio']:checked").val()=="week") {
				var refreshValidate = false;
				$("input[name='day']:checked").each(function () {
					refreshValidate = true;
			    	var $num = $(this).attr("lang");
			    	$("input[lang='"+$num+"']").not("input[disabled='disabled']").attr("checked",this.checked);
				});
				if(refreshValidate){
					//选中后要添加验证
					addValidateRule();					
				}
			} else if($("input[type='radio']:checked").val()=="dateNum"){
				var refreshValidate = false;
				if ($("input[name='single']:checked").length > 0) {
					refreshValidate = true;
					$("tbody tr:even").find("input[name='subbox']").not("input[disabled='disabled']").attr("checked","checked");
				};
				if ($("input[name='double']:checked").length >0) {
					refreshValidate = true;
					$("tbody tr:odd").find("input[name='subbox']").not("input[disabled='disabled']").attr("checked","checked")
				}
				if(refreshValidate){
					//选中后要添加验证
					addValidateRule();					
				}
			}
			
			$("input[value='week']").attr("checked","checked");
		    $("input[value='week']").trigger("change");
		}

		function formatDate(year,month,day,seprator){
			return year+ (month<10 ? (seprator+"0"+month):(seprator+""+month)) + (day<10 ? (seprator+"0"+day):(seprator+""+day));
		}
		function processCalandar(year, month){
			$(".li_year .year").text(year);
			$(".priceCalandar_List a").removeClass("on");
			$(".priceCalandar_List a[lang='"+month+"']").attr("class", "on");
			getMonthList(year, month);
			setMonthData(year, month);
			
			
		}
	    
		var setMonthData=function(year,month){
			YM.post('stockMonth.do',{productId:'${productId}',year:year,month:month},function(result){
				if(!result){
					return;
				}
				var data = eval('('+result+')');
				if(!data||data.length==0){
	        		return;
	        	}
				$("input[name='stockId']").val('');
				$("input[tag='stock']").val('');
				$(".w_table>tbody>tr>td[tag='receive']").html('');
				for (var i = 0; i < data.length; i++) {
	                var item = data[i];
	                var itemDate = new Date(item.itemDate);
	                var datestr = formatDate(itemDate.getFullYear(),itemDate.getMonth()+1,itemDate.getDate(),'');
	                $("#chk-"+datestr).attr("checked","checked")                
	                if(item.receiveCount+item.reserveCount>0){
	                	$("#chk-"+datestr).attr("disabled","disabled");                	
	                }
	                $("#id-"+datestr).val(item.id);                
	                $("#stock-"+datestr).val(item.stockCount);
	                if(!item.reserveCount){
	                	item.reserveCount = 0;
	                }
	                $("#stock-"+datestr).attr("receive",item.receiveCount+item.reserveCount);
	                $("#receive-"+datestr).html(item.receiveCount+item.reserveCount);
	                addValidateRule(datestr);
				}
			},function(err){
				$.error("服务器忙，请稍后再试");
			},'json',false); 
		}
		
		//---------------添加验证规则
		$.validator.addMethod("reasonable", function(value,element) {
		          var receive = $(element).attr("receive");
		          var receiveNum = parseInt(receive);
		          return this.optional(element) || (value>=receiveNum);
		}, "计划数应大于已收数");
		
		$.validator.setDefaults({
			submitHandler : function(form) {
				var stockArr = onData();
				YM.post('saveStock.do',{productId:'${productId}',stockStr:JSON.stringify(stockArr),year:yearSel,month:monthSel},function(){
					$.success('保存成功',function(){
						setMonthData(yearSel,monthSel);
					});
				});
				return false;
			}
		});
		
		$("#stockForm").validate({			
			errorPlacement: function(error, element) {
				error.insertAfter(element);
			}			
		})
		
		//给某行或者全部选中行加验证规则
	    var addValidateRule = function(datestr){
			if(datestr){
				$("#stock-"+datestr).rules("remove");
				if($("#chk-"+datestr).attr("checked")){
					$("#stock-"+datestr).rules("add",{required:true,isNum:true,reasonable:true,messages: { required: "必填",isNum:"必须输入数字"}});	
				}		
			}else{
				$("table.w_table>tbody").find("input[name='subbox']").each(function(){
					var datestr = $(this).attr("date2");
					var stock = $("#stock-"+datestr);
					stock.rules("remove");
					if($(this).attr("checked")){
						stock.rules("add",{required:true,isNum:true,reasonable:true,messages: { required: "必填",isNum:"必须输入数字"}});	
					}		
				})
			}
		}
		
		$("#checkAll").click(function(){
        	$("input[name='subbox']").not("input[disabled='disabled']").attr("checked",this.checked);
        	$("input[name='subbox']").click(function () {
        		$("#checkAll").attr("checked",$("input[name='subbox']").length == $("input[name='subbox']:checked").length ? true : false);
        	});
  		});
	    //星期单双号选择
	    $("input[type='radio']").on("change",function () {	
		    if ($("input[type='radio']:checked").val() =="week") {
		    	$(".batch-date").find("input[type='checkbox']:checked").attr("checked",false);
		    	$("input[name='subbox']:checked").not("input[disabled='disabled']").attr("checked",false);
		    	$(".batch-date").find("input[type='checkbox']").attr("disabled","disabled")
		    	$(".batch-week").find("input[type='checkbox']").removeAttr("disabled");
		    	$(".batch-date input").unbind("click");
		    	$("input[name='day']").click(function () {
			    	var $num = $(this).attr("lang");
			    	$("input[lang='"+$num+"']").not("input[disabled='disabled']").attr("checked",this.checked);
			    	
			    	addValidateRule();
			    });
		    }else{
		    	$(".batch-week").find("input[type='checkbox']:checked").attr("checked",false);
		    	$("input[name='subbox']:checked").not("input[disabled='disabled']").attr("checked",false);
		    	$(".batch-week").find("input[type='checkbox']").attr("disabled","disabled");
		    	$(".batch-date").find("input[type='checkbox']").removeAttr("disabled");
		    	$(".batch-week input").unbind("click")
		    	$("input[name='single']").click(function () {
			    	$("tbody tr:even").find("input[name='subbox']").not("input[disabled='disabled']").attr("checked",this.checked);
			    	
			    	addValidateRule();
		    	});
		    	$("input[name='double']").click(function () {
					$("tbody tr:odd").find("input[name='subbox']").not("input[disabled='disabled']").attr("checked",this.checked);
					
					addValidateRule();
		    	});	 
		    };
		    addValidateRule();
	    });
	    
	    $("input[name='subbox']").live("change",function(){
	    	var datestr = $(this).attr("date2");
	    	$("#stock-"+datestr).rules("remove");
	    	if($(this).attr("checked")){
	    		$("#stock-"+datestr).rules("add",{required:true,isNum:true,reasonable:true,messages: { required: "必填",isNum:"必须输入数字"}});
	    	}
	    })
	    
	    //input传值
	    $(".ppNum").click(function () {
	    	var $pval = $("input[name='ppNum']").val();
	    	$("input[name='subbox']:checked").closest("td").siblings().find("input[tag='stock']").val($pval);	    	
	    })    
		
	    //切换年
	    $(".li_year input").click(function(){
	    	var action = $(this).attr("class");
	    	var year =$(".li_year label").text();
	    	var month = $(".priceCalandar_List a[class='on']").text();
	    	if (action == "left") 
	    		year = parseInt(year) - 1;
	    	else
	    		year = parseInt(year) + 1;
	    		
	    	yearSel = year;
	    	monthSel = month;
	    	processCalandar(year, month);
	    	
	    });
	 	
	 	//切换月
	    $(".priceCalandar_List a").click(function(){
	    	var year =$(".li_year label").text();
	    	var month = $(this).text();
	    	
	    	yearSel = year;
	    	monthSel = month;
	    	processCalandar(year, month);
	    });
	    
	    //初始化
	    var date=new Date();
	    var yearSel = date.getFullYear();
	    var monthSel = date.getMonth()+1;
		processCalandar(yearSel, monthSel);
		
		var onData=function(){
			var stockArr = new Array();
			var productId=${productId};
			$("table.w_table>tbody").find("input[name='subbox']:checked").each(function(){
				var date = $(this).attr("itemdate");
				var tr = $(this).closest("tr");
				var stock = tr.find("input[tag='stock']").val();
				var stockid = tr.find("input[name='stockId']").val();
				stockArr.push({id:stockid,productId:productId,itemDate:date,stockCount:stock});
			})
			return stockArr;
		}
	});

</script>
</html>
