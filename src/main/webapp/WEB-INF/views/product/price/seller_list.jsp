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
    <title>新增产品_价格设置</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <%@ include file="../../../include/top.jsp" %>
     
</head>
<body>
  
   <div class="p_container" >

	    <div class="p_container_sub" id="tab1">

	    	<p class="p_paragraph_title"><b>用户列表</b></p>
            <button onclick="selectUser()" class="button button-primary button-small mt-20 ml-20">新增用户</button>
            <input type="hidden" name="productId" readonly="readonly" id="productId" value="${productId}" >
   			<input type="hidden" name="groupId" id="groupId" value="${groupId}" >
			<button type="button" onclick="history.go(-1)" class="button button-primary button-small">返回</button>
            <dl class="p_paragraph_content">
	    		<dd>
	    			<div class="dd_right" style="width:80%">
                     <table cellspacing="0" cellpadding="0" class="w_table ml-10" border="1"> 
		             <col width="10%" /><col width="" /><col width="20%" />
		             <thead>
		             	<tr>
		             		<th>序号</th>
		             		<th>姓名</th>
		             		<th>操作</th>
		             	</tr>
		             </thead>
		             <tbody> 
		              <c:forEach items="${groupSuppliers}" var="gs" varStatus="status">
			               <tr id="${gs.id }"> 
			                  <td>${status.count }</td>
			                  <td>${gs.operatorName }</td>
			                  <td>
			                  	<a onclick="delPsupplier(${gs.id})" class="def" href="#">删除</a>
			                  </td>
			               </tr>
		               </c:forEach>
		             </tbody>
	          		</table>
	    			</div>
					<div class="clear"></div>
	    		</dd>
            </dl>
            </div>
            </div>    	
	    </div>
        
    </div>
</body>
<script type="text/javascript">


	function selectSupplier(){
    		layer.openSupplierLayer({
    			title : '选择客户',
    			content : '<%=path%>/component/supplierList.htm?page=1&type=multi&supplierType=1',//参数：操作类型（type:单选(single)、多选(multi)）供应商类型supplierType=1
    			callback: function(arr){
    				if(arr.length==0){
    					$.warn("请选择客户");
    					return false;
    				}
    				
    				var dataAry = [];
    				for(var i=0;i<arr.length;i++){
    					//console.log("supplier_id:"+arr[i].id+",name:"+arr[i].name+",type:"+arr[i].type+",province:"+arr[i].province+",city:"+arr[i].city+",area:"+arr[i].area+",town:"+arr[i].town);
    					dataAry.push({"groupId":${groupId},"supplierId":arr[i].id,"supplierName":arr[i].name,"province":arr[i].province,"city":arr[i].city,"area":arr[i].area,"town":arr[i].town });
    				}
    				//id:37,name:怡美假日旅行社,type:1,province:云南,city:昆明,area:安宁,town:八街镇
					//id:37,name:怡美假日旅行社,type:1,province:云南,city:昆明,area:安宁,town:八街镇
					/* var r = "{id:37,groupId：22,name:'怡美假日旅行社',type:1,province:'云南',city:'昆明',area:'安宁',town:'八街镇'}"; */
					
    				$.ajax({
    					 url :"supplier_save.do",
     				    type :"POST", 
     				    dataType:"json",
     				    data:{data:JSON.stringify(dataAry)},
     				    success : function(data) {
     				    	  if (data.success) {
     				    		 $.success('操作成功',function(){
     				    			window.location.href="<%=path%>/productInfo/price/supplier_list.htm?groupId=${groupId}&productId=${productId}";
 								});
                                 
                              } else {
                            	  layer.alert(data.msg, {
  									icon : 5
  								});
                              }
     				    },
     				error:function(e){
     					layer.alert(data.msg, {
							icon : 5
						});
     				    }
    				});
    		    }
    		});
    	}

	
	function delPsupplier(id){
		$.confirm("确认删除吗？",function(){
			  $.post("delSeller.do",{id:id},function(data){
			   		if(data.success){
			   		
			   			$.success('删除成功！', function(){
                            $("#"+id).remove();
						});
//
			   			
			   		}else{
			   			$.info(data.msg);
			   		}
			  },"json");
	},function(){
		  $.info('取消删除！');
		
	});
		}
	var ids =[];
	function selectUser(){
		
		var expIds ="";
		var productId=$("#productId").val();
		$.ajax({
			url :"expSellers.htm",
		    type :"GET", 
		    dataType:"json",
		    data:{productId:productId},
		    success : function(data) {		    	
		    	expIds = data.result;
		    	var win=0;
		    	layer.open({
					type : 2,
					title : '选择人员',
					shadeClose : true,
					shade : 0.5,
					area : [ '400px', '470px' ],
					content : '../../component/orgUserTree.htm?type=multi&expIds='+expIds,//单选地址为orgUserTree.htm，多选地址为
					btn: ['确定', '取消'],
					success:function(layero, index){
						win = window[layero.find('iframe')[0]['name']];
					},
					yes: function(index){
						//userArr返回的是user对象的数组，user包含属性：用户id(id),职位(pos)，名称（name），mobile（手机）,phone（电话）,fax（传真）
						var userArr = win.getUserList();    				
						if(userArr.length==0){
							$.warn("请选择人员");
							return false;
						}
						for(var i=0;i<userArr.length;i++){
							ids.push(userArr[i].id);
						}
						saveSeller(ids.join(','));				
						//一般设定yes回调，必须进行手工关闭
				        layer.close(index); 
				    },cancel: function(index){
				    	layer.close(index);
				    }
				});
		    }
		})
		
		
		
	}
	
	function saveSeller(ids){
		var groupId = $("#groupId").val();
		var productId = $("#productId").val();
		$.post("saveSeller.do", {"ids": ids,"groupId" : groupId,"productId" : productId}, function(data){
			data = $.parseJSON(data);
			if(data.success == true){
				$.success("添加成功！");
				location.reload();
			}else{
				$.error(data.msg);
			}
		}); 
	}
</script>
</html>
