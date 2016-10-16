<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="../../../include/top.jsp"%>
<style type="text/css">
.Wdate {
	width: 95px;
}
</style>
<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/supplierCar.js"></script>
</head>
<body>
	<div class="p_container">
		<form class="form-horizontal" id="editSupplierCarForm">
			<input type="hidden" name="supplierType" value="${supplierType}" />
			<input type="hidden" name="state" value="2" />
			<p class="p_paragraph_title">
				<b>修改车辆基本信息:</b>
			</p>
			<dl class="p_paragraph_content">
				<dd>
					<div class="dd_left">
						<i class="red">* </i>车型：
					</div>
					<div class="dd_right">
					<input name="supplierCar.id" type="hidden" value="${supplierCarVO.supplierCar.id}" />
						<select name="supplierCar.typeId">
							<c:forEach items="${carType }" var="car">
								<option value="${car.id}"  <c:if test="${supplierCarVO.supplierCar.typeId==car.id }"> selected="selected" </c:if>  >${car.value}</option>
							</c:forEach>
						</select>
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left">
						<i class="red">* </i>车牌号：
					</div>
					<div class="dd_right">
						<input name="supplierCar.carLisenseNo" type="text" value="${supplierCarVO.supplierCar.carLisenseNo }"
							class="IptText300" placeholder="车牌号" />
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left">
						<i class="red">* </i>座位数：
					</div>
					<div class="dd_right">
						<input name="supplierCar.seatNum" type="text" class="IptText300" value="${supplierCarVO.supplierCar.seatNum }"
							placeholder="座位数" />座
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left">品牌：</div>
					<div class="dd_right">
						<input name="supplierCar.brand" type="text" class="IptText300" value="${supplierCarVO.supplierCar.brand }"
							placeholder="品牌" />
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left">型号：</div>
					<div class="dd_right">
						<input name="supplierCar.mode" type="text" class="IptText300" value="${supplierCarVO.supplierCar.mode }"
							placeholder="型号" />
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left">保险：</div>
					<div class="dd_right">
						<input name="supplierCar.insurance" type="text" class="IptText300" value="${supplierCarVO.supplierCar.insurance }"
							placeholder="保险" />
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left">
						<i class="red">* </i>购车日期：
					</div>
					<div class="dd_right">
						<input name="supplierCar.buyDate" type="text" class="Wdate"
							onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="<fmt:formatDate pattern='yyyy-MM-dd' value='${supplierCarVO.supplierCar.buyDate }'/>" 
							placeholder="购车日期" />
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left">
						<i class="red">* </i>年审日期：
					</div>
					<div class="dd_right">
						<input name="supplierCar.examDate" type="text" class="Wdate"  value="<fmt:formatDate pattern='yyyy-MM-dd' value='${supplierCarVO.supplierCar.examDate }'/>" 
							onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})"
							placeholder="年审日期" />
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left">
						<i class="red">* </i>照片：
					</div>
					<div class="dd_right addImg">
						
						<c:forEach items="${supplierCarVO.imgList }" var="img" varStatus="v">
							<span class="ulImg">
							<img src="${config.imgServerUrl}${img.imgPath}" /><i class="icon_del delImg" style="display: none;" ></i>
							<input type="hidden" name="imgList[${v.index }].bussniessType" value="5" />
							<input type="hidden" name="imgList[${v.index }].imgName" value="${img.imgName }" />
							<input type="hidden" name="imgList[${v.index }].imgPath" value="${img.imgPath }" />
							</span>
						</c:forEach>
						</span>
					</div>
					<label onclick="selectImg(this, '#imgTemp')" class="ulImgBtn"></label>
					<div class="clear"></div>
				</dd>
				<dd class="Footer">
					<div class="dd_left"></div>
					<div class="dd_right">
						<button type="submit" class="button button-primary button-small">保存</button>
						<button type="button" onclick="closeWindow()"
							class="button button-primary button-small">关闭</button>
					</div>
				</dd>

			</dl>
		</form>
	</div>

</body>
<script type="text/html" id="imgTemp">
<span class="ulImg">
<img src="$src" alt="$name"><i class="icon_del delImg" style="display: none;" ></i>
<input type="hidden" name="imgList[$index].bussniessType" value="5" />
<input type="hidden" name="imgList[$index].imgName" value="$name" />
<input type="hidden" name="imgList[$index].imgPath" value="$path" />
</span>
</script>
</html>