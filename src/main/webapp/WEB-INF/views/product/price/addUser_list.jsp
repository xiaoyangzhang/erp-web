<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>


<%
    String path = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8"/>
<title>新增产品_价格设置</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<%@ include file="../../../include/top.jsp"%>

</head>
<body>

	<div class="p_container">
		<dl class="p_paragraph_content">
			<dd class="inl-bl">
				<div class="dd_left">用户：</div>
				<div class="dd_right grey">
					<input type="text" name="operatorNames" id="operatorNames"
						value="${product.operatorName}" readonly="readonly" />
					<button onclick="selectUser()"
						class="button button-primary button-small ">选择</button>

				</div>
				<div class="clear"></div>
			</dd>
		</dl>
		<form action="productInfoList.do" id="queryForm">
			<input name="page" type="hidden" id="page" value="" /> <input
				type="hidden" id="pageSize" name="pageSize"
				value="${page.pageSize }" /> <input type="hidden"
				name="operatorIds" id="operatorIds" value="${product.operatorIds }" />
			<input type="hidden" name="operatorName" id="operatorName"
				value="${product.operatorName }" />
			<div class="p_container_sub" id="list_search">
				<dl class="p_paragraph_content">

					<dd class="inl-bl">
						<div class="dd_left">品牌:</div>
						<div class="dd_right grey">
							<select class="select160" name="brandId" id="brandId">
								<option value="">全部</option>
								<c:forEach items="${brandList }" var="brand">
									<option value="${brand.id }"
										<c:if test="${product.brandId==brand.id }">selected</c:if>>${brand.value }</option>

								</c:forEach>
							</select>
						</div>

					</dd>
					<dd class="inl-bl">
						<div class="dd_left">产品名称:</div>
						<div class="dd_right grey">
							<input type="text" name="nameCity" id="nameCity"
								value="${product.nameCity }" class="w-200" />

						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">状态:</div>
						<div class="dd_right grey">
							<select name="state" id="state">
								<option value="">全部</option>
								<option value="0"
									<c:if test="${product.state==0 }">selected</c:if>>未上架</option>
								<option value="1"
									<c:if test="${product.state==1 }">selected</c:if>>已上架</option>
							</select>
						</div>
						<div class="clear"></div>
					</dd>

					<dd class="inl-bl">
						<div class="dd_right">
							<button type="button" id="btnQuery"
								class="button button-primary button-small">搜索</button>

						</div>
						<div class="clear"></div>
					</dd>

				</dl>

			</div>
		</form>
		<dl class="p_paragraph_content">

			<dd class="inl-bl">
				<table class="w_table" cellspacing="0" cellpadding="0">
					<colgroup>
						<col width="5%">

						<col width="7%">
						<col width="10%">
						<col width="7%">
						<col width="5%">

					</colgroup>
					<thead>
						<tr>
							<th>序号<i class="w_table_split"></i></th>
							<th>品牌<i class="w_table_split"></i></th>
							<th>产品<i class="w_table_split"></i></th>
							<th>价格组<i class="w_table_split"></i></th>
							<th>全选<input type="checkbox" class="all_check"
								onclick="chkAll()" /><i class="w_table_split"></i></th>

						</tr>
					</thead>
					<tbody id="subList">
						<c:forEach items="${page.result}" var="product" varStatus="status">
							<tr>
								<td rowspan="${fn:length(product.productGroupList) }">${status.count }</td>
								<td rowspan="${fn:length(product.productGroupList) }">${product.brandName }</td>
								<td rowspan="${fn:length(product.productGroupList) }">${product.nameCity }</td>
								<c:forEach items="${product.productGroupList }" var="group"
									varStatus="groupStatus">
									<c:if test="${groupStatus.index==0 }">
										<td>${group.name }</td>
										<td><input type="checkbox" name="sub_group"
											<c:if test="${group.checked }">checked</c:if>
											productId="${product.id }" groupId="${group.id }" /></td>
									</c:if>
									<c:if test="${groupStatus.index>0 }">
										<tr>
											<td>${group.name }</td>
											<td><input type="checkbox" name="sub_group"
												<c:if test="${group.checked }">checked</c:if>
												productId="${product.id }" groupId="${group.id }" /></td>
										</tr>
									</c:if>
								</c:forEach>
							</tr>

						</c:forEach>
					</tbody>
				</table>
			</dd>

			<dd class="inl-bl">
				<div >
					<button type="button" onclick="saveSeller()"
						class="button button-primary button-small">保存</button>
					<button type="button" onclick="opReturn()"
						class="button button-primary button-small">关闭</button>
				</div>
				<div id="az"></div>
				<div class="clear"></div>
			</dd>
			<jsp:include page="/WEB-INF/include/page.jsp">
				<jsp:param value="${page.page }" name="p" />
				<jsp:param value="${page.totalPage }" name="tp" />
				<jsp:param value="${page.pageSize }" name="ps" />
				<jsp:param value="${page.totalCount }" name="tn" />
			</jsp:include>
		</dl>

	</div>
</body>
<script type="text/javascript" src="<%=staticPath %>/assets/js/json2.js"></script>

<script type="text/javascript">
	 /* $(function(){
		 alert("ww")
		 
	}) */ 
	$("#btnQuery").click(function(){
		queryList();
	})
	function queryList(page,pageSize){
		if(!page || page<0){
			$("#page").val(1);
		}
		$("#page").val(page);
		$("#pageSize").val(pageSize);
		$("#queryForm").submit();
	}


	 
	function selectUser(){
		 var userNameArr=[];
		 var  userIdArr=[];
		    	var win=0;
		    	layer.open({
					type : 2,
					title : '选择人员',
					//shadeClose : true,
					//shade : 0.5,
					area : [ '500px', '400px' ],
					content : '<%=path%>/component/orgUserTree.htm?type=multi',//单选地址为orgUserTree.htm，多选地址为
					btn: ['确定', '取消'],
					 success:function(layero, index){
							 win = window[layero.find('iframe')[0]['name']];
					},
					yes: function(index){
						 userArr = win.getUserList();
						if(userArr.length==0){
							$.warn("请选择人员");
							return false;
						}
						for(var i=0;i<userArr.length;i++){
							userNameArr.push(userArr[i].name);
							userIdArr.push(userArr[i].id);
							
						}
						$("#operatorName").val(userNameArr.join());		
						$("#operatorNames").val(userNameArr.join());		
						$("#operatorIds").val(userIdArr.join());		
						//console.log(userNameArr.join());
						
						//selectGroupByOperator();
						queryList();
						//一般设定yes回调，必须进行手工关闭
				       layer.close(index); 
				    },cancel: function(index){
				    	layer.close(index);
				    } 
				});
		    }
	function chkAll(){
		if($(".all_check").is(":checked")){
			$("input[name='sub_group']").attr("checked","checked");
		}
		else{
			
			$("input[name='sub_group']").removeAttr("checked");
		}
	}
	

	function getProductUserList(state){
		var user={
				groupSellers:[]
		};
		
		var operatorIds = $("#operatorIds").val().split(',');
		var operatorNames = $("#operatorNames").val().split(',');
		//console.log("operatorIds.val："+$("#operatorIds").val()+"，数组："+operatorIds);
		
		for(var i=0; i<operatorIds.length; i++){
			if (operatorIds[i] != ""){
				$("input[type='checkbox'][name='sub_group']").each(function(){
					if ($(this).prop("checked")==state)
						user.groupSellers.push({productId:$(this).attr("productid"),groupId:$(this).attr("groupid"),operatorId:operatorIds[i],operatorName:operatorNames[i]});
				});
			}
			/*
			for(var j=1; j<$(":checkbox:checked").length; j++){
				user.groupSellers.push({productId:$(":checkbox:checked").eq(j).attr("productId"),groupId:$(":checkbox:checked").eq(j).attr("groupId"),operatorId:operatorIds[i],operatorName:operatorNames[i]});
			}
			*/
		}
		
		//console.log(user);
		//console.log(JSON.stringify(user.groupSellers));
		return user;
	}
	
	function saveSeller(){
		var userInsert = getProductUserList(true);  
		var userDelete = getProductUserList(false);  
		/* if(user.groupSellers.length==0){
			$.warn("请选择价格组");
			return false;
		} */
		if($("#operatorIds").val().length==0){
			$.warn("请选择用户");
			return false;
		}
		
		$.post("saveUser.do", {insertJson:JSON.stringify(userInsert), deleteJson:JSON.stringify(userDelete)}, function(data){
			data = $.parseJSON(data);
			if(data.success == true){
				$.success("保存成功！");
				//window.location.reload(true);
				//closeWindow();
			}else{
				$.error(data.msg);
			}
		});
		
	}
	
	function opReturn(){
		var selected = $(top.document).find('#sysMenuTab li[class*="select"]').children('em');
        top.barClose(selected);
	}

	
	/* 
	//当选择用户以后，选中该用户对应的价格组
	function selectGroupByOperator(){
		var operatorIds=$("#operatorIds").val();
		$.post("selectPriceGroupByOperator.do",{"operatorIds":operatorIds},function(data){
			var data=$.parseJSON(data);
			console.log(data);
		})
	} 
	*/
	
	
</script>

</html>
