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
    <%@ include file="/WEB-INF/include/top.jsp" %>
     
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
            <button id="addPgroup" class="button button-primary button-small mt-20 ml-20">新增价格组</button>
            <dl class="p_paragraph_content">
	    		<dd>
	    			<div class="dd_right" style="width:80%">
                     <table cellspacing="0" cellpadding="0" class="w_table ml-20" > 
		             <col width="10%" /><col width="15%" /><col width="" /><col width="20%" /><col width="25%" />
		             <thead>
		             	<tr>
		             		<th>序号<i class="w_table_split"></i></th>
		             		<th>出发地<i class="w_table_split"></i></th>
		             		<th>价格组名称<i class="w_table_split"></i></th>
		             		<th>是否过期<i class="w_table_split"></i></th>
		             		<th>操作</th>
		             	</tr>
		             </thead>
		             <tbody> 
		             <c:forEach items="${prouctGroups}" var="pg" varStatus="status">
			               <tr id="${pg.id}"> 
			                  <td>${status.count }</td>
			                  <td>${pg.cityDeparture }</td> 
			                  <td>${pg.name }</td>
			                  <td>${pg.flag }</td>
			                  <td>
			                  	<c:if test="${pg.groupSetting!=null and pg.groupSetting==0 }">
			                  	<a class="mr-10 blue" href="supplier_list.htm?groupId=${pg.id }&productId=${productId}">客户列表</a>
			                  	</c:if>
			                  	<a class="mr-10 blue" href="price_list.htm?groupId=${pg.id }&productId=${productId}">价格表</a>
			                  	<a onclick='editPgroup("${pg.id}","${pg.name }","${pg.cityDeparture }","${pg.groupSetting }")' class="mr-10 blue" href="#">修改</a>
			                  	<a onclick="delPgroup(${pg.id})" class="def" href="#">删除</a>
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
    <!-- 弹出价格组添加弹出层        开始 -->
<div id="addPModal" style="display: none">
	<form class="definewidth m20" id="addPriceGroup">
		<dl class="p_paragraph_content">
			
			<dd>
				<div class="dd_left">价格组名称:</div>
				<div class="dd_right">
					<input class="IptText200" type="text" name="name" id="newName" />
					<input type="hidden" name="productId"  value="${productId }">
				<!-- 	<input type="hidden" id="id" name="id"> -->
				</div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">出发地:</div>
				<div class="dd_right">
					<input class="IptText200" type="text" name="cityDeparture" />
				</div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">统一定价:</div>
				<div class="dd_right">
					<input type="checkbox" name="groupSetting" value="0" onclick="this.value=(this.value==0) ? 1:0" />是
				</div>
				
			</dd>
		</dl>
		
	</form>
</div>


<div id="editPModal" style="display: none">
	<form class="definewidth m20" id="editPriceGroup">
		<dl class="p_paragraph_content">
			
			<dd>
				<div class="dd_left">价格组名称:</div>
				<div class="dd_right">
					<input class="IptText200" type="text" id="name" name="name" />
					<input type="hidden" name="productId"  value="${productId }">
					<input type="hidden" id="id" name="id">
				</div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">出发地:</div>
				<div class="dd_right">
					<input class="IptText200" type="text" id="cityDeparture" name="cityDeparture" />
				</div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">统一定价:</div>
				<div class="dd_right">
					<input type="checkbox" name="groupSetting" id="groupSetting" onclick="this.value=(this.value==0) ? 1:0" />是
				</div>
				
			</dd>
		</dl>
		
	</form>
</div>
<!-- end -->
  
</body>
<script type="text/javascript">
$(document).ready(function(){

	/*提交**/
	$("#addPriceGroup").validate(
			{
				rules:{
					'name' : {
						required : true,
						remote:{//验证用户名是否存在
				               type:"POST",
				               url:"valideteEmpName.do",//servlet
				               data:{
				                 name:function(){return $("#newName").val();},
				                /*  id:function(){return $("#id").val();}, */
				                 productId:'${productId }'
				                 }}
					},
					
					'cityDeparture' : {
						required : true
					}
				},
				messages: {name:{remote:jQuery.format("此价格组已存在！")}},
				errorPlacement : function(error, element) { // 指定错误信息位置

					if (element.is(':radio') || element.is(':checkbox')
							|| element.is(':input')) { // 如果是radio或checkbox
						var eid = element.attr('name'); // 获取元素的name属性
						error.appendTo(element.parent()); // 将错误信息添加当前元素的父结点后面
					} else {
						error.insertAfter(element);
					}
				},
				submitHandler : function(form) {

					var options = {
						url : "save.do",
						type : "post",
						dataType : "json",
						success : function(data) {
							if (data.success) {
								$.success('操作成功',function(){
									
									location.href = "../price/list.htm?productId=${productId }";
								});
								 
							} else {
								
								layer.alert(data.msg, {
									icon : 5
								});

							}
						},
						error : function(XMLHttpRequest, textStatus,
								errorThrown) {
							layer.alert('服务忙，请稍后再试', {
								icon : 5
							});
						}
					};
					$(form).ajaxSubmit(options);
				},
				invalidHandler : function(form, validator) { // 不通过回调
					return false;
				}
			});
	
	
	$("#editPriceGroup").validate(
			{
				rules:{
					'name' : {
						required : true,
						remote:{//验证用户名是否存在
				               type:"POST",
				               url:"valideteEmpName.do",//servlet
				               data:{
				                 name:function(){return $("#name").val();},
				                id:function(){return $("#id").val();},
				                 productId:'${productId }'
				                 }}
					},
					
					'cityDeparture' : {
						required : true
					}
				},
				messages: {name:{remote:jQuery.format("此价格组已存在！")}},
				errorPlacement : function(error, element) { // 指定错误信息位置

					if (element.is(':radio') || element.is(':checkbox')
							|| element.is(':input')) { // 如果是radio或checkbox
						var eid = element.attr('name'); // 获取元素的name属性
						error.appendTo(element.parent()); // 将错误信息添加当前元素的父结点后面
					} else {
						error.insertAfter(element);
					}
				},
				submitHandler : function(form) {

					var options = {
						url : "save.do",
						type : "post",
						dataType : "json",
						success : function(data) {
							if (data.success) {
								$.success('操作成功',function(){
									
									location.href = "../price/list.htm?productId=${productId }";
								});
								 
							} else {
								
								layer.alert(data.msg, {
									icon : 5
								});

							}
						},
						error : function(XMLHttpRequest, textStatus,
								errorThrown) {
							layer.alert('服务忙，请稍后再试', {
								icon : 5
							});
						}
					};
					$(form).ajaxSubmit(options);
				},
				invalidHandler : function(form, validator) { // 不通过回调
					return false;
				}
			});
});
//弹出一个页面层
$('#addPgroup').on('click', function(){
	$("#name").val("");
	$("#cityDeparture").val("");
    layer.open({
        type: 1,
        title :'新增价格组',
        area: [ '420px', '250px'],
        shadeClose: false, //点击遮罩关闭
        closeBtn:false,
        content: $('#addPModal'),
        btn: ['确定', '取消'],
        yes: function(index){
        	$("#addPriceGroup").submit();
			//一般设定yes回调，必须进行手工关闭
	       /*  layer.close(index);  */
	    },cancel: function(index){
	    	layer.close(index);
	    	
	    }
    });
});

		function editPgroup(id,name,cityDeparture,groupSetting){
			$("#id").val(id);
			$("#name").val(name);
			$("#cityDeparture").val(cityDeparture);
			if(groupSetting && groupSetting==1){
				$("#groupSetting").val(1);
				$("#groupSetting").attr("checked","checked");
			}else{
				$("#groupSetting").val(0);				
			}
		    layer.open({
		        type: 1,
		        title :'新增价格组',
				area: [ '420px', '250px'],
		      	shadeClose: true, //点击遮罩关闭 
		        content: $('#editPModal'),
		        btn: ['确定', '取消'],
		        yes: function(index){
		        	$("#editPriceGroup").submit();
					//一般设定yes回调，必须进行手工关闭
			       /*  layer.close(index);  */
			    },cancel: function(index){
			    	layer.close(index);
			    }
	    });
	}

	function delPgroup(id){
		$.confirm("确认删除吗？",function(){
			  $.post("save.do",{state:-1,id:id},function(data){
			   		if(data.success){
			   			$.info('删除成功！');
			   			$("#"+id).remove();
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
