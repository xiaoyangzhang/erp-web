<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!-- 车队 -->
<div id="addOrEditMotorcade" style="display: none;">
	<form id="addOrEditMotorcadeForm" method="post" action="">
		<div class="p_container">

			<input type="hidden" id="orderId" name="groupId"
				value="${tourGroup.id}" /> <input type="hidden" name="id"
				id="motorcadeId" /> <input type="hidden" name="supplierType"
				value="4" />

			<dl class="p_aragraph_content" style="margin-top: 10px">
				<dd>
					<div class="dd_left">
						<i class="red">*</i>日期:
					</div>
					<input type="text" id="motorcadeRequireDate" name="requireDate"
						class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />-<input
						type="text" id="motorcadeRequireDateTo" name="requireDateTo"
						class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
				</dd>
			</dl>
			<dl class="p_aragraph_content" style="margin-top: 10px">
				<dd>
					<div class="dd_left">型号:</div>
					<select name="modelNum" id="modelNum">
						<c:forEach items="${cdcxList }" var="cdcx">
							<option value="${cdcx.id }">${cdcx.value}</option>
						</c:forEach>
					</select>
				</dd>
			</dl>
			<dl class="p_aragraph_content" style="margin-top: 10px">
				<dd>
					<div class="dd_left">
						<i class="red">*</i>座位数:
					</div>
					<input type="text" name="countSeat" id="countSeat" value=""
						class="IptText301" />
				</dd>
			</dl>
			<dl class="p_aragraph_content" style="margin-top: 10px">
				<dd>
					<div class="dd_left">
						<i class="red">*</i>车辆年限:
					</div>
					<input type="text" name="ageLimit" id="ageLimit" value=""
						class="IptText301" />
				</dd>
			</dl>
			<dl class="p_aragraph_content" style="margin-top: 10px">
				<dd>
					<div class="dd_left">备注:</div>
					<textarea id="motorcadeRemark" class="l_textarea"
						style="width: 150px" name="remark"></textarea>
				</dd>
			</dl>
			<dl class="p_aragraph_content" style="margin-top: 10px">
				<dd>
					<div class="dd_left"></div>
					<div class="dd_right">
						<button type="submit" class="button button-primary button-small">保存</button>
						<button type="reset" class="button button-primary button-small">重置</button>
					</div>
				</dd>
			</dl>

		</div>
		<div class="modal-footer" style="text-align: center;"></div>
	</form>
</div>

<!-- 导游 -->
<div id="addOrEditGuide" style="display: none;">
	<form id="addOrEditGuideForm" method="post" action="">
		<div class="p_container">

			<input type="hidden" id="orderId" name="groupId"
				value="${tourGroup.id}" /> <input type="hidden" name="id"
				id="guideId" /> <input type="hidden" name="supplierType" value="8" />
			<dl class="p_aragraph_content" style="margin-top: 10px">
				<dd>
					<div class="dd_left">语种:</div>
					<input type="text" name="language" id="language" value=""
						class="IptText301" />
				</dd>
			</dl>
			<dl class="p_aragraph_content" style="margin-top: 10px">
				<dd>
					<div class="dd_left">性别:</div>
					
						<input type="radio" id="guestGender" name="gender" value="1"/>男 <input type="radio" id="guestGender"
							name="gender" value="0" />女<input type="radio" id="guestGender" name="gender" value="2"
							checked="checked" />不限 
					
				</dd>
			</dl>
			<dl class="p_aragraph_content" style="margin-top: 10px">
				<dd>
					<div class="dd_left">年限:</div>
					<input type="text" name="ageLimit" id="guideAgeLimit" value=""
						class="IptText301" />
				</dd>
			</dl>
			<dl class="p_aragraph_content" style="margin-top: 10px">
				<dd>
					<div class="dd_left">备注:</div>
					<textarea id="guideRemark" class="l_textarea" style="width: 150px"
						name="remark"></textarea>
				</dd>
			</dl>
			<dl class="p_aragraph_content" style="margin-top: 10px">
				<dd>
					<div class="dd_left"></div>
					<div class="dd_right">
						<button type="submit" class="button button-primary button-small">保存</button>
						<button type="reset" class="button button-primary button-small">重置</button>
					</div>
				</dd>
			</dl>
		</div>
	</form>
</div>

<!-- 餐厅 -->
<div id="addOrEditRestaurant" style="display: none;">
	<form id="addOrEditRestaurantForm" method="post" action="">
		<div class="p_container">
			<input type="hidden" name="id" id="restaurantId" /> <input
				type="hidden" id="orderId" name="groupId" value="${tourGroup.id}" />
			<input type="hidden" name="supplierType" value="2" />
			<dl class="p_aragraph_content" style="margin-top: 10px">
				<dd>
					<div class="dd_left">日期:</div>
					<input type="text" id="restaurantRequireDate" name="requireDate"
						class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm'})" />
				</dd>
			</dl>
			<dl class="p_aragraph_content" style="margin-top: 10px">
				<dd>
					<div class="dd_left">区域:</div>
					<input type="text" name="area" id="restaurantArea" value=""
						class="IptText301" />
				</dd>
			</dl>
			<dl class="p_aragraph_content" style="margin-top: 10px">
				<dd>
					<div class="dd_left">人数:</div>
					<input type="text" name="countRequire" id="restaurantCountRequire"
						value="" class="IptText301" />
				</dd>
			</dl>
			<dl class="p_aragraph_content" style="margin-top: 10px">
				<dd>
					<div class="dd_left">备注:</div>
					<textarea id="restaurantRemark" class="l_textarea"
						style="width: 150px" name="remark"></textarea>
				</dd>
			</dl>
			<dl class="p_aragraph_content" style="margin-top: 10px">
				<dd>
					<div class="dd_left"></div>
					<div class="dd_right">
						<button type="submit" class="button button-primary button-small">保存</button>
						<button type="reset" class="button button-primary button-small">重置</button>
					</div>
				</dd>
			</dl>
		</div>
	</form>
</div>