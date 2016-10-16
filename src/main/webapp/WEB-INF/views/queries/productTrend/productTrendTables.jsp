<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<table cellspacing="0" cellpadding="0" class="w_table" id="payTable">
	<thead>
		<tr>
			<th rowspan="2">序号<i class="w_table_split"></i></th>
			<th rowspan="2" style="width:15%;">品牌<i class="w_table_split"></i></th>
			<th rowspan="2" style="width:15%;">产品名称<i class="w_table_split"></i></th>
			<th colspan="31">人数<i class="w_table_split"></i></th>
			<!-- <th rowspan="2">月总数<i class="w_table_split"></i></th> -->
		</tr>
		<tr>
			<%-- <c:forEach items="${strList }" var="str">
				<th id="nums">${str }<i class="w_table_split"></i></th>
			</c:forEach> --%>
			<th id="nums">01<i class="w_table_split"></i></th>
			<th id="nums">02<i class="w_table_split"></i></th>
			<th id="nums">03<i class="w_table_split"></i></th>
			<th id="nums">04<i class="w_table_split"></i></th>
			<th id="nums">05<i class="w_table_split"></i></th>

			<th id="nums">06<i class="w_table_split"></i></th>
			<th id="nums">07<i class="w_table_split"></i></th>
			<th id="nums">08<i class="w_table_split"></i></th>
			<th id="nums">09<i class="w_table_split"></i></th>
			<th id="nums">10<i class="w_table_split"></i></th>

			<th id="nums">11<i class="w_table_split"></i></th>
			<th id="nums">12<i class="w_table_split"></i></th>
			<th id="nums">13<i class="w_table_split"></i></th>
			<th id="nums">14<i class="w_table_split"></i></th>
			<th id="nums">15<i class="w_table_split"></i></th>

			<th id="nums">16<i class="w_table_split"></i></th>
			<th id="nums">17<i class="w_table_split"></i></th>
			<th id="nums">18<i class="w_table_split"></i></th>
			<th id="nums">19<i class="w_table_split"></i></th>
			<th id="nums">20<i class="w_table_split"></i></th>

			<th id="nums">21<i class="w_table_split"></i></th>
			<th id="nums">22<i class="w_table_split"></i></th>
			<th id="nums">23<i class="w_table_split"></i></th>
			<th id="nums">24<i class="w_table_split"></i></th>
			<th id="nums">25<i class="w_table_split"></i></th>

			<th id="nums">26<i class="w_table_split"></i></th>
			<th id="nums">27<i class="w_table_split"></i></th>
			<th id="nums">28<i class="w_table_split"></i></th>
			<th id="nums">29<i class="w_table_split"></i></th>
			<th id="nums">30<i class="w_table_split"></i></th>
			<th id="nums">31<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${page.result}" var="v" varStatus="vs">
			<tr>
				<td>${vs.count}</td>
				<td>${v.productBrandName}</td>
				<td>${v.productName}</td>
				<%-- <td>${Integer.parseInt(v.departureDate.substring(8, 10)) }</td> --%>
				<td>${v.day1}</td>
				<td>${v.day2}</td>
				<td>${v.day3}</td>
				<td>${v.day4}</td>
				<td>${v.day5}</td>
				<td>${v.day6}</td>
				<td>${v.day7}</td>
				<td>${v.day8}</td>
				<td>${v.day9}</td>
				<td>${v.day10}</td>
				
				<td>${v.day11}</td>
				<td>${v.day12}</td>
				<td>${v.day13}</td>
				<td>${v.day14}</td>
				<td>${v.day15}</td>
				<td>${v.day16}</td>
				<td>${v.day17}</td>
				<td>${v.day18}</td>
				<td>${v.day19}</td>
				<td>${v.day20}</td>
				
				<td>${v.day21}</td>
				<td>${v.day22}</td>
				<td>${v.day23}</td>
				<td>${v.day24}</td>
				<td>${v.day25}</td>
				<td>${v.day26}</td>
				<td>${v.day27}</td>
				<td>${v.day28}</td>
				<td>${v.day29}</td>
				<td>${v.day30}</td>
				<td>${v.day31}</td>
				
				<!-- <td></td> -->
				<%-- <td id="depDate"><fmt:parseDate value="${v.departureDate}"
						pattern="yyyy-MM-dd" var="mtDate"></fmt:parseDate> <fmt:formatDate
						value="${mtDate }" pattern="dd" />
				</td> --%>
				<%-- <c:forEach items="${listMap }" var="m">
					<td>${m.person }</td>
				</c:forEach> --%>
					<%-- <c:choose>
						<c:when test="${m.date eq strList}">
							<td>${m.person }</td>
						</c:when>
						<c:otherwise>
							<td>0</td>
						</c:otherwise>
					</c:choose> --%>
				
				
				<%-- <c:if test="${v.departureDate eq '2016-07-01'}">
			<td >${v.numAdult+v.numChild }</td>
			</c:if>
			<c:if test="${v.departureDate eq '2016-07-02'}">
			<td >${v.numAdult+v.numChild }</td>
			</c:if>
			<c:if test="${v.departureDate eq '2016-07-03'}">
			<td >${v.numAdult+v.numChild }</td>
			</c:if>
			<c:if test="${v.departureDate eq '2016-07-04'}">
			<td >${v.numAdult+v.numChild }</td>
			</c:if>
			<c:if test="${v.departureDate eq '2016-07-05'}">
			<td >${v.numAdult+v.numChild }</td>
			</c:if>
			<c:if test="${v.departureDate eq '2016-07-06'}">
			<td >${v.numAdult+v.numChild }</td>
			</c:if>
			<c:if test="${v.departureDate eq '2016-07-07'}">
			<td >${v.numAdult+v.numChild }</td>
			</c:if>
			<c:if test="${v.departureDate eq '2016-07-08'}">
			<td >${v.numAdult+v.numChild }</td>
			</c:if>
			<c:if test="${v.departureDate eq '2016-07-09'}">
			<td >${v.numAdult+v.numChild }</td>
			</c:if>
			<c:if test="${v.departureDate eq '2016-07-10'}">
			<td >${v.numAdult+v.numChild }</td>
			</c:if>
			<c:if test="${v.departureDate eq '2016-07-11'}">
			<td >${v.numAdult+v.numChild }</td>
			</c:if>
			<c:if test="${v.departureDate eq '2016-07-12'}">
			<td >${v.numAdult+v.numChild }</td>
			</c:if>
			<c:if test="${v.departureDate eq '2016-07-13'}">
			<td >${v.numAdult+v.numChild }</td>
			</c:if>
			<c:if test="${v.departureDate eq '2016-07-14'}">
			<td >${v.numAdult+v.numChild }</td>
			</c:if>
			<c:if test="${v.departureDate eq '2016-07-15'}">
			<td >${v.numAdult+v.numChild }</td>
			</c:if>
			<c:if test="${v.departureDate eq '2016-07-16'}">
			<td >${v.numAdult+v.numChild }</td>
			</c:if>
			<c:if test="${v.departureDate eq '2016-07-17'}">
			<td >${v.numAdult+v.numChild }</td>
			</c:if>
			<c:if test="${v.departureDate eq '2016-07-18'}">
			<td >${v.numAdult+v.numChild }</td>
			</c:if>
			<c:if test="${v.departureDate eq '2016-07-19'}">
			<td >${v.numAdult+v.numChild }</td>
			</c:if>
			<c:if test="${v.departureDate eq '2016-07-20'}">
			<td >${v.numAdult+v.numChild }</td>
			</c:if>
			<c:if test="${v.departureDate eq '2016-07-21'}">
			<td >${v.numAdult+v.numChild }</td>
			</c:if>
			<c:if test="${v.departureDate eq '2016-07-22'}">
			<td >${v.numAdult+v.numChild }</td>
			</c:if>
			<c:if test="${v.departureDate eq '2016-07-23'}">
			<td >${v.numAdult+v.numChild }</td>
			</c:if>
			<c:if test="${v.departureDate eq '2016-07-24'}">
			<td >${v.numAdult+v.numChild }</td>
			</c:if>
			<c:if test="${v.departureDate eq '2016-07-25'}">
			<td >${v.numAdult+v.numChild }</td>
			</c:if>
			<c:if test="${v.departureDate eq '2016-07-26'}">
			<td >${v.numAdult+v.numChild }</td>
			</c:if>
			<c:if test="${v.departureDate eq '2016-07-27'}">
			<td >${v.numAdult+v.numChild }</td>
			</c:if>
			<c:if test="${v.departureDate eq '2016-07-28'}">
			<td >${v.numAdult+v.numChild }</td>
			</c:if>
			<c:if test="${v.departureDate eq '2016-07-29'}">
			<td >${v.numAdult+v.numChild }</td>
			</c:if>
			<c:if test="${v.departureDate eq '2016-07-30'}">
			<td >${v.numAdult+v.numChild }</td>
			</c:if>
			<c:if test="${v.departureDate eq '2016-07-31'}">
			<td >${v.numAdult+v.numChild }</td>
			</c:if> --%>
		
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

