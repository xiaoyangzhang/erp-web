<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<script type="text/javascript">
	$(function() {
		$('#departureCity').autocomplete(cities, {
			max : 12, // 列表里的条目数
			minChars : 0, // 自动完成激活之前填入的最小字符
			width : 385, // 提示的宽度，溢出隐藏
			scrollHeight : 300, // 提示的高度，溢出显示滚动条
			matchContains : true, // 包含匹配，就是data参数里的数据，是否只要包含文本框里的数据就显示
			autoFill : false, // 自动填充
			minChars : 1,
			formatItem : function(row, i, max) {
				return row.name + '（' + row.pinyin + '）';
			},
			formatMatch : function(row, i, max) {
				return row.match;
			},
			formatResult : function(row) {
				return row.name;
			},
			resultsClass : 'search-text'
		}).result(function(event, row, formatted) {
		});
		$('#arrivalCity').autocomplete(cities, {
			max : 12, // 列表里的条目数
			minChars : 0, // 自动完成激活之前填入的最小字符
			width : 385, // 提示的宽度，溢出隐藏
			scrollHeight : 300, // 提示的高度，溢出显示滚动条
			matchContains : true, // 包含匹配，就是data参数里的数据，是否只要包含文本框里的数据就显示
			autoFill : false, // 自动填充
			minChars : 1,
			formatItem : function(row, i, max) {
				return row.name + '（' + row.pinyin + '）';
			},
			formatMatch : function(row, i, max) {
				return row.match;
			},
			formatResult : function(row) {
				return row.name;
			},
			resultsClass : 'search-text'
		}).result(function(event, row, formatted) {
		});
	
	$('#airticketCityDeparture').autocomplete(cities, {
		max: 12, // 列表里的条目数
		minChars: 0, // 自动完成激活之前填入的最小字符
		width: 385, // 提示的宽度，溢出隐藏
		scrollHeight: 300, // 提示的高度，溢出显示滚动条
		matchContains: true, // 包含匹配，就是data参数里的数据，是否只要包含文本框里的数据就显示
		autoFill: false, // 自动填充
		minChars:1,
		formatItem: function(row, i, max) {
		return row.name + '（'+row.pinyin+'）';
		},
		formatMatch: function(row, i, max) {
		return row.match;
		},
		formatResult: function(row) {
		return row.name;
		},resultsClass:'search-text'
		}).result(function(event, row, formatted) {
	});
	$('#airticketCityArrival').autocomplete(cities, {
		max: 12, // 列表里的条目数
		minChars: 0, // 自动完成激活之前填入的最小字符
		width: 385, // 提示的宽度，溢出隐藏
		scrollHeight: 300, // 提示的高度，溢出显示滚动条
		matchContains: true, // 包含匹配，就是data参数里的数据，是否只要包含文本框里的数据就显示
		autoFill: false, // 自动填充
		minChars:1,
		formatItem: function(row, i, max) {
		return row.name + '（'+row.pinyin+'）';
		},
		formatMatch: function(row, i, max) {
		return row.match;
		},
		formatResult: function(row) {
		return row.name;
		},resultsClass:'search-text'
		}).result(function(event, row, formatted) {
	});
	
	$('#trainticketCityDeparture').autocomplete(cities, {
		max: 12, // 列表里的条目数
		minChars: 0, // 自动完成激活之前填入的最小字符
		width: 385, // 提示的宽度，溢出隐藏
		scrollHeight: 300, // 提示的高度，溢出显示滚动条
		matchContains: true, // 包含匹配，就是data参数里的数据，是否只要包含文本框里的数据就显示
		autoFill: false, // 自动填充
		minChars:1,
		formatItem: function(row, i, max) {
		return row.name + '（'+row.pinyin+'）';
		},
		formatMatch: function(row, i, max) {
		return row.match;
		},
		formatResult: function(row) {
		return row.name;
		},resultsClass:'search-text'
		}).result(function(event, row, formatted) {
	});
	$('#trainticketCityArrival').autocomplete(cities, {
		max: 12, // 列表里的条目数
		minChars: 0, // 自动完成激活之前填入的最小字符
		width: 385, // 提示的宽度，溢出隐藏
		scrollHeight: 300, // 提示的高度，溢出显示滚动条
		matchContains: true, // 包含匹配，就是data参数里的数据，是否只要包含文本框里的数据就显示
		autoFill: false, // 自动填充
		minChars:1,
		formatItem: function(row, i, max) {
		return row.name + '（'+row.pinyin+'）';
		},
		formatMatch: function(row, i, max) {
		return row.match;
		},
		formatResult: function(row) {
		return row.name;
		},resultsClass:'search-text'
		}).result(function(event, row, formatted) {
	});
	
	var reg = /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/;
	$("input[name='certificateNum']").on('input',
			function(e) {
				var guestCertificateNum = $("input[name='certificateNum']").val();
				if (reg.test(guestCertificateNum) === true) {
					var card = new Card(guestCertificateNum);
					card.init(function(data){
						$("#guestAge").val(data.age);
						$("#guestNativePlace").val(data.addr);
						if(data.sex=='男'){
							//$("input[name='gender'][value=1]").attr("checked", "checked");
							$("#guestGender").val("1");
						}else{
							//$("input[name='gender'][value=0]").attr("checked", "checked");
							$("#guestGender").val("0");
						}
					});
					
				}
			});
	})
</script>
<!-- 客人信息弹出层        开始-->
<div id="guestModal" style="display: none">
	<form class="definewidth m20" id="guestInfoForm">
		<input type="hidden" name="orderId" value="${groupOrder.id}" /> <input
			type="hidden" name="id" id="modalGuestId" />
		<dl class="p_paragraph_content">
			<div class="searchRow">
				<dd>
					<div class="dd_left"><i class="red">* </i>姓名:</div>
					<div class="dd_right">
						<input type="text" name="name" id="guestName" class="IptText200" />
					</div>
					<div class="dd_left">证件类型:</div>
					<div class="dd_right">
						<select name="certificateTypeId" id="guestCertificateTypeId">
							<c:forEach items="${zjlxList}" var="zjlx">
								<option value="${zjlx.id}">${zjlx.value}</option>
							</c:forEach>
						</select>
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left"><i class="red">* </i>证件号码:</div>
					<div class="dd_right">
						<input name="certificateNum" id="guestCertificateNum" type="text"
							class="IptText200" placeholder="证件号码" />
					</div>
					<div class="dd_left">性别:</div>
					<div class="dd_right">
						<select name="gender" id="guestGender">
							<option value="1">男</option>
							<option value="0">女</option>
						</select>
					</div>

					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left">年龄:</div>
					<div class="dd_right">
						<input class="IptText200" type="text" name="age" id="guestAge" />
					</div>
					<div class="dd_left">类别:</div>
					<div class="dd_right">
						<select name="type" id="guestType">
							<option value="1">成人</option>
							<option value="2">儿童</option>
						</select>
					</div>
					
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left">籍贯:</div>
					<div class="dd_right">
						<input name="nativePlace" id="guestNativePlace" type="text"
							class="IptText200" />
					</div>
					<div class="dd_left">是否单房:</div>
					<div class="dd_right">
						<select name="isSingleRoom" id="guestIsSingleRoom">
							<option value="0">否</option>
							<option value="1">是</option>
						</select>
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left">职业:</div>
					<div class="dd_right">
						<input name="career" id="guestCareer" type="text"
							class="IptText200" placeholder="职业" />
					</div>
					<div class="dd_left">是否领队:</div>
					<div class="dd_right">
						<select name="isLeader" id="guestIsLeader">
							<option value="0">否</option>
							<option value="1">是</option>
						</select>
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left">手机号码:</div>
					<div class="dd_right">
						<input type="text" class="IptText200" name="mobile"
							id="guestMobile" />
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
				<div class="dd_left">备注:</div>
					<div class="dd_right">
						<textarea id="guestRemark" class="l_textarea" name="remark"></textarea>
					</div>
					<div class="clear"></div>
				</dd>
			</div>
		</dl>
		<div class="w_btnSaveBox" style="text-align: center;">
			<button type="submit"
				class="button button-primary button-small">提交</button>
		</div>
	</form>
</div>
<!-- 客人信息弹出层       结束 -->


<!-- 价格信息弹出层        开始[成本、预算公用一个] -->
<div id="costModal" style="display: none">
	<form class="definewidth m20" id="costInfoForm">
		<input type="hidden" name="orderId" value="${groupOrder.id}" /> <input
			type="hidden" name="mode" /> <input type="hidden" name="rowState"
			value="0" /> <input type="hidden" name="id" id="modalPriceId" />
		<dl class="p_paragraph_content">
			<dd>
				<div class="dd_left">项目:</div>
				<div class="dd_right">
					<select name="itemId" id="costItemName">
						<c:forEach items="${lysfxmList}" var="lysfxm">
							<option value="${lysfxm.id}">${lysfxm.value }</option>
						</c:forEach>
					</select>
				</div>
				<div class="clear"></div>
			</dd>
			
			<dd>
				<div class="dd_left">单价:</div>
				<div class="dd_right">
					<input class="IptText301" type="text" name="unitPrice"
						placeholder="单价" />
				</div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">次数:</div>
				<div class="dd_right">
					<input class="IptText301" type="text" name="numTimes"
						placeholder="次数"  />
				</div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">人数:</div>
				<div class="dd_right">
					<input class="IptText301" type="text" name="numPerson"
						placeholder="人数"  />
				</div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">金额:</div>
				<div class="dd_right">
					<input class="IptText301" type="text" name="totalPrice"
						placeholder="金额"  readonly="readonly" />
				</div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">备注:</div>
				<div class="dd_right">
					<textarea class="l_textarea" style="width: 200px;" name="remark" id="priceRemark"
						placeholder="备注"></textarea>
				</div>
				<div class="clear"></div>
			</dd>
		</dl>
		<div class="w_btnSaveBox" style="text-align: center;">
			<button type="submit"
				class="button button-primary button-small">提交</button>
		</div>
	</form>
</div>
<!-- 价格信息弹出层       结束[成本、预算公用一个] -->


<!-- 接送信息弹出层        开始 -->
<div id="transportModal" style="display: none">
	<form class="definewidth m20" id="transportInfoForm">
		<input type="hidden" name="orderId" value="${groupOrder.id}" /> <input
			type="hidden" name="id" id="modalTransportId" />
		<dl class="p_paragraph_content">
			<dd>
				<div class="dd_left">交通方式:</div>
				<div class="dd_right">
				<select name="sourceType" id="sourceType" style="width: 160px">
					<option value="1">省外交通</option>
					<option value="0">省内交通</option>
				</select>
				</div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">接送方式:</div>
				<div class="dd_right">
					<input type="radio" name="type" value="0" checked="checked">接</input>
					<input type="radio" name="type" value="1">送</input>
				</div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">交通方式:</div>
				<div class="dd_right">
					<select name="method" id="transportMethod" style="width: 160px;">
						<c:forEach items="${jtfsList}" var="jtfs">
							<option value="${jtfs.id}">${jtfs.value }</option>
						</c:forEach>
					</select>
				</div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">出发城市:</div>
				<div class="dd_right">
					<input id="departureCity" class="IptText301" type="text"
						name="departureCity" placeholder="出发城市" />
				</div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">到达城市:</div>
				<div class="dd_right">
					<input id="arrivalCity" class="IptText301" type="text"
						name="arrivalCity" placeholder="到达城市" />
				</div>
				<div class="clear"></div>
			</dd>

			<dd>
				<div class="dd_left">班次/车次:</div>
				<div class="dd_right">
					<input class="IptText301" type="text" name="classNo"
						placeholder="班次/车次" />
				</div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">出发日期:</div>
				<div class="dd_right">
					<input type="text" name="departureDate" class="Wdate"
						onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" style="width: 150px;"/>
				</div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">出发时间:</div>
				<div class="dd_right">
					<input type="text" name="departureTime" class="Wdate"
						onClick="WdatePicker({dateFmt:'HH:mm'})"  style="width: 150px;"/>
				</div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">备注:</div>
				<div class="dd_right">
					<input class="IptText301" type="text" name="destination"
						placeholder="备注" />
				</div>
				<div class="clear"></div>
			</dd>
		</dl>
		<div style="text-align: center;">
			<button type="submit"
				class="button button-primary button-small">提交</button>
		</div>
	</form>
</div>
<!-- 接送信息弹出层        结束-->


<!-- 酒店弹出层        开始 -->
<div id="restaurantModal" style="display: none">
	<form class="definewidth m20" id="restaurantInfoForm">
		<input type="hidden" name="orderId" value="${groupOrder.id}" />
		<input type="hidden" name="groupId" value="${groupOrder.groupId}" />
		<input
			type="hidden" name="id" id="modalRestaurantId" /> <input
			type="hidden" name="supplierType" value="3" />
		<dl class="p_paragraph_content">
<!-- 			<dd> -->
<!-- 				<div class="dd_left">日期:</div> -->
<!-- 				<div class="dd_right"> -->
<!-- 					<input type="text" name="requireDate" id="restRequireDate" -->
<!-- 						class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" /> -->
<!-- 				</div> -->
<!-- 				<div class="clear"></div> -->
<!-- 			</dd> -->
<!-- 			<dd> -->
<!-- 				<div class="dd_left">区域:</div> -->
<!-- 				<div class="dd_right"> -->
<!-- 					<input class="IptText301" type="text" name="area" id="restArea" -->
<!-- 						placeholder="区域" /> -->
<!-- 				</div> -->
<!-- 				<div class="clear"></div> -->
<!-- 			</dd> -->
			<dd>
				<div class="dd_left">星级:</div>
				<div class="dd_right">
					<select name="hotelLevel" id="restHotelLevel">
						<c:forEach items="${jdxjList}" var="jdxj">
							<option value="${jdxj.id }">${jdxj.value}</option>
						</c:forEach>
					</select>
				</div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">单人间:</div>
				<div class="dd_right">
					<input class="IptText301" type="text" name="countSingleRoom"
						id="restCountSingleRoom" placeholder="单人间" value="0" />
				</div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">三人间:</div>
				<div class="dd_right">
					<input class="IptText301" type="text" name="countTripleRoom"
						id="restCountTripleRoom" placeholder="三人间" value="0" />
				</div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">标准间:</div>
				<div class="dd_right">
					<input class="IptText301" type="text" name="countDoubleRoom"
						id="restCountDoubleRoom" placeholder="标准间" value="0" />
				</div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">陪房:</div>
				<div class="dd_right">
					<input class="IptText301" type="text" name="peiFang"
						id="restPeiFang" placeholder="陪房" value="0" />
				</div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">加床:</div>
				<div class="dd_right">
					<input class="IptText301" type="text" name="extraBed"
						id="restExtraBed" placeholder="加床" value="0" />
				</div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">备注:</div>
				<div class="dd_right">
					<textarea id="restRemark" class="l_textarea" style="width: 135px;" name="remark"></textarea>
				</div>
				<div class="clear"></div>
			</dd>

		</dl>
		<div class="w_btnSaveBox" style="text-align: center;">
			<button type="submit"
				class="button button-primary button-small">提交</button>
		</div>
	</form>
</div>
<!-- 酒店弹出层           结束-->

<!-- 机票弹出层        开始 -->
<div id="airticketModal" style="display: none">
	<form class="definewidth m20" id="airticketInfoForm">
		<input type="hidden" name="orderId" value="${groupOrder.id}" />
		<input type="hidden" name="groupId" value="${groupOrder.groupId}" />
		<input type="hidden" name="id" id="modalAirticketId" /> <input
			type="hidden" name="supplierType" value="9" />
		<dl class="p_paragraph_content">
			<dd>
				<div class="dd_left">日期:</div>
				<div class="dd_right">
					<input type="text" name="requireDate" id="airticketRequireDate"
						class="Wdate"
						onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm'})" />
				</div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">班次:</div>
				<div class="dd_right">
					<input class="IptText301" type="text" name="classNo"
						id="airticketClassNo" placeholder="班次" />
				</div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">出发城市:</div>
				<div class="dd_right">
					<input class="IptText301" type="text" name="cityDeparture"
						id="airticketCityDeparture" placeholder="出发城市" />
				</div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">到达城市:</div>
				<div class="dd_right">
					<input class="IptText301" type="text" name="cityArrival"
						id="airticketCityArrival" placeholder="到达城市" />
				</div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">数量:</div>
				<div class="dd_right">
					<input class="IptText301" type="text" name="countRequire"
						id="airticketCountRequire" placeholder="数量" />
				</div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">备注:</div>
				<div class="dd_right">
					<textarea id="airticketRemark" class="l_textarea" style="width: 135px;" name="remark"></textarea>
				</div>
				<div class="clear"></div>
			</dd>

		</dl>
		<div class="w_btnSaveBox" style="text-align: center;">
			<button type="submit"
				class="button button-primary button-small">提交</button>
		</div>
	</form>
</div>
<!-- 机票弹出层           结束-->


<!-- 火车票弹出层        开始 -->
<div id="trainticketModal" style="display: none">
	<form class="definewidth m20" id="trainticketInfoForm">
		<input type="hidden" name="orderId" value="${groupOrder.id}" />	<input type="hidden" name="groupId" value="${groupOrder.groupId}" /> <input
			type="hidden" name="id" id="modalTrainticketId" /> <input
			type="hidden" name="supplierType" value="10" />
		<dl class="p_paragraph_content">
			<dd>
				<div class="dd_left">日期:</div>
				<div class="dd_right">
					<input type="text" name="requireDate" id="trainticketRequireDate"
						class="Wdate"
						onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm'})" />
				</div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">车次:</div>
				<div class="dd_right">
					<input class="IptText301" type="text" name="classNo"
						id="trainticketClassNo" placeholder="班次" />
				</div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">出发地:</div>
				<div class="dd_right">
					<input class="IptText301" type="text" name="cityDeparture"
						id="trainticketCityDeparture" placeholder="出发城市" />
				</div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">目的地:</div>
				<div class="dd_right">
					<input class="IptText301" type="text" name="cityArrival"
						id="trainticketCityArrival" placeholder="到达城市" />
				</div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">数量:</div>
				<div class="dd_right">
					<input class="IptText301" type="text" name="countRequire"
						id="trainticketCountRequire" placeholder="数量" />
				</div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">摘要:</div>
				<div class="dd_right">
					<textarea id="trainticketRemark" class="l_textarea" style="width: 135px;" name="remark"></textarea>
				</div>
				<div class="clear"></div>
			</dd>

		</dl>
		<div class="w_btnSaveBox" style="text-align: center;">
			<button type="submit"
				class="button button-primary button-small">提交</button>
		</div>
	</form>
</div>
<!-- 火车票弹出层           结束-->