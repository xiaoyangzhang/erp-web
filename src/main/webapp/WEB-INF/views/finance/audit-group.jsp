<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>团收支审核</title>
<%@ include file="../../include/top.jsp"%>
<link href="<%=staticPath%>/assets/css/supplier/supplier.css" rel="stylesheet" />

<link rel="stylesheet" type="text/css" href="<%=staticPath%>/assets/css/finance/finance.css" />
<script type="text/javascript" src="<%=staticPath%>/assets/js/jquery.idTabs.min.js"></script>
<script type="text/javascript">
	function toDetail(supType, feeType) {
		document.location.href = 'auditList.htm?groupId=${group.id}&supType=' + supType + '&feeType=' + feeType;
	}

	function postAudit() {
		YM.post("finAudit.do", {
			groupId : '${group.id}'
		}, function(data) {
			$.success('操作成功');
			location.reload();
		});
	}
	
	function postUnAudit() {
		YM.post("finUnAudit.do", {
			groupId : '${group.id}'
		}, function(data) {
			$.success('操作成功');
			location.reload();
		});
	}
	

	function showOperateLogs(groupId) {
		if(!groupId){
			return;
		}
		
		var data = {};
		data.groupId = groupId;
		$("#operateLogsDiv").load("operateLog.htm", data);
		
		layer.open({
			type : 1,
			title : '操作记录详情',
			closeBtn : false,
			area : [ '700px', '400px' ],
			shadeClose : false,
			content : $("#operateLogsDiv"),
			btn : [ '确定', '取消' ],
			yes : function(index) {

				//一般设定yes回调，必须进行手工关闭
				layer.close(index);
			},
			cancel : function(index) {
				layer.close(index);
			}
		});
	}
	
	$(function(){
		$("#guideCg").change(function(){
			var groupId = $("#groupId").val();
			var bookingId = $(this).children('option:selected').val();
			newWindow('导游报账审核详情', '<%=staticPath%>/bookingGuide/finance.htm?fromfin=1&groupId='+groupId+'&bookingId='+bookingId);
			$('#guideCg option:eq(0)').attr('selected','selected');
		});
	});
</script>
</head>
<body>
	<div class="p_container">
		<div class="p_container_sub">
			<dl class="p_paragraph_content">
				<div class="title_h w-1100 ml-20 mt-20 mb-20">
					<b>审核结算单</b>
				</div>
				<div class="group_con w-1100 pl-20">
					<p class="group_h">
						<b>团信息</b>
					</p>
					<div class="group_msg">
						<dd class="inl-bl w-400">
							<div class="dd_left">团号：</div>
							<div class="dd_right">${group.group_code }</div>
							<div class="clear"></div>
						</dd>
						<dd class="inl-bl w-600">
							<div class="dd_left">计调：</div>
							<div class="dd_right">${group.operator_name }</div>
							<div class="clear"></div>
						</dd>
						<dd class="inl-bl w-400">
							<div class="dd_left">人数：</div>
							<div class="dd_right">
								<c:if test="${not empty group.total_adult}">${group.total_adult}大</c:if>
								<c:if test="${not empty group.total_child}">${group.total_child}
									<c:if test="${group.total_baby == null}"></c:if>
									<c:if test="${group.total_baby != null}"><span style="color: red;">(${group.total_baby})</span></c:if>
								小</c:if>
								<c:if test="${not empty group.total_guide}">${group.total_guide}陪</c:if>
							</div>
							<div class="clear"></div>
						</dd>
						<dd class="inl-bl w-600">
							<div class="dd_left">产品名称：</div>
							<div class="dd_right">【${group.product_brand_name }】 ${group.product_name }</div>
							<div class="clear"></div>
						</dd>
						<dd class="inl-bl w-400">
							<div class="dd_left">状态：</div>
							<div class="dd_right">
								<c:if test="${group.group_state eq 0}">未确认</c:if>
								<c:if test="${group.group_state eq 1}">已确认</c:if>
								<c:if test="${group.group_state eq 2}">作废</c:if>
								<c:if test="${group.group_state eq 3}">已审核</c:if>
								<c:if test="${group.group_state eq 4}">已封存</c:if>
							</div>
							<div class="clear"></div>
						</dd>
						<dd class="inl-bl w-600">
							<div class="dd_left">起始日期：</div>
							<div class="dd_right">${group.date_start }~${group.date_end }</div>
							<div class="clear"></div>
						</dd>
					</div>
				</div>
			</dl>

			<dl class="p_paragraph_content">
				<div class="check_con ml-20">
					<div class="income_box">

						<div class="income_l">

							<p class="p1">
								<a  onclick="newWindow('结算单详情列表','<%=staticPath%>/finance/auditGroupList.htm?groupId=${group.id}')" 
								  	href="javascript:void(0)" style="color:#333333;">收入</a>
							</p>
							<p class="grey"><fmt:formatNumber value="${group.total_income }" pattern="#.##"/>元</p>

						</div>
						<div class="income_c"></div>
						<div class="income_r">

							<ul class="check_d">
								<li class="check_box">
								<c:if test="${order.isAudited }">
									<img class="check_seal" src="<%=staticPath%>/assets/css/finance/img/shen.png" />
								</c:if>
<%--  								<a href="javascript:void(0)" onclick="toDetail('${order.id}','order')"> --%>
 								<a href="javascript:void(0)" onclick="newWindow('审核详情-组团社','<%=staticPath%>/finance/auditList.htm?groupId=${group.id}&supType=${order.id}&feeType=order')" >
										<div class="box_top">
											<div class="bg_group"></div>
											<div class="box_n">
												<p>组团社</p>
												<p class="grey">${order.auditedNum}/${order.count}</p>
											</div>
										</div>
										<p class="box_pri"><fmt:formatNumber value="${order.num }" pattern="#.##"/>元</p>
								</a></li>
								<!-- 
								<li class="check_box">
								<c:if test="${shop.isAudited }">
										<img class="check_seal" src="<%=staticPath%>/assets/css/finance/img/shen.png" />
								</c:if>
								<a href="javascript:void(0)" onclick="newWindow('审核详情-购物','<%=staticPath%>/finance/auditList.htm?groupId=${group.id}&supType=${shop.id}&feeType=shop')" >
										<div class="box_top">
											<div class="bg_shop"></div>
											<div class="box_n">
												<p>购物</p>
												<p class="grey">${shop.auditedNum}/${shop.count}</p>
											</div>
										</div>
										<p class="box_pri"><fmt:formatNumber value="${shop.num }" pattern="#.##"/>元</p>
								</a></li>
								 -->
								<li class="check_box">
								<c:if test="${otherin.isAudited }">
										<img class="check_seal" src="<%=staticPath%>/assets/css/finance/img/shen.png" />
								</c:if>
								<a href="javascript:void(0)" onclick="newWindow('审核详情-其他','<%=staticPath%>/finance/auditList.htm?groupId=${group.id}&supType=${otherin.id}&feeType=otherin')" >
										<div class="box_top">
											<div class="bg_other"></div>
											<div class="box_n">
												<p>其他</p>
												<p class="grey">${otherin.auditedNum}/${otherin.count}</p>
											</div>
										</div>
										<p class="box_pri"><fmt:formatNumber value="${otherin.num }" pattern="#.##"/>元</p>
								</a></li>
							</ul>
						</div>
					</div>
					<div class="income_box">
						<div class="income_l">
							<p class="p1">
								<a onclick="newWindow('结算单详情列表','<%=staticPath%>/finance/auditGroupList.htm?groupId=${group.id}')" 
								  	href="javascript:void(0)" style="color:#333333;">支出</a>
							</p>
							<p class="grey"><fmt:formatNumber value="${group.total_cost }" pattern="#.##"/>元</p>
						</div>
						<div class="income_c"></div>
						<div class="income_r">
							<ul class="check_d">
								<li class="check_box">
								<c:if test="${del.isAudited }">
										<img class="check_seal" src="<%=staticPath%>/assets/css/finance/img/shen.png" />
								</c:if>
								<a href="javascript:void(0)" onclick="newWindow('审核详情-下接社','<%=staticPath%>/finance/auditList.htm?groupId=${group.id}&supType=${del.id}&feeType=del')" >
										<div class="box_top">
											<div class="bg_roompri"></div>
											<div class="box_n">
												<p>地接社</p>
												<p class="grey">${del.auditedNum}/${del.count}</p>
											</div>
										</div>
										<p class="box_pri"><fmt:formatNumber value="${del.num }" pattern="#.##"/>元</p>
								</a></li>
								<c:forEach items="${sup }" var="s">
									<c:if test="${s.id!=121 }">
										<li class="check_box">
											<c:if test="${s.isAudited }">
												<img class="check_seal" src="<%=staticPath%>/assets/css/finance/img/shen.png" />
											</c:if>
											<a href="javascript:void(0)" onclick="newWindow('审核详情-${s.name }','<%=staticPath%>/finance/auditList.htm?groupId=${group.id}&supType=${s.id}&feeType=sup')" >
												<div class="box_top">
													<div class="${s.css }"></div>
													<div class="box_n">
														<p>${s.name }</p>
														<p class="grey">${s.auditedNum}/${s.count}</p>
													</div>
												</div>
												<p class="box_pri"><fmt:formatNumber value="${s.num }" pattern="#.##"/>元</p>
											</a>
										</li>
									</c:if>
								</c:forEach>
								<c:forEach items="${sup }" var="s">
									<c:if test="${s.id==121 }">
										<li class="check_box">
											<c:if test="${s.isAudited }">
												<img class="check_seal" src="<%=staticPath%>/assets/css/finance/img/shen.png" />
											</c:if>
											<a href="javascript:void(0)" onclick="newWindow('审核详情-${s.name }','<%=staticPath%>/finance/auditList.htm?groupId=${group.id}&supType=${s.id}&feeType=sup')" >
												<div class="box_top">
													<div class="${s.css }"></div>
													<div class="box_n">
														<p>${s.name }</p>
														<p class="grey">${s.auditedNum}/${s.count}</p>
													</div>
												</div>
												<p class="box_pri"><fmt:formatNumber value="${s.num }" pattern="#.##"/>元</p>
											</a>
										</li>
									</c:if>
								</c:forEach>
							</ul>
						</div>
					</div>
					<div class="income_box">
						<div class="income_l">
							<p class="p1">利润</p>
							<p class="grey"><fmt:formatNumber value="${group.total_profit }" pattern="#.##"/>元</p>
						</div>
						<div class="income_c"></div>
						<div class="income_r">
							<div class="check_profit">
								<p>单团利润：<fmt:formatNumber value="${group.total_profit }" pattern="#.##"/>元</p>
								<p>人均利润：<fmt:formatNumber value="${group.person_profit }" pattern="#.##"/>元</p>
							</div>
						</div>
					</div>

				</div>
			<input type="hidden" value="${group.id}" id="groupId"/> 
			</dl>
		</div>
		<div style="text-align: center;">
		<button class="button button-primary button-small" onclick="saveMsg();">发送消息</button>
			<a href="auditGroup.htm?groupId=${reqpm.groupId }" class="button button-primary button-small">刷新</a>
			<c:if test="${optMap['PRINT']}">
				<a  onclick="window.open('<%=staticPath%>/finance/auditGroupListPrint.htm?groupId=${group.id}&isShow=true','结算单打印')" 
					href="javascript:void(0)" class="button button-primary button-small">打印</a>
<%-- 				<a href="financeChargeDownload.htm?groupId=${group.id}"  class="button button-primary button-small">打印</a> --%>
			</c:if>				
			<c:if test="${group.group_state == 1 && optMap['AUDIT']}">
				<button id="btn_seal" onclick="postAudit()" class="button button-primary button-small">审核通过</button>
				<!--  
					<button id="btn_seal" onclick="postSeal()" class="button button-primary button-small">封存</button>
				-->
			</c:if>
			<c:if test="${group.group_state == 3 && optMap['AUDIT']}">
				<button id="btn_seal" onclick="postUnAudit()" class="button button-primary button-small">取消审核通过</button>
			</c:if>
			<button id="btn_seal" onclick="showOperateLogs(${group.id })" class="button button-primary button-small">操作记录</button>
			<a onclick="closeWindow()" href="javascript:void(0);" class="button button-primary button-small">关闭</a>
			<select id="guideCg">
					<option value="">查看报账单</option>
				<c:forEach items="${bookingGuides}" var="booking">
					<option value="${booking.id}">${booking.guideName}</option>
				</c:forEach>
			</select>
		</div>
		<div id="operateLogsDiv"></div>
	</div>
<script type="text/javascript">
function saveMsg() {
    var msg_title;
    var msg_info;
    var operatorName;
    var operatorIds;
    var orderId;
    layer.open({ 
        type : 2,
        title : '发送消息',
        closeBtn : false,
        area : [ '450px', '470px' ],
        shadeClose : true,
        content : '../msgInfo/showMsg.htm',
        btn: ['确定', '取消'],
        success:function(layero, index){
            win = window[layero.find('iframe')[0]['name']];
            
            msg_title = win.$("#msg_title");
            msg_info = win.$("#msg_info");
            operatorName = win.$("#operatorName");
            operatorIds = win.$("#operatorIds");
            
            msg_title.val($("#groupOrder_receiveMode").val());
            orderId = $("#orderId");
        },
        yes: function(index){
            if(msg_title.val() == "") {
                layer.msg("消息标题不能为空！");
                return;
            } else if (msg_info.val() == "") {
                layer.msg("消息内容不能为空！");
                return;
            } else if (operatorName.val() == "") {
                layer.msg("接收人员不能为空！");
                return;
            }
            
            $.post(
                    "../msgInfo/sendMsg.do", 
                    {
                        orderId: orderId.val(),
                        title: msg_title.val(),
                        info: msg_info.val() ,
                        ids: operatorIds.val(),
                        names: operatorName.val(),
                        msgType: 1
                    }, function(data){
                        if(data.success){
                            layer.msg("发送成功！");
                        }else{
                            layer.msg("发送失败！");
                        }
                    },
            "json");
            
            layer.close(index);
        },cancel: function(index){
            layer.close(index);
        }
    });
}
</script>
</body>
</html>
