<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>新增供应商</title>
<%@ include file="../../include/top.jsp"%>
<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/supplier.js"></script>
<script type="text/javascript" charset="utf-8"
	src="<%=ctx%>/assets/ueditor/ueditor.config.js"></script>
<script type="text/javascript" charset="utf-8"
	src="<%=ctx%>/assets/ueditor/ueditor.all.min.js">
	
</script>
<script type="text/javascript">
	$(function(){
		$("input[name='nameFull']").blur(function(){
			if($("input[name='nameShort']").val()==''){
			$("input[name='nameShort']").val($("input[name='nameFull']").val());
			}
		});
	});
	function back(type){
		var map = ['toTravelagencyList.htm', 'toRestaurantList.htm', 'toHotelList.htm', 'toFleetList.htm',
			'toScenicspotList.htm', 'toShoppingList.htm', 'toEntertainmentList.htm', '', 'toAirticketagentList.htm', 'toTrainticketagentList.htm', 'toGolfList.htm', 'toOtherList.htm'];
		window.location = map[type - 1];
	}
</script>
<!--建议手动加在语言，避免在ie下有时因为加载语言失败导致编辑器加载失败-->
<!--这里加载的语言文件会覆盖你在配置项目里添加的语言类型，比如你在配置项目里配置的是英文，这里加载的中文，那最后就是中文-->
<script type="text/javascript" charset="utf-8"
	src="<%=ctx%>/assets/ueditor/lang/zh-cn/zh-cn.js"></script>


</head>
<body>
	<div class="p_container" >
		<ul class="w_tab">
	    	<li><a href="javascript:void(0)" class="selected">基本信息</a></li>
	    	<li><a href="toBusinessInfo.htm?supplierId=${supplierInfo.id}&operType=${operType}">结算信息</a></li>
	    	<li><a href="toContactManList.htm?id=${supplierInfo.id}&operType=${operType}">联系人</a></li>
	    	<li><a href="toFolderList.htm?id=${supplierInfo.id}&supplierType=${supplierInfo.supplierType}&operType=${operType}">图片</a></li>
    		
	    	<li class="clear"></li>
	    </ul>
		
		<div class="p_container_sub" id="tab1">	
			<dl class="p_paragraph_content"> 	
			<form class="definewidth m20" id="editSupplierForm">
			<input type="hidden" name="supplierType"
				value="${supplierInfo.supplierType }" />
			<input type="hidden" name="id" value="${supplierInfo.id}" />
			<input type="hidden" name="state" value="${supplierInfo.state}" />
			<dd>
    			<div class="dd_left"><i class="red">* </i>全称：</div> 
    			<div class="dd_right">
    				<input name="nameFull" type="text" class="IptText300" value="${supplierInfo.nameFull }" placeholder="全称" />
    			</div>
				<div class="clear"></div>
    		</dd> 
    		<dd>
		    	<div class="dd_left"><i class="red">* </i>简称：</div> 
		    	<div class="dd_right">
		    		<input name="nameShort" type="text" class="IptText300" value="${supplierInfo.nameShort }" placeholder="简称" />
		    	</div>
				<div class="clear"></div>
			</dd>
			<dd>
		    	<div class="dd_left">英文名：</div> 
		    	<div class="dd_right">
		    		<input name="nameEn" type="text" class="IptText300" value="${supplierInfo.nameEn }" placeholder="英文名" />
		    	</div>
				<div class="clear"></div>
			</dd>
			<dd>
		    	<div class="dd_left">编码：</div> 
		    	<div class="dd_right">
		    		<input name="code" type="text" class="IptText300" value="${supplierInfo.code }" placeholder="编码" />
		    	</div>
				<div class="clear"></div>
			</dd>
			<dd>
			
				<c:if test="${supplierInfo.supplierType==1}">
				<div class="dd_left">类别：</div>
				<div class="dd_right"><select name="level"
					placeholder="请选择">
						<c:forEach items="${travelagencylevelList}" var="level">
							<option value="${level.id }"
								<c:if test="${supplierInfo.level==level.id }"> selected="selected" </c:if>>${level.value }</option>
						</c:forEach>
				</select></div>
				</c:if>
				
				<c:if test="${supplierInfo.supplierType==2}">
				<div class="dd_left">类别：</div>
				<div class="dd_right"><select name="level"
					placeholder="请选择">
						<c:forEach items="${restaurantlevelList}" var="level">
							<option value="${level.id }"
								<c:if test="${supplierInfo.level==level.id }"> selected="selected" </c:if>>${level.value }</option>
						</c:forEach>
				</select></div>
				</c:if>
				
				<c:if test="${supplierInfo.supplierType==3}">
				<div class="dd_left">星级：</div>
				<div class="dd_right"><select name="level"
					placeholder="请选择">
						<c:forEach items="${levelList}" var="level">
							<option value="${level.id }"
								<c:if test="${supplierInfo.level==level.id }"> selected="selected" </c:if>>${level.value }</option>
						</c:forEach>
				</select></div>
				</c:if>
				
				<c:if test="${supplierInfo.supplierType==4}">
				<div class="dd_left">类别：</div>
				<div class="dd_right"><select name="level"
					placeholder="请选择">
						<c:forEach items="${fleetlevelList}" var="level">
							<option value="${level.id }"
								<c:if test="${supplierInfo.level==level.id }"> selected="selected" </c:if>>${level.value }</option>
						</c:forEach>
				</select></div>
				</c:if>
				
				<c:if test="${supplierInfo.supplierType==5}">
				<div class="dd_left">类别：</div>
				<div class="dd_right"><select name="level"
					placeholder="请选择">
						<c:forEach items="${scenicspotlevelList}" var="level">
							<option value="${level.id }"
								<c:if test="${supplierInfo.level==level.id }"> selected="selected" </c:if>>${level.value }</option>
						</c:forEach>
				</select></div>
				</c:if>
				
				<c:if test="${supplierInfo.supplierType==6}">
				<div class="dd_left">类别：</div>
				<div class="dd_right"><select name="level"
					placeholder="请选择">
						<c:forEach items="${shoppinglevelList}" var="level">
							<option value="${level.id }"
								<c:if test="${supplierInfo.level==level.id }"> selected="selected" </c:if>>${level.value }</option>
						</c:forEach>
				</select></div>
				</c:if>
				
				<c:if test="${supplierInfo.supplierType==7}">
				<div class="dd_left">类别：</div>
				<div class="dd_right"><select name="level"
					placeholder="请选择">
						<c:forEach items="${entertainmentlevelList}" var="level">
							<option value="${level.id }"
								<c:if test="${supplierInfo.level==level.id }"> selected="selected" </c:if>>${level.value }</option>
						</c:forEach>
				</select></div>
				</c:if>
				
				<c:if test="${supplierInfo.supplierType==8}">
				<div class="dd_left">类别：</div>
				<div class="dd_right"><select name="level"
					placeholder="请选择">
						<c:forEach items="${guidelevelList}" var="level">
							<option value="${level.id }"
								<c:if test="${supplierInfo.level==level.id }"> selected="selected" </c:if>>${level.value }</option>
						</c:forEach>
				</select></div>
				</c:if>
				
				<c:if test="${supplierInfo.supplierType==9}">
				<div class="dd_left">类别：</div>
				<div class="dd_right"><select name="level"
					placeholder="请选择">
						<c:forEach items="${airticketagentlevelList}" var="level">
							<option value="${level.id }"
								<c:if test="${supplierInfo.level==level.id }"> selected="selected" </c:if>>${level.value }</option>
						</c:forEach>
				</select></div>
				</c:if>
				
				<c:if test="${supplierInfo.supplierType==10}">
				<div class="dd_left">类别：</div>
				<div class="dd_right"><select name="level"
					placeholder="请选择">
						<c:forEach items="${trainticketagentlevelList}" var="level">
							<option value="${level.id }"
								<c:if test="${supplierInfo.level==level.id }"> selected="selected" </c:if>>${level.value }</option>
						</c:forEach>
				</select></div>
				</c:if>
				
				<c:if test="${supplierInfo.supplierType==11}">
				<div class="dd_left">类别：</div>
				<div class="dd_right"><select name="level"
					placeholder="请选择">
						<c:forEach items="${golflevelList}" var="level">
							<option value="${level.id }"
								<c:if test="${supplierInfo.level==level.id }"> selected="selected" </c:if>>${level.value }</option>
						</c:forEach>
				</select></div>
				</c:if>
				
				<c:if test="${supplierInfo.supplierType==12}">
				<div class="dd_left">类别：</div>
				<div class="dd_right"><select name="level"
					placeholder="请选择">
						<c:forEach items="${otherlevelList}" var="level">
							<option value="${level.id }"
								<c:if test="${supplierInfo.level==level.id }"> selected="selected" </c:if>>${level.value }</option>
						</c:forEach>
				</select></div>
				</c:if>
				
				<c:if test="${supplierInfo.supplierType==15}">
				<div class="dd_left">类别：</div>
				<div class="dd_right"><select name="level"
					placeholder="请选择">
						<c:forEach items="${insuranclevelList}" var="level">
							<option value="${level.id }"
								<c:if test="${supplierInfo.level==level.id }"> selected="selected" </c:if>>${level.value }</option>
						</c:forEach>
				</select></div>
				</c:if>
				<c:if test="${supplierInfo.supplierType==16}">
				<div class="dd_left">类别：</div>
				<div class="dd_right"><select name="level"
					placeholder="请选择">
						<c:forEach items="${localtravelList}" var="level">
							<option value="${level.id }"
								<c:if test="${supplierInfo.level==level.id }"> selected="selected" </c:if>>${level.value }</option>
						</c:forEach>
				</select></div>
				</c:if>
				
				<div class="clear"></div>
			</dd>			
			<dd>	
				<div class="dd_left"><i class="red">* </i>法人：</div>
				<div class="dd_right"><input type="text" class="IptText300"
					name="lawPerson" value="${supplierInfo.lawPerson}" placeholder="法人" /></div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">前台电话：</div>
				<div class="dd_right"><input type="text" class="IptText300"
					name="receptionTel" value="${supplierInfo.receptionTel }"
					placeholder="前台电话" /></div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">前台传真：</div>
				<div class="dd_right"><input type="text" class="IptText300"
					name="receptionFax" value="${supplierInfo.receptionFax }"
					placeholder="前台传真" /></div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">开业时间：</div>
				<div class="dd_right"><input type="text"
					name="dateOpen" class="Wdate"
					value="<fmt:formatDate pattern='yyyy-MM-dd' value='${supplierInfo.dateOpen}'/>"
					onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" /></div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">网址：</div>
				<div class="dd_right">http://<input type="text" class="IptText300"
					name="website" value="${supplierInfo.website }"
					placeholder="请输入网址" /></div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">邮编：</div>
				<div class="dd_right"><input type="text" class="IptText300"
					name="zipCode" value="${supplierInfo.zipCode }"
					placeholder="100000" /></div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">最近装修时间：</div>
				<div class="dd_right"><input type="text"
					name="dateDecoration"
					value="<fmt:formatDate pattern='yyyy-MM-dd' value='${supplierInfo.dateDecoration}'/>"
					class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" /></div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">区域：</div>
				<div class="dd_right">
				<select name="provinceId" id="provinceCode">
						<option value="">请选择省</option>
						<c:forEach items="${allProvince}" var="province">
							<option value="${province.id }"
								<c:if test="${province.id==supplierInfo.provinceId }"> selected="selected" </c:if>>${province.name }</option>
						</c:forEach>
				</select> 
				<select name="cityId" id="cityCode">
						<option value="">请选择市</option>
						<c:forEach items="${cityList}" var="city">
							<option value="${city.id }"
								<c:if test="${city.id==supplierInfo.cityId }"> selected="selected" </c:if>>${city.name }</option>
						</c:forEach>
				</select> <select name="areaId" id="areaCode">
						<option value="">请选择区县</option>	
						<c:forEach items="${areaList}" var="area">
							<option value="${area.id }"
								<c:if test="${area.id==supplierInfo.areaId }"> selected="selected" </c:if>>${area.name }</option>
						</c:forEach>
				</select> <select name="townId" id="townCode">
						<option value="">请选择街道</option>
						<c:forEach items="${townList}" var="town">
							<option value="${town.id }"
								<c:if test="${town.id==supplierInfo.townId }"> selected="selected" </c:if>>${town.name }</option>
						</c:forEach>
				</select></div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">商圈：</div>
				<div class="dd_right"><input type="text" class="IptText300"
					name="bussinessDistrictName" value="${supplierInfo.bussinessDistrictName }"/></div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">地理坐标：</div>
				<div class="dd_right">经度<input name="positionLon" class="input-large"
					value="${supplierInfo.positionLon }" readonly="readonly" /> 纬度<input
					name="positionLat" value="${supplierInfo.positionLat }" class="input-large"
					readonly="readonly" />
					<button type="button" onclick="baiduMap();" class="button button-small">查找经纬度</button>
				</div>
				<div class="clear"></div>
			</dd>			
			<dd>
				<div class="dd_left">地址：</div>
				<div class="dd_right"><span id="pValue">${supplierInfo.provinceName }</span><span id="cValue">${supplierInfo.cityName }</span><span id="aValue">${supplierInfo.areaName }</span><span id="tValue">${supplierInfo.townName }</span><span></span><input
					type="text" class="IptText300" name="address"
					placeholder="红拼108号" value="${supplierInfo.address }" /></div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">简单介绍：</div>
				<div class="dd_right"><textarea name="introBrief" class="w_textarea"
						placeholder="简单介绍" style="width:680px">${supplierInfo.introBrief }</textarea>
				</div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">小贴士：</div>
				<div class="dd_right"><textarea class="w_textarea" name="introTip"
						placeholder="小贴士" style="width:680px">${supplierInfo.introTip }</textarea></div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">详细介绍：</div>
				<div class="dd_right"><script type="text/javascript">
					$(function() {
						window.UEDITOR_HOME_URL = "/assets/ueditor/";
						var ue = UE.getEditor('editor');
					});
				</script> <script id="editor" type="text/plain" name="intro"
						style="width: 700px; height:350px"> ${supplierInfo.intro} </script></div>
				<div class="clear"></div>
			</dd>
			<c:if test="${supplierInfo.supplierType==5 or supplierInfo.supplierType==6}">
				<dd>
	    			<div class="dd_left">费用项目：</div> 
	    			<div style="float:left;">
	    				<ul id="ulSel">
	    					<c:forEach items="${supplierItems}" var="v">
	    						<li sid="${v.id}" sname="${v.itemName}" >${v.itemName}<span class="pop_check_del"></span></li>
	    					</c:forEach>
						</ul>
						<div>
							<input type="text" id="txt_newItem" placeholder="请输入项目名称" value="">
							<input type="button" id="btn_newItem" class="button button-primary button-small" value="添加" onclick="supplierItem_new()" />
						</div>
						<input type="hidden" name="items" id="items" value=""/>
					</div>
					<div class="clear"></div>
    			</dd>
			</c:if>
			
		<dd class="Footer">
   			<div class="dd_left"></div> 
   			<div class="dd_right">
   			<c:if test="${operType==1}">
   				<button type="submit" class="button button-primary button-small">保存</button></c:if>

   				<button type="button" onclick="closeWindow()" class="button button-primary button-small">关闭</button>
   			</div>
	    </dd>
	</form>
					
			</dl>
	</div>
	</div>
	
</body>
</html>