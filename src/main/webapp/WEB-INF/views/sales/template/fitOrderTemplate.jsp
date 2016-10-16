<%@ page pageEncoding="UTF-8"%>

<script type="text/html" id="price_template_numAdult">
					<tr>
						<td><input type="hidden"
							name="groupOrderPriceList[{{index}}].orderId"
							value="${groupOrder.id}" /> <input type="hidden"
							name="groupOrderPriceList[{{index}}].mode" value="0"/>
						<input type="hidden" name="groupOrderPriceList[{{index}}].priceLockState" value="1" />
						</td>
						<td>
						<input type="hidden" name="groupOrderPriceList[{{index}}].itemName"/>
						<select name="groupOrderPriceList[{{index}}].itemId" readonly="readonly">
								<c:forEach items="${dicInfoCRList}" var="lysfxm">
									<option value="${lysfxm.id}">${lysfxm.value }</option>
								</c:forEach>
						</select></td>
						<td><textarea class="l_textarea_mark" style="width:95%;"
								name="groupOrderPriceList[{{index}}].remark" placeholder="备注"></textarea>
						</td>
						<td><input style="width:80%;border-color: red" type="text"
							name="groupOrderPriceList[{{index}}].unitPrice" placeholder="单价" readonly="readonly"/>
						</td>
						<td><input style="width:80%" type="text"
							name="groupOrderPriceList[{{index}}].numPerson" placeholder="人数"  value="1" onblur="countTotalPrice({{index}})"/>
						</td>
						<td><input style="width:80%" type="text"
							name="groupOrderPriceList[{{index}}].numTimes" placeholder="次数"  value="1" onblur="countTotalPrice({{index}})"/>
						</td>
						<td><input style="width:80%" type="text"
							name="groupOrderPriceList[{{index}}].totalPrice" placeholder="金额"
							 readonly="readonly"/></td>
						<td  id="price_numAdult_select">
						</td>
					</tr>
</script>
<script type="text/html" id="price_template_numChild">
					<tr>
						<td><input type="hidden"
							name="groupOrderPriceList[{{index}}].orderId"
							value="${groupOrder.id}" /> <input type="hidden"
							name="groupOrderPriceList[{{index}}].mode" value="0" />
							<input type="hidden" name="groupOrderPriceList[{{index}}].priceLockState" value="1" />
						</td>
						<td>
						<input type="hidden" name="groupOrderPriceList[{{index}}].itemName"/>
						<select name="groupOrderPriceList[{{index}}].itemId" readonly="readonly">
								<c:forEach items="${dicInfoETList}" var="lysfxm">
									<option value="${lysfxm.id}">${lysfxm.value }</option>
								</c:forEach>
						</select></td>
						<td><textarea class="l_textarea_mark" style="width:95%;"
								name="groupOrderPriceList[{{index}}].remark" placeholder="备注"></textarea>
						</td>
						<td><input style="width:80%;border-color: red" type="text"
							name="groupOrderPriceList[{{index}}].unitPrice" placeholder="单价" readonly="readonly"/>
						</td>
						<td><input style="width:80%" type="text"
							name="groupOrderPriceList[{{index}}].numPerson" placeholder="人数" value="1" onblur="countTotalPrice({{index}})"/>
						</td>
						<td><input style="width:80%" type="text"
							name="groupOrderPriceList[{{index}}].numTimes" placeholder="次数" value="1" onblur="countTotalPrice({{index}})"/>
						</td>
						
						<td><input style="width:80%" type="text"
							name="groupOrderPriceList[{{index}}].totalPrice" placeholder="金额"
							 readonly="readonly"/></td>
						<td  id="price_numChild_select">
						</td>
					</tr>
</script>

<script type="text/html" id="cost_template_numAdult">
					<tr>
						<td><input type="hidden"
							name="groupOrderCostList[{{index}}].orderId"
							value="${groupOrder.id}" /> <input type="hidden"
							name="groupOrderCostList[{{index}}].mode" value="1"/>
					<input type="hidden" name="groupOrderCostList[{{index}}].priceLockState" value="1" />
						</td>
						<td>
						<input type="hidden" name="groupOrderCostList[{{index}}].itemName"/>
						<select name="groupOrderCostList[{{index}}].itemId" readonly="readonly">
								<c:forEach items="${dicInfoCRList}" var="lysfxm">
									<option value="${lysfxm.id}">${lysfxm.value }</option>
								</c:forEach>
						</select></td>
						<td><textarea class="l_textarea_mark"  style="width:95%;"
								name="groupOrderCostList[{{index}}].remark" placeholder="备注"></textarea>
						</td>
						<td><input style="width:80%;border-color: red" type="text"
							name="groupOrderCostList[{{index}}].unitPrice" placeholder="单价" readonly="readonly"/>
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
						<td  id="cost_numAdult_select">
						</td>
					</tr>
</script>
<script type="text/html" id="cost_template_numChild">
					<tr>
						<td><input type="hidden"
							name="groupOrderCostList[{{index}}].orderId"
							value="${groupOrder.id}" /> <input type="hidden"
							name="groupOrderCostList[{{index}}].mode" value="1"/>
							<input type="hidden" name="groupOrderCostList[{{index}}].priceLockState" value="1" />
						</td>
						<td>
						<input type="hidden" name="groupOrderCostList[{{index}}].itemName"/>
						<select name="groupOrderCostList[{{index}}].itemId" readonly="readonly">
								<c:forEach items="${dicInfoETList}" var="lysfxm">
									<option value="${lysfxm.id}">${lysfxm.value }</option>
								</c:forEach>
						</select></td>
						<td><textarea class="l_textarea_mark"  style="width:95%;"
								name="groupOrderCostList[{{index}}].remark" placeholder="备注"></textarea>
						</td>
						<td><input style="width:80%;border-color: red" type="text"
							name="groupOrderCostList[{{index}}].unitPrice" placeholder="单价" readonly="readonly"/>
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
						<td  id="cost_numChild_select">
						</td>
					</tr>
</script>