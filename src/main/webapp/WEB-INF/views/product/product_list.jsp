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
    <title>地接【产品列表】</title>
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
  <div class="p_container" >
		
        <div class="p_container_sub pl-10 pr-10">
			<dl class="p_paragraph_content">
				<form id="searchProductForm">
				<input type="hidden" id="searchPage" name="page" value=""/>
				<input type="hidden" id="searchPageSize" name="pageSize" value=""/>
				<dd class="inl-bl">
						<div class="dd_left">状态：</div>
						<div class="dd_right grey">
							<select class="select160" name="state">
								
								<option value="">全部</option>
								<option value="1">待上架</option>
								<option value="2">已上架</option>
							</select>
						</div>
						<div class="clear"></div>
				</dd>
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
						<div class="dd_right">
							<button type="button" onclick="searchBtn()" class="button button-primary button-small">查询</button>
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
			</dl>
        </div>

    </div>
    
  
</body>
<script type="text/javascript">
$(document).ready(function(){
	queryList();
});

/* $("#provinceCode").change(function() {
			var s = "<option value=''>请选择市</option>";
			var val = this.options[this.selectedIndex].value;
			if(val !== ''){
				$.getJSON("../basic/getRegion.do?id="
						+ val, function(data) {
					data = eval(data);
					$.each(data, function(i, item) {
						s += "<option value='" + item.id + "'>" + item.name
								+ "</option>";
					});
					$("#cityCode").html(s);
				});
			}else{
				$("#cityCode").html(s);
			}

		}); */
		
function queryList(page,pageSize) {
	$("#searchPageSize").val(pageSize);
	$("#searchPage").val(page);
	var options = {
		url:"productList.do",
    	type:"post",
    	dataType:"html",
    	success:function(data){
    		$("#productDiv").html(data);
    	},
    	error:function(XMLHttpRequest, textStatus, errorThrown){
    		$.error("服务忙，请稍后再试");
    	}
    };
    $("#searchProductForm").ajaxSubmit(options);	
}
function searchBtn() {
	var pageSize=$("#searchPageSize").val();
	queryList(1,pageSize);
}

/**删除产品**/
function delProduct(id){	
		$.confirm("确认删除此产品吗？",function(){
				  $.post("upState.do",{state:-1,id:id},function(data){
				   		if(data.success){
				   			$.success('删除成功！', function(){
                                queryList($('input[name="page"]').val(), $('input[name="pageSize"]').val());
							});
//				   			$("#"+id).remove();
				   			
				   		}else{
				   			$.info(data.msg);
				   		}
				  },"json");
		},function(){
			  $.info('取消删除！');
			
		});
	
	}

function dataRight(obj,productid){
	var win;
	layer.open({ 
		type : 2,
		title : '选择单位',
		closeBtn : false,
		area : [ '400px', '490px' ],
		shadeClose : false,
		content : 'rightTree.htm?productId='+productid,
		btn: ['确定', '取消'],
		success:function(layero, index){
			win = window[layero.find('iframe')[0]['name']];
		},
		yes: function(index){    				
			var orgArr = win.getOrgList();
			if(orgArr.length==0){
				alert("请选择单位");
				return false;
			}
			var orgIdArr = new Array();
			//var orgNameArr = new Array();
			for(var i=0;i<orgArr.length;i++){
				orgIdArr.push(orgArr[i].id);
				//orgNameArr.push(orgArr[i].name);;
			}
			
			$.ajax({
				url:"saveRight.do",
				dataType:"json",
				type:"post",
				data:{
					productId:productid,
					orgIdArr:JSON.stringify(orgIdArr)
				},
				success:function(data){
					if(data.success){
						//$(obj).closest("tr").find("td[tag='right']").html(orgNameArr.join(","));
						alert("操作成功");
					}
					else{
						alert("操作失败");
					}
					
					//一般设定yes回调，必须进行手工关闭
			        layer.close(index); 
				},
				error:function(XMLHttpRequest, textStatus, errorThrown){
					alert("服务器忙，请稍候再试");
				}
			});
			
			 
	    },cancel: function(index){
	    	layer.close(index);
	    }
	});
	
}

</script>
<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp" %>

</html>
