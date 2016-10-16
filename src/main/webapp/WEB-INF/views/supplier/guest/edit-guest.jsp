<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib uri="http://yihg.com/custom-taglib" prefix="cf" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@ include file="../../../include/top.jsp"%>
	<style type="text/css">
		.p_container .search-con{overflow: hidden;}
		.p_container .search-con ul{margin-left: 10px;overflow: hidden;}
		.p_container .search-con ul li{float: left;position: relative; width: 160px;height: 40px;margin: 5px 0 10px 10px;border: 1px solid #ddd;}
		.p_container .search-con ul li .label-name{width: 120px; margin: 10px 0 10px 15px; font-size: 16px;font-weight: 700;}
		.p_container .search-con ul li .label-icon{display: none; position: absolute;top: 10px;right: 5px;}
		.p_container .search-con ul li .label-sel{display: block;}
	</style>
</head>
<body>
	<div class="p_container">
		<form class="form-horizontal" id="guestForm">
			<input type="hidden" name="id" value="${guest.id }"/>
			<input type="hidden" name="choseIds" id="choseIds" value=""/>
			<p class="p_paragraph_title"><b>客人基本信息:</b></p>
			<dl class="p_paragraph_content">
	    		<dd>
	    			<div class="dd_left"><i class="red">* </i>姓名：</div> 
	    			<div class="dd_right">
	    				<input name="name" type="text" class="IptText300" placeholder="姓名" value="${guest.name }" />
	    			</div>
					<div class="clear"></div>
	    		</dd> 
	    		<dd>
	    			<div class="dd_left"><i class="red">* </i>手机：</div> 
	    			<div class="dd_right">
	    				<input name="mobile" type="text" class="IptText300" placeholder="手机" value="${guest.mobile }" />
					</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left">身份证号：</div> 
	    			<div class="dd_right">
	    				<input name="idCardNo" type="text" class="IptText300"  placeholder="身份证" value="${guest.idCardNo }">
					</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left">性别：</div> 
	    			<div class="dd_right">
	    				<input name="gender" type="radio" value="M" <c:if test="${guest.gender=='M' }">checked</c:if>/>男
	    				<input name="gender" type="radio" value="F" <c:if test="${guest.gender=='F' }">checked</c:if>/>女
					</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left">出生日期：</div> 
	    			<div class="dd_right">
	    				<input type="text" name="birthDate" class="Wdate" value="<fmt:formatDate pattern='yyyy-MM-dd' value='${guest.birthDate }'/>"
							onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
					</div>
					<div class="clear"></div>
	    		</dd>  		
	    		<dd>
	    			<div class="dd_left">年龄：</div> 
	    			<div class="dd_right">
	    				<input name="age" type="text" class="IptText300"  placeholder="年龄" value="${guest.age }">
					</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left">籍贯：</div> 
	    			<div class="dd_right">
	    				<input type="hidden" name="provinceName" id="provinceName" />
	    				<input type="hidden" name="cityName" id="cityName" />
	    				<select name="provinceId" id="provinceId" class="input-small">
							<option value="">请选择省</option>		
							<c:forEach items="${allProvince}" var="province">
								<option value="${province.id }" <c:if test="${guest.provinceId!=null && guest.provinceId==province.id  }">selected</c:if> >${province.name }</option>
							</c:forEach>					
						</select> 
						<select name="cityId" id="cityId" class="input-small">
							<option value="">请选择市</option>
							<c:forEach items="${cityList}" var="city">
								<option value="${city.id }" <c:if test="${guest.cityId!=null && city.id==guest.cityId }"> selected</c:if>>${city.name }</option>
							</c:forEach>
						</select> 
					</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left">QQ：</div> 
	    			<div class="dd_right">
	    				<input name="qq" type="text" class="IptText300"  placeholder="QQ" value="${guest.qq }">
					</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left">微信：</div> 
	    			<div class="dd_right">
	    				<input name="weChat" type="text" class="IptText300"  placeholder="微信" value="${guest.weChat }">
					</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left">E-mail：</div> 
	    			<div class="dd_right">
	    				<input name="mail" type="text" class="IptText300"  placeholder="E-mail" value="${guest.mail }">
					</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left">住址：</div> 
	    			<div class="dd_right">
	    				<input type="hidden" name="adProvinceName" id="adProvinceName" />
	    				<input type="hidden" name="adCityName" id="adCityName" />
	    				<select name="adProvinceId" id="adProvinceId" class="input-small">
							<option value="">请选择省</option>		
							<c:forEach items="${allProvince}" var="province">
								<option value="${province.id }" <c:if test="${guest.adProvinceId!=null && guest.adProvinceId==province.id  }">selected</c:if> >${province.name }</option>
							</c:forEach>					
						</select> 
						<select name="adCityId" id="adCityId" class="input-small">
							<option value="">请选择市</option>
							<c:forEach items="${adCityList}" var="city">
								<option value="${city.id }" <c:if test="${guest.adCityId!=null && city.id==guest.adCityId }"> selected</c:if>>${city.name }</option>
							</c:forEach>
						</select> 
						<input name="addr" type="text" class="IptText300"  placeholder="地址" value="${guest.addr }" />
						
					</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left">备注：</div> 
	    			<div class="dd_right">
	    				<input name="remark" type="text" class="IptText300"  placeholder="备注" value="${guest.remark }">
					</div>
					<div class="clear"></div>
	    		</dd>
	    		
	    		<p class="p_paragraph_title"><b>客人标签:</b></p>
				<div class="search-con">
		            	<c:forEach items="${supplierGuestLabels}" var="supplierGuest" varStatus="status">
				    		<ul>
				    			<c:forEach items="${supplierGuest}" var="sup" varStatus="status">
				    				<li id="${sup.id }" onclick="choseLable(${sup.id });">
				    					<c:if test="${sup.choose eq true }">
				    						<input type="hidden" id="label${sup.id }"  value="1"/>
				    						<img src="../assets/img/pop_imgDelte.png" class="label-icon label-sel"/>
				    					</c:if>
				    					<c:if test="${sup.choose ne true }">
				    						<input type="hidden" id="label${sup.id }"  value="0"/>
				    						<img src="../assets/img/pop_imgDelte.png" class="label-icon"/>
				    					</c:if>
				    					
				    					<input type="hidden" id="labelName${sup.id }"  value="${sup.name }"/>
					    				<p class="label-name" style="cursor:pointer;">${sup.name }</p>
					    				
					    			</li>
				    			</c:forEach>
				    		</ul>
			    		</c:forEach>
	            		
	            	</div>
	    		
	    		<dd class="Footer">
	    			<div class="dd_left"></div> 
	    			<div class="dd_right">
	    				<c:if test="${reqpm.check ne true }">
	    					<button type="submit" class="button button-primary button-small">保存</button>
	    				</c:if>
	    				 <button type="button" onclick="closeWindow()" class="button button-primary button-small">关闭</button> 
	    			</div>
	    		</dd>
	    	</dl>
		</form>
	</div>	
</body>
<script type="text/javascript">
	function beforeSubmit(){
		if($("#provinceId").val()){
			$("#provinceName").val($("#provinceId").find("option:selected").text());			
		}
		if($("#cityId").val()){
			$("#cityName").val($("#cityId").find("option:selected").text());			
		}
		if($("#adProvinceId").val()){
			$("#adProvinceName").val($("#adProvinceId").find("option:selected").text());			
		}
		if($("#adCityId").val()){
			$("#adCityName").val($("#adCityId").find("option:selected").text());			
		}
		
		var a =getApplyList();
		$("#choseIds").val(a[0]);
		
	}
	$(function(){
		
		$(".search-con ul").on("click","li",function () {
			$(this).find(".label-icon").toggleClass("label-sel");
		})
		
	$("#guestForm").validate({
		rules : {
			'name' : {
				required : true
			},
			'mobile':{
				required : true,
				isMobile:true
			}
		},
		messages : {
			'name' : {
				required : "请输入姓名"
			}
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
			beforeSubmit();
			var options = {
				url : "saveGuest.do",
				type : "post",
				dataType : "json",
				success : function(data) {
					if (data.success) {
						$.success("保存成功",function(){
							closeWindow();
						});
					} else {
						$.error("保存失败"+data.msg);
					}
				},
				error : function(XMLHttpRequest, textStatus,
						errorThrown) {
					$.error("服务忙，请稍后再试");
				}
			}
			$(form).ajaxSubmit(options);
		},
		invalidHandler : function(form, validator) { // 不通过回调
			return false;
		}
	});
	
	$("#provinceId").change(
			function() {
				var s = "<option value=''>请选择市</option>";
				var val = this.options[this.selectedIndex].value;
				if(val !== ''){
					$.getJSON("<%=ctx%>/basic/getRegion.do?id="
							+ $("#provinceId").val(), function(data) {
						data = eval(data);
						var s = "<option value=''>请选择市</option>";
						$.each(data, function(i, item) {
							s += "<option value='" + item.id + "'>" + item.name
									+ "</option>";
						});
						$("#cityId").html(s);
					});
				}else{
					$("#cityId").html(s);
				}

				/* $("#areaId").html("<option value=''>请选择区县</option>");
				$("#townId").html("<option value=''>请选择街道</option>"); */

				});
	$("#adProvinceId").change(
			function() {
				var s = "<option value=''>请选择市</option>";
				var val = this.options[this.selectedIndex].value;
				if(val !== ''){
					$.getJSON("<%=ctx%>/basic/getRegion.do?id="
							+ $("#adProvinceId").val(), function(data) {
						data = eval(data);
						var s = "<option value=''>请选择市</option>";
						$.each(data, function(i, item) {
							s += "<option value='" + item.id + "'>" + item.name
									+ "</option>";
						});
						$("#adCityId").html(s);
					});
				}else{
					$("#adCityId").html(s);
				}

				/* $("#areaId").html("<option value=''>请选择区县</option>");
				$("#townId").html("<option value=''>请选择街道</option>"); */

				});
	});
	
	function choseLable(id){
		var val =$("#label"+id).val();
		if(val==0){
			$("#label"+id).val(1);
		}else{
			$("#label"+id).val(0);
		}
	}
	
	function getApplyList(){
		var date = [];
		var names = [];
		var notIds = [];
		$(".p_container .search-con ").each(function(){

			var obj = [];
			var ul = $(this).find("li");
			for(var i = 0; i < ul.length; i++){
				var item = ul[i];
				var id = $(item).attr("id");
				var value = $("#label"+id).val();
				if(value==1){
					notIds.push(id);	
					names.push($("#labelName"+id).val());
				}
			}
		});
		date[0] = notIds;
		date[1] = names;
		return date;
	}

</script>
</html>