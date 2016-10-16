<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>司机信息维护</title>
<%@ include file="../../../include/top.jsp"%>
<style type="text/css">
	.text {width:300px;min-height:10px;}
</style>
</script>
</head>
<body>
	<div class="p_container">
		<form class="form-horizontal" id="driverForm">
			<input type="hidden" name="id" value="${driver.id }"/>
			<input type="hidden" name="state" value="0" value="${driver.state }"/>
			<dl class="p_paragraph_content">
	    		<dd>
	    			<div class="dd_left">姓名：</div> 
	    			<div class="dd_right text">${driver.name }</div>
	    			<div class="dd_left">性别：</div> 
	    			<div class="dd_right text">
	    				<c:if test="${not empty driver.id ne ''}">
	    					<c:if test="${driver.gender eq 0 }">男</c:if>
	    					<c:if test="${driver.gender eq 1 }">女</c:if>
	    				</c:if>
					</div>
					<div class="clear"></div>
	    		</dd> 
	    		<dd>
	    			<div class="dd_left">籍贯：</div> 
	    			<div class="dd_right text">${driver.nativePlace }</div>
					<div class="dd_left">民族：</div> 
	    			<div class="dd_right text">
    					<c:forEach var="mz" items="${mzList}">
	    					<c:if test="${driver.nationality!=null && mz.id == driver.nationality }">${mz.value }</c:if>	    						
    					</c:forEach>
					</div>
					<div class="clear"></div>
	    		</dd> 
	    		<dd>
	    			<div class="dd_left">手机：</div> 
	    			<div class="dd_right text">${driver.mobile }</div>
	    			<div class="dd_left">身份证号：</div> 
	    			<div class="dd_right text">${driver.idCardNo }</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left">领证日期：</div> 
	    			<div class="dd_right text">
	    				<fmt:formatDate pattern='yyyy-MM-dd' value='${driver.licenseDate }'/>
					</div>
					<div class="dd_left">驾驶证号：</div> 
	    			<div class="dd_right text">${driver.licenseNo }</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left">住址：</div> 
	    			<div class="dd_right">
	    				<c:if test="${not empty driver.provinceName}">
	    					${driver.provinceName}（省/市）
	    				</c:if>
	    				<c:if test="${not empty driver.cityName}">
	    					${driver.cityName}（市）
	    				</c:if>
	    				<c:if test="${not empty driver.areaName}">
	    					${driver.areaName}（县/区）
	    				</c:if>
	    				<c:if test="${not empty driver.townName}">
	    					${driver.townName}（县/区）
	    				</c:if>
	    				${driver.addr }
					</div>
					<div class="clear"></div>
				</dd>
	    		<dd>
	    			<div class="dd_left">头像：</div> 
	    			<div class="dd_right">
	    				<span class="ulImg">	
	    					<input type="hidden" name="photo" value="${driver.photo}"/>    	
	    					<c:choose>  
							   <c:when test="${empty driver.photo}">  
							   		<img src="<%=staticPath %>/assets/img/uploadImg.png" alt="" />
							   </c:when>  
							     
							   <c:otherwise> 
							   		<img src="${images_source_200}/${driver.photo}" alt="" />
							   </c:otherwise>  
							</c:choose>  				
	    					
	    				</span>
					</div>
					<div class="clear"></div>
	    		</dd>
	    	</dl>
		</form>
	</div>	
</body>
<script type="text/javascript">



	$("#driverForm").validate({
		rules : {
			'name' : {
				required : true
			},
			'mobile' : {
				isPhone : true
			}
		},
		messages : {
			'name' : {
				required : "请输入名称"
			},
			'mobile' : {
				isPhone : "手机号格式不合法"
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
			//beforeSubmit();
			var options = {
				url : "saveDriver.do",
				type : "post",
				dataType : "json",
				success : function(data) {
					var isAdd = data["isAdd"];
					if(isAdd == "true"){
						$.success("保存成功");
						refreshWindow("修改司机", "<%=staticPath %>/supplier/driver/editDriver.htm?id="+ data["id"]);	
					}else{
						$.success("修改成功");
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
				$("#provinceName").val($(this).find("option:selected").text());
				
				$("#cityId").html("<option value=''>请选择市</option>");
				$("#areaId").html("<option value=''>请选择区县</option>");
				$("#townId").html("<option value=''>请选择街道</option>");
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

			});

	$("#cityId").change(
			function() {
				$("#cityName").val($(this).find("option:selected").text());
				
				$("#areaId").html("<option value=''>请选择区县</option>");
				$("#townId").html("<option value=''>请选择街道</option>");
				$.getJSON("<%=ctx%>/basic/getRegion.do?id=" + $("#cityId").val(),
						function(data) {
							data = eval(data);
							var s = "<option value=''>请选择区县</option>";
							$.each(data, function(i, item) {
								s += "<option value='" + item.id + "'>"
										+ item.name + "</option>";
							});
							$("#areaId").html(s);

						});

			});
	$("#areaId").change(function() {
		$("#areaName").val($(this).find("option:selected").text());
		
		$("#townId").html("<option value=''>请选择街道</option>");
		$.getJSON("<%=ctx%>/basic/getRegion.do?id=" + $("#areaId").val(),
				function(data) {
					data = eval(data);
					var s = "<option value=''>请选择街道</option>";
					$.each(data, function(i, item) {
						s += "<option value='" + item.id + "'>"
								+ item.name + "</option>";
					});
					$("#townId").html(s);

				});
		});

	$("#townId").change(function() {
		$("#townName").val($(this).find("option:selected").text());
		});
	
	$("#nationality").change(function() {
		$("#nationalityName").val($(this).find("option:selected").text());
		});
	
	
	function selectAttachment(clickObj){
		var win;
		layer.open({ 
			type : 2,
			title : '选择图片/文件',
			closeBtn : false,
//			area : [ '980px', '620px' ],
			area : [{minLength : '1100px', areas : ['980px', '620px']}, {maxLength : '1100px', areas : ['600px', '450px']}],
			shadeClose : false,
			content : '<%=ctx%>/component/imgSelect.htm',
			btn: ['确定', '取消'],
			success:function(layero, index){
				win = window[layero.find('iframe')[0]['name']];
			},
			yes: function(index){
				//orgArr返回的是org对象的数组
				var arr = win.getImgSelected();    				
				if(arr.length==0){
					$.warn("请选择图片");
					return false;
				}
				
				//for(var i=0;i<arr.length;i++){
					//console.log("name:"+arr[i].name+",path:"+arr[i].path+",thumb:"+arr[i].thumb);
				//}
				var imgInfo = arr[0];
				$("input[name='photo']").val(imgInfo.path);
				clickObj.attr("src", imgInfo.thumb);
				
				//一般设定yes回调，必须进行手工关闭
		        layer.close(index); 
		    },cancel: function(index){
		    	layer.close(index);
		    }
		});
	}
	
	function carChange(ckb){
		var arr = [];
		$("input[name='ckb_permitCarType']:checked").each(function (i,o) {
            arr.push(this.value);
        })
        $("#permitCarType").val(arr.join());
	}
	
	function checkCar(){
		var cars = "${driver.permitCarType}".split(",");
		$("input[name='ckb_permitCarType']").each(function (i,o) {
			$.each(cars,function(ii,oo){
				if(oo == o.value){
					$(o).attr("checked","checked");
				}
			});
        })
	}
	

	$(function() {
		$.validator.addMethod("isPhone", function(value, element) {
			var length = value.length;
			var mobile = /^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0-9]|170)\d{8}$/;
			var tel = /^\d{3,4}-?\d{7,9}$/;
			return this.optional(element) || (tel.test(value) || mobile.test(value));
		}, "请输入正确的手机号码");

		$(".ulImg img").click(function() {
			selectAttachment($(this));
		});
		checkCar();
	})
</script>
</html>