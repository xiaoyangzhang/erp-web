<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="../../include/top.jsp"%>
<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/supplier.js"></script>
<script type="text/javascript" charset="utf-8"
	src="<%=ctx%>/assets/ueditor/ueditor.config.js"></script>
<script type="text/javascript" charset="utf-8"
	src="<%=ctx%>/assets/ueditor/ueditor.all.min.js">
	
</script>
<!--建议手动加在语言，避免在ie下有时因为加载语言失败导致编辑器加载失败-->
<!--这里加载的语言文件会覆盖你在配置项目里添加的语言类型，比如你在配置项目里配置的是英文，这里加载的中文，那最后就是中文-->
<script type="text/javascript" charset="utf-8"
	src="<%=ctx%>/assets/ueditor/lang/zh-cn/zh-cn.js"></script>
<script type="text/javascript">
	$(function(){
		$("input[name='nameFull']").blur(function(){
			if($("input[name='nameShort']").val()==''){
			$("input[name='nameShort']").val($("input[name='nameFull']").val());
			}
		});
	})
</script>
</head>
<body>
	<div class="p_container">
		<form class="form-horizontal" id="saveSupplierForm">
			<input type="hidden" name="supplierType" value="${supplierType}" />
			<input type="hidden" name="state" value="2" />
			<p class="p_paragraph_title"><b>基本信息:</b></p>
			<dl class="p_paragraph_content">
	    		<dd>
	    			<div class="dd_left"><i class="red">* </i>全称：</div> 
	    			<div class="dd_right">
	    				<input name="nameFull" type="text" class="IptText300" placeholder="全称" />
	    			</div>
					<div class="clear"></div>
	    		</dd> 
	    		<dd>
	    			<div class="dd_left"><i class="red">* </i>简称：</div> 
	    			<div class="dd_right">
	    				<input name="nameShort" type="text" class="IptText300" 
							placeholder="简称" />
					</div>
					<div class="clear"></div>
	    		</dd> 
	    		<dd>
	    			<div class="dd_left">英文名：</div> 
	    			<div class="dd_right">
	    				<input name="nameEn" type="text" class="IptText300" placeholder="英文名" />
					</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left">编码：</div> 
	    			<div class="dd_right">
	    				<input name="code" type="text" class="IptText300" placeholder="编码" />
					</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
					<c:if test="${supplierType==1}">
						<div class="dd_left">类别：</div>
						<div class="dd_right">
							<select name="level">
								<c:forEach items="${travelagencylevelList}" var="level">
									<option value="${level.id }">${level.value }</option>
								</c:forEach>
							</select>
						</div>
					</c:if>	
					<c:if test="${supplierType==2}">
						<div class="dd_left">类别：</div>
						<div class="dd_right">
							<select name="level">
								<c:forEach items="${restaurantlevelList}" var="level">
									<option value="${level.id }">${level.value }</option>
								</c:forEach>
							</select>
						</div>
					</c:if>	  
					<c:if test="${supplierType==3}">
						<div class="dd_left">星级：</div>
						<div class="dd_right">
							<select name="level">
								<c:forEach items="${levelList}" var="level">
									<option value="${level.id }">${level.value }</option>
								</c:forEach>
							</select>
						</div>
					</c:if>	  
					<c:if test="${supplierType==4}">
						<div class="dd_left">类别：</div>
						<div class="dd_right">
							<select name="level">
								<c:forEach items="${fleetlevelList}" var="level">
									<option value="${level.id }">${level.value }</option>
								</c:forEach>
							</select>
						</div>
					</c:if>	  
					<c:if test="${supplierType==5}">
						<div class="dd_left">类别：</div>
						<div class="dd_right">
							<select name="level">
								<c:forEach items="${scenicspotlevelList}" var="level">
									<option value="${level.id }">${level.value }</option>
								</c:forEach>
							</select>
						</div>
					</c:if>	  
					<c:if test="${supplierType==6}">
						<div class="dd_left">类别：</div>
						<div class="dd_right">
							<select name="level">
								<c:forEach items="${shoppinglevelList}" var="level">
									<option value="${level.id }">${level.value }</option>
								</c:forEach>
							</select>
						</div>
					</c:if>	  
					<c:if test="${supplierType==7}">
						<div class="dd_left">类别：</div>
						<div class="dd_right">
							<select name="level">
								<c:forEach items="${entertainmentlevelList}" var="level">
									<option value="${level.id }">${level.value }</option>
								</c:forEach>
							</select>
						</div>
					</c:if>	  
					<c:if test="${supplierType==8}">
						<div class="dd_left">类别：</div>
						<div class="dd_right">
							<select name="level">
								<c:forEach items="${guidelevelList}" var="level">
									<option value="${level.id }">${level.value }</option>
								</c:forEach>
							</select>
						</div>
					</c:if>	  
					<c:if test="${supplierType==9}">
						<div class="dd_left">类别：</div>
						<div class="dd_right">
							<select name="level">
								<c:forEach items="${airticketagentlevelList}" var="level">
									<option value="${level.id }">${level.value }</option>
								</c:forEach>
							</select>
						</div>
					</c:if>	  
					<c:if test="${supplierType==10}">
						<div class="dd_left">类别：</div>
						<div class="dd_right">
							<select name="level">
								<c:forEach items="${trainticketagentlevelList}" var="level">
									<option value="${level.id }">${level.value }</option>
								</c:forEach>
							</select>
						</div>
					</c:if>	  
					<c:if test="${supplierType==11}">
						<div class="dd_left">类别：</div>
						<div class="dd_right">
							<select name="level">
								<c:forEach items="${golflevelList}" var="level">
									<option value="${level.id }">${level.value }</option>
								</c:forEach>
							</select>
						</div>
					</c:if>	  
					<c:if test="${supplierType==12}">
						<div class="dd_left">类别：</div>
						<div class="dd_right">
							<select name="level">
								<c:forEach items="${otherlevelList}" var="level">
									<option value="${level.id }">${level.value }</option>
								</c:forEach>
							</select>
						</div>
					</c:if>	  
					<c:if test="${supplierType==15}">
						<div class="dd_left">类别：</div>
						<div class="dd_right">
							<select name="level">
								<c:forEach items="${insuranclevelList}" var="level">
									<option value="${level.id }">${level.value }</option>
								</c:forEach>
							</select>
						</div>
					</c:if>	
					<c:if test="${supplierType==16}">
						<div class="dd_left">类别：</div>
						<div class="dd_right">
							<select name="level">
								<c:forEach items="${localtravelList}" var="level">
									<option value="${level.id }">${level.value }</option>
								</c:forEach>
							</select>
						</div>
					</c:if>	  
					    			
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left"><i class="red">* </i>法人：</div> 
	    			<div class="dd_right">
	    				<input name="lawPerson" type="text" class="IptText300"
							placeholder="法人" />
					</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left">前台电话：</div> 
	    			<div class="dd_right">
	    				<input name="receptionTel" type="text" class="IptText300" placeholder="前台电话" />
					</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left">前台传真：</div> 
	    			<div class="dd_right">
	    				<input name="receptionFax" type="text" class="IptText300" placeholder="前台传真" />
					</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left">开业时间：</div> 
	    			<div class="dd_right">
	    				<input type="text" name="dateOpen" class="Wdate"
							onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
					</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left">网址：</div> 
	    			<div class="dd_right">
	    				http://<input name="website" type="text" class="IptText300"  placeholder="网址">
					</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left">邮编：</div> 
	    			<div class="dd_right">
	    				<input name="zipCode" type="text" class="IptText300" placeholder="邮编">
					</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left">最近装修时间：</div> 
	    			<div class="dd_right">
	    				<input type="text" name="dateDecoration" class="Wdate"
							onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
					</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left">区域：</div> 
	    			<div class="dd_right">
	    				<select name="provinceId" id="provinceCode" class="input-small">
							<option value="">请选择省</option>
							<c:forEach items="${allProvince}" var="province">
								<option value="${province.id }">${province.name }</option>
							</c:forEach>
						</select> <select name="cityId" id="cityCode" class="input-small">
							<option value="">请选择市</option>
						</select> <select name="areaId" id="areaCode" class="input-small">
							<option value="">请选择区县</option>
						</select> <select name="townId" id="townCode" class="input-small">
							<option value="">请选择街道</option>
						</select>
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left">商圈：</div> 
	    			<div class="dd_right">
	    				<input name="bussinessDistrictName" type="text"
							class="IptText300" placeholder="商圈" />
					</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left">地理坐标：</div> 
	    			<div class="dd_right">
	    				<input name="positionLon" type="text" class="input-large"
							readonly="readonly" placeholder="经度" />-<input
							name="positionLat" type="text" class="input-large"
							readonly="readonly" placeholder="纬度" />
						<button type="button" class="button button-small"
							onclick="baiduMap();">查找经纬度</button>
					</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left">地址：</div> 
	    			<div class="dd_right">
	    				<span id="pValue"></span><span id="cValue"></span><span id="aValue"></span><span id="tValue"></span><input name="address" type="text" class="IptText300"  placeholder="地址" />
					</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left">简单介绍：</div> 
	    			<div class="dd_right">
	    				<textarea class="w_textarea" name="introBrief"
							placeholder="简单介绍"></textarea>
					</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left">小贴士：</div> 
	    			<div class="dd_right">
	    				<textarea class="w_textarea" name="introTip"
							placeholder="小贴士"></textarea>
					</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left">详细介绍：</div> 
	    			<div class="dd_right">
	    				<script type="text/javascript">
							$(function() {
								window.UEDITOR_HOME_URL = "/assets/ueditor/";
								var ue = UE.getEditor('editor');
							});
						</script>
						<script id="editor" type="text/plain" name="intro"
							style="width: 700px; height:350px"></script>
					</div>
					<div class="clear"></div>
	    		</dd>
	    		<c:if test="${supplierType==5 or supplierType==6}">
	    		<dd>
	    			<div class="dd_left">费用项目：</div>
	    			<div style="float:left;">
						<ul id="ulSel">
						</ul>
					
						<input type="text" id="txt_newItem" placeholder="请输入项目名称" value="" style="width:100px;">
						<input type="button" id="btn_newItem" class="button button-primary button-small" value="添加" onclick="supplierItem_new()" />
					<input type="hidden" name="items" id="items"/></div>
					<div class="clear"></div>
	    		</dd>
	    		</c:if>
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
	<script type="text/javascript">
		var path = '<%=ctx%>';
		$(function () {
	        $(".AreaDef").autoTextarea({ minHeight: 80 });
	    });
	</script>
	<script type="text/javascript">

</script>	
</body>
</html>