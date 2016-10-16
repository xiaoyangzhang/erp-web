<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>新增导游</title>
<%@ include file="../../../include/top.jsp"%>
</script>
</head>
<body>
	<div class="p_container">
		<form class="form-horizontal" id="guideForm">
			<input type="hidden" name="id"/>
			<input type="hidden" name="state" value="0"/>
			<p class="p_paragraph_title"><b>导游基本信息:</b></p>
			<dl class="p_paragraph_content">
	    		<dd>
	    			<div class="dd_left"><i class="red">* </i>姓名：</div> 
	    			<div class="dd_right">
	    				<input name="name" type="text" class="IptText300" placeholder="姓名" value="${guide.name }" />
	    			</div>
					<div class="clear"></div>
	    		</dd> 
	    		<dd>
	    			<div class="dd_left">性别：</div> 
	    			<div class="dd_right">
	    				<input name="gender" type="radio" value="0" checked />男
	    				<input name="gender" type="radio" value="1" />女
					</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left">出生日期：</div> 
	    			<div class="dd_right">
	    				<input type="text" name="birthDate" class="Wdate"
							onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
					</div>
					<div class="clear"></div>
	    		</dd>  		
	    		<dd>
	    			<div class="dd_left">民族：</div> 
	    			<div class="dd_right">
	    				<input type="hidden" name="nationalityName" id="nationalityName" />
	    				<select name="nationality" id="nationality">
	    					<option value="-1">请选择</option>
	    					<c:forEach var="mz" items="${mzList}">
		    					<option value="${mz.id }">${mz.value }</option>	    						
	    					</c:forEach>
	    				</select>
					</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left">籍贯：</div> 
	    			<div class="dd_right">
	    				<input name="nativePlace" type="text" class="IptText300" placeholder="籍贯" />
					</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left"><i class="red">* </i>手机：</div> 
	    			<div class="dd_right">
	    				<input name="mobile" type="text" class="IptText300" placeholder="手机" />
					</div>
					<div class="clear"></div>
	    		</dd>
	    		
	    		<dd>
	    			<div class="dd_left"><i class="red">* </i>身份证号：</div> 
	    			<div class="dd_right">
	    				<input name="idCardNo" type="text" class="IptText300"  placeholder="身份证">
					</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left"><i class="red">* </i>导游证号：</div> 
	    			<div class="dd_right">
	    				<input name="licenseNo" type="text" class="IptText300" placeholder="导游证号">
					</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left"><i class="red">* </i>开户行：</div> 
	    			<div class="dd_right">
	    				<input name="bankName" type="text" class="IptText300" placeholder="开户行">
					</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left"><i class="red">* </i>银行账号：</div> 
	    			<div class="dd_right">
	    				<input name="bankAccount" type="text" class="IptText300" placeholder="银行账号">
					</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left">资格证号：</div> 
	    			<div class="dd_right">
	    				<input name="licenseNoQuality" type="text" class="IptText300" placeholder="资格证号">
					</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left">初次领证日期：</div> 
	    			<div class="dd_right">
	    				<input type="text" name="licenseDate" class="Wdate"
							onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
					</div>
					<div class="clear"></div>
	    		</dd> 
	    		<dd>
	    			<div class="dd_left">等级：</div> 
	    			<div class="dd_right">
	    				<input type="hidden" name="levelName" id="levelName" />
	    				<select name="level" id="level">
	    					<option value="-1">请选择</option>
	    					<c:forEach var="dj" items="${djList}">
		    					<option value="${dj.id }">${dj.value }</option>	    						
	    					</c:forEach>
	    				</select>
					</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left">星级评定：</div> 
	    			<div class="dd_right">
	    				<input type="hidden" name="starLevelName" id="starLevelName" />
	    				<select name="starLevel" id="starLevel">
	    					<option value="-1">请选择</option>
	    					<c:forEach var="xjpd" items="${xjpdList}">
		    					<option value="${xjpd.id }">${xjpd.value }</option>	    						
	    					</c:forEach>
	    				</select>
					</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left">导游语种：</div> 
	    			<div class="dd_right">
	    				<input name="language" type="text" class="IptText300" placeholder="导游语种">
					</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left">适合带团人数：</div> 
	    			<div class="dd_right">
	    				<input type="hidden" name="personZoneName" id="personZoneName" />
	    				<select name="personZoneId" id="personZoneId">
	    					<option value="">请选择</option>
	    					<c:forEach var="rs" items="${shdtrsList}">
		    					<option value="${rs.id }">${rs.value }</option>	    						
	    					</c:forEach>
	    				</select>
					</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left">适合带团区域：</div> 
	    			<div class="dd_right">
	    				<input name="personArea" type="text" class="IptText300" placeholder="适合带团区域">
					</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left">专/兼职：</div> 
	    			<div class="dd_right">
	    				<input name="isFullTime" type="radio" value="1" checked/>专职
	    				<input name="isFullTime" type="radio" value="2"/>兼职
					</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left">住址：</div> 
	    			<div class="dd_right">
	    				<input type="hidden" name="provinceName" id="provinceName" />
	    				<input type="hidden" name="cityName" id="cityName" />
	    				<input type="hidden" name="areaName" id="areaName" />
	    				<input type="hidden" name="townName" id="townName" />
	    				<select name="provinceId" id="provinceId" class="input-small">
							<option value="">请选择省</option>	
							<c:forEach items="${allProvince}" var="province">
								<option value="${province.id }">${province.name }</option>
							</c:forEach>						
						</select> <select name="cityId" id="cityId" class="input-small">
							<option value="">请选择市</option>
						</select> <select name="areaId" id="areaId" class="input-small">
							<option value="">请选择区县</option>
						</select> <select name="townId" id="townId" class="input-small">
							<option value="">请选择街道</option>
						</select>
						<input name="addr" type="text" class="IptText300"  placeholder="地址" />
					</div>
					<div class="clear"></div>
	    		<dd>
	    			<div class="dd_left">头像：</div> 
	    			<div class="dd_right">
	    				<span class="ulImg">	
	    					<input type="hidden" name="photo" />    					
	    					<img src="<%=staticPath %>/assets/img/uploadImg.png" alt="" />
	    				</span>
					</div>
					<div class="clear"></div>
	    		</dd>
	    		<!-- <dd>
	    			<div class="dd_left">生活照：</div> 
	    			<div class="dd_right">
	    				<span class="ulImg">
	    					<img src="assets/imgTemp/upImgDefault.png" alt="" />
	    				</span>
					</div>
					<div class="clear"></div>
	    		</dd> -->
	    		<dd class="Footer">
	    			<div class="dd_left"></div> 
	    			<div class="dd_right">
	    				<button type="submit" class="button button-primary button-small">保存</button>
	    				 <button type="button" onclick="closeWindow()" class="button button-primary button-small">关闭</button> 
	    			</div>
	    		</dd>
	    	</dl>
		</form>
	</div>	
</body>
<script type="text/javascript">
	function beforeSubmit(){
		if($("#nationality").val()!=-1){
			$("#nationalityName").val($("#nationality").find("option:selected").text());			
		}
		if($("#level").val()!=-1){
			$("#levelName").val($("#level").find("option:selected").text());			
		}
		if($("#starLevel").val()!=-1){
			$("#starLevelName").val($("#starLevel").find("option:selected").text());			
		}
		if($("#personZoneId").val()){
			$("#personZoneName").val($("#personZoneId").find("option:selected").text());			
		}
		if($("#provinceId").val()){
			$("#provinceName").val($("#provinceId").find("option:selected").text());			
		}
		if($("#cityId").val()){
			$("#cityName").val($("#cityId").find("option:selected").text());			
		}
		if($("#areaId").val()){
			$("#areaName").val($("#areaId").find("option:selected").text());			
		}
		if($("#townId").val()){
			$("#townName").val($("#townId").find("option:selected").text());			
		}
	}
	
	$("#guideForm").validate({
		rules : {
			'name' : {
				required : true
			},
			'idCardNo' : {
				required : true
			},
			'licenseNo' : {
				required : true
			},
			'mobile':{
				required : true,
				isMobile:true
			}
		},
		messages : {
			'name' : {
				required : "请输入名称"
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
				url : "saveGuide.do",
				type : "post",
				dataType : "json",
				success : function(data) {
					if (data.sucess) {
						$.success("保存成功");
						//window.location = "guideList.htm";
		            	refreshWindow("修改导游","<%=staticPath %>/supplier/editGuide.htm?id="+data['guideId']);

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

				$("#areaId").html("<option value=''>请选择区县</option>");
				$("#townId").html("<option value=''>请选择街道</option>");


			});

	$("#cityId").change(
			function() {
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
	
	$(function(){
		$(".ulImg img").click(function(){
			selectAttachment($(this));
		})
	})
</script>
</html>