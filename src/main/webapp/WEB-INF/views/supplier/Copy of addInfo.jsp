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


</head>
<body>
	<form class="definewidth m20" id="saveSupplierForm">


		<span class="level1">基本信息：</span>

		<table class="table table-bordered table-hover definewidth m10">
			<input type="hidden" name="supplierType" value="${supplierType}" />
			<input type="hidden" name="state" value="2" />
			<tr>
				<td width="10%" class="tableleft"><font color="red">*</font>全称：</td>
				<td width="20%" class="tableleft"><input type="text"
					name="nameFull" placeholder="全称" /></td>
				<td width="10%" class="tableleft"><font color="red">*</font>简称：</td>
				<td width="20%" class="tableleft"><input type="text"
					name="nameShort" placeholder="简称" /></td>
				<td width="10%" class="tableleft">英文名：</td>
				<td width="20%" class="tableleft"><input type="text"
					name="nameEn" placeholder="英文名" /></td>
			</tr>

			<tr>
				<td width="10%" class="tableleft">编码：</td>
				<td width="20%" class="tableleft"><input type="text"
					name="code" placeholder="QCYN" /></td>

				<c:if test="${supplierType!=1}">
					<td width="10%" class="tableleft">级别：</td>
					<td width="20%" class="tableleft"><select name="level"
						placeholder="请选择">
							<c:forEach items="${levelList}" var="level">
								<option value="${level.id }">${level.value }</option>
							</c:forEach>
					</select></td>
				</c:if>
				<c:if test="${supplierType==1}">
					<td width="10%" class="tableleft">类别：</td>
					<td width="20%" class="tableleft"><select name="level"
						placeholder="请选择">
							<c:forEach items="${travelagencylevelList}" var="level">
								<option value="${level.id }">${level.value }</option>
							</c:forEach>
					</select></td>
				</c:if>


				<td width="10%" class="tableleft"><font color="red">*</font>法人：</td>
				<td width="20%" class="tableleft"><input type="text"
					name="lawPerson" placeholder="法人" /></td>
			</tr>
			<tr>
				<td width="10%" class="tableleft">前台电话：</td>
				<td width="20%" class="tableleft"><input type="text"
					name="receptionTel" placeholder="前台电话" /></td>
				<td width="10%" class="tableleft">前台传真：</td>
				<td width="20%" class="tableleft"><input type="text"
					name="receptionFax" placeholder="前台传真" /></td>
				<td width="10%" class="tableleft">开业时间：</td>
				<td width="20%" class="tableleft"><input type="text"
					name="dateOpen" class="Wdate"
					onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" /></td>
			</tr>
			<tr>
				<td width="10%" class="tableleft">网址：</td>
				<td width="20%" class="tableleft">http://<input type="text"
					name="website" placeholder="www.baidu.com" /></td>
				<td width="10%" class="tableleft">邮编：</td>
				<td width="20%" class="tableleft"><input type="text"
					name="zipCode" placeholder="100000" /></td>
				<td width="10%" class="tableleft">最近装修时间：</td>
				<td width="20%" class="tableleft"><input type="text"
					name="dateDecoration" class="Wdate"
					onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" /></td>
			</tr>
			<tr>
				<td width="10%" class="tableleft">区域：</td>
				<td width="20%" class="tableleft"><select name="provinceId"
					id="provinceCode">
						<option value="">请选择省</option>
						<c:forEach items="${allProvince}" var="province">
							<option value="${province.id }">${province.name }</option>
						</c:forEach>
				</select> <select name="cityId" id="cityCode">
						<option value="">请选择市</option>
				</select> <select name="areaId" id="areaCode">
						<option value="">请选择区县</option>
				</select> <select name="townId" id="townCode">
						<option value="">请选择街道</option>
				</select></td>
				</td>
				<td width="10%" class="tableleft">商圈：</td>
				<td width="20%" class="tableleft"><input type="text"
					name="bussinessDistrictName" /></td>
				<td width="10%" class="tableleft">地理坐标：</td>
				<td width="20%" class="tableleft">经度<input name="positionLon"
					readonly="readonly" /> 纬度<input name="positionLat"
					readonly="readonly" />
					<button type="button" onclick="baiduMap();">查找经纬度</button>
				</td>
			</tr>
			<tr>
				<td>地址：</td>
				<td colspan="5"><input type="text" style="width: 800px;"
					name="address" placeholder="红拼108号" /></td>
			</tr>
			<tr>
				<td>简单介绍：</td>
				<td colspan="5"><textarea style="width: 100%" name="introBrief"
						placeholder="七彩云南大酒楼品牌是七彩云南集团将云南民族文化和现代产业发展相融合，建设的面向世界发展的酒楼品牌。"></textarea></td>
			</tr>

			<tr>
				<td>详细介绍：</td>
				<td colspan="5"><script type="text/javascript">
					$(function() {
						window.UEDITOR_HOME_URL = "/assets/ueditor/";
						var ue = UE.getEditor('editor');
					});
				</script> <script id="editor" type="text/plain" name="uContent"
						style="width: 100%; height: 500px;"></script></td>
			</tr>
			<tr>
				<td>小贴士：</td>
				<td colspan="5"><textarea style="width: 100%" name="introTip"
						placeholder="七彩云南大酒楼品牌是七彩云南集团将云南民族文化和现代产业发展相融合，建设的面向世界发展的酒楼品牌。"></textarea></td>
			</tr>

		</table>
		<table class="definewidth m10 menu_table">
			<tr>
				<td style="padding-left: 0px; border: 0; text-align: center;">
					<button type="submit" class="btn btn-info">保存</button>
				</td>
			</tr>
		</table>

	</form>


</body>
</html>