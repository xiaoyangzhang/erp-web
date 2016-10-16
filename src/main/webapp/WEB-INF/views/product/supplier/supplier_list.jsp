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
	   <ul class="w_tab">
	    	<%--<li><a href="../edit.htm?productId=${productId }">基本信息</a></li>--%>
	    	<%--<li><a href="../route/view.htm?productId=${productId }">行程列表</a></li>--%>
	    	<%--<li><a href="../tag/view.htm?productId=${productId }">标签属性</a></li>--%>
	    	<%--<li><a href="../remark/view.htm?productId=${productId }">备注信息</a></li>--%>
	    	<li><a href="../price/list.htm?productId=${productId }" class="selected">价格设置</a></li>
	    	<li class="clear"></li>
	    </ul>

	    <div class="p_container_sub" id="tab1">

	    	<p class="p_paragraph_title"><b>价格组列表</b></p>
            <button onclick="selectSupplier()" class="button button-primary button-small mt-20 ml-20">新增客户</button>
			<button type="button" onclick="history.go(-1)" class="button button-primary button-small">返回</button>
            <dl class="p_paragraph_content">
	    		<dd>
	    			<div class="dd_right" style="width:80%">
                     <table cellspacing="0" cellpadding="0" class="w_table ml-10" border="1"> 
		             <col width="10%" /><col width="30%" /><col width="" /><col width="20%" />
		             <thead>
		             	<tr>
		             		<th>序号</th>
		             		<th>区域</th>
		             		<th>名称</th>
		             		<th>操作</th>
		             	</tr>
		             </thead>
		             <tbody> 
		              <c:forEach items="${groupSuppliers}" var="gs" varStatus="status">
			               <tr id="${gs.id }"> 
			                  <td>${status.count }</td>
			                  <td>${gs.province}-${gs.city }-${gs.area }</td> 
			                  <td>${gs.supplierName }</td>
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
			  $.post("delSupplier.do",{state:-1,id:id},function(data){
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
</script>
</html>
