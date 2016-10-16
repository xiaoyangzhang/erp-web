<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <title>复制团期</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <%@ include file="../../../include/top.jsp" %>
</head>
<body>
	<div class="p_container">
		<form id="copyForm">
			<input type="hidden" value="${groupId }" name="groupId" />
			<input type="hidden" id="destYear"  name="destYear" />
			<input type="hidden" id="destMonth" name="destMonth" />
			<dl class="p_paragraph_content">
				<dd class="inl-bl">
					<div class="dd_left">从:</div>
					<div class="dd_right grey">
						<input type="text" id="startTime" name="startTime"
							class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false,readOnly:true})"
							value="${startTime }" /> — <input type="text" id="endTime"
							name="endTime" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false,readOnly:true})" value="${endTime }" />
					</div>
					<div class="clear"></div>
				</dd>
				<dd class="inl-bl">
					<div class="dd_left">复制到:</div>
					<div class="dd_right grey">
						<input type="text" id="destTime" name="destTime" value="${destTime }"
							class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM',isShowClear:false,readOnly:true})"/>
					</div>
					<div class="clear"></div>
				</dd>
			</dl>
			<dd class="inl-bl">
				<div class="dd_right">
					<button type="submit" class="button button-primary button-small">确定</button>
				</div>
				<div class="clear"></div>
			</dd>
		</form>
	</div>
</body>
<script type="text/javascript"> 

	$(function(){
		function chkValidDateSpan(){
			var start = $("#startTime").val();
			var end = $("#endTime").val();
			var dt1=new Date(start.replace(/-/g,"/"));
			var dt2=new Date(end.replace(/-/g,"/"));
			if(dt1.getYear()!=dt2.getYear() || dt1.getMonth()!=dt2.getMonth()){
				alert("日期时间段必须在同年同月");
				return false;
			}
			return true;
		}
		
		$("#copyForm").validate({
			rules : {
				'startTime' : {
					required : true
				},
				'endTime' : {
					required : true
				},
				'destTime' : {
					required : true
				}
			},
			messages : {
				'startTime' : {
					required : "请选择开始日期"

				},
				'endTime' : {
					required : "请选择结束日期"
				},
				'destTime' : {
					required : "请选择目标日期"
				}
			},
			errorPlacement : function(error, element) { // 指定错误信息位置
				if ( element.is(':checkbox')
						|| element.is(':input')) { // 如果是radio或checkbox
					var eid = element.attr('name'); // 获取元素的name属性
					error.appendTo(element.parent()); // 将错误信息添加当前元素的父结点后面
				} else {
					error.insertAfter(element);
				}
			},
			submitHandler : function(form) {
				if(!chkValidDateSpan()){
					return false;
				}
				
				$("#destYear").val($dp.cal.getP("y"));
				$("#destMonth").val($dp.cal.getP("M"));				
				var options={
					type: 'POST',
					cache:false,
			        url: "saveCopy.do",
			        dataType: 'json',
			        //async:false,
			        success: function(data) {						        	
			            if (data.success) {	
			            	alert("保存成功");
			            }else{
			            	alert("保存失败"+data.msg);
						}
			        },
			        error: function(data,msg) {
			        	alert("操作失败"+msg);
			        }
				};
				$(form).ajaxSubmit(options);
			},
			invalidHandler : function(form, validator) { // 不通过回调
				return false;
			}
		})
	})
</script>
</html>
