<%@ page pageEncoding="UTF-8"%>

<script type="text/html" id="hotel_template">
				<tr>
					<td>
						<input type="hidden" name="hotelGroupRequirementList[{{index}}].id"/>
						<input type="hidden" name="hotelGroupRequirementList[{{index}}].supplierType" value="3"/>
					</td>
					<td>
						<input type="text" name="hotelGroupRequirementList[{{index}}].requireDate" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
					</td>
					<td>
						<input type="text" name="hotelGroupRequirementList[{{index}}].area" />
					</td>
					<td>
						<select name="hotelGroupRequirementList[{{index}}].hotelLevel">
							<c:forEach items="${jdxjList}" var="jdxj">
								<option value="${jdxj.id }">${jdxj.value }</option>
							</c:forEach>
						</select>
					</td>
					<td>
						<input name="hotelGroupRequirementList[{{index}}].countSingleRoom" type="text" style="width: 100px;" value="0" />
					</td>
					<td>
						<input name="hotelGroupRequirementList[{{index}}].countDoubleRoom" type="text" style="width: 100px;" value="0"/>
					</td>
					<td>
						<input name="hotelGroupRequirementList[{{index}}].countTripleRoom" type="text" style="width: 100px;" value="0"/>
					</td>
					<td>
						<input name="hotelGroupRequirementList[{{index}}].peiFang" type="text" style="width: 100px;" value="0"/>
					</td>
					<td>
						<input name="hotelGroupRequirementList[{{index}}].extraBed" type="text" style="width: 100px;" value="0" />
					</td>
					<td>
						<input name="hotelGroupRequirementList[{{index}}].remark"  type="text"  style="width: 80%" />
					</td>
					<td>
						<a href="javascript:void(0);" onclick="delHotelTable(this)" class="def">删除</a>
					</td>
</script>
<script type="text/html" id="fleet_template">
				<tr>
					<td>
				 		<input type="hidden" name="fleetGroupRequirementList[{{index}}].id" />
						<input type="hidden" name="fleetGroupRequirementList[{{index}}].supplierType" value="4"/>
					</td>
					<td>
						<input type="text" name="fleetGroupRequirementList[{{index}}].requireDate" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
					   ~<input type="text" name="fleetGroupRequirementList[{{index}}].requireDateTo" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
					</td>
					<td>
						<select name="fleetGroupRequirementList[{{index}}].modelNum">
							<c:forEach items="${ftcList}" var="ftc">
								<option value="${ftc.id }" >${ftc.value }</option>
							</c:forEach>
						</select>
					</td>
					<td>
						<input type="text" name="fleetGroupRequirementList[{{index}}].countSeat"/>
					</td>
					<td>
						<input type="text" name="fleetGroupRequirementList[{{index}}].ageLimit" />
					</td>
					<td>
						<input type="text"  name="fleetGroupRequirementList[{{index}}].remark" style="width: 80%"/>
					</td>
					<td>
						<a href="javascript:void(0);" onclick="delFleetTable(this)" class="def">删除</a>
					</td>
			</tr>

</script>
<script type="text/html" id="guide_template">
				<tr>
					<td>
				 		<input type="hidden" name="guideGroupRequirementList[{{index}}].id" />
						<input type="hidden" name="guideGroupRequirementList[{{index}}].supplierType" value="8"/>
					</td>
					<td>
						<input type="text" name="guideGroupRequirementList[{{index}}].language" />
					</td>
					<td>
						<select name="guideGroupRequirementList[{{index}}].gende">
							<option value="2">不限</option>
							<option value="0">男</option>
							<option value="1">女</option>
						</select>
					</td>
					<td>
						<input type="text" name="guideGroupRequirementList[{{index}}].ageLimit" />
					</td>
					<td>
						<input type="text"  name="guideGroupRequirementList[{{index}}].remark" style="width: 80%"/>
					</td>
					<td>
						<a href="javascript:void(0);" onclick="delGuideTable(this)" class="def">删除</a>
					</td>
			</tr>

</script>
<script type="text/html" id="restaurant_template">
				<tr>
					<td>
				 		<input type="hidden" name="restaurantGroupRequirementList[{{index}}].id" />
						<input type="hidden" name="restaurantGroupRequirementList[{{index}}].supplierType" value="2"/>
					</td>
					<td>
						<input type="text" name="restaurantGroupRequirementList[{{index}}].requireDate" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
					</td>
					<td>
						<input type="text" name="restaurantGroupRequirementList[{{index}}].area" />
					</td>
					<td>
						<input type="text" name="restaurantGroupRequirementList[{{index}}].countRequire" />
					</td>
					<td>
						<input type="text"  name="restaurantGroupRequirementList[{{index}}].remark" style="width: 80%"/>
					</td>
					<td>
						<a href="javascript:void(0);" onclick="delRestaurantTable(this)" class="def">删除</a>
					</td>
			</tr>
</script>


