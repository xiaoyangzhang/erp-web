<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    String path = request.getContextPath();
String staticPath = request.getContextPath();
%>
<style>
<!--
.msgNotice{background-color: red; color:#fff; border-radius: 50%;-moz-border-radius: 50%;  -webkit-border-radius: 50%;  display: inline-block; padding: 3px;}
-->
</style>
<table cellspacing="0" cellpadding="0" class="w_table">
    <col width="4%"/>
     <col width="4%"/>
    <col width="12%"/>
    <col />
    <col width="7%"/>
    <col width="7%"/>
    <col width="6%"/>
    <col width="6%"/>
    <col width="14%"/>
    <col width="5%"/>
    <thead>
    <tr>
    
        <th>序号<i class="w_table_split"></i></th>
         <th>ID<i class="w_table_split"></i></th>
        <th>产品编号<i class="w_table_split"></i></th>
        <th>产品名称<i class="w_table_split"></i></th>
        <th>操作员<i class="w_table_split"></i></th>
        <th>计调<i class="w_table_split"></i></th>
        <th>状态<i class="w_table_split"></i></th>
        <th>资源码<i class="w_table_split"></i></th>
       <th>资源查看<i class="w_table_split"></i></th>
        <th>操作</th>
    </tr>
    </thead>
    <tbody class="wtbodys">
    <c:forEach items="${page.result}" var="productInfo" varStatus="status">
        <tr id="${productInfo.id }">
            <td>${status.count}</td>
			<td>${productInfo.id}</td>
            <td>${productInfo.code }</td>
            <td style="text-align:left">
                【${productInfo.brandName }】${productInfo.nameCity }</td>
          
            <td>${productInfo.creatorName }</td>            
            <td>${productInfo.operatorName }</td>            
            <td>
            	<c:if test="${productInfo.state==2 }"><span class="log_action insert">已上架</span></c:if>
            	<c:if test="${productInfo.state!=2 }"><span class="log_action delete">未上架</span></c:if>
            </td>
            <td>
           <c:if test="${productInfo.productSysId==0}"><a href="javascript:void(0)" onclick="AYSysId(this,'${productInfo.id }')" class="def">无</a></c:if>
             <c:if test="${productInfo.productSysId !=0}">
             	<a href="javascript:void(0)"   onclick="AYSysId(this,'${productInfo.id }')" class="def">${productInfo.productSysId }</a>
             </c:if>
            </td> 
            <td>
					 <c:if test="${productInfo.productSysId != 0}">
					 		<a href="${apiPath}Product/product_detail.aspx?pid=${productInfo.productSysId }" target="_blank" >变更</a>
					 		<a href="javascript:void(0)"  onclick="showProductAttach('price', ${productInfo.productSysId })">价格</a>
					 		<a href="javascript:void(0)"  onclick="showProductAttach('product', ${productInfo.productSysId })">产品</a>
					 </c:if>
					 <a href="${apiPath}MsgAlert/AlertMyself.aspx?pid=${productInfo.productSysId }&erpuid=${userId}"  target="_blank"  id="showMsgAtag_${productInfo.productSysId }"  class="msgNotice"  style="display:none;"></strong>
            </td>           
            <td>
				<div class="tab-operate">
					<a href="####" class="btn-show">操作<span class="caret"></span></a>
					<div class="btn-hide" id="asd">
						<a href="javascript:void(0)" onclick="dataRight(this,'${productInfo.id }')" class="def aEditRight">权限</a>
                    	<a href="javascript:void(0)" class="def aEditRight" onclick="newWindow('编辑产品-${productInfo.nameCity}', '<%=path%>/productInfo/edit.htm?productId=${productInfo.id }')" class="def aEditRight">编辑</a>
                    	<a href="javascript:void(0)" class="def aEditRight" onclick="newWindow('复制产品-${productInfo.id}', '<%=path%>/productInfo/copy.htm?productId=${productInfo.id }')" >复制</a>
                    	<a href="javascript:void(0)" class="def aEditRight"
                    		<c:if test="${priceMode == 'GROUP_ANGENCY' }"> onclick="newWindow('产品价格组', '<%=path%>/productInfo/price/list.htm?productId=${productInfo.id }')"</c:if>
                			<c:if test="${priceMode == 'LOCAL_ANGENCY' }"> onclick="newWindow('产品价格组',  '<%=path%>/product/price/supplier_list.htm?productId=${productInfo.id }')"</c:if>
                   		>价格</a>
	                   <c:if test="${productInfo.state== 1 or productInfo.state== 3}">
                    	<a href="javascript:void(0)" onclick="upState(${productInfo.id})" class="def aEditRight">上架</a>
                       </c:if>
                    	<c:if test="${productInfo.state==2}">
                    	<a href="javascript:void(0)" onclick="downState(${productInfo.id})" class="def aEditRight">下架</a>
                    	</c:if>
                		<a href="javascript:void(0)" onclick="delProduct(${productInfo.id})" class="def aEditRight">删除</a>
                	
						<a href="javascript:void(0)"
                   			<c:if test="${priceMode == 'GROUP_ANGENCY' }"> onclick="newWindow('产品详情', '<%=path%>/productSales/detail.htm?id=${productInfo.id }')"</c:if>
                   			<c:if test="${priceMode == 'LOCAL_ANGENCY' }"> onclick="newWindow('产品详情', '<%=path%>/productSales/info.htm?id=${productInfo.id }')" </c:if>
                   		class="def">预览</a> 
						<a href="javascript:void(0)" class="def"  id="preview" onclick="toPreview(${productInfo.id })" > 导出</a>
					</div>
				</div>
				            
            	
                
	                
                
                
            </td>
        </tr>
    </c:forEach>
    </tbody>
</table>

<div id="show" style="display: none; margin: 10px 10px;">
	<input type="hidden" id="productId">
	<div class="dd_left">资源码:</div>
						<div class="dd_right grey">
							<input name="productSysId"  id="productSysId" type="text"/>
						</div>
	 <button class="button button-primary button-small" onclick="updateAYSysId()" type="button">确定</button>
	 
	</div>
<jsp:include page="/WEB-INF/include/page.jsp">
    <jsp:param value="${page.page }" name="p"/>
    <jsp:param value="${page.totalPage }" name="tp"/>
    <jsp:param value="${page.pageSize }" name="ps"/>
    <jsp:param value="${page.totalCount }" name="tn"/>
</jsp:include>

<script type="text/javascript">
	$(function(){
		fixHeader();
		$(".aEditRight").css("display", ($("#optEdit").val() == "true"?"":"none"));
		getAiyouProductMsg();
	});
	
	function setAiyouProductMsg(msg){
		if (parseInt(msg.length)==0) return;
		$.each(msg.data, function(i, result){
			var $a = $("a[id='showMsgAtag_"+result.pid+"']");
			$a.text(result.msgCount).css("display", "");
		}); 		
	}
	
	//length:3,data: [{pid: '16',msgCount: '3'},{pid: '107',msgCount: '2'},{pid: '109',msgCount: '1'}]
	function getAiyouProductMsg(){
		var apiUrl = "${aiyouProduct_Msg}";
		$.ajax({
            type : "get",
            async:false,
            url : apiUrl,
            dataType : "jsonp",
            jsonp: "callback",//传递给请求处理程序或页面的，用以获得jsonp回调函数名的参数名默认为:callback)
          	jsonpCallback:"setAiyouProductMsg", //定义的jsonp回调函数名称，默认为jQuery自动生成的随机函数名
            success : function(json){
                //console.log(json);
            },
            error:function(XMLHttpRequest, textStatus, errorThrown){
                console.log('读取爱游产品系统出错：'+textStatus+";"+errorThrown);
            }
        });
	}
	function toPreview(productId){
		window.open("<%=path %>/productInfo/productInfoPreview.htm?productId="+productId+"&preview=1");
	}
	function showProductAttach(viewType, pid){
		var apiUrl = "${apiPath}";
		apiUrl += "Product/ProEdit_attachView.aspx?"
		if (viewType=="price") 
			viewType="2";
		else
			viewType="1";
		apiUrl += "type="+viewType+"&pid="+pid;
		//console.log(apiUrl);
		layer.open({
			type : 2,
			title : '资源查看',
			shadeClose : true,
			shade : 0.5,
			area: ['1000px', '500px'],
			content: apiUrl
		});
	}
	

	var layerInd=0;
	function AYSysId(obj,productId){
		$("#productId").val(productId);
		// alert(productId);
		layerInd = layer.open({
			type : 1,
			title : '编辑资源码',
			shadeClose : true,
			shade : 0.5,
			area: ['300px', '150px'],
			content: $("#show").show()
		});
	}
	
function updateAYSysId(){
	var productId = $("#productId").val();
	var productSysId = $("#productSysId").val();
			$.ajax({
				 url: 'updateAYSysId.do?productId='+productId+"&productSysId="+productSysId,
				 type: 'post',
				 success: function (data) {
		        		alert("操作成功");
		        		layer.close(layerInd);
		        		
		        		var page = $("#searchPage").val(), pageSize=$("#searchPageSize").val();
		        		queryList(page, pageSize);
					},
					error: function () {
						alert("操作失败");
					}
			 });
};
</script>