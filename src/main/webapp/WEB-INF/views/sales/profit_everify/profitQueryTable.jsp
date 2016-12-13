<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="../../../include/path.jsp"%>
<%-- <script type="text/javascript" src="<%=ctx%>/assets/js/web-js/sales/taobaoOrderList.js"></script> --%>
<script type="text/javascript">
	 <%-- function clickShBtn(value,id){
		  console.info(value+'   '+id);
		$.ajax({
					url: "<%=ctx%>/tourGroup/doExamineVerifyAccounts",
					data:{id:id,value:value},
					type: "post",
					dataType: "JSON",
					error: function(data){
						$.error(data.responseText);
						queryList($("#searchPage").val(), $("#searchPageSize").val());
					},
					success: function(data){
						$.success(data.responseText, function(){
							queryList($("#searchPage").val(), $("#searchPageSize").val());
						});
					}
			  }); 
	  } --%>
	 function changePrice(obj,id){
		    $(obj).hide() ;
		    var oriPrice = $(obj).text() ;
		   	$(obj).after('<input type="text" style="width:80%" id="newPrice" value='+oriPrice+' />');
		   	$("#newPrice").focus();
		   	$("#newPrice").blur(
				function(e) {
					var nowPrice = $("#newPrice").val() ;
					if(isNaN(nowPrice)){
						$.warn("只能输入数字！") ;
						$("#newPrice").remove();
						$(obj).text(oriPrice) ;
						$(obj).show();
						return  ;
					}
					if(nowPrice==''){
						$.warn("不能修改数据为空！") ;
						$("#newPrice").remove();
						$(obj).text(oriPrice) ;
						$(obj).show();
						return ;
					}
					var param = nowPrice - oriPrice ;
					if(param!=0){
						jQuery.ajax({
							url : "../costItem/toAddProfitChange.do",
							type : "post",
							async : false,
							data : {
								"id" : id,
								"price":param
							},
							dataType : "json",
							success : function(data) {
								if(data.success){
									$("#newPrice").remove();
			   						$(obj).text(nowPrice) ;
			   						$(obj).show();
			   						$("#curTotal").text(Number($("#curTotal").text())+Number(param)) ;
			   						$("#total").text(Number($("#total").text())+Number(param)) ;
			   						$.info("更新成功！") ;
								}else{
									$.warn("更新失败！") ;
								}
							},
							error : function(XMLHttpRequest, textStatus, errorThrown) {
								$.error(textStatus);
							}
						});
					}else{
						$("#newPrice").remove();
							$(obj).text(oriPrice) ;
							$(obj).show();
					}
					
				}
			);
		}
</script>

<table id="w_table_id" class="w_table" style="margin-left: 0px">
	<colgroup> 
		<col width="4%"/>
		<col width="9%"/>
		<col width="7%"/>
		<col/>
		<col width="5%"/>
		<col width="8%"/>
		<col width="6%"/>
		
		<col width="5%"/>
		<col width="5%"/>
		<col width="5%"/>
		<col width="5%"/>
		<col width="4%"/>
		
		<col width="4%"/>
		<col width="4%"/>
		<col width="4%"/>
		<col width="4%"/>
		<col width="4%"/>
	</colgroup>
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>团号<i class="w_table_split"></i></th>
			<th>发团日期<i class="w_table_split"></i></th>
			<th>产品名称<i class="w_table_split"></i></th>
			<th>业务<i class="w_table_split"></i></th>
			<th>客户<i class="w_table_split"></i></th>
			<th>客人信息<i class="w_table_split"></i></th>
			<th>客源地<i class="w_table_split"></i></th>
			<th>人数<i class="w_table_split"></i></th>
			<th>销售<i class="w_table_split"></i></th>
			<th>计调<i class="w_table_split"></i></th>
			<th>收入<i class="w_table_split"></i></th>
			<th>其它收入<i class="w_table_split"></i></th>
			<th>成本<i class="w_table_split"></i></th>
			<th>毛利<i class="w_table_split"></i></th>
			<th>团状态<i class="w_table_split"></i></th>
			<th>操作<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
       	<c:forEach items="${page.result}" var="gl" varStatus="v">
       		<tr>
       		<!-- 序号 -->
              <td>${v.count}</td>
             <!--  团号 -->
              <td style="text-align: left;">
	              <c:if test="${gl.orderType <= 0}">
	              	<a class="def" href="javascript:void(0)" onclick="newWindow('查看定制团信息','<%=staticPath %>/fitGroup/toFitGroupInfo.htm?groupId=${gl.groupId}&operType=0')">${gl.tourGroup.groupCode}</a> 
	              </c:if>
	              <c:if test="${gl.orderType > 0}">
	              	<a href="javascript:void(0);" class="def" onclick="newWindow('查看散客团信息','<%=staticPath %>/teamGroup/toEditTeamGroupInfo.htm?groupId=${gl.groupId}&operType=0')">${gl.tourGroup.groupCode}</a>
	              </c:if>
               </td>
               <!-- 发团日期 -->
              <td><fmt:formatDate value="${gl.tourGroup.dateStart}" pattern="yyyy-MM-dd"/></td>
             <!--  产品名称 -->
              <td style="text-align: left">【${gl.productBrandName}】${gl.productName}</td>
              <!-- 业务 -->
				<td style="text-align: left">${gl.orderModeType}</td>
              <!-- 客户-->
              <td style="text-align: left">${gl.supplierName}</td>
              <!-- 客人信息 -->
              <td style="text-align: left;">${gl.receiveMode}</td>
              <!-- 客源地 -->
              <td>${gl.provinceName}${gl.cityName}</td>
              <!-- 人数 -->
              <td>${gl.numAdult}+${gl.numChild}+${gl.numGuide}</td>
             <!--  销售 -->
              <td>${gl.saleOperatorName}</td>
            <!--   计调 -->
              <td>${gl.operatorName}</td>
              <!-- 收入 -->
              <td>
              	<fmt:formatNumber value="${gl.total}" type="currency" pattern="#.##"/>
              </td>
            <!--  其它收入 -->
             <td>
              	<fmt:formatNumber value="${gl.qdtotal}" type="currency" pattern="#.##"/>
              </td> 
             <!--  成本 -->
              <td>		
			    <font color="blue">
			    <c:if test="${optMap['EDIT'] }">
				    <c:if test="${gl.stateFinance ==0 }">
						<span style="cursor:pointer" class="price" onclick="changePrice(this,${gl.id})">
							<fmt:formatNumber value="${gl.budget}" type="currency" pattern="#.##"/>	
						</span>
						</c:if>
					</c:if>
					
					<c:if test="${gl.stateFinance ==1}">
						<span style="cursor:pointer" class="price">
								<fmt:formatNumber value="${gl.budget}" type="currency" pattern="#.##"/>	
						</span>
					</c:if>
				</font>
				<c:if test="${!optMap['EDIT'] }">
							<fmt:formatNumber value="${gl.budget}" type="currency" pattern="#.##"/>	
				</c:if>

              </td>
              
              <!-- 毛利 -->
              <td>
              	<fmt:formatNumber value="${gl.g_profit}" type="currency" pattern="#.##"/>	
              </td>
              
             <!--  团状态 -->
              <td>
              		<c:if test="${gl.tourGroup.groupState eq 0 }">未确认</c:if>
	                <c:if test="${gl.tourGroup.groupState eq 1 }">已确认</c:if>
					<c:if test="${gl.tourGroup.groupState eq 2}">废弃</c:if>
					<c:if test="${gl.tourGroup.groupState eq 3}">封存</c:if>
					<c:if test="${gl.tourGroup.groupState eq 4}">封存</c:if>
			  </td>
			  
			  <!-- 操作 -->
			  <td style="width:20px;">
					<c:if test="${gl.tourGroup.groupCode != null}"><a class="def"  onclick="window.open('<%=staticPath%>/finance/auditGroupListPrint.htm?groupId=${gl.tourGroup.id}&isShow=true','结算单打印')" 
					href="javascript:void(0)" >打印</a></c:if>&nbsp;&nbsp;
					<%-- <c:if test="${optMap['EDIT'] }">
							<c:if test="${gl.b2b_export_state ==0 }">
								<a class="def" href="javascript:void(0)" onclick="clickShBtn(${gl.b2b_export_state},${gl.id} );" ><span style="color:green;">审核</span></a>
							</c:if>
							<c:if test="${gl.b2b_export_state ==1 }">
								<a class="def" href="javascript:void(0)" onclick="clickShBtn(${gl.b2b_export_state},${gl.id} );"  ><span style="color:red">取消审核</span></a>
							</c:if>
					</c:if> --%>
				</td>
         	</tr>
         	
         	
         	<%-- <c:set var="sum_adult" value="${sum_adult+gl.numAdult}" />
			<c:set var="sum_child" value="${sum_child+gl.numChild}" />
			<c:set var="sum_guide" value="${sum_guide+gl.numGuide}" />
			<c:set var="sum_income" value="${sum_income+gl.income}" />
			<c:set var="sum_budget" value="${sum_budget+gl.budget}" /> --%>
       	</c:forEach>
	</tbody>
	<tfoot>
			<tr class="footer1">
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td colspan="1" style="text-align: right">合计：</td>
			<td>${pageTotalAudit}+${pageTotalChild}+${pageTotalGuide}</td>
		    <td></td>
         	<td></td>
         	<!-- 收入 -->
			<td><fmt:formatNumber value="${sum_total}" type="currency" pattern="#.##"/></td>
			<!-- 其它收入 -->
			<td><fmt:formatNumber value="${sum_qdtotal}" type="currency" pattern="#.##"/></td>
			<!-- 成本 -->
			<td id="curTotal"><fmt:formatNumber value="${sum_budget}" type="currency" pattern="#.##"/></td>
			<!-- 毛利 -->
			<td><fmt:formatNumber value="${sum_g_profit}" type="currency" pattern="#.##"/></td>
			
			<td></td>
			<td></td>
		</tr>
		<tr class="footer2">
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td colspan="1" style="text-align: right">总合计：</td>
			<td>${numberPeople} </td>
		    <td></td>
         	<td></td>
			<!-- 收入 -->
			<td><fmt:formatNumber value="${z_sum_total}" type="currency" pattern="#.##"/></td>
			<!-- 其它收入 -->
			<td><fmt:formatNumber value="${z_sum_qdtotal}" type="currency" pattern="#.##"/></td>
			<!-- 成本 -->
			<td id="curTotal"><fmt:formatNumber value="${z_sum_budget}" type="currency" pattern="#.##"/></td>
			<!-- 毛利 -->
			<td><fmt:formatNumber value="${z_sum_profit}" type="currency" pattern="#.##"/></td>
			<td></td>
			<td></td>
		</tr>
	</tfoot>
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${page.page }" name="p" />
	<jsp:param value="${page.totalPage }" name="tp" />
	<jsp:param value="${page.pageSize }" name="ps" />
	<jsp:param value="${page.totalCount }" name="tn" />
</jsp:include>