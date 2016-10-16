<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ include file="../../../include/path.jsp"%>


<table cellspacing="0" cellpadding="0" class="w_table">
	<col width="3%" />
	<col width="10%" />
	<col width="5%" />
	<col width="15%" />
	<col width="15%" />
	<col width="5%" />
	<col width="5%" />
	<col width="5%" />
	<col width="5%" />
	<col width="5%" />
	<col width="5%" />
	<col width="5%" />
	<col width="5%" />
	<col width="5%" />
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>团号<i class="w_table_split"></i></th>
			<th>出发日期<i class="w_table_split"></i></th>
		
			<th>产品名称<i class="w_table_split"></i></th>
			<th>组团社<i class="w_table_split"></i></th>
			<th>人数<i class="w_table_split"></i></th>
			<th>计调<i class="w_table_split"></i></th>
			<th>进店数<i class="w_table_split"></i></th>
			<th>计划销售<i class="w_table_split"></i></th>
			<th>实际销售</th>
			<th>差额/完成率</th>
			<th>人均购物</th>
			<th>人员返款</th>
			<th>购物返款</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${page.result}" var="groupInfo" varStatus="status">
			<tr>
				<td class="serialnum">
					
					${status.index+1}
				</td>
				<td style="text-align: left;"><c:choose>
				                  		<c:when test="${groupInfo.groupMode > 0}">
				                  		
				                  <a class="def" href="javascript:void(0)" onclick="newWindow('查看团信息','<%=staticPath %>/tourGroup/toAddTourGroupOrder.htm?groupId=${groupInfo.groupId }&operType=0')">${groupInfo.groupCode}</a></td> 
				                  		</c:when>
				                  		<c:otherwise>
								 <a class="def" href="javascript:void(0)" onclick="newWindow('查看团信息','<%=staticPath %>/groupOrder/toFitEdit.htm?groupId=${groupInfo.groupId}&operType=0')">${groupInfo.groupCode}</a></td> 
				                  		
				                  		</c:otherwise>
				                  	</c:choose>

				</td>
				<td><fmt:formatDate value="${groupInfo.dateStart}"
						pattern="yyyy-MM-dd" /></td>
				
				<td style="text-align: left;">${groupInfo.productName}</td>
				<td style="text-align: left;">${groupInfo.supplierName}</td>
				<td>${groupInfo.personCount}</td>
				<td>${groupInfo.operatorName}</td>
				<c:if test="${groupInfo.bookingShopSelect!=null}">
					<td>${groupInfo.bookingShopSelect.shopCount}家</td>
					<td><fmt:formatNumber type="number"  value="${groupInfo.bookingShopSelect.jhSales}" pattern="0.00#" />元</td>
					<td><fmt:formatNumber type="number"  value="${groupInfo.bookingShopSelect.factSales}" pattern="0.00#" />元</td>
					<td><fmt:formatNumber type="number"  value="${groupInfo.bookingShopSelect.factSales-groupInfo.bookingShopSelect.jhSales}" pattern="0.00#" />元
					<br>
							<c:if test="${groupInfo.bookingShopSelect.jhSales=='0.0000'}">
	          					<fmt:formatNumber type="number" value="0" pattern="0.00#" />%
	          				</c:if>
	          				<c:if test="${groupInfo.bookingShopSelect.jhSales!='0.0000'}">
							<fmt:formatNumber type="number"  value="${groupInfo.bookingShopSelect.factSales/ groupInfo.bookingShopSelect.jhSales *100}" pattern="0.00#" />%
						</c:if>
					</td>
					<td>
						<c:choose>
			<c:when test="${groupInfo.personCount ne 0 and groupInfo.bookingShopSelect.factSales ne 0.0000 }">
			<fmt:formatNumber type="number"  value="${groupInfo.bookingShopSelect.factSales/groupInfo.personCount}" pattern="#.##" /></c:when>
			<c:otherwise><fmt:formatNumber type="number" value="0" pattern="#.##" /></c:otherwise>
			</c:choose>
					
					</td>
					<td><fmt:formatNumber type="number"  value="${groupInfo.bookingShopSelect.personRepayTotal}" pattern="0.00#" />元</td>
					<td><fmt:formatNumber type="number"  value="${groupInfo.bookingShopSelect.totalRepay}" pattern="0.00#" />元</td>
				</c:if>
				<c:if test="${groupInfo.bookingShopSelect==null}">
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
				</c:if>
				
			</tr>
		</c:forEach>
	</tbody>
</table>

<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${page.page }" name="p" />
	<jsp:param value="${page.totalPage }" name="tp" />
	<jsp:param value="${page.pageSize }" name="ps" />
	<jsp:param value="${page.totalCount }" name="tn" />
</jsp:include>


