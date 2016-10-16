<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>新增订单</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<%@ include file="../../../../include/top.jsp"%>
<link rel="stylesheet" type="text/css" href="<%=staticPath %>/assets/css/operate/operate.css"/>
<style type="text/css">
	.dn{display:none;}
	.textarea-w200-h50{height:50px;width:80%;margin-top:4px;}
	.input-w80{width:70%;}
	.fontBold{font-weight:bold;}
	.select-w80{width:80%;}
</style>
</head>
<body>
	<div class="p_container">
		<div class="p_container_sub" id="tab1">
			<div id="groupDetail"></div>
			<form id="bookingForm" action="" method="post">
				<input type="hidden" name="groupId" id="groupId" value="${groupId }" />
				<input type="hidden" name="bookingId" id="bookingId" value="${bookingId }" />
				<input type="hidden" name="stateBooking" id="stateBooking" value="${supplier.stateBooking }" />
				<input type="hidden" name="stateFinance" id="stateFinance" value="${supplier.stateFinance }" />
				<input type="hidden" name="flag" id="flag" value="${flag }" />
				
				<input type="hidden" name="supplierType" id="supplierType"
					value="${supplierType }" />
				<p class="p_paragraph_title">
					<b>高尔夫</b>
				</p>
				<dl class="p_paragraph_content">
					<dd>
						<div class="dd_left">
							<i class="red">* </i>供应商名称：
						</div>
						<div class="dd_right">
							<input type="text" name="supplierName" id="supplierName"
								value="${supplier.supplierName }" class="IptText300" />
							<input type="hidden" name="supplierId" id="supplierId"
								value="${supplier.supplierId }" /> <input type="button"
								value="选择" class="button button-primary button-small" onclick="selectGolf()" id="golf" />
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">联系方式：</div>
						<div class="dd_right">
							<p class="pb-5">
							<p class="pb-5">
								<input type="text" id="contact" placeholder="联系人" name="contact"
									class="IptText60" value="${supplier.contact }" >
								<input type="text" id="contactTel" placeholder="电话"
									name="contactTel" class="IptText60"
									value="${supplier.contactTel }" > <input
									type="text" id="contactMobile" name="contactMoblie"
									placeholder="手机" class="IptText60"
									value="${supplier.contactMobile }" > <input
									type="text" id="contactFax" name="contactFax" placeholder="传真"
									class="IptText60" value="${supplier.contactFax }" >
								<input type="button" value="选择" class="button button-primary button-small" onclick="selectContact()" id="contact1"/>
							</p>
							</p>
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">结算方式：</div>
						<div class="dd_right">
							<select name="cashType" id="cashType">
								
								<c:choose>
									
								<c:when test="${empty supplier.cashType }">
								<c:forEach items="${cashTypes }" var="type">
									<option value="${type.value }">${type.value }</option>
								</c:forEach>
								</c:when>
								<c:otherwise >
									<c:forEach items="${cashTypes }" var="type">
										<option <c:if test="${supplier.cashType eq type.value }">selected</c:if>  >${type.value }</option>
									</c:forEach>
								</c:otherwise>
								</c:choose>
							</select>
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
	    				<div class="dd_left">导游：</div> 
		    			<div class="dd_right">
		    				<c:set var="disabled" value="" />
							<c:if test="${supplier.payStatus eq 1 }">
								<c:set var="disabled" value="disabled='disabled'" />
							</c:if>
							<select id="bookingGuideId" style="width:93px;" ${disabled } >
								<option value=""></option>
								<c:forEach items="${bookingGuides}" var="booking">
									<option value="${booking.id}"
										<c:if test="${booking.id eq supplier.bookingId }">selected="selected"</c:if> 
									>${booking.guideName}</option>
								</c:forEach>
							</select>
		    			</div>
						<div class="clear"></div>
		    		</dd> 
		    		<dd>
		    			<div class="dd_left">报账金额：</div> 
		    			<div class="dd_right">
		    				<input id="financeTotal" value="<fmt:formatNumber value="${supplier.financeTotal}" pattern="#.##"/>" 
							${disabled } type="text" style="width:85px;"/>
		    			</div>
						<div class="clear"></div>
		    		</dd>
					<dd>
						<div class="dd_left">备注：</div>
						<div class="dd_right">
							<textarea rows="5" cols="30" id="remark" name="remark"
								value="${supplier.remark }">${supplier.remark }</textarea>
						</div>
						<div class="clear"></div>
					</dd>

				</dl>
				<p class="p_paragraph_title">
					<b>项目详情</b>
				</p>
				<dl class="p_paragraph_content" style="margin-left: 20px">
					<dd>

						<div class="dd_right" style="width: 80%">
							<table cellspacing="0" cellpadding="0" class="w_table"
								id="priceTable">
								<col width="20%" />
								<col width="20%" />
								<col width="10%" />
								<col width="10%" />
								<col width="10%" />
								<col width="10%" />
								<col width="20%" />
								
								<thead>
									<tr>
										<th>项目<i class="w_table_split"></i></th>
										<th>日期<i class="w_table_split"></i></th>
										<th>数量<i class="w_table_split"></i></th>
										<th>单价<i class="w_table_split"></i></th>
										<th>免去数<i class="w_table_split"></i></th>
										<th>金额<i class="w_table_split"></i></th>
										<!-- <th>操作<i class="w_table_split"></i></th> -->
										<th><a href="javascript:void(0)" id="golfBtn"
											class="button button-primary button-small"  >添加</a></th>

									</tr>
								</thead>
								<tbody id="golfTblTr">
									<c:if test="${! empty bookingDetailList  }">
										<c:forEach items="${bookingDetailList }" var="detail">
											<tr>
											<td><input type="hidden" name="detailId" value="${detail.id }"/>
													<select id="type1Id" name="type1Id" class="select-w80"> 
														<c:forEach items="${golfTypes}" var="t1" varStatus="vs">
															<option value="${t1.id }" <c:if test="${t1.id==detail.type1Id }">selected</c:if> >${t1.value }</option>
														</c:forEach>
													</select></td>
												
												<td><input type="text" class='input-w80' name="itemDate"  value="<fmt:formatDate value='${detail.itemDate}' pattern='yyyy-MM-dd' />"
																			 /></td>											
											<td><input class='input-w80' type="text" name="itemNum" id="itemNum" value="<fmt:formatNumber value="${detail.itemNum}" pattern="#.##" type="number"/>" /></td>
												<td><input type="text"  name="itemPrice" id="itemPrice" value="<fmt:formatNumber value="${detail.itemPrice}" pattern="#.##" type="number"/>" class="input-w80" /></td>
												<td><input type="text" id="itemNumMinus" name="itemNumMinus" value="<fmt:formatNumber value="${detail.itemNumMinus }" pattern="#.##" type="number"/>" class="input-w80" /></td>
												<td><input id="itemTotal" type="text" name="itemTotal" value="<fmt:formatNumber value="${detail.itemTotal }" pattern="#.##" type="number"/>" class="input-w80" readonly="readonly" /></td>
												<td>
												<c:if test="${empty flag }">
												<a href="javascript:void(0)" name="del">删除</a>
													</c:if></td>
												
											</tr>
											<c:set var="sum_price" value="${sum_price+detail.itemTotal }" />
										</c:forEach>
									</c:if>
								</tbody>
								<tfoot>
									<tr><td colspan="5" style="text-align: right;" class="fontBold">合计（￥）：</td>
					            	<td id="sumPrice"><fmt:formatNumber value="${sum_price }" pattern="#.##" type="number"/></td>
					            	<td></td>
				            	</tr>
								</tfoot>
							</table>
						</div>
						<div class="clear"></div>
					</dd>
				</dl>
				<div class="Footer">
					<dl class="p_paragraph_content">
						<dd>
							<div class="dd_left"></div>
							<div class="dd_right">
							<c:if test="${optMap['EDIT'] }">
									<button type="submit"
										class="button button-primary button-small" id="btnSave" >保存</button>
								</c:if><a href="javascript:void(0)" onclick="closeWindow()" class="button button-primary button-small">关闭</a>
							</div>

						</dd>
					</dl>
				</div>
			</form>
			
		</div>
	</div>



	<div id="addGolfItem" style="display: none;">
		<div class="p_container">
			<div class="p_container_sub">
				<form action="" id="detailForm">
					<dl class="p_paragraph_content" style="margin-top: 20px">
						<dd>
							<!-- <input type="hidden" id="bookingId" name="bookingId" value="" /> -->
							<div class="dd_left">高尔夫:</div>
							<!-- <input type="hidden" id="type1Id" name="type1Id" value=""/> -->
							<select id="type1Id" name="type1Id" class="select160"
								style="width: 310px; text-align: right">

								
								<c:forEach items="${golfTypes}" var="t1" varStatus="vs">
									<option value="${t1.id }">${t1.value }</option>
								</c:forEach>
							</select>
						</dd>


						


						<dd>
							<div class="dd_left">日期:</div>
							<input type="text" name="itemDate" id="itemDate" class="Wdate"
								onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
						</dd>


						<dd>
							<div class="dd_left">数量:</div>
							<input type="text" name="itemNum" id="itemNum" value="0"
								class="IptText300" />
						</dd>


						<dd>
							<div class="dd_left">单价:</div>
							<input type="text" name="itemPrice" id="itemPrice" value="0"
								class="IptText300" />
						</dd>


						<dd>
							<div class="dd_left">免去数:</div>
							<input type="text" id="itemNumMinus" name="itemNumMinus" value="0"
								class="IptText300"></input>
						</dd>


						<dd>
							<div class="dd_left">金额:</div>
							<input id="itemTotal" type="text" name="itemTotal" value="0"
								class="IptText300" readonly="readonly"></input>
						</dd>
						<dd>
							<div class="dd_left"></div>
							<div class="dd_right">
								<input type="submit" id="golfSubmit"
									class="button button-primary button-small"
									value="确定" /> <input type="button" id="golfCancel"
									class="button button-primary button-small"
									value="取消" />
							</div>
							<div class="clear"></div>
						</dd>
					</dl>

				</form>
			</div>
		</div>
	</div>
</body>
<script type="text/html" id="golfRow">

<tr>
<td><input type="hidden" name="detailId" value=""/>
			<select id="type1Id" name="type1Id" class="select-w80"> 
				<c:forEach items="${golfTypes}" var="t1" varStatus="vs">
					<option value="${t1.id }"  >${t1.value }</option>
				</c:forEach>
			</select></td>
		
		<td><input type="text" class='input-w80' name="itemDate"  class="Wdate"
								 /></td>											
	<td><input class='input-w80' type="text" name="itemNum" id="itemNum" value="0" /></td>
		<td><input type="text"  name="itemPrice" id="itemPrice" value="0" class="input-w80" /></td>
		<td><input type="text" id="itemNumMinus" name="itemNumMinus" value="0" class="input-w80" /></td>
		<td><input id="itemTotal" type="text" name="itemTotal" value="0" class="input-w80" readonly="readonly" /></td>
		<td>
		<c:if test="${empty flag }">
		<a href="javascript:void(0)" name="del">删除</a>
			</c:if></td>
</tr>

</script>
<script type="text/javascript" src="<%=staticPath %>/assets/js/json2.js"></script>
<script type="text/javascript" src="<%=staticPath %>/assets/js/utils/float-calculate.js"></script>

<script type="text/javascript">

function showAdd(){
	$("#golfTblTr").append($("#golfRow").html());
}
function bindEvent(){
	$("#golfTblTr tr").each(function(){
		//绑定删除事件
		$(this).find("a[name='del']").unbind("click").bind("click",function(){
			var rowindex = $(this).closest("#golfTblTr").find("tr").index($(this).closest("tr")[0]);			
			$(this).closest("tr").remove();
			$("#sumPrice").html(calcSum());
		})			
		
		var price=null;
		
		//绑定行计算
		var itemPriceObj=$(this).find("input[name='itemPrice']");
		var itemNumObj=$(this).find("input[name='itemNum']");
		var itemNumMinusObj=$(this).find("input[name='itemNumMinus']");
		var itemTotalObj=$(this).find("input[name='itemTotal']");
		itemPriceObj.removeAttr("onblur").blur(function(){		
			var itemPrice = itemPriceObj.val();
			if(itemPrice=='' || isNaN(itemPrice)){
				itemPriceObj.val(0);
				itemPrice = 0;
			}
			var itemNum = itemNumObj.val();
			var itemNumMinus =itemNumMinusObj.val();
			var total =(new Number(itemPrice==''?'0':itemPrice)).mul((new Number(itemNum==''?'1':itemNum)).sub(new Number(itemNumMinus==''?'0':itemNumMinus)));
			itemTotalObj.val(isNaN(total)? 0:total);	
			
			$("#sumPrice").html(calcSum());
		})
		itemNumObj.removeAttr("onblur").blur(function(){
			var itemPrice = itemPriceObj.val();
			var itemNum = itemNumObj.val();
			if(itemNum==''||isNaN(itemNum)){
				itemNumObj.val(1);
				itemNum = 1;
			}else{
				if(price!=null && price.derateReach && price.derateReach){
					var minusNum= parseInt((new Number(itemNum)).div(new Number(price.derateReach))) * price.derateReduction;
					itemNumMinusObj.val(minusNum);
				}
			}
			var itemNumMinus =itemNumMinusObj.val();
			var total =(new Number(itemPrice==''?'0':itemPrice)).mul((new Number(itemNum==''?'1':itemNum)).sub(new Number(itemNumMinus==''?'0':itemNumMinus)));
			itemTotalObj.val(isNaN(total)? 0:total);	
			$("#sumPrice").html(calcSum());
		})
		itemNumMinusObj.removeAttr("onblur").blur(function(){
			var itemPrice = itemPriceObj.val();
			var itemNum = itemNumObj.val();
			var itemNumMinus =itemNumMinusObj.val();
			if(itemNumMinus=='' || isNaN(itemNumMinus)){
				itemNumMinusObj.val(0);
				itemNumMinus=0;
			}
			var total =(new Number(itemPrice==''?'0':itemPrice)).mul((new Number(itemNum==''?'1':itemNum)).sub(new Number(itemNumMinus==''?'0':itemNumMinus)));
			itemTotalObj.val(isNaN(total)? 0:total);	
			$("#sumPrice").html(calcSum());
		})	
		//绑定日期控件
		var typeidObj = $(this).find("select[name='type1Id']");
		var itemDateObj=$(this).find("input[name='itemDate']");
		$(this).find("input[name='itemDate']").unbind("click").click(function(){			
			WdatePicker({dateFmt:'yyyy-MM-dd',onpicked:function(){
				var typeid=typeidObj.val();
				var date =itemDateObj.val();
				onPrice(typeid,date,itemPriceObj,itemNumObj,itemNumMinusObj,itemTotalObj);
			}});
		})
		//绑定类别
		$(this).find("select[name='type1Id']").unbind("change").change(function(){
			var typeid=typeidObj.val();
			var date =itemDateObj.val();
			onPrice(typeid,date,itemPriceObj,itemNumObj,itemNumMinusObj,itemTotalObj);
		})
		
		function calcSum(){
			var sum=0;
			//计算总价				
			$("#golfTblTr tr").find("input[name='itemTotal']").each(function(){
				var total= $(this).val()=='' ? 0:$(this).val();
				sum = (new Number(sum)).add(new Number(isNaN(total) ? 0:total));
			})			
			return sum;
		}		
		function onPrice(typeid,date,priceObj,numObj,minusObj,totalObj){
			var supplierId = $("#supplierId").val();
			if(supplierId && typeid && date){
				var data={supplierId:supplierId,type1:typeid,date:date};
				$.ajax({
					type: 'POST',
			        url: 'price.do',
			        dataType: 'json',
			        data:data,
			        success: function(data) {
			        	if(data){
			        		price={};
			        		price.contractPrice = data.contractPrice;
			        		price.derateReach = data.derateReach;
			        		price.derateReduction = data.derateReduction;
			        		priceObj.val(data.contractPrice ? data.contractPrice:priceObj.val());
			        		//协议
			        		if(price.derateReach && price.derateReduction){
				        		var vNum = numObj.val();
				        		var minusNum=parseInt((new Number(vNum)).div(new Number(price.derateReach))) * price.derateReduction;
				        		minusObj.val(minusNum);			        			
			        		}
			        		var itemPrice = priceObj.val();			    			
			    			var itemNum = numObj.val();
			    			var itemNumMinus =minusObj.val();
			    			var total =(new Number(itemPrice==''?'0':itemPrice)).mul((new Number(itemNum==''?'1':itemNum)).sub(new Number(itemNumMinus==''?'0':itemNumMinus)));
			    			itemTotalObj.val(isNaN(total)? 0:total);	
			    			
			    			$("#sumPrice").html(calcSum());
			        		
			        	}else{
			        		price=null;
			        	}	        
			        },
			        error: function(data,msg) {
			            $.error("操作失败"+msg);		            
			        }
				});			
			}
		}
	})
}
var detailArr=new Array();
var layindex=0;
$(function(){
	<c:if test='${! empty bookingDetailList }'>
		<c:forEach items="${bookingDetailList}" var="detail">				
			detailArr.push({id:${detail.id},type1Name:'${detail.type1Name}',type2Name:'${detail.type2Name}',type1Id:'${detail.type1Id}',type2Id:'${detail.type2Id}',bookingId:${detail.bookingId},itemDate:'<fmt:formatDate value="${detail.itemDate}" pattern="yyyy-MM-dd"/>',itemNum:${detail.itemNum},itemPrice:${detail.itemPrice},itemNumMinus:${detail.itemNumMinus},itemTotal:${detail.itemTotal}});				
		</c:forEach>
	</c:if>
	 $("#groupDetail").load("<%=staticPath%>/booking/groupDetail.htm?gid="+$("#groupId").val()+"&stype=11");
	 if($("#flag").val()==1){
		 $("#btnSave").attr("style","display:none");
		 $("#golf").attr("style","display:none");
		 $("#contact1").attr("style","display:none");
		 $("#golfBtn").attr("style","display:none");
		// $("#del").attr("style","display:none");
		 $("#cashType").attr("disabled","disabled");
			$("#remark").attr("disabled","disabled");
	 }
	$("#bookingForm").validate({
		rules : {
			'supplierName' : {
				required : true,
				maxlength:50
			},
			
			'remark' : {
				//required : true
				maxlength:100
			}
		},
		messages : {
			'supplierName' : {
				required : "请选择高尔夫地点"

			},
			
			'remark' : {
				maxlength : "备注信息长度小于100 "

			}
		},
		errorPlacement : function(error, element) { // 指定错误信息位置
			if ( element.is(':checkbox')
					|| element.is(':input')) { // 如果是radio或checkbox
				var eid = element.attr('name'); // 获取元素的name属性
				error.appendTo(element.parent()); // 将错误信息添加当前元素的父结点后面
			} else {
				error.insertAfter(element);
			}
		},
		submitHandler : function(form) {
			var booking={
					id:$("#bookingId").val(),
				groupId:$("#groupId").val(),
				supplierId:$("#supplierId").val(),
				supplierType:$("#supplierType").val(),
				supplierName:$("#supplierName").val(),
				contactTel:$("#contactTel").val(),
				contact:$("#contact").val(),
				contactFax:$("#contactFax").val(),
				contactMobile:$("#contactMobile").val(),
				cashType:$("#cashType  option:selected").text(),
				remark:$("#remark").val(),
				stateBooking:$("#stateBooking").val(),
				stateFinance:$("#stateFinance").val(),
				detailList:[]
			};
			
			//debugger
			$("#golfTblTr tr").each(function(){
				booking.detailList.push({id:$(this).find("input[name='detailId']").val(),type1Id:$(this).find("select[name='type1Id']").val(),
					type1Name:$(this).find("select[name='type1Id']").find("option:selected").text(),
					itemDate:$(this).find("input[name='itemDate']").val(),itemNum:$(this).find("input[name='itemNum']").val(),
					itemPrice:$(this).find("input[name='itemPrice']").val(),itemNumMinus:$(this).find("input[name='itemNumMinus']").val(),
					itemTotal:$(this).find("input[name='itemTotal']").val()});
			});
			
			var financeGuide = "";
			var bookingGuideId = $("#bookingGuideId");
			if(bookingGuideId && !$(bookingGuideId).attr("disabled")){
				financeGuide = '{"bookingId":"'+ bookingGuideId.val() +'", "total":"'+ $("#financeTotal").val() +'"}';
			}
			
			jQuery.ajax({
				url : "../tourGroup/validatorSupplier.htm",
				type : "post",
				async : false,
				data : {
					"supplierId" : $("#supplierId").val(),
					"supplierName":$("#supplierName").val()
				},
				dataType : "json",
				success : function(data) {
					if (data.success) {
						var options={
								type: 'POST',
								cache:false,
						        url: "saveSupplier.do",
						        dataType: 'json',		        
						        data: {bookingJson:JSON.stringify(booking), financeGuideJson:financeGuide},
						        //async:false,
						        success: function(data) {
						            if (data.sucess ) {		
						            	$.success("保存成功",function(){
						            	refreshWindow("修改高尔夫订单","<%=staticPath %>/booking/toAddGolf?groupId="+data['groupId']+"&bookingId="+data['bookingId']+"&stateBooking="+data['stateBooking']);
						            	})
						            }else{
										$.error("操作失败"+data.msg);
									}
						        },
						        error: function(data,msg) {
						            $.error("操作失败"+msg);
						        }
						};
						$(form).ajaxSubmit(options);
					}else{
						$.warn(data.msg);
					}
				},
				error : function(XMLHttpRequest, textStatus, errorThrown) {
					$.error(textStatus);
					window.location = window.location;
				}
			});
			
		},
		invalidHandler : function(form, validator) { // 不通过回调
			return false;
		}
	})

	$("#golfBtn").click(function(){
		var supplierId = $("#supplierId").val().trim() ;
		if(supplierId==""){
			layer.msg("请先选商家 ");
			return;
		}
		showAdd();	
		bindEvent();
	});
	bindEvent();
})
		
	
	
	
	
	
	
	
	
			
	
	
	function selectGolf(){
		layer.openSupplierLayer({
			title : '选择地点',
			content : '<%=ctx%>/component/supplierList.htm?supplierType=11',
			callback: function(arr){
				if(arr.length==0){
					$.warn("请选择地点 ");
					return false;
				}
				
				/*for(var i=0;i<arr.length;i++){
					console.log("id:"+arr[i].id+",name:"+arr[i].name+",type:"+arr[i].type+",province:"+arr[i].province+",city:"+arr[i].city+",area:"+arr[i].area+",town:"+arr[i].town);
				}*/
				$("#supplierName").val(arr[0].name);
				$("#supplierId").val(arr[0].id);
		    }
		});
	}
	
	function selectContact(){
		/**
		 * 先选择供应商，再根据供应商id选择联系人 
		 */
		var win=0;
		var supplierId = $("#supplierId").val().trim() ;
		if(supplierId==""){
			layer.msg("请先选择地点 ");
		}else{
			layer.open({ 
				type : 2,
				title : '选择联系人',
				closeBtn : false,
				area : [ '550px', '450px' ],
				shadeClose : false,
				content : '<%=ctx%>/component/contactMan.htm?supplierId='
						+ supplierId,//参数为供应商id
				btn : [ '确定', '取消' ],
				success : function(layero, index) {
					win = window[layero.find('iframe')[0]['name']];
				},
				yes : function(index) {
					//manArr返回的是联系人对象的数组
					var arr = win.getChkedContact();
					if (arr.length == 0) {
						$.warn("请选择联系人");
						return false;
					}
					$("#contact").val(arr[0].name);
					$("#contactMobile").val(arr[0].mobile);
					$("#contactTel").val(arr[0].tel);
					$("#contactFax").val(arr[0].fax);
					//一般设定yes回调，必须进行手工关闭
					layer.close(index);
				},
				cancel : function(index) {
					layer.close(index);
				}
			});
		}
	}
	function del(obj) {
		delRowEvent(obj);
	}
	function delRowEvent(obj) {
		var rowindex = $(obj).closest("#golfTblTr").find("tr").index(
				$(obj).closest("tr")[0]);
		$(obj).closest("tr").remove();
		detailArr.splice(rowindex, 1);
	}
</script>
<link href="<%=ctx%>/assets/js/web-js/sales/autocomplete/jquery.autocomplete.css" rel="stylesheet" type="text/css" />
    <script src="<%=ctx%>/assets/js/web-js/sales/autocomplete/jquery.autocomplete.js" type="text/javascript"></script>
<script type="text/javascript">
	var supplierType = $("#supplierType").val() ;
    $(function(){
        var param = "";
        JAutocompleteEx("#supplierName", "<%=staticPath %>/tourGroup/getSupplier?supplierType=11", param, "supplierId", customerTicketCallback, 1);
    });
    function customerTicketCallback(event, value) {
        
    } 
</script>

</html>
