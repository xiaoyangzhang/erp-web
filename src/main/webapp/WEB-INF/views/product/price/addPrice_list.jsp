<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <title>新增产品_价格设置</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <%@ include file="../../../include/top.jsp" %>
    <link href="<%=ctx %>/assets/css/product/newgroup.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="<%=ctx %>/assets/js/web-js/kalendae/kalendae.css"/>
    <%-- <script type="text/javascript" src="<%=ctx %>/assets/js/web-js/product/product_price.js"></script> --%>
    <script src="<%=ctx %>/assets/js/web-js/kalendae/kalendae.standalone.js" type="text/javascript" ></script>
    
</head>
<body>
  <div class="p_container" >
	   <%-- <ul class="w_tab">	    	
	    	<li><a href="../price/list.htm?productId=${productId }" class="selected">价格设置</a></li>
	    	<li class="clear"></li>
	    </ul> --%>
   
           <div class="p_container_sub" id="tab1">
	    	<p class="p_paragraph_title"><b>新增编辑团期</b></p>
            <dl class="p_paragraph_content">
	    		<dd>
	    			<div class="dd_right" style="width:1200px;">
                     <table cellspacing="0" cellpadding="0" class="w_table"> 
		             <col width="100%" />
		             <thead>
		             	<tr>
		             		<th class="pl-20" style="text-align: left;">
		             			产品名称：<span class="mr-100 red">${info.brandName }${info.nameCity }</span>
								产品编号：<span class="mr-100 red">${info.code }</span>
								当前状态：<span class="mr-100 red"><c:if test="${info.state eq 1}">待上架</c:if><c:if test="${info.state eq 2}">上架</c:if><c:if test="${info.state eq 3}">下架</c:if></span>
		             		</th>
		             	</tr>
		             </thead>
		             <tbody> 
		               <tr style="background:#FFFFFF ;"> 
		                  <td class="pt-20 pb-20" style="text-align: left; border: 1;">
					        <form id="savePriceList">
								<fieldset class="fl ml-20" style="">
									<legend>选择团期</legend>		
										 <div class="" id="divCalandar"></div>
										 
										 <script type="text/javascript" charset="utf-8">
											
//											new Kalendae(document.body, {
//												months:1,
//												mode:'multiple',
//												selected:[Kalendae.moment().subtract({M:1}), Kalendae.moment().add({M:1})]
//											});
											var getDates;
											var k = new Kalendae("divCalandar", {
														months:1,
														mode:'multiple'
													});
													k.subscribe('change', function (date) {
											       //console.log(date, this.getSelected());
											       getDates = this.getSelected();
											      // alert(getDates);
											      $("#groupDates").val(getDates);
													});
										</script>	
								</fieldset>
								<fieldset class="fc">
									<legend>团期报价</legend>
									<fieldset class="fcl mt-10 ml-20">
										<legend>建议价格</legend>
										<input id="groupDates" type="hidden" name="groupPrice.groupDates">
										<input type="hidden" name="groupPrice.groupId" value="${groupId }">
										<p><span>成人 </span> <input type="text" name="groupPrice.priceSuggestAdult" value="0" /> 元</p>
										<p><span>儿童</span> <input type="text" name="groupPrice.priceSuggestChild" value="0"/> 元</p>
										<p><span>单房差 </span> <input type="text" name="groupPrice.priceSuggestRoomSpread" value="0"/> 元</p>
									</fieldset>
									<fieldset class="fcl mt-10 ml-30">
										<legend>结算价格</legend>
										<p><span>成人 </span> <input type="text" name="groupPrice.priceSettlementAdult" value="0"/> 元</p>
										<p><span>儿童</span> <input type="text" name="groupPrice.priceSettlementChild" value="0"/> 元</p>
										<p><span>单房差 </span> <input type="text" name="groupPrice.priceSettlementRoomeSpread" value="0"/> 元</p>
									</fieldset>
									<fieldset class="fcl mt-10 ml-20">
										<legend>预算成本</legend>
										<p><span>成人 </span> <input type="text" name="groupPrice.priceCostAdult" value="0"/> 元</p>
										<p><span>儿童</span> <input type="text" name="groupPrice.priceCostChild" value="0"/> 元</p>
										<p><span>单房差 </span> <input type="text" name="groupPrice.priceCostRoomSpread" value="0"/> 元</p>
									</fieldset>
									<div class="fcl mt-10 ml-10">
										<p>报名截止提前： <input type="text" name="groupPrice.daysRegisterFinish" id="daysRegisterFinish" value="0"/> 天</p>
									</div>
									<div class="clear"></div>
								</fieldset>
								<%-- <fieldset class="fr">
									<legend>库存设置</legend>
									<p>计划收客人数: <input type="text" name="groupPrice.stockCount" id="groupPricestockCount" /> 人</p>
									<c:if test="${groupSetting==0 }">
									<p>名额分配: <a id="addStockal" href="#" class="blue">设置查看</a></p>
									</c:if>
									
								</fieldset> --%>
								
								<div class="clear"></div>
								<div style="margin-bottom: 10px;" align="center">
							           <button  type="submit" class="button button-primary button-small">保存</button>
							            <a href="javascript:history.go(-1);" class="button button-primary button-small">返回</a>
						            </div>
							</form>
		                  </td>
		               </tr>
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
<!-- end -->
  <!--名额分配style="display: none"  -->
  <div id="stockalDiv" style="display: none">
	<table class="w_table">
		<%-- <colgroup>
			<col width="8%">
			<col width="30%">
			<col width="40%">
			<col width="12%">
			<col width="12%">
	    </colgroup> --%>
	   
	<thead>
		<tr>	
			<th>序号<i class="w_table_split"></i></th>
			<th>类别<i class="w_table_split"></i></th>					
			<th>名称<i class="w_table_split"></i></th>					
			<th>区域<i class="w_table_split"></i></th>
			<th>人数<i class="w_table_split"></i></th>					
		</tr>
	</thead>
	
		 <c:forEach items="${suppliers}" var="supplier"
			varStatus="status"> 
			<tr>
				<td>${status.count }</td>
				<td>组团社</td>					
				<td>${supplier.supplierName }<input type="hidden" id="supplierId" name="priceStockallocate[${status.index}].supplierId" value="${supplier.supplierId }"> </td>					
				<td>${supplier.province}-${supplier.city }</td>
				<td><input type="text" id="stockNum" name="priceStockallocate[${status.index}].stockNum" ></td>						
			</tr>
		 </c:forEach>
	 
</table>

	  			
  </div>
 <!-- end --> 

</body>
<script type="text/javascript">

//弹出一个页面层
$('#addStockal').on('click', function(){
	 $("#savePriceList #stockalDiv").remove();
	var num = 0;
    layer.open({
        type: 1,
        title :'库存名额分配',
        area: [ '50%', '45%'],
        shadeClose: true, //点击遮罩关闭
        content: $('#stockalDiv'),
        btn: ['确定', '取消'],
        yes: function(index){
        
       	 $("input[id=stockNum]").each(function(index) {//遍历
                   num=num + parseInt(this.value);
             });
       	
       	 var groupPricestockCount = $("#groupPricestockCount").val();
       		if(num>groupPricestockCount){
       			num = 0;
       			$.warn("请合理分配人数");
       		}else{
       			$("#savePriceList").append($("#stockalDiv").clone());
       			$("#stockalDiv").hide();
       			layer.close(index);
       		}
			//一般设定yes回调，必须进行手工关闭
	         
	    },cancel: function(index){
	    	layer.close(index);
	    }
    });
});
$(document).ready(function(){
	/*提交**/
	$("#savePriceList").validate(
			{
				rules:{
					
				},
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
					var dateValue = $('#groupDates').val();
					if(!dateValue){
						$.warn('至少选择一个团期');
						return false;
					}

					var options = {
						url : "priceListsave.do",
						type : "post",
						dataType : "json",
						success : function(data) {

							if (data.success) {
								$.success('操作成功',function(){
									window.location.href="price_list.htm?groupId=${groupId}&productId=${productId}";
								});
								
							} else {
								//alert(data.msg);
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
</script>
</html>
