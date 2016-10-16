<%@ page pageEncoding="UTF-8"%>
										
<script type="text/html" id="price_template">
					<tr>
						<td> 
								<input type="hidden" name="groupOrderPriceList[{{index}}].orderId" value="${groupOrder.id}" /> 
								<input type="hidden" name="groupOrderPriceList[{{index}}].mode" value="0"/>
								<input type="hidden" name="groupOrderPriceList[{{index}}].priceLockState" value="0"/>
								<input type="hidden" name="groupOrderPriceList[{{index}}].stateFinance"	value="0" />
						</td>
						<td>
						<input type="hidden" name="groupOrderPriceList[{{index}}].itemName"/>
						<select name="groupOrderPriceList[{{index}}].itemId">
								<c:forEach items="${lysfxmList}" var="lysfxm">
									<option value="${lysfxm.id}" text="${lysfxm.value }">${lysfxm.value }</option>
								</c:forEach>
						</select></td>
						<td><textarea class="l_textarea_mark" style="width:95%;" name="groupOrderPriceList[{{index}}].remark" placeholder="备注"></textarea>
						</td>
						<td><input style="width:80%" type="text" name="groupOrderPriceList[{{index}}].unitPrice" placeholder="单价" onblur="countTotalPrice({{index}})"/>
						</td>
						<td><input style="width:80%" type="text" name="groupOrderPriceList[{{index}}].numPerson" placeholder="人数"  value="1" onblur="countTotalPrice({{index}})"/>
						</td>
						<td><input style="width:80%" type="text" name="groupOrderPriceList[{{index}}].numTimes" placeholder="次数" value="1" onblur="countTotalPrice({{index}})"/>
						</td>
						<td><input style="width:80%" type="text" name="groupOrderPriceList[{{index}}].totalPrice" placeholder="金额" readonly="readonly"/></td>
						<td>
								<a href="javascript:void(0);" lang="aDeletePriceRow" onclick="delPriceTable(this,'{{delType}}')">删除</a>
						</td>
					</tr>
</script>

<script type="text/html" id="cost_template">
					<tr>
						<td>
							<input type="hidden" name="groupOrderCostList[{{index}}].orderId" value="${groupOrder.id}" /> 
							<input type="hidden" name="groupOrderCostList[{{index}}].mode" value="1" />
							<input type="hidden" name="groupOrderCostList[{{index}}].priceLockState" value="0"/>
							<input type="hidden" name="groupOrderCostList[{{index}}].stateFinance"	value="0" />
						</td>
						<td>
						<input type="hidden" name="groupOrderCostList[{{index}}].itemName"/>
						<select name="groupOrderCostList[{{index}}].itemId">
								<c:forEach items="${lysfxmList}" var="lysfxm">
									<option value="${lysfxm.id}">${lysfxm.value }</option>
								</c:forEach>
						</select></td>
						<td><textarea class="l_textarea_mark"  style="width:95%;"
								name="groupOrderCostList[{{index}}].remark" placeholder="备注"></textarea>
						</td>
						<td><input style="width:80%" type="text"
							name="groupOrderCostList[{{index}}].unitPrice" placeholder="单价" onblur="countTotalCost({{index}})"/>
						</td>
						<td><input style="width:80%" type="text"
							name="groupOrderCostList[{{index}}].numPerson" placeholder="人数" value="1" onblur="countTotalCost({{index}})"/>
						</td>
						<td><input style="width:80%" type="text"
							name="groupOrderCostList[{{index}}].numTimes" placeholder="次数" value="1" onblur="countTotalCost({{index}})"/>
						</td>
						<td><input style="width:80%" type="text"
							name="groupOrderCostList[{{index}}].totalPrice" placeholder="金额"
							 readonly="readonly"/></td>
						<td><a href="javascript:void(0);" onclick="delCostTable(this,'{{delType}}')">删除</a>
						</td>
					</tr>
</script>


<script type="text/html" id="trans_template">
					<tr>
						<td><input type="hidden"
							name="groupOrderTransportList[{{index}}].orderId"
							value="${groupOrder.id}" />
						</td>
						<td>
							<select name="groupOrderTransportList[{{index}}].sourceType" style="width: 100px">
								<option value="1">省外交通</option>
								<option value="0">省内交通</option>
							</select>
						</td>
						<td>
							<input type="radio" name="groupOrderTransportList[{{index}}].type" value="0" checked="checked">接</input>
							<input type="radio" name="groupOrderTransportList[{{index}}].type" value="1">送</input>
			
						</td>
						<td>
							<select name="groupOrderTransportList[{{index}}].method" id="transportMethod" style="width: 100px;">
								<c:forEach items="${jtfsList}" var="jtfs">
									<option value="${jtfs.id}">${jtfs.value }</option>
								</c:forEach>
							</select>
						</td>
						<td>
							<input  style="width:80px" type="text" name="groupOrderTransportList[{{index}}].departureCity" placeholder="出发城市" />
						</td>
						<td>
							<input style="width:80px" type="text" name="groupOrderTransportList[{{index}}].arrivalCity" placeholder="到达城市" />
						</td>
						<td>
							<input style="width:80px" type="text" name="groupOrderTransportList[{{index}}].classNo" placeholder="班次/车次" />
						</td>
						<td>
							<input type="text" name="groupOrderTransportList[{{index}}].departureDate" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" style="width: 100px;"/>
						</td>
						<td>
							<input type="text" name="groupOrderTransportList[{{index}}].departureTime" class="Wdate" onClick="WdatePicker({dateFmt:'HH:mm'})"  style="width: 100px;"/>
						</td>
						<td>
							<input style="width:100px" type="text" name="groupOrderTransportList[{{index}}].destination" placeholder="备注" />
						</td>
						<td><a href="javascript:void(0);" onclick="delTranTable(this,'newTransport')">删除</a>
						</td>
					</tr>
</script>

<script type="text/html" id="guest_template">
					<tr>
						<td><input type="hidden"
							name="groupOrderGuestList[{{index}}].orderId"
							value="${orderId}" />
						</td>
						<td>
							<input type="text" name="groupOrderGuestList[{{index}}].name" style="width:50px"/>
						</td>
						<td>
							<input type="radio" name="groupOrderGuestList[{{index}}].gender" value="1" checked="checked" />男
							<input type="radio" name="groupOrderGuestList[{{index}}].gender" value="0" />女
			
						</td>
						<td>
							<input type="text" name="groupOrderGuestList[{{index}}].age"  style="width:50px"/>
						</td>
						<td>
							<input type="text" name="groupOrderGuestList[{{index}}].nativePlace" style="width:120px"/>
						</td>
						<td>
							<input type="text" name="groupOrderGuestList[{{index}}].career" style="width:50px" />
						</td>
						<td>
							<select name="groupOrderGuestList[{{index}}].type" style="width:80px">
									<option value="1">成人</option>
									<option value="2">儿童</option>
									<option value="3">全陪</option>
							</select>
						</td>
						<td>
							<select id="certificateTypeId"  name="groupOrderGuestList[{{index}}].certificateTypeId" style="width:80px" onchange="recCertifNum({{index}})">
									<c:forEach items="${zjlxList}" var="v"
										varStatus="vs">
										<option id="it" value="${v.id}">${v.value}</option>
									</c:forEach>
							</select>
						</td>
						<td>
							<input type="text" name="groupOrderGuestList[{{index}}].certificateNum" class="certificateNum" style="width:130px" onblur="recCertifNum({{index}})" />
						</td>
						<td>
							<input type="text" name="groupOrderGuestList[{{index}}].mobile" style="width:100px"/>
						</td>

						<td>
							<input type="radio"  name="groupOrderGuestList[{{index}}].isSingleRoom" value="1">是</input>
							<input type="radio"  name="groupOrderGuestList[{{index}}].isSingleRoom" value="0" checked="checked">否</input>
						</td>
						<td>
							<input type="radio" name="groupOrderGuestList[{{index}}].isLeader" value="1">是</input>
							<input type="radio" name="groupOrderGuestList[{{index}}].isLeader" value="0" checked="checked">否</input>
						</td>
						<td>
							<input  type="text" style="width:100px" name="groupOrderGuestList[{{index}}].remark" />
						</td>
						<td><a href="javascript:void(0);" onclick="delGuestTable(this,'newGuest')">删除</a>
						</td>
					</tr>
</script>
