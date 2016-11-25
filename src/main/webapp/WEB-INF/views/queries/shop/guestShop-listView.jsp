<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ include file="../../../include/path.jsp" %>

<table cellspacing="0" cellpadding="0" class="w_table" > 
		             	<col width="3%" /><col width="10%" /><col width="10%" /><col width="12%" />
		             	<col width="5%" /><col width="6%" /><col width="8%" /><col width="5%" /><col width="8%" /><col width="6%" /><col width="" /><col width="5%" />
			             <thead>
			             	<tr>
			             		<th>序号<i class="w_table_split"></i></th>
			             		<th>团号<i class="w_table_split"></i></th>
			             		<th>组团社<i class="w_table_split"></i></th>
			             		<th>产品名称<i class="w_table_split"></i></th>
			             		<th>人数<i class="w_table_split"></i></th>
			             		<th>客人<i class="w_table_split"></i></th>
			             		<th>客源地<i class="w_table_split"></i></th>
			             		<th>客源地类别<i class="w_table_split"></i></th>
			             		<th>导管<i class="w_table_split"></i></th>
			             		<th>购物总额<i class="w_table_split"></i></th>
			             		<th>购物明细(导游/购物店/购物金额)<i class="w_table_split"></i></th>
			             		<th>人均</th>
			             	</tr>
			             </thead>
			             <tbody> 
			              	 <c:forEach items="${page.result}" var="groupInfo" varStatus="status">
			              	  <tr> 
			                  	  <td class="serialnum">
				                  		${status.index+1}
				                  </td>
				                  <td style="text-align: left;">
						              <c:if test="${groupInfo.groupMode<1}">
						              	<a class="def" href="javascript:void(0)" onclick="newWindow('查看散客团信息','fitGroup/toFitGroupInfo.htm?groupId=${groupInfo.groupId}&operType=0')">${groupInfo.groupCode}</a> 
						              </c:if>
						             <c:if test="${groupInfo.groupMode>0}">
						              	<a href="javascript:void(0);" class="def" onclick="newWindow('查看定制团信息','teamGroup/toEditTeamGroupInfo.htm?groupId=${groupInfo.groupId}&operType=0')">${groupInfo.groupCode}</a>
						              </c:if>
					             	</td>
				                  <td>${groupInfo.supplierName}</td>
				                  <td>【${groupInfo.productBrandName}】${groupInfo.productName}</td>
				                  <td>${groupInfo.adultNum}大${groupInfo.childNum}小</td>
				                  <td>${groupInfo.receiveMode}</td> 
				                  <td>${groupInfo.source}</td>
				                  <td>${groupInfo.sourceType}</td>
				                   <td>${groupInfo.userName}</td>
				                   <td>
				                   <c:if test="${shoppingDataState ==0  }">
				                   
				                   </c:if>
				                   <c:if test="${shoppingDataState ==1  }">
				                   <fmt:formatNumber type="currency"  value="${groupInfo.totalFee }" pattern="#.##" />
				                   </c:if>
				                   </td>
				                   <td>
					                   <c:if test="${groupInfo.shopFeeArr!=null and fn:length(groupInfo.shopNameArr)>0}">
					                   		<table class="in_table">
					                   		<c:forEach items="${groupInfo.shopNameArr}" var="shop" varStatus="st">
												<tr>
						                   			<td style="width:30%;">${groupInfo.guideNameArr[st.index]}</td>
							                   		<td>${shop}</td>
								                 	<td style="width:20%;">
								                 	<c:if test="${shoppingDataState ==0  }">
				                   
				                  					 </c:if><c:if test="${shoppingDataState ==1  }">
								                 	<fmt:formatNumber type="currency"  value="${groupInfo.shopFeeArr[st.index]}" pattern="#.##" />
								                 	</c:if>
								                 	</td>
								                 </tr>					                  	
					                   		</c:forEach>
					                   		</table>				                   		
					                   </c:if>
				                   </td>
				                   <td>
				                 	<c:if test="${groupInfo.adultNum+groupInfo.childNum>0}">
				                 	<c:if test="${shoppingDataState ==0  }">
				                   
				                  	</c:if><c:if test="${shoppingDataState ==1  }">
				                 		<fmt:formatNumber type="currency"  value="${groupInfo.totalFee /(groupInfo.adultNum+groupInfo.childNum)}" pattern="#.##" />
				                  	</c:if>
				                  	</c:if>
				                  	<c:if test="${groupInfo.adultNum+groupInfo.childNum==0}">
				                  	<c:if test="${shoppingDataState ==0  }">
				                   
				                  	</c:if><c:if test="${shoppingDataState ==1  }">
				                 	    0
				                 	    </c:if>
				                  	</c:if>
				                  	</td>	              		
				               </tr>
				               <c:set  var="sumAdultNum" value="${groupInfo.adultNum + sumAdultNum }"/>
				               <c:set  var="sumChildNum" value="${groupInfo.childNum + sumChildNum }"/>
				               <c:if test="${shoppingDataState ==0  }">
				                   <c:set  var="sumTotalFee" value=""/>
				              </c:if>
				              <c:if test="${shoppingDataState ==1  }">
				              	 <c:set  var="sumTotalFee" value="${groupInfo.totalFee + sumTotalFee }"/>
				              </c:if>
				              
			              </c:forEach>
			              </tbody>
			              <tfoot>
				               <tr class="footer1">
				               	<td colspan="4">本页合计：</td>
				               	<td>${sumAdultNum}大${sumChildNum}小</td>
				               	<td colspan="4"/>
				               	<td><fmt:formatNumber type="currency"  value="${sumTotalFee}" pattern="#.##" /></td>
				               	<td></td>
			               		<td>
			               			<c:if test="${shoppingDataState ==1 && (sumAdultNum+sumChildNum) != 0 }">
				                 		<fmt:formatNumber type="currency"  value="${sumTotalFee /(sumAdultNum+sumChildNum) }" pattern="#.##" />
				                  	</c:if>
			               		</td>
				               </tr>
				               
				               <tr class="footer2">
				               	<td colspan="4">总合计：</td>
				               	<td>${queryGuideShop.adultNumTotal}大${queryGuideShop.childNumTotal}小</td>
				               	<td colspan="4"/>
				               	<td><fmt:formatNumber type="currency"  value="${queryGuideShop.allTotalFee}" pattern="#.##" /></td>
			               		<td/>
			               		<td>
			               			<c:if test="${shoppingDataState ==1 && (queryGuideShop.adultNumTotal+queryGuideShop.childNumTotal) != 0 }">
				                 		<fmt:formatNumber type="currency"  value="${queryGuideShop.allTotalFee /(queryGuideShop.adultNumTotal+queryGuideShop.childNumTotal)}" pattern="#.##" />
				                  	</c:if>
			               		</td>
				               </tr>
			             </tfoot>
	          		 </table>
          		
 <jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${page.page }" name="p" />
	<jsp:param value="${page.totalPage }" name="tp" />
	<jsp:param value="${page.pageSize }" name="ps" />
	<jsp:param value="${page.totalCount }" name="tn" />
</jsp:include>


		