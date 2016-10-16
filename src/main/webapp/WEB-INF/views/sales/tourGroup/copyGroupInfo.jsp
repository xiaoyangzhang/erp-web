<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="../../../include/top.jsp"%>
<!-- <script type="text/javascript" -->
<%-- 	src="<%=ctx%>/assets/js/web-js/sales/groupOrder.js"></script> --%>
<style type="text/css">
.Wdate {
	width: 300px;
}
</style>
<script type="text/javascript">
function selectSupplier(){
	layer.openSupplierLayer({
		title : '选择组团社',
		content : getContextPath() + '/component/supplierList.htm?supplierType=1',//参数：操作类型（type:单选(single)、多选(multi)）供应商类型supplierType=1
		callback: function(arr){
			if(arr.length==0){
				$.warn("请选组团社");
				return false;
			}
			$("#supplierName").val(arr[0].name);
			$("#supplierId").val(arr[0].id);
			/**
			 * 每次选择完组团社后将联系人相关部分数据清空
			 */
			$("#contactName").val("");
			$("#contactMobile").val("");
			$("#contactTel").val("");
			$("#contactFax").val("");
			$("#selA").show();
	    }
	});
}
function selectContact(){
	var win=0;
	var supplierId = $("#supplierId").val().trim() ;
	if(supplierId==""){
		$.warn("未选择组团社");
	}else{
		layer.open({ 
			type : 2,
			title : '选择联系人',
			shadeClose : true,
			shade : 0.5,
			//offset : [th,lh],
			area : ['450px', '400px'],
			content : '../component/contactMan.htm?supplierId='+supplierId,//参数为供应商id
			btn: ['确定', '取消'],
			success:function(layero, index){
				win = window[layero.find('iframe')[0]['name']];
			},
			yes: function(index){
				var arr = win.getChkedContact();    				
				if(arr.length==0){
					$.warn("请选择联系人");
					return false;
				}
				$("#contactName").val(arr[0].name);
				$("#contactMobile").val(arr[0].mobile);
				$("#contactTel").val(arr[0].tel);
				$("#contactFax").val(arr[0].fax);
		        layer.close(index); 
		    },cancel: function(index){
		    	layer.close(index);
		    }
		});
	}
}
function selectUser(num){
	var win=0;
	layer.open({
		type : 2,
		title : '选择人员',
		shadeClose : true,
		shade : 0.5,
		area : [ '400px', '470px' ],
		content : '../component/orgUserTree.htm',//单选地址为orgUserTree.htm，多选地址为
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
			//销售计调
			if(num==1){
				$("#saleOperatorId").val(userArr[0].id);
				$("#saleOperatorName").val(userArr[0].name);
			}
			//操作计调
			if(num==2){
				$("#operatorId").val(userArr[0].id);
				$("#operatorName").val(userArr[0].name);
			}
			//一般设定yes回调，必须进行手工关闭
	        layer.close(index); 
	    },cancel: function(index){
	    	layer.close(index);
	    }
	});
}
$(function(){
	$("#copyGroupForm").validate(
			{
				rules : {
					'dateStart' : {
						required : true
					},
					'supplierName' : {
						required : true
					},
					'contactName' : {
						required : true
					},
					'contactTel' : {
						required : true
					},
					'contactMobile' : {
						required : true
					},
					'contactFax' : {
						required : true
					},
					'totalAdult' : {
						required : true,
						digits : true
					},
					'totalChild' : {
						required : true,
						digits : true
					},
					'totalGuide' : {
						required : true,
						digits : true
					}


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
					var options = {
						url : 'copyTourGroup.do',
						type : "post",
						dataType : "json",
						success : function(data) {
							if (data.success) {
								$.success('操作成功',function(){
									refreshWindow('团队管理');
									closeWindow();
								});
								
							} else {
								$.warn(data.msg, {
									icon : 5
								});

							}
						},
						error : function(XMLHttpRequest, textStatus,
								errorThrown) {
							$.warn('服务忙，请稍后再试', {
								icon : 5
							});
						}
					}
					$(form).ajaxSubmit(options);
				},
				invalidHandler : function(form, validator) { // 不通过回调
					return false;
				}

			});
	
})

</script>
</head>
<body>
	<div class="p_container">
		<div class="p_container_sub">
			<form id="copyGroupForm" method="post">
				<input type="hidden" name="orderId" value="${orderId}" />
				<input type="hidden" name="groupId" value="${groupId}" />
				<dl class="p_paragraph_content">
					<p class="p_paragraph_title">
						<b>复制为新团</b>
					</p>
					<dd>
						<div class="dd_left">
							<i class="red">*</i>选择日期:
						</div>
						<input type="text" name="dateStart" class="Wdate"
							onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
					</dd>
					<dd>
						<div class="dd_left">销售计调 :</div>
						<input name="saleOperatorName" id="saleOperatorName"
							value="${groupOrder.saleOperatorName}" placeholder="请选择"
							readonly="readonly" class="IptText300" type="text"> <a
							href="javascript:void(0);" onclick="selectUser(1)">请选择</a> <input
							type="hidden" name="saleOperatorId" id="saleOperatorId"
							value="${groupOrder.saleOperatorId}" />
					</dd>
					<dd>
						<div class="dd_left">操作计调:</div>
						<input name="operatorName" id="operatorName" placeholder="请选择"
							readonly="readonly" value="${groupOrder.operatorName}"
							class="IptText300" type="text"> <a
							href="javascript:void(0);" onclick="selectUser(2)">请选择</a> <input
							type="hidden" name="operatorId" id="operatorId"
							value="${groupOrder.operatorId}">
					</dd>
					<dd>
						<div class="dd_left">
							<i class="red">*</i>组团社名称:
						</div>
						<input type="text" value="${groupOrder.supplierName}"
							name="supplierName" id="supplierName" placeholder="请选择"
							readonly="readonly" class="IptText300" /> <input type="hidden"
							name="supplierId" id="supplierId" /> <a
							href="javascript:void(0);" onclick="selectSupplier()">请选择</a>
					</dd>
					<dd>
						<div class="dd_left">
							<i class="red">* </i>联系人
						</div>

						<input type="text" name="contactName" id="contactName"
							class="IptText100" placeholder="姓名" /> <input type="text"
							name="contactTel" id="contactTel" class="IptText100" placeholder="电话" />
						<input type="text" name="contactMobile" id="contactMobile"
							class="IptText100" placeholder="手机" /> <input type="text"
							name="contactFax" id="contactFax" class="IptText100" placeholder="传真" />
						<a href="javascript:void(0)" onclick="selectContact();">请选择</a>

					</dd>
					<dd>
						<div class="dd_left">
							<i class="red">*</i>团人数:
						</div>
						<input style="width: 92px;" type="text" name="totalAdult"
							placeholder="成人数" value="0" /> <input style="width: 92px;"
							type="text" name="totalChild" placeholder="小孩数" value="0" /> <input
							style="width: 92px;" type="text" name="totalGuide"
							placeholder="全陪数" value="0" /> (成人数~小孩数~全陪数)
					</dd>
				</dl>
				<dl class="p_paragraph_content">
					<p class="p_paragraph_title">
						<b>复制内容</b>
					</p>
					<dd>
						<div class="dd_left">
							<input type="checkbox" name="info" value="1" checked="checked" disabled="disabled" />行程列表
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">
							<input type="checkbox" name="info" value="2" checked="checked" disabled="disabled" />备注信息
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">
							<input type="checkbox" name="info" value="7" checked="checked" disabled="disabled" />导游信息
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">
							<input type="checkbox" name="info" value="3"/>接送信息
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">
							<input type="checkbox" name="info" value="4"/>计调需求
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">
							<input type="checkbox" name="info" value="5"/>价格信息
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">
							<input type="checkbox" name="info" value="6"/>客人名单
						</div>
						<div class="clear"></div>
					</dd>
				</dl>
				<div class="Footer">
					<dl class="p_paragraph_content">
						<dd>
							<div class="dd_left"></div>
							<div class="dd_right">
								<button type="submit" class="button button-primary button-small">确定</button>
								<a href="javascript:void(0)" onclick="closeWindow()" class="button button-primary button-small">取消</a>
							</div>
						</dd>
					</dl>
				</div>
			</form>

		</div>
		</form>
	</div>
	</div>
</body>
</html>