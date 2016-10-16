<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>基本信息</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<%@ include file="../../../include/top.jsp"%>
</head>
<body>
	 <div class="p_container" >
	  

	    <div class="p_container_sub" id="tab1">
	    	<form id="saveGuideForm">
	    	<p class="p_paragraph_title"><b>导游信息</b></p>
	    	<dl class="p_paragraph_content">
	    		<dd>
	    			<div class="dd_left">导游姓名：</div> 
	    			<div class="dd_right">
	    				<input type="hidden" name="guide.groupId"" value="${groupId }"/>
	    				<input type="hidden" name="guide.id" value="${vo.guide.id }"/>
	    				<input type="hidden" id="guideId" name="guide.guideId" value="${vo.guide.guideId }"/>
	    				<input type="text" id="guideName" name="guide.guideName" readonly="readonly" <c:if test="${add eq 'add' }"> onclick="imp()" </c:if> value="${vo.guide.guideName }" class="IptText300"></div>
					<div class="clear"></div>
	    		</dd> 
                <dd>
	    			<div class="dd_left">导游电话：</div> 
	    			<div class="dd_right">
	    			<input type="text" id="guideMobile" name="guide.guideMobile" readonly="readonly" <c:if test="${add eq 'add' }"> onclick="imp()" </c:if> value="${vo.guide.guideMobile }" class="IptText300"></div>
					<div class="clear"></div>
	    		</dd>
                <dd>
	    			<div class="dd_left">是否默认导游：</div> 
	    			<div class="dd_right">
	    			<input type="radio"  name="guide.isDefault" value="1"  checked="true"  >是
	    			<input type="radio"  name="guide.isDefault" value="0"  <c:if test="${vo.guide.isDefault eq 0   }">checked</c:if>  >否
	    			
	    			</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left">结对司机：</div> 
	    			<div class="dd_right">
	    				
	    				<select name ="guide.bookingDetailId" >
	    					<option value="">请选择</option>
	    					<c:forEach items="${driverList }" var="driver">	    						
	    						<option value="${driver.id }" <c:if test="${vo.guide.bookingDetailId==driver.id }">selected</c:if> >${driver.driverName }-${driver.driverTel }-${driver.carLisence }</option>
	    					</c:forEach>
	    				</select>
	    			</div>
					<div class="clear"></div>
	    		</dd>
	    		 <dd>
	    			<div class="dd_left">备注：</div> 
	    			<div class="dd_right">
						<%--style="height: 110px;"--%>
	    				<textarea class="w_textarea" name="guide.remark" >${vo.guide.remark }</textarea>
	    			</div>
					<div class="clear"></div>
	    		</dd>
	    	</dl>

	    	<p class="p_paragraph_title"><b>上下团时间</b></p>
	    	<dl  class="p_paragraph_content" id="times">
	    	<c:if test="${vo.guideTimes eq null}">
	    		<dd>
	    			<div class="dd_left">时间：</div> 
	    			<div class="dd_right">
	    			<input style="width:150px;" type="text" readonly="readonly" name="guideTimes[0].timeStart"  class="Wdate" class="IptText300" onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm'})" value="<fmt:formatDate value='${group.dateStart }' pattern='yyyy-MM-dd HH:mm:ss'/>" />
	    			~<input style="width:150px;" type="text" readonly="readonly" name="guideTimes[0].timeEnd"  class="Wdate" class="IptText300" onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm'})" value="<fmt:formatDate value='${group.dateEnd }' pattern='yyyy-MM-dd HH:mm:ss'/>"/>
					<i class="gray"><em> 默认为出团时间~结团时间 </em></i>
					</div>
					<div class="clear"></div>
	    		</dd>
	    	</div>
	    	</c:if>
	    	 <c:forEach items="${vo.guideTimes}" var="times" varStatus="a">
	    		<dd>
	    			<div class="dd_left">时间：</div> 
	    			<div class="dd_right">
	    			<input style="width:150px;" type="text" readonly="readonly" name="guideTimes[${a.index}].timeStart" class="Wdate" class="IptText300" onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm'})" value="${times.timeStart }" placeholder="上团时间"/>
	    			~<input style="width:150px;" type="text" readonly="readonly" name="guideTimes[${a.index}].timeEnd" class="Wdate" class="IptText300" onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm'})" value="${times.timeEnd }" placeholder="下团时间"/>
					</div>
					<div class="clear"></div>
	    		</dd>
	    	</c:forEach>  	
	    	</dl>
	    	
	    	   <a href="#" class="btn_guide_add button button-rounded button-tiny ml-20">添加</a>
            <div class="Footer">
            <dl class="p_paragraph_content">
	    		<dd>
	    			<div class="dd_left"></div> 
	    			<div class="dd_right">
            <button type="submit" class="button button-primary button-small">保存</button>
            &nbsp;<a href="guideDetailListView.htm?groupId=${groupId }" class="button button-primary button-small">返回</a>
           
            </div>
           	
            </div>    
            </form>	
          
			
	    </div>
     
        
    </div>
</body>

<script type="text/html" id="timeTemp">
<dd>
	    			<div class="dd_left">时间：</div> 
	    			<div class="dd_right">
	    			<input type="text"  name="guideTimes[$index].timeStart" style="width:150px;" class="Wdate" class="IptText300" onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" value="" placeholder="上团时间"/>
	    			~<input type="text"  name="guideTimes[$index1].timeEnd" style="width:150px;" class="Wdate" class="IptText300" onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" value="" placeholder="下团时间"/>
					<a class="def" href="javascript:void(0)" onclick="delTime(this)">删除</a>
					</div>
<div class="clear"></div>					
</dd>

</script>

<script type="text/javascript">
//onClick="WdatePicker({dateFmt:'+"'yyyy-MM-dd HH:ss'"+'})"
var conTr =$("#times dd").length;

$(".btn_guide_add").unbind("click").click(function () {
	
	var addhtml="";
	var html1 = $("#timeTemp").html();
	
	//addhtml = addhtml +  html1.replace(/\\$index/g, conTr++);
	var i = conTr++;
	addhtml = addhtml + html1.replace('$index', i).replace('$index1', i);
	$("#times dd").append(addhtml);
});

 function delTime(obj){
	 $(obj).closest("dd").remove(); 
 } 
$(function(){
	
	/*提交**/
	$("#saveGuideForm").validate(
			{
				rules:{
					'guide.guideName' : {
						required : true
					},
					'guide.guideMobile' : {
						required : true
					}/* ,
					'guideTimes[0].timeStart' :{
						required : true
					},
					'guideTimes[0].timeEnd' :{
						required : true
					} */
				},
				errorPlacement : function(error, element) { // 指定错误信息位置

					if (element.is(':radio') || element.is(':checkbox')
							|| element.is(':input')) { // 如果是radio或checkbox
						var eid = element.attr('name'); // 获取元素的name属性
						error.appendTo(element.parent()); // 将错误信息添加当前元素的父结点后面
					} else {
						error.insertAfter(element);
					}
				},
				submitHandler : function(form) {
					 /* var count=$("#times").length;
					 if(count>0){
					 }else{
					 	$.warn("请添加上团时间");
						return false;
					 } */
					var options = {
						url : "saveGuide.do",
						type : "post",
						dataType : "json",
						success : function(data) {
							
							if (data.success) {
								$.success('操作成功',function(){
									window.location.href="guideDetailListView.htm?groupId=${groupId }";
								});
							} else {
								layer.alert(data.msg, {
									icon : 5
								});

							}
						},
						error : function(XMLHttpRequest, textStatus,
								errorThrown) {
							layer.alert('服务忙，请稍后再试', {
								icon : 5
							});
						}
					};
					
					$(form).ajaxSubmit(options);
				},
				invalidHandler : function(form, validator) { // 不通过回调
					return false;
				}
			});
	//changeState();
})


/* function changeState(){
	var state='${vo.guide.isDefault}';
	if(state&&state=='0'){
		$("input:radio").removeAttr("checked");
	}
} */

function imp(){
	//兼顾分辨率低的情况
	var height = $(window).height();
	var heightStr='580px';
	if(height<700){
		heightStr='420px';
	}
	var win;
	layer.open({ 
		type : 2,
		title : '选择导游',
		closeBtn : false,
		area : [ '980px', heightStr ],
		shadeClose : false,
		content : 'impGuideList.htm',
		btn: ['确定', '取消'],
		success:function(layero, index){
			win = window[layero.find('iframe')[0]['name']];
		},
		yes: function(index){
			//orgArr返回的是org对象的数组
			var arr = win.getGuide(); 
			/* alert(arr.name); */
			/* console.log("name:"+arr.name+"); */
		
			$("#guideId").val(arr.id);
			$("#guideName").val(arr.name);
			$("#guideMobile").val(arr.mobile);
			
		
			//一般设定yes回调，必须进行手工关闭
	        layer.close(index); 
	    },cancel: function(index){
	    	layer.close(index);
	    }
	});
}
</script>

</html>
