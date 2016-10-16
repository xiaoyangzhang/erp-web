<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@ include file="../../../include/top.jsp"%>
<script type="text/javascript" src="<%=ctx%>/assets/js/web-js/sales/regional.js"></script>
<style type="text/css">
	.help-block{color:red;}
</style>
</head>
<body>
	<div class="p_container">
		<form class="form-horizontal" action="saveConsultGuest.do" method="post" id="consultForm">
			<p class="p_paragraph_title"><b>咨询登记:</b></p>
			<dl class="p_paragraph_content">
	    		<dd>
	    			<div class="dd_left"><i class="red">* </i>姓名：</div> 
	    			<div class="dd_right">
	    				<input name="name" type="text" class="IptText300"  />
	    			</div>
					<div class="clear"></div>
	    		</dd> 
	    		<dd>
	    			<div class="dd_left"><i class="red">* </i>电话：</div> 
	    			<div class="dd_right">
	    				<input name="phone" id="phone" type="text" class="IptText300"  />
					</div>
					<div class="clear"></div>
	    		</dd> 
	    		<dd>
	    			<div class="dd_left">性别：</div> 
	    			<div class="dd_right">
	    				<input name="sex" type="radio"   value="M"  />男&nbsp;&nbsp;&nbsp;
	    				<input name="sex" type="radio"  value="F" />女
					</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left">籍贯：</div> 
	    			<div class="dd_right">
	    				<select name="provinceId" id="provinceCode" class="input-small">
							<option value="">请选择省</option>
							<c:forEach items="${allProvince}" var="province">
								<option value="${province.id }">${province.name }</option>
							</c:forEach>
						</select> <select name="cityId" id="cityCode" class="input-small">
							<option value="">请选择市</option>
						</select>
						<input name="provinceName" id="provinceName" type="hidden"  value="" />
						<input name="cityName" id="cityName" type="hidden"  value="" />
					</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
					
						<div class="dd_left">QQ：</div>
						<div class="dd_right">
							<input name="qq" type="text" class="IptText300"  />
						</div>
						<div class="clear"></div>
					</dd><dd>
						<div class="dd_left">微信：</div>
						<div class="dd_right">
							<input name="wechat" type="text" class="IptText300"  />
						</div>
						<div class="clear"></div>
					</dd><dd>
						<div class="dd_left">E-mail：</div>
						<div class="dd_right">
							<input name="email" type="text" class="IptText300"  />
						</div>
						<div class="clear"></div>
					</dd><dd>
						<div class="dd_left">咨询日期：</div>
						<div class="dd_right">
						<input type="text" name="consultDate" class="Wdate"
							onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value='<fmt:formatDate value="${curDate }" pattern="yyyy-MM-dd"/>'  />
							
						</div>
						<div class="clear"></div>
					</dd><dd>
						<div class="dd_left">咨询主题：</div>
						<div class="dd_right">
							<input name="topic" type="text" class="IptText300"  />
						</div>
						<div class="clear"></div>
					</dd><dd>
						<div class="dd_left">咨询内容：</div>
						<div class="dd_right">
							<textarea class="AreaDef" rows="10" cols="20" name="content"></textarea>
						</div>
						<div class="clear"></div>
					</dd><dd>
						<div class="dd_left">备注：</div>
						<div class="dd_right">
							<textarea class="AreaDef" rows="10" cols="20" name="note"></textarea>
						</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left">客人来源：</div>
						<div class="dd_right">
							<c:forEach items="${guestSources }" var="guest">
								<input name="guestSourceId" type="radio"  value="${guest.id }" /><span>${guest.value }</span>
							</c:forEach>
								<input name="guestSourceName" id="guestSourceName" type="hidden"  value="" />
						</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left">意向游玩：</div>
						<div class="dd_right">
							<c:forEach items="${intentionDests }" var="dest">
								<input name="intentionDestId" type="radio"  value="${dest.id }" /><span>${dest.value }</span>
							</c:forEach>
							<input name="intentionDestName" id="intentionDestName" type="hidden"  value="" />
						</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left">信息渠道：</div>
						<div class="dd_right">
							<c:forEach items="${infoSources }" var="info">
								<input name="infoSourceId" type="radio"  value="${info.id }" /><span>${info.value }</span>
							</c:forEach>
							<input name="infoSourceName" id="infoSourceName" type="hidden"  value="" />
						</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<button type="submit" class="button button-primary button-small" >保存</button>&nbsp;&nbsp;&nbsp;
	    			<a href="javascript:void(0)" onclick="closeWindow()" class="button button-primary button-small">关闭</a>
	    		</dd>
    	</dl>
		</form>
	</div>
	<script type="text/javascript">
		var path = '<%=ctx%>';
		$(function () {
	        $(".AreaDef").autoTextarea({ minHeight: 80 });
	    });
		$(function(){
			$("#consultForm").validate({
				//focusCleanup:true,
				errorElement : 'span',
				errorClass : 'help-block',
				rules:{
					name:"required",
					phone:{
						required:true,
						remote:{
							url:"../consult/commons/validetePhone.htm",
							cache:false,
							async:false,
							type:"post",
							//dataType:"json",
							data:{
								phone:function(){return $("#phone").val();}
							}
							 
							}
					},
					email: {
				        
				        email: true
				      }
				},
				messages:{
					name:"姓名不能为空",
					phone:{
						required:"电话不能为空",
						remote:"该电话已存在，请跟进"
					},
					email:"请输入正确格式的邮箱"
				},
				errorPlacement: function(error, element) {  
				    error.appendTo(element.parent());  
				},
				submitHandler:function(form){
					$("#guestSourceName").val($("input[name='guestSourceId']:checked+span").text());
					$("#intentionDestName").val($("input[name='intentionDestId']:checked+span").text());
					$("#infoSourceName").val($("input[name='infoSourceId']:checked+span").text());
					var options={
							type:"post",
							dataType:"json",
							success:function(data){
								if(data.success){
									//alert(123);
									$.success("保存成功");
								}
								else{
									if (data.msg){
										$.warn(data.msg);
									}else {
										$.warn("保存失败");
									}
								}
							},
							error:function(){
								$.error("服务器忙，请稍后再试");
							}
					};
					//form.submit();
					$(form).ajaxSubmit(options);
		        }  ,
		        invalidHandler : function(form, validator) { // 不通过回调
		    		return false;
		    	}
				
			})
		})
	</script>
	
</body>
</html>