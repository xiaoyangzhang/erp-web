<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
    String ctx = request.getContextPath();
%>
<table cellspacing="0" cellpadding="0" class="w_table" id="payTable">
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>团号<i class="w_table_split"></i></th>
			<th>组团社<i class="w_table_split"></i></th>
			<th>计调<i class="w_table_split"></i></th>
			<th>客人<i class="w_table_split"></i></th>
			<th>接送方式<i class="w_table_split"></i></th>
			<th>交通方式<i class="w_table_split"></i></th>
			<th>出发城市<i class="w_table_split"></i></th>
			<th>到达城市<i class="w_table_split"></i></th>
			<th>是否直达<i class="w_table_split"></i></th>
			<th>目的地<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody><input type="hidden"  id="searchPageSize" value="${pageBean.pageSize }"/>
		<c:forEach items="${pageBean.result}" var="v" varStatus="vs">
			<tr>
				<td style="width:5%">${vs.count}</td>
				<td style="width:15%;text-align: left;">
	              <c:choose>
               		<c:when test="${v.groupMode > 0}">
               		    <a class="def" href="javascript:void(0)" onclick="newWindow('查看定制团信息','teamGroup/toEditTeamGroupInfo.htm?groupId=${v.groupId}&operType=0')">${v.groupCode}</a> </c:when>
               		<c:otherwise>
						<a class="def" href="javascript:void(0)" onclick="newWindow('查看散客团信息','fitGroup/toFitGroupInfo.htm?groupId=${v.groupId}&operType=0')">${v.groupCode}</a>
               		</c:otherwise>
                  	</c:choose>
             	</td>
				<td style="width:10%;text-align: left">
				${v.supplierName}
					
				</td>
				<td style="width:5%">${v.operatorName}</td>
				<td style="text-align: left;width:15%">
					  <c:if test="${v.groupMode <1}">
		              	<a class="def" href="javascript:void(0)" onclick="newWindow('查看订单信息','<%=ctx %>/groupOrder/toLookGroupOrder.htm?id=${v.orderId}')">${v.receiveMode}</a> 
		              </c:if>
		              <c:if test="${v.groupMode>0}">
		              	<a href="javascript:void(0);" class="def" onclick="newWindow('查看订单信息','<%=ctx %>/tourGroup/toAddTourGroupOrder.htm?groupId=${v.groupId}&state=4')">${v.receiveMode}</a>
		              </c:if>
				</td>
				<td style="width:5%">
					<c:if test="${v.TYPE==0}">送</c:if>
					<c:if test="${v.TYPE==1}">接</c:if>
				</td>
				<td style="text-align: left;width:10%">
					<span class="sm">${v.method}</span>
					<c:if test="${v.class_no!='' and v.class_no!=null}">
						(${v.class_no})
					</c:if>
					<c:if test="${v.class_no==''and v.class_no==null}">
						(${v.class_no})
					</c:if>
					
				</td>
				<td style="width:10%">
					<c:if test="${v.departureStation!=''and v.departureStation!=null}">
						${v.departureCity}(${v.departureStation})</br>${v.departureTime}&nbsp;${v.departureDate}
					</c:if>
					<c:if test="${v.departureStation==''or v.departureStation==null}">
						${v.departureCity}</br>${v.departureTime}
					</c:if>
				</td>
				<td style="width:10%">
					<c:if test="${v.arrivalStation!=''and v.arrivalStation!=null}">
						${v.arrivalCity}(${v.arrivalStation})</td>
					</c:if>
					<c:if test="${v.arrivalStation==''or v.arrivalStation==null}">
						${v.arrivalCity}</td>
					</c:if>
				<td style="width:5%">${v.isDirect}</td>
				<td style="text-align: left;width:10%">${v.destination}</td>
			</tr>
		</c:forEach>
	</tbody>
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p" />
	<jsp:param value="${pageBean.totalPage }" name="tp" />
	<jsp:param value="${pageBean.pageSize }" name="ps" />
	<jsp:param value="${pageBean.totalCount }" name="tn" />
</jsp:include>
