<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>基本信息</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<%@ include file="../../../include/top.jsp"%>
<link rel="stylesheet" type="text/css" href="<%=staticPath %>/assets/css/operate/operate.css"/>
<style type="text/css">
	.dn{display:none;}
	.textarea-w200-h50{height:50px;width:80%;margin-top:4px;}
	.input-w80{width:70%;}
	.fontBold{font-weight:bold;}
</style>
<link href="<%=ctx%>/assets/js/web-js/sales/autocomplete/jquery.autocomplete.css" rel="stylesheet" type="text/css" />
    <script src="<%=ctx%>/assets/js/web-js/sales/autocomplete/jquery.autocomplete.js" type="text/javascript"></script>
</head>
<body>
	 <div class="p_container" >
	    <div class="p_container_sub" id="tab1">
	    	<div id="groupDetail">
            	
            </div>  
	    	<form id="bookingForm" method="post">
	    	<input type="hidden" name="groupId" id="groupId" value="${group.id}" />
	    	<input type="hidden" id="bookingId" value="${booking.id}" />
	    	<input type="hidden" name="stateFinance" id="stateFinance" value="${booking.stateFinance }" />
	    	
	    	<input type="hidden" id="groupMode" value="${group.groupMode}" />
	    	<input type="hidden" id="stateBooking" value="${booking.stateBooking}" />
	    	<p class="p_paragraph_title"><b>地接社</b></p>
	    	<dl class="p_paragraph_content">
	    		<dd>
	    			<div class="dd_left"><i class="red">* </i>地接社：</div> 
	    			<div class="dd_right">
	    				<input type="text" name="supplierName" id="supplierName" value="${booking.supplierName}" class="IptText300"/>
	    				<input type="hidden" name="supplierId" id="supplierId" value="${booking.supplierId}" />
	    				<c:if test="${empty view }">
	    					<input type="button" class="button button-primary button-small" value="选择" onclick="show.agency('<%=ctx%>')"/>
	    				</c:if>
	    			</div>
					<div class="clear"></div>
	    		</dd> 
	    		<dd>
	    			<div class="dd_left">地接社团号：</div> 
	    			<div class="dd_right">
	    				<input type="text" id="supplierOrderNo" name="supplierOrderNo" placeholder="团号" class="IptText300" value="${booking.supplierOrderNo}" />
	    			</div>
					<div class="clear"></div>
	    		</dd> 
	    		<dd>
	    			<div class="dd_left">联系方式：</div> 
	    			<div class="dd_right">
	    			<p class="pb-5">	    				
						<p class="pb-5">
						<input type="text" id="contact" placeholder="联系人" name="contact" class="IptText60" value="${booking.contact}"/>
                        <input type="text" id="contactTel" placeholder="电话"  name="contactTel" class="IptText60" value="${booking.contactTel}"/>
                        <input type="text" id="contactMobile" name="contactMoblie" placeholder="手机" class="IptText60" value="${booking.contactMobile}"/>
                        <input type="text" id="contactFax" name="contactFax" placeholder="传真" class="IptText60" value="${booking.contactFax}" />
                        <c:if test="${empty view }">
                        	<input type="button" class="button button-primary button-small"  value="选择" onclick="show.contact('<%=ctx%>')"/>
                        </c:if>
	    				</p>                        
	    			</div>
					<div class="clear"></div>
	    		</dd> 
	    		<dd>
	    			<div class="dd_left"><i class="red">* </i>到达日期：</div> 
	    			<div class="dd_right">
	    				<input type="text" name="dateArrival" id="dateArrival" class="Wdate"
							onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" 
							<c:if test="${not empty booking}">
								value="<fmt:formatDate value="${booking.dateArrival}" pattern="yyyy-MM-dd"/>"
							</c:if>
							<c:if test="${empty booking}">
								value="<fmt:formatDate value="${group.dateStart}" pattern="yyyy-MM-dd"/>"
							</c:if> 
							/>
	    			</div>
					<div class="clear"></div>
	    		</dd> 
                <dd>
	    			<div class="dd_left">人数：</div> 
	    			<div class="dd_right">	    				
	    				成人：<i class="grey ml-10" id="numAdult">
	    						<c:if test="${booking==null}">
	    							<c:if test="${group.groupMode>0}">${group.totalAdult}</c:if><c:if test="${group.groupMode==0}">0</c:if>
	    						</c:if>
	    						<c:if test="${booking!=null }">
	    							${booking.personAdult }
	    						</c:if> 
	    					</i>&nbsp;&nbsp;
	    				小孩：<i class="grey ml-10" id="numChild">
	    						<c:if test="${booking==null }">
	    							<c:if test="${group.groupMode>0 }">${group.totalChild}</c:if><c:if test="${group.groupMode==0}">0</c:if>
	    						</c:if>
	    						<c:if test="${booking!=null }">
	    							${booking.personChild }
	    						</c:if> 
	    					</i>
	    				全陪：<i class="grey ml-10" id="numGuide">
	    						<c:if test="${booking==null }">
	    							<c:if test="${group.groupMode>0 }">${group.totalGuide}</c:if><c:if test="${group.groupMode==0}">0</c:if>
	    						</c:if>
	    						<c:if test="${booking!=null }">
	    							${booking.personGuide==null ? 0: booking.personGuide}
	    						</c:if> 
	    					</i>
	    			</div>
					<div class="clear"></div>
	    		</dd>	    		
	    	</dl>

	    	<p class="p_paragraph_title"><b>地接行程</b></p>
            <dl class="p_paragraph_content">
	    		<dd>
	    			<div class="dd_left"></div> 
	    			<div class="dd_right" style="width:80%">
                     <table cellspacing="0" cellpadding="0" class="w_table chk_table" id="routeTable" > 
		             	<col width="40px" /><col width="90px" /><col width="" /><col width="15%" /><col width="15%" />
			             <thead>
			             	<tr>
			             		<th><input type="checkbox" class="chkAll" /></th>
			             		<th>日期<i class="w_table_split"></i></th>
			             		<th>行程<i class="w_table_split"></i></th>
			             		<th>酒店<i class="w_table_split"></i></th>
			             		<th>用餐</th>		             		
			             	</tr>
			             </thead>
			             <tbody>
			            	<c:forEach items="${routeList }" var="route">
			            		<tr>
			            			<td>
			            				<input type="checkbox" class="itemChk" rid="${route.id }" 
			            					<c:if test="${booking!=null&&booking.routeList!=null }">
			            						<c:forEach items="${booking.routeList }" var="broute">
			            							<c:if test="${route.id==broute.routeId }">checked="checked" brid="${broute.id }"  bkid="${broute.bookingId }"</c:if>
			            						</c:forEach>
			            					</c:if> />
			            			</td>
			            			<td><fmt:formatDate value="${route.groupDate }" pattern="yyyy-MM-dd"/></td>
			            			<td>${route.routeDesp }</td>
			            			<td>${route.hotelName }</td>
			            			<td>
			            				早：${route.breakfast }
			            				中：${route.lunch }
			            				晚：${route.supper }
			            			</td>
			            		</tr>
			            	</c:forEach>
			             </tbody>
	          		</table>
	    			</div>
					<div class="clear"></div>
	    		</dd>
            </dl>
	    	<p class="p_paragraph_title"><b>项目费用</b></p>
	    	<dl class="p_paragraph_content">
	    		<dd>
	    			<div class="dd_left"><span class="btnTianjia"><i></i>&nbsp;&nbsp;</span></div> 
	    			<div class="dd_right" style="width:80%">
                     <table cellspacing="0" cellpadding="0" class="w_table" id="priceTable"> 
		             	<col width="15%" /><col width="35%" /><col width="10%" /><col width="10%" />
		             	<col width="10%" /><col width="10%" /><col width="10%" />
			             <thead>
			             	<tr>
			             		<th>项目<i class="w_table_split"></i></th>
			             		<th>描述<i class="w_table_split"></i></th>
			             		<th>单价￥<i class="w_table_split"></i></th>
			             		<th>次数<i class="w_table_split"></i></th>
			             		<th>人数<i class="w_table_split"></i></th>		             		
			             		<th>金额￥<i class="w_table_split"></i></th>
			             		<c:if test="${empty view }">
			             		<th><a href="javascript:void(0)" id="priceBtn" class="button button-primary button-small">添加</a>			             		
			             		</th>
			             		</c:if>
			             	</tr>
			             </thead>
			             <tbody id="priceTblTr">
			             	<c:if test="${booking!=null&&booking.priceList!=null }">
				            	<c:forEach items="${booking.priceList }" var="price">
				            		<tr>
				            			<td><input type="hidden" name="priceId" value="${price.id }" /><select name="itemName">
				            				<c:forEach items="${typeList}" var="v" varStatus="vs">
				            					<option value="${v.value}" <c:if test="${v.value==price.itemName }">selected</c:if>>${v.value}</option>
				            				</c:forEach>
				            			</select></td>
				            			<td><textarea class="textarea-w200-h50" name='note'>${price.remark }</textarea></td>
				            			<td><input class="input-w80" name="unitPrice" type="text" value='<fmt:formatNumber value="${price.unitPrice }" type="number" pattern="#.##"/>' /></td>
				            			<td><input class="input-w80" name="numTimes" type="text" value='<fmt:formatNumber value="${price.numTimes }"  pattern="#.##"/>' /></td>
				            			<td><input class="input-w80" name="numPerson" type="text" value='<fmt:formatNumber value="${price.numPerson }"  pattern="#.##"/>' /></td>
				            			<td><input class="input-w80" name="totalPrice" type="text" value='<fmt:formatNumber value="${price.totalPrice }" type="number" pattern="#.##"/>'  readOnly/></td>
				            			<c:if test="${empty view }">
				            			<td><a href="javascript:void(0)" name="priceDel">删除</a></td>
				            			</c:if>
				            		</tr>
			            			<c:set var="sum_price" value="${sum_price+price.totalPrice }" />
				            	</c:forEach>
			            	</c:if>
			             </tbody>
			             <tfoot>
				            	<tr><td colspan="5" style="text-align: right;" class="fontBold">合计（￥）：</td>
					            	<td id="sumPrice"><fmt:formatNumber value="${sum_price }" pattern="#.##" type="number"/></td>
					            	<c:if test="${empty view }">
					            	<td><a href="javascript:void(0)" id="impBtn" class="button button-primary button-small">导入</a></td></c:if>
				            	</tr>
				         </tfoot>
	          		</table>
	    			</div>
					<div class="clear"></div>
	    		</dd>
            </dl>
            <p class="p_paragraph_title"><b>备注</b></p>
	    	<dl class="p_paragraph_content">
	    		<dd>
	    			<div class="dd_left"></div> 
	    			<div class="dd_right" style="width:80%">
	    				<c:choose>
		    				<c:when test="${booking!=null && !empty booking.remark }"><textarea class="w_textarea" name="remark" id="remark">${booking.remark }</textarea></c:when>
	    					<c:otherwise><textarea class="w_textarea" name="remark" id="remark"></textarea></c:otherwise>
	    				</c:choose>
                     	
                    </div>
					<div class="clear"></div>
	    		</dd>
            </dl>
            <c:if test="${group.groupMode<1 }">
	            <p class="p_paragraph_title"><b>散单</b></p>
		    	<dl class="p_paragraph_content">
		    		<dd>
		    			<div class="dd_left"></div> 
		    			<div class="dd_right" style="width:80%">
	                     <table cellspacing="0" cellpadding="0" class="w_table chk_table"  id="orderTable"> 
			             	<col width="40px" /><col width="14%" /><col width="8%" /><col width="10%" /><col width="10%" />
			             	<col width="" /><col width="15%" /><col width="8%" /><col width="8%" />
				             <thead>
				             	<tr>
				             		<th><input type="checkbox"  class="chkAll"/><i class="w_table_split"></i></th>
				             		<th>组团社<i class="w_table_split"></i></th>
				             		<th>联系人<i class="w_table_split"></i></th>
				             		<th>接站牌<i class="w_table_split"></i></th>
				             		<th>人数<i class="w_table_split"></i></th>			             		
				             		<th>产品名称<i class="w_table_split"></i></th>		             		
				             		<th>备注<i class="w_table_split"></i></th>
				             		<th>客人名单<i class="w_table_split"></i></th>
				             		<th>接送信息</th>
				             	</tr>
				             </thead>
				             <tbody>
				            	<c:forEach items="${orderList }" var="order">
				            		<tr>
				            			<td>
				            				<input type="checkbox"  class="itemChk" tag="num" oid="${order.id }" adultnum="${order.numAdult }" childnum="${order.numChild }"
				            					<c:if test="${booking!=null&&booking.orderList!=null }">
				            						<c:forEach items="${booking.orderList }" var="border">
				            							<c:if test="${order.id==border.orderId }">checked="checked" boid="${border.id }" bkid="${border.bookingId }"</c:if>
				            						</c:forEach>
				            					</c:if> />
				            			</td>
				            			<td>${order.supplierName }</td>
				            			<td>${order.contactName }${order.contactMobile }</td>
				            			<td>${order.receiveMode }</td>
				            			<td>${order.numAdult+order.numChild }人（${order.numAdult }大${order.numChild }小）</td>
				            			<td>${order.productBrandName }${order.productName }</td>
				            			<td>${order.remarkInternal }</td>
				            			<td><a href="javascript:void(0)" onclick="show.guest(${order.id })">点击查看</a></td>
				            			<td><a href="javascript:void(0)" onclick="show.traffic(${order.id })">点击查看</a></td>
				            		</tr>
				            	</c:forEach>
				            	
				             </tbody>
		          		</table>
		    			</div>
						<div class="clear"></div>
		    		</dd>
	            </dl>
            </c:if>
            <div class="Footer">
	            <dl class="p_paragraph_content">
		    		<dd>
		    			<div class="dd_left"></div> 
		    			<div class="dd_right">
		    				<c:if test="${empty view }">
	            			<button  type="submit" class="button button-primary button-small" id="btnSave">保存</button>
	            			</c:if>
	            			<a href="javascript:void(0)" onclick="closeWindow()" class="button button-primary button-small">关闭</a>
	            		</div>
	            	</dd>
	            </dl>
	        </div>    
            </form>	
                                  
	    </div>
    </div>  
</body>
<script type="text/html" id="priceRowHtml">
<tr>
<td tag='name'><input type="hidden" name="priceId"/><select name='itemName'><c:forEach items="${typeList}" var="v" varStatus="vs"><option value="${v.value}">${v.value}</option></c:forEach></select></td>
<td tag='note'><textarea class="textarea-w200-h50" name='note'></textarea></td><td tag='unit'><input class="input-w80" type="text" name="unitPrice" value="1" /></td>
<td tag='times'><input class="input-w80" type="text" name="numTimes" value="1" /></td><td tag='num'><input class="input-w80" type="text" name="numPerson" value="0" /></td>
<td tag='total'><input class="input-w80" type="text" name="totalPrice" value="0" readOnly /></td>
<td><a href="javascript:void(0)" name="priceDel">删除</a></td>
</tr>
</script>
<script type="text/javascript" src="<%=staticPath %>/assets/js/json2.js"></script>
<script type="text/javascript">
var person = {adult:0,child:0,guide:0};
var dataInit=function(){
	<c:if test='${booking!=null }'>
		person.adult = ${booking.personAdult==null?0:booking.personAdult};
		person.child = ${booking.personChild==null?0:booking.personChild};
		person.guide = ${booking.personGuide==null?0:booking.personGuide};
	</c:if>	
	<c:if test='${booking==null }'>
		<c:if test="${group.groupMode>0}">
			person.adult = ${group.totalAdult};
			person.child = ${group.totalChild};
			person.guide = ${group.totalGuide};
		</c:if>
	</c:if>
}
var showGroupInfo=function(){
	$("#groupDetail").load("groupDetail.htm?gid=${group.id}&stype=1");
}
dataInit();
showGroupInfo();
</script>
<script type="text/javascript" src="<%=ctx %>/assets/js/utils/float-calculate.js"></script>
<script type="text/javascript" src="<%=ctx %>/assets/js/operate/delivery-edit.js"></script>
<script type="text/javascript">
	var supplierType = $("#supplierType").val() ;
    $(function(){
        var param = "";
        JAutocompleteEx("#supplierName", "<%=staticPath %>/tourGroup/getSupplier?supplierType=16", param, "supplierId", customerTicketCallback, 1);
        <c:if test='${booking==null }'>
        	$(".itemChk").attr("checked", "checked");
        </c:if>
    });
    function customerTicketCallback(event, value) {
         
    } 
</script>
</html>
