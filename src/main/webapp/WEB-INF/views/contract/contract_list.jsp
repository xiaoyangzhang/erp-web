<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <title>供应商协议列表</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <%@ include file="../../include/top.jsp" %>
    <script type="text/javascript">
        var path = '<%=path%>';

        var deleteContract = function(supplierId, contractId, contractName){
            $.confirm('确认要删除协议么？',function(){
                var dialog = this;
                $.ajax({
                    type : "post",
                    cache : false,
                    url : path + "/contract/" + supplierId + "/" + contractId + "/delete.do",
                    dataType : 'json',
                    success : function(data) {
                        if (data.success) {
                            $.success('操作成功', function(){
                                queryList($('input[name="page"]').val(), $('input[name="pageSize"]').val());
                            });

//                            top.topManager.reloadPage('contract');
//                            top.topManager.reloadPage('view_contract_list');
                        } else {
                            $.error('操作失败');
//                            BUI.Message.Alert('操作失败', 'error');
                        }
                    },
                    error : function(data) {
                        $.error('操作失败');
//                        BUI.Message.Alert('请求失败', 'error');
                    }
                });
            },function(){
                $.info('取消操作');
            });
        };
        //复制合同
        var copyContract = function(supplierId, contractId, contractName){
           // $.confirm('确认要删除协议么？',function(){
                var dialog = this;
                $.ajax({
                    type : "post",
                    cache : false,
                    url : path + "/contract/" + supplierId + "/" + contractId + "/copyContract.do",
                    dataType : 'json',
                    success : function(data) {
                        if (data.success) {
                            $.success('复制成功', function(){
                                queryList($('input[name="page"]').val(), $('input[name="pageSize"]').val());
                            });

//                            top.topManager.reloadPage('contract');
//                            top.topManager.reloadPage('view_contract_list');
                        } else {
                            $.error('复制失败');
//                            BUI.Message.Alert('操作失败', 'error');
                        }
                    },
                    error : function(data) {
                        $.error('复制失败');
//                        BUI.Message.Alert('请求失败', 'error');
                    }
                });
          //  },'question');
        };

        var deleteFleetContract = function(contractId, contractName){
            $.confirm('确认要删除协议么？',function(){
                var dialog = this;
                $.ajax({
                    type : "post",
                    cache : false,
                    url : path + "/contract/" + contractId + "/fleet-delete.do",
                    dataType : 'json',
                    success : function(data) {
                        if (data.success) {
                            $.success('操作成功', function(){
                                queryList($('input[name="page"]').val(), $('input[name="pageSize"]').val());
                            });

//                            top.topManager.reloadPage('contract');
//                            top.topManager.reloadPage('view_contract_list');
                        } else {
                            $.error('操作失败');
//                            BUI.Message.Alert('操作失败', 'error');
                        }
                    },
                    error : function(data) {
                        $.error('操作失败');
//                        BUI.Message.Alert('请求失败', 'error');
                    }
                });
            },function(){
                $.info('取消操作');
            });
        };


        function returnToSupplierList(){
            location.href = '<%=path%>/contract/list.htm';
        }
		
        /**
         * 分页查询
         */
        function queryList(page, pageSize) {
            if (!page || page < 1) {
                page = 1;
            }
            $("#searchPage").val(page);
            $("#searchPageSize").val(pageSize);
            $("#queryForm").submit();
        }
        function searchBtn(){
            $("#searchPage").val(1);
            $("#queryForm").submit();

        }
        $(function() {
    		function setData(){
    			var curDate=new Date();
    			var startTime=curDate.getFullYear()+"-01-01";//+(curDate.getMonth()+1)+"-"+1;
    			 $("input[name='startDate']").val(startTime);
    			//var new_date = new Date(curDate.getFullYear(),curDate.getMonth()+1,1);                  
    		   //  var endDate=(new Date(new_date.getTime()-1000*60*60*24)).getDate();
    			var endTime=curDate.getFullYear()+"-12-31";//+(curDate.getMonth()+1)+"-"+endDate;
    		     $("input[name='endDate']").val(endTime);			
    		}
    		setData();
    })
    </script>
</head>
<body>
<div class="p_container">
	<div class="p_container_sub">
		<div class="searchRow">
            <c:choose>
                <c:when test="${supplierType eq FLEET }">
                    <form id="queryForm"  action="<%=path%>/contract/fleet-list.htm" method="post">
                        <input type="hidden" name="page" value="${page.page}" id="searchPage" />
                        <input type="hidden" name="pageSize" value="${page.pageSize}" id="searchPageSize" />
                        <ul>
                            <li class="text">
                                <label class="control-label" for="contractName">合同名称：</label>
                            </li>
                            <li>
                                <input type="text" id="contractName" placeholder="合同名称" name="contractName" value="${page.parameter.contractName}"/>
                            </li>

                            <li class="text">
                                <label class="control-label" for="startDate">签订日期：</label>
                            </li>
                            <li>
                                <input  type="text" name="startDate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="<fmt:formatDate value="${page.parameter.startDate}" pattern="yyyy-MM-dd"/>"/>
                                &nbsp;-&nbsp;<input type="text"  name="endDate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="<fmt:formatDate value="${page.parameter.endDate}" pattern="yyyy-MM-dd"/>"/>
                            </li>

                            <li class="text">
                                <label class="control-label" for="state">状态：</label>
                            </li>
                            <li>
                                <select id="state" name="state">
                                    <option value="" selected>请选择</option>
                                    <c:forEach items="${contractStateMap}" var="type">
                                        <option value="${type.key}" <c:if test="${type.key == page.parameter.state}">selected="selected"</c:if>>${type.value}</option>
                                    </c:forEach>
                                </select>
                            </li>


                            <li class="clear" />
                            <li class="text"></li>
                            <li>
                                <button type="submit" class="button button-primary button-small" id="searchTitle" onclick="searchBtn();">
                                    查询
                                </button>
                                <button type="button" class="button button-primary button-small" id="searchTitle" onclick="newWindow('新增协议', '<%=path%>/contract/fleet-add.htm')">
                                    新增
                                </button>
                                    <%--<button type="button" class="button button-primary button-small" id="returnBtn" onclick="returnToSupplierList();">--%>
                                    <%--返回--%>
                                    <%--</button>--%>
                            </li>
                        </ul>
                    </form>
                </c:when>
                <c:otherwise>
                    <form id="queryForm"  action="<%=path%>/contract/${supplierId}/${flag }/view-list.htm" method="post">
                        <input type="hidden" name="page" value="${page.page}" id="searchPage" />
                        <input type="hidden" name="pageSize" value="${page.pageSize}" id="searchPageSize" />
                        <ul>
                            <li class="text">
                                <label class="control-label" for="contractName">合同名称：</label>
                            </li>
                            <li>
                                <input type="text" id="contractName" placeholder="合同名称" name="contractName" value="${page.parameter.contractName}"/>
                            </li>

                           <%--  <li class="text">
                                <label class="control-label" for="startDate">签订日期：</label>
                            </li>
                            <li>
                                <input  type="text" name="startDate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="<fmt:formatDate value="${page.parameter.startDate}" pattern="yyyy-MM-dd"/>"/>
                                &nbsp;-&nbsp;<input type="text" name="endDate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="<fmt:formatDate value="${page.parameter.endDate}" pattern="yyyy-MM-dd"/>"/>
                            </li>
 --%>
                            <li class="text">
                                <label class="control-label" for="state">状态：</label>
                            </li>
                            <li>
                                <select id="state" name="state">
                                    <option value="" selected>请选择</option>
                                    <c:forEach items="${contractStateMap}" var="type">
                                        <option value="${type.key}" <c:if test="${type.key == page.parameter.state}">selected="selected"</c:if>>${type.value}</option>
                                    </c:forEach>
                                </select>
                            </li>


                            <li class="clear" />
                            <li class="text"></li>
                            <li>
                                <button type="submit" class="button button-primary button-small" id="searchTitle" onclick="searchBtn();">查询</button>
                                <c:if test="${flag eq 1 }">
                                <button type="button" class="button button-primary button-small" id="searchTitle" onclick="newWindow('新增协议', '<%=path%>/contract/${supplierId }/add.htm')">新增 </button>
                                <c:if test="${supplierInfo.getSupplierType() eq 16}">
                                <button type="button" class="button button-primary button-small" id="searchTitle" onclick="newWindow('新增协议', '<%=path%>/contract/${supplierId }/delivery-add.htm')">新增2 </button>
                                </c:if>
                                </c:if>
                            </li>
                        </ul>
                    </form>
                </c:otherwise>
            </c:choose>

		</div>
    
    <table id="table" class="w_table">
        <thead>
            <tr>
                <th>合同名称<i class="w_table_split"></i></th>
                <th>签订日期<i class="w_table_split"></i></th>
                <th>优先级<i class="w_table_split"></i></th>
                <th>合同协议有效期<i class="w_table_split"></i></th>
                <th>提醒<i class="w_table_split"></i></th>
                <th>操作</th>
            </tr>
        </thead>
        <tbody>
        <c:forEach var="contract" items="${page.result}" varStatus="status">
            <tr>
                <td>${contract.contractName}</td>
                <td><fmt:formatDate value="${contract.signDate}" pattern="yyyy-MM-dd"/></td>
                <td>${contract.datePriority}</td>
                <td><fmt:formatDate value="${contract.startDate}" pattern="yyyy-MM-dd"/> ~
                    <fmt:formatDate value="${contract.endDate}" pattern="yyyy-MM-dd"/></td>
                <td>${contractStateMap[contract.state]}</td>
                <td>
                    <c:choose>
                        <c:when test="${supplierType == FLEET}">
                            <a class="def" onclick="newWindow('查看协议', '<%=path%>/contract/${contract.id}/fleet-view.htm')" href="javascript:void(0);">查看</a>&nbsp;
                            <a class="def" onclick="newWindow('修改协议', '<%=path%>/contract/${contract.id}/fleet-edit.htm')" href="javascript:void(0);">修改</a>&nbsp;
                            <a class="def" onclick="deleteFleetContract('${contract.id}', '${contract.contractName}');" href="javascript:void(0);">删除</a>
                            <a class="def" onclick="copyContract('-1', '${contract.id}', '${contract.contractName}');" href="javascript:void(0);">复制</a>
                            <%--<a class="def" onclick="copyFleetContract('${contract.id}', '${contract.contractName}');" href="javascript:void(0);">复制</a>--%>
                        </c:when>
                        <c:otherwise>
                            <a class="def" onclick="newWindow('查看协议', '<%=path%>/contract/${supplierId}/${contract.id}/view.htm')" href="javascript:void(0);">查看</a>&nbsp;
                            <a class="def" onclick="newWindow('修改协议', '<%=path%>/contract/${supplierId}/${contract.id}/edit.htm')" href="javascript:void(0);">修改</a>&nbsp;
                            <a class="def" onclick="deleteContract('${supplierId}', '${contract.id}', '${contract.contractName}');" href="javascript:void(0);">删除</a>
                            <a class="def" onclick="copyContract('${supplierId}', '${contract.id}', '${contract.contractName}');" href="javascript:void(0);">复制</a>
                            <c:if test="${supplierInfo.getSupplierType() eq 16}">
                            <a class="def" onclick="newWindow('修改协议', '<%=path%>/contract/${contract.id}/delivery-edit.htm')" href="javascript:void(0);">修改2</a>
                            </c:if>
                        </c:otherwise>
                    </c:choose>
                </td>
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

</div>
</div>
</body>
</html>
