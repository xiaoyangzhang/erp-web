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
    <title>产品列表</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <%@ include file="../../include/top.jsp" %>
    <style>
        .searchRow li.text {
            width: 80px;
            text-align: right;
            margin-right: 10px;
        }
    </style>
</head>
<body>
<div class="p_container">
    
   <div class="p_container_sub pl-10 pr-10">
			<dl class="p_paragraph_content">
            <form id="searchProductForm">
            <%-- <input type="hidden" name="state" value="${state }"/>  --%>
            <input type="hidden" id="searchPage" name="page" value=""/>
            <input type="hidden" id="searchPageSize" name="pageSize" value=""/>
            	<dd class="inl-bl">
						<div class="dd_left">产品编号:</div>
						<div class="dd_right grey">
							<input name="code" type="text"/>
						</div>
						<div class="clear"></div>
				</dd>
				<%-- <dd class="inl-bl">
						<div class="dd_left">目的地:</div>
						<div class="dd_right grey">
							<select name="destProvinceId" id="provinceCode">
		                        <option value="">请选择省</option>
		                        <c:forEach items="${allProvince}" var="province">
		                            <option value="${province.id }">${province.name }</option>
		                        </c:forEach>
	                   		 </select>
	                        <select name="destCityId" id="cityCode">
	                            <option value="">请选择市</option>
	                        </select>
						</div>
						<div class="clear"></div>
				</dd> --%>
           		<dd class="inl-bl">
						<div class="dd_left">产品名称:</div>
						<div class="dd_right grey">
							<select class="select160" name="brandId">
	                            <option value="">选择品牌</option>
	                            <c:forEach items="${brandList}" var="brand">
	                                <option value="${brand.id }">${brand.value }</option>
	                            </c:forEach>
                        	</select>
                       		 <input type="text" name="productName"/>
						</div>
						<div class="clear"></div>
				</dd>
            	<!-- <dd class="inl-bl">
						<div class="dd_left">产品负责人:</div>
						<div class="dd_right grey">
							<input id="Text1" type="text" name="name"/>
						</div>
						<div class="clear"></div>
				</dd> -->
				<!-- <dd class="inl-bl">
						<div class="dd_left">线路类型:</div>
						<div class="dd_right grey">
							<select name="type">
	                            <option value="">全部</option>
	                            <option value="1">国内长线</option>
	                            <option value="2">周边短线</option>
	                            <option value="3">出境线路</option>
                        	</select>
						</div>
						<div class="clear"></div>
				</dd> -->
				<dd class="inl-bl">
						<div class="dd_left">状态:</div>
						<div class="dd_right grey">
							<select name="state" id="state">
	                            <option value="">全部</option>
	                            <option value="2">已上架</option>
	                            <option value="1">未上架</option>
	                            
                        	</select>
						</div>
						<div class="clear"></div>
				</dd>
				<dd class="inl-bl">
	    			<div class="dd_right">
	    				部门:
	    				<input type="text" name="orgNames" id="orgNames" stag="orgNames" value="" readonly="readonly" onclick="showOrg()"/>
						<input name="orgIds" id="orgIds" stag="orgIds" value="" type="hidden" value=""/>	    				
	    			</div>
	    			<div class="dd_right">
	    				计调:
	    				<input type="text" name="operatorName" id="operatorName" stag="userNames" value="" readonly="readonly" onclick="showUser()"/>
						<input name="operatorIds" id="operatorIds" stag="userIds" value="" type="hidden" value=""/>	    				
	    			</div>
	    		</dd>
				<dd class="inl-bl">
						<div class="dd_right">
							 <button type="button" onclick="searchBtn();" class="button button-primary button-small">查询 </button>
                        <c:if test="${optMap['EDIT'] }">
                            <a href="javascript:void(0)" onclick="newWindow('新增产品', '<%=path%>/productInfo/add.htm')" class="button button-primary button-small">新增</a>
                        </c:if>
						</div>
						<div class="clear"></div>
				</dd>
            </form>
            </dl>
            <dl class="p_paragraph_content">
        <div id="productDiv">
            <%-- <jsp:include page="product_list_table.jsp"></jsp:include>		 --%>
        </div>
        <div class="dd_right">
        <a href="javascript:void(0)" id="preview" onclick="productPricePreview()"  class="button button-primary button-small" >
						打印预览</a>
		</div>
        </dl>
    </div>


</div>


</body>
<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp" %>

<script type="text/javascript">
    $(document).ready(function () {
        queryList();
    });

    $("#provinceCode").change(function () {
        var s = "<option value=''>请选择市</option>";
        var val = this.options[this.selectedIndex].value;
        if (val !== '') {
            $.getJSON("../basic/getRegion.do?id="
                    + val, function (data) {
                data = eval(data);
                $.each(data, function (i, item) {
                    s += "<option value='" + item.id + "'>" + item.name
                            + "</option>";
                });
                $("#cityCode").html(s);
            });
        } else {
            $("#cityCode").html(s);
        }

    });

    function queryList(page, pageSize) {
        $("#searchPageSize").val(pageSize);
        $("#searchPage").val(page);
        var options = {
            url: "productPriceList.do",
            type: "post",
            dataType: "html",
            success: function (data) {
                $("#productDiv").html(data);
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                $.error("服务忙，请稍后再试");
            }
        };
        $("#searchProductForm").ajaxSubmit(options);
    }
    function searchBtn() {
    	
        queryList(1,$("#searchPageSize").val());
    }
    
	function toPreview(productId){
		window.open("<%=staticPath %>/productInfo/productInfoPreview.htm?productId="+productId+"&preview=1");
		
	}
var productIdArr=[];
function productPricePreview(){
	$("input[type='checkbox'][name='sub_check']:checked").each(function(){
		productIdArr.push($(this).attr("productId"));
	});
	if(productIdArr.length==0){
		$.warn("请选择产品");
		return false;
	}
	window.open("<%=staticPath %>/productInfo/productPricePreview.htm?productIds="+productIdArr.join());
}


	$("input[type='checkbox'][name='all_check']").live("click",function(){
		if($(this).is(':checked')){
			$("input[type='checkbox'][name='sub_check']").each(function(){
				$(this).attr("checked","checked");
			})
		}else{
			$("input[type='checkbox'][name='sub_check']").each(function(){
				$(this).removeAttr("checked");
			})
		}
	})
	
	$("input[type='checkbox'][name='sub_check']").each(function(){
		$(this).live("click",function(){
			if($(this).is(':checked')){
				
				if($("input[type='checkbox'][name='sub_check']:checked").size()==$("input[type='checkbox'][name='sub_check']").size()){
					$("input[type='checkbox'][name='all_check']").attr("checked","checked");
				}
			}else{
				if($("input[type='checkbox'][name='all_check']").is(':checked')){
					$("input[type='checkbox'][name='all_check']").removeAttr("checked");
				}
			}
		})
	})

</script>
</html>
