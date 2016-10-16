<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
	<link href="<%=staticPath %>/assets/css/product/product_price.css" rel="stylesheet" />
    
    <style type="text/css">
    	.td-time{margin: 5px 0; white-space: nowrap;}
    	.pri{margin: 5px 0;}
    </style>
</head>
<body>
    <div class="p_container" >
	    <div class="p_container_sub" id="tab1">
	    	<p class="mt-20 ml-10"><b>【${brandName}】${productName }</b></p>
	    	<p class="p_paragraph_title"><b>${supplierName }</b></p>
	    	<form action="" method="post" id="priceGroupForm">
	    	<input type="hidden" name="groupSupplierId" id="groupSupplierId" value="${groupSupplierId }" />
            <dl class="p_paragraph_content">
	            <div class="pl-10 pr-10">
		            <table cellspacing="0" cellpadding="0" class="w_table" id="priceTable"> 
			            <col width="5%" /><col width="20%" /><col width="25%" />
			            <col width="10%" /><col width="10%" /><col width="10%" /><col width="10%" /><col width="50%" />
			            <thead>
			            	<tr>
			            		<th><input type="checkbox" name="" id="checkAll" value="" />全选</th>
			            		<th>价格组</th>
			            		<th>日期段</th>
			            		<th>成人结算价</th>
			            		<th>儿童结算价</th>
			            		<th>成人成本价</th>
			            		<th>儿童成本价</th>
			            		<th>操作</th>
			            	</tr>
			            </thead>
			            <tbody> 
			            <c:forEach items="${productGroups }" var="pg" varStatus="st">
			                <tr> 
			                  <td><input type="checkbox" name="subbox" priceId="${pg.id }" /></td> 
			                  <td><input type="text" name="name-${st.index }" tag="name"  value="${pg.name }" class="w-300"/>
			                  <input type="hidden" name="id" tag="groupId" value="${pg.id }" />
			                  </td> 
			                  <td class="time">
			                  <c:forEach items="${pg.groupPrices }" var="gp" varStatus="vs">
			                  	<div class="td-time">
			                  		<input type="hidden" name="id"  tag="priceId" value="${gp.id }"  />
				                  	<input type="text" readonly="readonly" name="groupDate-${st.index }-${vs.index }" tag="groupDate"  value="<fmt:formatDate value="${gp.groupDate }" pattern="yyyy-MM-dd" />" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})"/>
				                  	 ~ <input type="text" name="groupDateTo-${st.index }-${vs.index}" tag="groupDateTo" readonly="readonly" value="<fmt:formatDate value="${gp.groupDateTo }" pattern="yyyy-MM-dd" />" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})"/>
				                  	<a href="javascript:void(0);" class="def td-add">增加</a>
				                  	<c:if test="${vs.index!=0 }">
				                  	<a href="javascript:void(0);" class="def td-del">删除</a>	
				                  	</c:if>		                  				                  		
			                  	</div>	
			                  </c:forEach>	                  	
			                  </td> 
			                  <td class="td-pri psa">
			                  <c:forEach items="${pg.groupPrices }" var="gp" varStatus="vs">
			                  	<div class="pri">
				                  	<input type="text" name="priceSettlementAdult-${st.index }-${vs.index }" tag="priceSettlementAdult"  value="<fmt:formatNumber value="${gp.priceSettlementAdult}" pattern="#.##" type="number"/>" class="w-50"/>			                  		
			                  	</div>			                  </c:forEach>
			                  </td> 
			                  <td class="td-pri psc">
			                  <c:forEach items="${pg.groupPrices }" var="gp" varStatus="vs">
			                  	<div class="pri">
				                  	<input type="text" name="priceSettlementChild-${st.index }-${vs.index }" tag="priceSettlementChild"  value="<fmt:formatNumber value="${gp.priceSettlementChild}" pattern="#.##" type="number"/>" class="w-50"/>			                  		
			                  	</div>			                  </c:forEach>
			                  </td>
			                  <td class="td-pri pca">
			                  <c:forEach items="${pg.groupPrices }" var="gp" varStatus="vs">
			                  	<div class="pri">
				                  	<input type="text" name="priceCostAdult-${st.index }-${vs.index }" tag="priceCostAdult"  value="<fmt:formatNumber value="${gp.priceCostAdult}" pattern="#.##" type="number"/>" class="w-50"/>			                  		
			                  	</div>			                  </c:forEach>
			                  </td>
			                  <td class="td-pri pcc">
			                  <c:forEach items="${pg.groupPrices }" var="gp" varStatus="vs">
			                  	<div class="pri">
				                  	<input type="text" name="priceCostChild-${st.index }-${vs.index }" tag="priceCostChild"  value="<fmt:formatNumber value="${gp.priceCostChild}" pattern="#.##" type="number"/>" class="w-50"/>			                  		
			                  	</div>
			                  </c:forEach>
			                  </td>
			                  <td>
			                  	<!-- <a href="javascript:void(0);" class="def" onclick="">复制</a> -->
				                <a href="javascript:void(0);" class="def row-del" onclick="delPGroup(this)"  >删除</a>
			                  </td> 
			                </tr>
			                </c:forEach>
			               	
			            </tbody>
		      		</table>	            	
	            </div>

	            <div class="btn-box mt-20 ml-20">
	            	<a href="javascript:void(0)" class="button button-primary button-small btn-add">新增</a>
	            	<button class="button button-primary button-small" type="submit">保存</button>
	            	<a href="javascript:void(0)" class="button button-primary button-small btn-copy">复制到其他组</a>
	            	<a href="javascript:void(0)" onclick="closeWindow()" class="button button-primary button-small">关闭</a>
							
	            </div>
            </dl>
                     </form>  
        </div>   	       
    </div>
    <script type="text/html" id="trHtml">
        <tr> 
          <td><input type="checkbox" name="subbox"  /></td> 
          <td><input type="text" name="name-{0}" tag="name"  class="w-300"/>
				<input type="hidden" name="id" tag="groupId" value="${pg.id }" />
			</td> 
          <td class="time">
          	<div class="td-time">
			<input type="hidden" name="id"  tag="priceId" value="${gp.id }"  />
              	<input type="text" name="groupDate-{0}-{1}" tag="groupDate"  readonly="readonly"  class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})"/> ~ <input type="text" readonly="readonly" name="groupDateTo-{0}-{1}" tag="groupDateTo" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})"/>
              	<a href="javascript:;" class="def td-add">增加</a>
					                  				                  		
          	</div>
          </td> 
          <td class="td-pri psa">
          	<div class="pri">
              	<input type="text" name="priceSettlementAdult-{0}-{1}" tag="priceSettlementAdult" value='0' class="w-50"/>			                  		
          	</div>
          </td> 
          <td class="td-pri psc">
          	<div class="pri">
              	<input type="text" name="priceSettlementChild-{0}-{1}" tag="priceSettlementChild" value='0' class="w-50"/>			                  		
          	</div>
          </td>
          <td class="td-pri pca">
          	<div class="pri">
              	<input type="text" name="priceCostAdult-{0}-{1}" tag="priceCostAdult" value='0' class="w-50"/>			                  		
          	</div>
          </td>
          <td class="td-pri pcc">
          	<div class="pri">
              	<input type="text" name="priceCostChild-{0}-{1}" tag="priceCostChild" value='0'  class="w-50"/>			                  		
          	</div>
          </td>
          <td>			
			<a href="javascript:void(0);" class="def row-del" onclick="delPGroup(this)" >删除</a>
		</td> 
        </tr> 
    </script>
    <script type="text/javascript" src="<%=staticPath %>/assets/js/json2.js"></script>
    
    <script type="text/javascript">
    $(function(){   
    	$.validator.setDefaults({
			submitHandler : function(form) {
				var priceGroupArr=getPriceGroups();
				/* if(priceGroupArr.length==0){
					$.info("请先添加价格组");
					return false;	
				} */				
				YM.post('savePriceGroup.do',{productGroups:JSON.stringify(priceGroupArr),groupSupplierId:$("#groupSupplierId").val()},function(){
					$.success('保存成功',function(){
						refreshWindow("编辑价格组","<%=path%>/product/price/addPriceGroup.htm?id="+${groupSupplierId});
					});
				},function(){
					$.error("操作失败");
				});
				return false;
			}
		});
		
		$("#priceGroupForm").validate({			
			errorPlacement: function(error, element) {
				error.insertAfter(element);
			}			
		});		
		
		jQuery.validator.addMethod("isFloat", function(value,element) {
			return this.optional(element) || /^(-?\d+)(\.\d+)?$/.test(value);
		}, "只能输入数字!");
		
		var addValidateRule = function(){
			/* $("#priceTable>tbody>tr").each(function(){
				var groupNameInput = $(this).find("input[tag='name']");
				groupNameInput.rules("remove");
				groupNameInput.rules("add",{required:true,messages: { required: "必填"}});
				
				$(this).find("td.time").find(".td-time").each(function(){
					$(this).find("input[tag='groupDate']").rules("remove");
					$(this).rules("add",{required:true,messages: { required: "必填"}});
				});	
				psaObj=$(this).find("td.psa").find(".pri");
				 pscObj=$(this).find("td.psc").find(".pri");
				 pcaObj=$(this).find("td.pca").find(".pri");
				pccObj=$(this).find("td.pcc").find(".pri");
			}) */
			$("input[tag='name']").each(function(){
				$(this).rules("remove");
				$(this).rules("add",{required:true,messages: { required: "*"}});
			});
			$("input[tag='groupDate']").each(function(){
				$(this).rules("remove");
				$(this).rules("add",{required:true,messages: { required: "*"}});
			});
			$("input[tag='groupDateTo']").each(function(){
				$(this).rules("remove");
				$(this).rules("add",{required:true,messages: { required: "*"}});
			});
			$("input[tag='priceSettlementAdult']").each(function(){
				$(this).rules("remove");
				$(this).rules("add",{required:true,isFloat:true,messages: { required: "*",isFloat:'数字'}});
			});
			$("input[tag='priceSettlementChild']").each(function(){
				$(this).rules("remove");
				$(this).rules("add",{required:true,isFloat:true,messages: { required: "*",isFloat:'数字'}});
			});
			$("input[tag='priceCostAdult']").each(function(){
				$(this).rules("remove");
				$(this).rules("add",{required:true,isFloat:true,messages: { required: "*",isFloat:'数字'}});
			});
			$("input[tag='priceCostChild']").each(function(){
				$(this).rules("remove");
				$(this).rules("add",{required:true,isFloat:true,messages: { required: "*",isFloat:'数字'}});
			});
		}
    	
    	var oindex=1000;
    	var pindex=10000;//产品
   		//全选按钮
		$("#checkAll").click(function  () {
			$("input[name='subbox']").attr("checked",this.checked);
			var $subbox=$("input[name='subbox']");
			$subbox.click(function  () {
				$("#checkAll").attr("checked",$subbox.length==$("input[name='subbox']:checked").length?true:false);
			})
		})
		$(".btn-add").click(function () {
			$(".w_table tbody").append($.format($("#trHtml").html(),oindex++,pindex++));
			addValidateRule();
		})
		$(".td-add").live("click",function () {
			//var index=$(this).closest("td").index();
			$(this).closest("td").append("<div class='td-time'><input type='text' name='groupDate-"+oindex+"-"+pindex+"' tag='groupDate' value='' class='w-100 Wdate' onClick=\"WdatePicker({dateFmt:'yyyy-MM-dd'})\"/> ~ <input type='text' name='groupDateTo-"+oindex+"-"+pindex+"' tag='groupDateTo' value='' class='w-100 Wdate' onClick=\"WdatePicker({dateFmt:'yyyy-MM-dd'})\"/> <a href='javascript:;' class='def td-add'>增加</a> <a href='javascript:;' class='def td-del'>删除</a></div>")
			
			$(this).closest("td").siblings(".psa").append("<div class='pri'><input type='text' name='priceSettlementAdult-"+oindex+"-"+pindex+"' tag='priceSettlementAdult' value='0' class='w-50'/></div>");
			$(this).closest("td").siblings(".psc").append("<div class='pri'><input type='text' name='priceSettlementChild-"+oindex+"-"+pindex+"' tag='priceSettlementChild' value='0' class='w-50'/></div>");
			$(this).closest("td").siblings(".pca").append("<div class='pri'><input type='text' name='priceCostAdult-"+oindex+"-"+pindex+"' tag='priceCostAdult' value='0' class='w-50'/></div>") ;
			$(this).closest("td").siblings(".pcc").append("<div class='pri'><input type='text' name='priceCostChild-"+oindex+"-"+pindex+"' tag='priceCostChild' value='0' class='w-50'/></div>");
			pindex++;
			addValidateRule();
		});
		$(".td-del").live("click",function () {
			var index=$(this).closest(".td-time").index();
			$(this).closest("td").siblings(".td-pri").each(function  () {
				$(this).find(".pri").eq(index).remove();
			});
			$(this).closest(".td-time").remove();
		})
		
		function getPriceGroups(){
			var priceGroupArr=[];
			var dateObj;
			var pscObj;
			var psaObj;
			var pcaObj;
			var pccObj;
			 $("#priceTable tbody tr").each(function(){
				var priceGroup={};
				priceGroup.id=$(this).find("input[tag='groupId']").val();
				priceGroup.groupSupplierId=$("#groupSupplierId").val();
				priceGroup.name=$(this).find("input[tag='name']").val();
				priceGroup.groupPrices=[];
				//获取每一行中从第二列开始的每一列中的对象
				dateObj=$(this).find("td.time").find(".td-time");
				 psaObj=$(this).find("td.psa").find(".pri");
				 pscObj=$(this).find("td.psc").find(".pri");
				 pcaObj=$(this).find("td.pca").find(".pri");
				pccObj=$(this).find("td.pcc").find(".pri");
				
				for(var i=0;i<dateObj.length;i++){
					priceGroup.groupPrices.push({id:dateObj.find("input[tag='priceId']").eq(i).val(),
						groupDate:dateObj.find("input[tag='groupDate']").eq(i).val(),
						groupDateTo:dateObj.find("input[tag='groupDateTo']").eq(i).val(),
						priceSettlementAdult:psaObj.find("input[tag='priceSettlementAdult']").eq(i).val(),
						priceSettlementChild:pscObj.find("input[tag='priceSettlementChild']").eq(i).val(),
						priceCostAdult:pcaObj.find("input[tag='priceCostAdult']").eq(i).val(),
						priceCostChild:pccObj.find("input[tag='priceCostChild']").eq(i).val()
					})
				}
				priceGroupArr.push(priceGroup);
			}); 
			return priceGroupArr;
		}
		
		addValidateRule();
		
		$(".btn-copy").click(function(){
			var groupArr = new Array();
			var nameArr = new Array();
			var cnt = 0;
			$("input[type='checkbox'][name='subbox']:checked").each(function(){
				if($(this).attr("priceId")){
					groupArr.push($(this).attr("priceId"));
					nameArr.push($(this).closest("tr").find("input[tag='name']").val());					
				}
				cnt++;
			})
			if(groupArr.length == 0){
				$.warn("请选择要复制的价格组");
				return;
			}
			if(groupArr.length != cnt){
				$.warn("选中的记录存在没有保存的，请先保存！");
				return;
			}
		
    		var win;
    		layer.open({ 
    			type : 2,
    			title : '选择组团社',
    			closeBtn : false,
    			area : [ '800px', '520px' ],
    			shadeClose : false,
    			content : '<%=ctx%>/component/productSupplierList.htm?productId=${productId}&outSupplierId=${supplierId}&single=0',
    			btn: ['确定', '取消'],
    			success:function(layero, index){
    				win = window[layero.find('iframe')[0]['name']];
    			},
    			yes: function(index){
    				//manArr返回的是联系人对象的数组
    				var supplierArr = win.getChkedSupplier();    				
    				if(supplierArr.length == 0){
    					$.warn("请选择组团社");
    					return false;
    				}
    				var groupSupplierIdArr = new Array();
    				for(var i=0,len=supplierArr.length;i<len;i++){
    					groupSupplierIdArr.push(supplierArr[i].psid);
    				}
					YM.post("copyGroups.do",{groupIds:JSON.stringify(groupArr),destGroupSupplierIds:JSON.stringify(groupSupplierIdArr)},function(){
						$.success("批量复制成功");						
					})			
    				
    				//一般设定yes回调，必须进行手工关闭
    		        layer.close(index); 
    		    },cancel: function(index){
    		    	layer.close(index);
    		    }
    		});	    
		})	
		
    })	
    
    function delPGroup(obj){
		obj.closest("tr").remove();
	}
    </script>

</body>
</html>
