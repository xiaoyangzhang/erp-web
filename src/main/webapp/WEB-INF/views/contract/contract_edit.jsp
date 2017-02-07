<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib uri="http://yihg.com/custom-taglib" prefix="cf" %>
<%
    String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <title>新增协议</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <%@ include file="../../include/top.jsp" %>
    <%--<link rel="stylesheet" href="<%=ctx %>/assets/css/jquery-ui-1.10.3.full.min.css"/>--%>
    <%--<link rel="stylesheet" href="<%=ctx %>/assets/css/jquery-ui-1.10.3.custom.min.css"/>--%>
    <%--<script type="text/javascript" src="<%=ctx%>/assets/js/jquery-ui-1.10.3.full.min.js"></script>--%>
    <%--<script type="text/javascript" src="<%=ctx%>/assets/js/jquery-ui-1.10.3.custom.min.js"></script>--%>
    <%--<script src="<%=ctx%>/assets/js/jquery.validate.min.js"></script>--%>
    <%--<script src="<%=ctx %>/assets/js/My97DatePicker/WdatePicker.js"></script>--%>
    
    <script src="<%=ctx %>/assets/js/web-js/contract_edit.js"></script>
    <style>
        .help-block{
            display: inline-block;
        }
    </style>
</head>
<body>
<%--<div>--%>
     <%--<ul class="breadcrumb">--%>
        <%--<li><a href="#">合同</a> <span class="divider">-</span></li>--%>
        <%--<li class="active"><a href="#">新增/修改合同</a></li>--%>
      <%--</ul>--%>
  <%--</div>--%>
<div class="p_container">
    <div class="p_container_sub">
        <form id="contractForm" action="" onsubmit="return false;" method="post" enctype="multipart/form-data">
            <input type="hidden" name="supplierContract.id" value="${supplierContractVo.supplierContract.id}" />
            <input type="hidden" name="supplierContract.shopSupplierId" value="${supplierContractVo.bizSupplierRelation.id}"/>

            <c:choose>
                <c:when test="${FLEET eq supplierContractVo.supplierInfo.supplierType}">
                    <input id="supplierType" type="hidden" value="${FLEET}" />
                </c:when>
                <c:otherwise>
                    <p class="p_paragraph_title"><b>基本信息:</b></p>
                    <dl class="p_paragraph_content">
                        <dd>
                            <div class="dd_left">类型：</div>
                            <div class="dd_right">
                                <select id="supplierType" disabled="disabled">
                                    <c:forEach items="${supplierTypeMap}" var="type">
                                        <option value="${type.key}" <c:if test="${type.key == supplierContractVo.supplierInfo.supplierType}">selected="selected"</c:if>>${type.value}</option>
                                    </c:forEach>
                                        <%--<option value="${TRAVELAGENCY}" <c:if test="${supplierInfo.supplierType == TRAVELAGENCY}">selected="selected"</c:if>>旅行社</option>--%>
                                        <%--<option value="${RESTAURANT}" <c:if test="${supplierInfo.supplierType == RESTAURANT}">selected="selected"</c:if>>餐厅</option>--%>
                                        <%--<option value="${HOTEL}" <c:if test="${supplierInfo.supplierType == HOTEL}">selected="selected"</c:if>>酒店</option>--%>
                                        <%--<option value="${FLEET}" <c:if test="${supplierInfo.supplierType == FLEET}">selected="selected"</c:if>>车队</option>--%>
                                        <%--<option value="${SCENICSPOT}" <c:if test="${supplierInfo.supplierType == SCENICSPOT}">selected="selected"</c:if>>景区</option>--%>
                                        <%--<option value="${SHOPPING}" <c:if test="${supplierInfo.supplierType == SHOPPING}">selected="selected"</c:if>>购物</option>--%>
                                        <%--<option value="${ENTERTAINMENT}" <c:if test="${supplierInfo.supplierType == ENTERTAINMENT}">selected="selected"</c:if>>娱乐</option>--%>
                                        <%--<option value="${GUIDE}" <c:if test="${supplierInfo.supplierType == GUIDE}">selected="selected"</c:if>>导游</option>--%>
                                        <%--<option value="${AIRTICKETAGENT}" <c:if test="${supplierInfo.supplierType == AIRTICKETAGENT}">selected="selected"</c:if>>机票代理</option>--%>
                                        <%--<option value="${TRAINTICKETAGENT}" <c:if test="${supplierInfo.supplierType == TRAINTICKETAGENT}">selected="selected"</c:if>>火车票代理</option>--%>
                                        <%--<option value="${GOLF}" <c:if test="${supplierInfo.supplierType == GOLF}">selected="selected"</c:if>>高尔夫</option>--%>
                                        <%--<option value="${OTHER}" <c:if test="${supplierInfo.supplierType == OTHER}">selected="selected"</c:if>>其他</option>--%>
                                </select>
                            </div>

                            <div class="dd_left">名称：</div>
                            <div class="dd_right">
                                    ${supplierContractVo.supplierInfo.nameFull}
                            </div>

                            <div class="dd_left">法人：</div>
                            <div class="dd_right">
                                    ${supplierContractVo.supplierInfo.lawPerson}
                            </div>

                            <div class="dd_left">地址：</div>
                            <div class="dd_right">
                                    ${supplierContractVo.supplierInfo.provinceName}&nbsp;${supplierContractVo.supplierInfo.cityName}&nbsp;${supplierContractVo.supplierInfo.areaName}&nbsp;${supplierContractVo.supplierInfo.townName}&nbsp;${supplierContractVo.supplierInfo.address}
                            </div>
                        </dd>
                    </dl>
                </c:otherwise>
            </c:choose>
			<div class="clear"></div>
            <p class="p_paragraph_title"><b>合同信息:</b></p>
            <div id="contractInfo">


            </div>
            <dl class="p_paragraph_content">
                <dd class="Footer">
                    <div class="dd_left"></div>
                    <div class="dd_right">
                        <button type="submit" class="button button-primary button-small">保存</button>
                        <button type="button" onclick="closeWindow()" class="button button-primary button-small">关闭</button>
                    </div>
                </dd>
            </dl>
        </form>
    </div>
</div>

<div id="agency" style="display: none;">

    <dl class="p_paragraph_content">
        <dd>
            <div class="dd_left"><i class="red">* </i>合同名称：</div>
            <div class="dd_right">
                <input id="contractName_agency" type="text" name="supplierContract.contractName" value="${supplierContractVo.supplierContract.contractName}" />
            </div>
            <div class="clear"></div>
        </dd>

        <dd>
            <div class="dd_left"><i class="red">* </i>开始日期：</div>
            <div class="dd_right">
                <input id="startDate_agency" type="text" name="supplierContract.startDate" value="<fmt:formatDate value='${supplierContractVo.supplierContract.startDate}' pattern='yyyy-MM-dd' />" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
            </div>

            <div class="dd_left"><i class="red">* </i>结束日期：</div>
            <div class="dd_right">
                <input id="endDate_agency" type="text" name="supplierContract.endDate" value="<fmt:formatDate value='${supplierContractVo.supplierContract.endDate}' pattern='yyyy-MM-dd' />" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd', minDate:'#F{$dp.$D(\'startDate_agency\')}'})" />
            </div>

            <div class="dd_left"><i class="red">* </i>签订日期：</div>
            <div class="dd_right">
                <input id="signDate_agency" type="text" name="supplierContract.signDate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd', maxDate:'#F{$dp.$D(\'endDate_agency\')}'})"
                       value="<fmt:formatDate value='${supplierContractVo.supplierContract.signDate}' pattern='yyyy-MM-dd' />" />
            </div>
            <div class="clear"></div>
        </dd>

        <dd>
            <div class="dd_left"><i class="red">* </i>日期优先级：</div>
            <div class="dd_right">
                <select id="datePriority_agency" name="supplierContract.datePriority">
                    <option value="1" <c:if test="${supplierContractVo.supplierContract.datePriority == 1}">selected="selected"</c:if> >1</option>
                    <option value="2" <c:if test="${supplierContractVo.supplierContract.datePriority == 2}">selected="selected"</c:if> >2</option>
                    <option value="3" <c:if test="${supplierContractVo.supplierContract.datePriority == 3}">selected="selected"</c:if> >3</option>
                    <option value="4" <c:if test="${supplierContractVo.supplierContract.datePriority == 4}">selected="selected"</c:if> >4</option>
                    <option value="5" <c:if test="${supplierContractVo.supplierContract.datePriority == 5}">selected="selected"</c:if> >5</option>
                </select>
                <%--<input id="datePriority_agency" type="text" name="supplierContract.datePriority" value="${supplierContractVo.supplierContract.datePriority}" /> <i class="grey ml-10">请填写数字</i>--%>
            </div>
            <div class="clear"></div>
        </dd>

        <dd>
            <div class="dd_left">结算方式：</div>
            <div class="dd_right">
                <input type="text" name="supplierContract.settlementDays" value="${supplierContractVo.supplierContract.settlementDays}" placeholder="45" />天，
                <input type="text" name="supplierContract.settlementDesp" value="${supplierContractVo.supplierContract.settlementDesp}" placeholder="一个半月结清" />
            </div>
            <div class="clear"></div>
        </dd>

        <dd>
            <div class="dd_left">团类别：</div>
            <div class="dd_right">
                <label>
                    <input type="radio" name="supplierContract.groupType" value="1" <c:if
                            test="${supplierContractVo.supplierContract.groupType == 1}">checked</c:if> />所有
                </label>
                <label>
                    <input type="radio" name="supplierContract.groupType" value="2" <c:if
                            test="${supplierContractVo.supplierContract.groupType == 2}">checked</c:if> />团队(代订\会展)
                </label>
                <label>
                    <input type="radio" name="supplierContract.groupType" value="3" <c:if
                            test="${supplierContractVo.supplierContract.groupType == 3}">checked</c:if> />散客
                </label>
            </div>
            <div class="clear"></div>
        </dd>

        <dd>
            <p class="p_paragraph_title"><b>结算方式:</b></p>
        </dd>

        <dd>
            <div class="dd_left">超出天数：</div>
            <div class="dd_right">
                <input id="exceedDays_agency" type="text" name="supplierContract.exceedDays" value="${supplierContractVo.supplierContract.exceedDays}" />
            </div>
            <div class="clear"></div>
        </dd>

        <dd>
            <div class="dd_left">最大欠款额度：</div>
            <div class="dd_right">
                <input id="maxDebt_agency" type="text" name="supplierContract.maxDebt" value="${supplierContractVo.supplierContract.maxDebt}" />
            </div>
            <div class="clear"></div>
        </dd>

        <dd>
            <div class="dd_left">超出额度：</div>
            <div class="dd_right">
                <input id="exceedAmount_agency" type="text" name="supplierContract.exceedAmount" value="${supplierContractVo.supplierContract.exceedAmount}" />
            </div>
            <div class="clear"></div>
        </dd>

        <dd>
            <div class="dd_left">开票要求：</div>
            <div class="dd_right">
                <textarea id="billDemand_agency" class="w_textarea" name="supplierContract.billDemand" >${supplierContractVo.supplierContract.billDemand}</textarea>
            </div>
            <div class="clear"></div>
        </dd>

        <dd>
            <div class="dd_left">备注：</div>
            <div class="dd_right">
                <textarea id="note_agency" class="w_textarea" name="supplierContract.note" >${supplierContractVo.supplierContract.note}</textarea>
            </div>

            <div class="clear"></div>
        </dd>

        <dd>
            <div class="dd_left">返款政策：</div>
            <div class="dd_right">
                <textarea id="rebatePolicy_agency" class="w_textarea" name="supplierContract.rebatePolicy">${supplierContractVo.supplierContract.rebatePolicy}</textarea>
            </div>
            <div class="clear"></div>
        </dd>

        <dd>
            <div class="dd_left">文档图片：</div>
            <div class="dd_right addImg" id="attachments">
                <c:forEach items="${supplierContractVo.attachments}" var="attachment" varStatus="a">
	    				<span class="ulImg">
							<img src="${config.images200Url }${cf:thumbnail(attachment.imgPath,'200x200')}" alt=""><i class="icon_del delImg" ></i>
							<input type="hidden" name="attachments[${a.index }].imgName" value="${attachment.imgName }" />
							<input type="hidden" name="attachments[${a.index }].imgPath" value="${attachment.imgPath}" />
							<input type="hidden" name="attachments[${a.index }].bussniessType" value="3" />
						</span>
                </c:forEach>
                <!-- <span class="ulImg"><img src="imgTemp/upImgDefault.png" alt=""><i class="w_icon_del"></i></span> -->

            </div>
            <label onclick="selectAttachment(this, '#imgTemp')" class="ulImgBtn"></label> <i class="grey ml-10">请把合同协议拍照后，按顺序上传，gif 、jpg、png格式的图片。</i>
            <div class="clear"></div>
        </dd>
    </dl>

</div>

<div id="others" style="display: none;">
    <dl class="p_paragraph_content">
        <dd>
            <div class="dd_left"><i class="red">* </i>合同名称：</div>
            <div class="dd_right">
                <input id="contractName" type="text" name="supplierContract.contractName" value="${supplierContractVo.supplierContract.contractName}" class="IptText300" />
            </div>
            <div class="clear"></div>
        </dd>
        <dd>
            <div class="dd_left"><i class="red">* </i>开始日期：</div>
            <div class="dd_right">
                <input id="startDate" type="text" name="supplierContract.startDate" value="<fmt:formatDate value='${supplierContractVo.supplierContract.startDate}' pattern='yyyy-MM-dd' />" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
            </div>
            <div class="clear"></div>
        </dd>
        <dd>
            <div class="dd_left"><i class="red">* </i>结束日期：</div>
            <div class="dd_right">
                <input id="endDate" type="text" name="supplierContract.endDate" value="<fmt:formatDate value='${supplierContractVo.supplierContract.endDate}' pattern='yyyy-MM-dd' />" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd', minDate:'#F{$dp.$D(\'startDate\')}'})" />
            </div>
            <div class="clear"></div>
        </dd>
        <dd>
            <div class="dd_left"><i class="red">* </i>签订日期：</div>
            <div class="dd_right">
                <input id="signDate" type="text" name="supplierContract.signDate" value="<fmt:formatDate value='${supplierContractVo.supplierContract.signDate}' pattern='yyyy-MM-dd' />" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd', maxDate:'#F{$dp.$D(\'endDate\')}'})" />
            </div>
            <div class="clear"></div>
        </dd>
        <dd>
            <div class="dd_left">返款政策：</div>
            <div class="dd_right">
                <textarea id="rebatePolicy" class="w_textarea" name="supplierContract.rebatePolicy" >${supplierContractVo.supplierContract.rebatePolicy}</textarea>
            </div>
            <div class="clear"></div>
        </dd>
        <dd>
            <div class="dd_left">日期优先级：</div>
            <div class="dd_right">
                <select id="datePriority" name="supplierContract.datePriority">
                    <option value="1" <c:if test="${supplierContractVo.supplierContract.datePriority == 1}">selected="selected"</c:if> >1</option>
                    <option value="2" <c:if test="${supplierContractVo.supplierContract.datePriority == 2}">selected="selected"</c:if> >2</option>
                    <option value="3" <c:if test="${supplierContractVo.supplierContract.datePriority == 3}">selected="selected"</c:if> >3</option>
                    <option value="4" <c:if test="${supplierContractVo.supplierContract.datePriority == 4}">selected="selected"</c:if> >4</option>
                    <option value="5" <c:if test="${supplierContractVo.supplierContract.datePriority == 5}">selected="selected"</c:if> >5</option>
                </select>
                <%--<input id="datePriority" type="text" name="supplierContract.datePriority" value="${supplierContractVo.supplierContract.datePriority}" /> <i class="grey ml-10">请填写数字</i>--%>
            </div>
            <div class="clear"></div>
        </dd>
        <dd>
            <div class="dd_left">备注：</div>
            <div class="dd_right">
                <textarea id="note" class="w_textarea" name="supplierContract.note" >${supplierContractVo.supplierContract.note}</textarea>
            </div>
            <div class="clear"></div>
        </dd>
        <dd>
            <div class="dd_left">结算方式：</div>
            <div class="dd_right">
            <select name="supplierContract.settlementMethod" id="settlementMethod">
								<option ></option>
								<c:choose>
									
								<c:when test="${empty supplierContractVo.supplierContract.settlementMethod }">
								<c:forEach items="${cashTypes }" var="type">
								
									<option value="${type.id }">${type.value }</option>
								</c:forEach>
								</c:when>
								<c:otherwise >
									<c:forEach items="${cashTypes }" var="type">
										<option <c:if test="${supplierContractVo.supplierContract.settlementMethod eq type.id }">selected</c:if> value="${type.id }"  >${type.value }</option>
									</c:forEach>
								</c:otherwise>
								</c:choose>
							</select>
            <div class="clear"></div>
        </dd>
        <dd>
            <div class="dd_left">文档图片：</div>
            <div class="dd_right addImg" id="attachments">
                <c:forEach items="${supplierContractVo.attachments}" var="attachment" varStatus="a">
	    				<span class="ulImg">
							<img src="${config.images200Url }${cf:thumbnail(attachment.imgPath,'200x200')}" alt=""><i class="icon_del delImg" ></i>
							<input type="hidden" name="attachments[${a.index }].imgName" value="${attachment.imgName }" />
							<input type="hidden" name="attachments[${a.index }].imgPath" value="${attachment.imgPath}" />
							<input type="hidden" name="attachments[${a.index }].bussniessType" value="3" />
						</span>
                </c:forEach>
                <!-- <span class="ulImg"><img src="imgTemp/upImgDefault.png" alt=""><i class="w_icon_del"></i></span> -->

            </div>
            <label onclick="selectAttachment(this, '#imgTemp')" class="ulImgBtn"></label> <i class="grey ml-10">请把合同协议拍照后，按顺序上传，gif 、jpg、png格式的图片。</i>
            <div class="clear"></div>
        </dd>
    </dl>


    <p class="p_paragraph_title"><b>价格信息:</b></p>
    <dl class="p_paragraph_content">
        <dd>
            <div class="dd_left">

            </div>
            <div class="dd_right" style="width:80%" id="priceTable">

            </div>
            <div class="clear"></div>
        </dd>
    </dl>

</div>

<c:choose>
    <c:when test="${SHOPPING == supplierContractVo.supplierInfo.supplierType}">
    <div id="shopPrice" style="display: none;">
        <button type="button" onclick="addPriceInfoRow('shopPriceRow', 'shopPriceData');" class="button button-primary button-small" >添加</button>
        <table cellspacing="0" class="w_table">
            <colgroup>
                <col width="25%" />
                <col width="35%" />
                <col width="30%" />
                <col width="10%" />
            </colgroup>
            <thead>
            <tr>
                <th>商品类别<i class="w_table_split"></i></th>
                <%--<th>正/特价<i class="w_table_split"></i></th>--%>
                <th>返款模式<i class="w_table_split"></i></th>
                <th>备注<i class="w_table_split"></i></th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody id="shopPriceRow">
            <c:forEach items="${supplierContractVo.priceVoList}" var="priceVo" varStatus="s">
                <tr>
                    <td>
                        <input type="hidden" id="priceVoList[${s.index}].supplierContractPrice.id" name="priceVoList[${s.index}].supplierContractPrice.id" value="${priceVo.supplierContractPrice.id}" />
                        <input type="hidden" id="priceVoList[${s.index}].supplierContractPrice.contractId" name="priceVoList[${s.index}].supplierContractPrice.contractId" value="${priceVo.supplierContractPrice.contractId}" />
                        <select id="priceVoList[${s.index}].supplierContractPrice.itemType" name="priceVoList[${s.index}].supplierContractPrice.itemType"
                                onchange="$(this).next('input').val(this.options[this.selectedIndex].text);" >
                            <option value="">请选择</option>
                            <c:if test="${supplierContractVo.supplierInfo.supplierType eq 6 }">
                            <c:forEach items="${dictTypeList}" var="type">
                                <option value="${type.id}" <c:if test="${priceVo.supplierContractPrice.itemType == type.id}">selected</c:if>>${type.itemName}</option>
                            </c:forEach></c:if>
                        </select>
                        <input type="hidden" id="priceVoList[${s.index}].supplierContractPrice.itemTypeName" name="priceVoList[${s.index}].supplierContractPrice.itemTypeName"
                               value="${priceVo.supplierContractPrice.itemTypeName}"/>
                    </td>
                    <%--<td>--%>
                        <%--<select id="priceVoList[${s.index}].supplierContractPrice.itemType2" name="priceVoList[${s.index}].supplierContractPrice.itemType2"--%>
                                <%--onchange="$(this).next('input').val(this.options[this.selectedIndex].text);" >--%>
                            <%--<option value="1" <c:if test="${priceVo.supplierContractPrice.itemType2 == 1}">selected="selected"</c:if>>正价</option>--%>
                            <%--<option value="2" <c:if test="${priceVo.supplierContractPrice.itemType2 == 2}">selected="selected"</c:if>>特价</option>--%>
                        <%--</select>--%>
                        <%--<input type="hidden" id="priceVoList[${s.index}].supplierContractPrice.itemType2Name" name="priceVoList[${s.index}].supplierContractPrice.itemType2Name"--%>
                               <%--value="<c:if test="${priceVo.supplierContractPrice.itemType2 == 1}">正价</c:if><c:if test="${priceVo.supplierContractPrice.itemType2 == 2}">特价</c:if>"/>--%>
                    <%--</td>--%>
                    <td>
                         <input type="hidden" name="priceVoList[${s.index}].supplierContractPrice.rebateMethod" value="1"  /> 按销售金额返款&nbsp;&nbsp;返款&nbsp;<input
                            id="priceVoList[${s.index}].supplierContractPrice.rebateAmountPercent" type="text"
                            name="priceVoList[${s.index}].supplierContractPrice.rebateAmountPercent" style="width: 40px;" value="${priceVo.supplierContractPrice.rebateAmount}" /> %
                       </td>
                    <td>
                        <textarea id="priceVoList[${s.index}].supplierContractPrice.note" class="control-row4 input-large" style="text-align:center;" name="priceVoList[${s.index}].supplierContractPrice.note" >${priceVo.supplierContractPrice.note}</textarea>
                    </td>
                    <td><a class="def" href="javascript:void(0)" onclick="deletePrice(this);">删除</a></td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>

    </c:when>
    <c:when test="${FLEET == supplierContractVo.supplierInfo.supplierType}">
    <div id="fleetPrice" style="display: none;">
        <button type="button" onclick="addPriceInfoRow('fleetPriceRow', 'fleetPriceData');" class="button button-primary button-small" >添加</button>
        <table cellspacing="0" class="w_table">
            <colgroup>
                <col width="15%" />
                <col width="15%" />
                <%--<col width="10%" />--%>
                <col width="40%" />
                <col width="20%" />
                <col width="10%" />
            </colgroup>
            <thead>
            <tr>
                <th>车型<i class="w_table_split"></i></th>
                <th>座位数<i class="w_table_split"></i></th>
                <%--<th>协议价<i class="w_table_split"></i></th>--%>
                <th>二级协议价<i class="w_table_split"></i></th>
                <th>备注<i class="w_table_split"></i></th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody id="fleetPriceRow">
            <c:forEach items="${supplierContractVo.priceVoList}" var="priceVo" varStatus="s">
                <tr>
                    <td>
                        <input type="hidden" id="priceVoList[${s.index}].supplierContractPrice.id" name="priceVoList[${s.index}].supplierContractPrice.id" value="${priceVo.supplierContractPrice.id}" />
                        <input type="hidden" id="priceVoList[${s.index}].supplierContractPrice.contractId" name="priceVoList[${s.index}].supplierContractPrice.contractId" value="${priceVo.supplierContractPrice.contractId}" />
                        <select id="priceVoList[${s.index}].supplierContractPrice.itemType" name="priceVoList[${s.index}].supplierContractPrice.itemType"
                                onchange="$(this).next('input').val(this.options[this.selectedIndex].text);" >
                            <option value="">请选择</option>
                            <c:if test="${supplierContractVo.supplierInfo.supplierType eq 4}">
                            <c:forEach items="${dictTypeList}" var="type">
                                <option value="${type.id}" <c:if test="${priceVo.supplierContractPrice.itemType == type.id}">selected</c:if>>${type.value}</option>
                            </c:forEach></c:if>
                        </select>
                        <input id="priceVoList[${s.index}].supplierContractPrice.itemTypeName" type="hidden" name="priceVoList[${s.index}].supplierContractPrice.itemTypeName" value="${priceVo.supplierContractPrice.itemTypeName}"/>
                    </td>
                    <td>
                        <input id="priceVoList[${s.index}].supplierContractPrice.itemType2" type="hidden" style="width: 40px;" name="priceVoList[${s.index}].supplierContractPrice.itemType2" value="${priceVo.supplierContractPrice.itemType2}" />
                        <input id="priceVoList[${s.index}].supplierContractPrice.itemType2Name" type="text" onblur="$(this).prev().val($(this).val());"
                               name="priceVoList[${s.index}].supplierContractPrice.itemType2Name" style="width: 40px;" value="${priceVo.supplierContractPrice.itemType2Name}" /> 座 -
                        <input id="priceVoList[${s.index}].supplierContractPrice.itemType3" type="hidden" style="width: 40px;" name="priceVoList[${s.index}].supplierContractPrice.itemType3" value="${priceVo.supplierContractPrice.itemType3}" />
                        <input id="priceVoList[${s.index}].supplierContractPrice.itemType3Name" type="text" onblur="$(this).prev().val($(this).val());"
                               name="priceVoList[${s.index}].supplierContractPrice.itemType3Name" style="width: 40px;" value="${priceVo.supplierContractPrice.itemType3Name}" /> 座
                    </td>
                    <td id="secondLevelPrice_${s.index}">
                        <table>
                            <thead>
                            <tr>
                                <td width="20%">线路品牌</td>
                                <td width="8%" >结算价</td>
                                <td width="8%" >采购价</td>
                                <td width="7%">操作</td>
                            </tr>
                            </thead>
                            <tbody id="secondLevelPriceRow_${s.index}" >
                            <c:forEach items="${priceVo.priceExtVoList}" var="priceExtVo" varStatus="s2">
                                <tr>
                                    <td>
                                        <input type="hidden" id="priceVoList[${s.index}].priceExtVoList[${s2.index}].supplierContractPriceExt.id" name="priceVoList[${s.index}].priceExtVoList[${s2.index}].supplierContractPriceExt.id" value="${priceExtVo.supplierContractPriceExt.id}" />
                                        <input type="hidden" id="priceVoList[${s.index}].priceExtVoList[${s2.index}].supplierContractPriceExt.priceId" name="priceVoList[${s.index}].priceExtVoList[${s2.index}].supplierContractPriceExt.priceId" value="${priceExtVo.supplierContractPriceExt.priceId}" />
                                        <select id="priceVoList[${s.index}].priceExtVoList[${s2.index}].supplierContractPriceExt.brandId" name="priceVoList[${s.index}].priceExtVoList[${s2.index}].supplierContractPriceExt.brandId"
                                                onchange="$(this).next('input').val(this.options[this.selectedIndex].text);" >
                                            <option value="">请选择</option>
                                            <c:forEach items="${dictSecLevelTypeList}" var="type">
                                                <option value="${type.id}" <c:if test="${priceExtVo.supplierContractPriceExt.brandId == type.id}">selected</c:if>>${type.value}</option>
                                            </c:forEach>
                                        </select>
                                        <input type="hidden" id="priceVoList[${s.index}].priceExtVoList[${s2.index}].supplierContractPriceExt.brandName"
                                               name="priceVoList[${s.index}].priceExtVoList[${s2.index}].supplierContractPriceExt.brandName"
                                               value="${priceExtVo.supplierContractPriceExt.brandName}"/>
                                    </td>
                                    <td>
                                        <input id="priceVoList[${s.index}].priceExtVoList[${s2.index}].supplierContractPriceExt.price" type="text" style="width: 40px;"
                                               name="priceVoList[${s.index}].priceExtVoList[${s2.index}].supplierContractPriceExt.price" value="${priceExtVo.supplierContractPriceExt.price}" /> 元
                                    </td>
                                    <td>
                                        <input id="priceVoList[${s.index}].priceExtVoList[${s2.index}].supplierContractPriceExt.salePrice" type="text" style="width: 40px;"
                                               name="priceVoList[${s.index}].priceExtVoList[${s2.index}].supplierContractPriceExt.salePrice" value="${priceExtVo.supplierContractPriceExt.salePrice}" /> 元
                                    </td>
                                    <td>
                                        <a class="def" href="javascript:void(0)" onclick="deleteSecondLevelPrice(this, '${s.index}','${priceExtVo.supplierContractPriceExt.id}');">删除</a>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                        <a href="javascript:void(0);" onclick="addSecLevelPriceInfoRow('${s.index}', 'secondLevelPriceRow_${s.index}', 'secondLevelPriceData');">添加</a>
                    </td>
                    <td>
                        <textarea id="priceVoList[${s.index}].supplierContractPrice.note" class="control-row4 input-large" style="text-align:center;" name="priceVoList[${s.index}].supplierContractPrice.note" >${priceVo.supplierContractPrice.note}</textarea>
                    </td>
                    <td><a class="def" href="javascript:void(0)" onclick="deletePrice(this);">删除</a></td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
    </c:when>
    <c:when test="${'temp' == deliveryType}">
    <div id="DeliveryPrice" style="display: none;">
    	<button type="button" onclick="addPriceInfoRow('DeliveryPriceRow', 'DeliveryPriceData');" class="button button-primary button-small" >添加</button>
        <table cellspacing="0" class="w_table">
        	<colgroup>
        		<col width="10%" />
        		<col width="8%" />
        		<col width="8%" />
        		<col width="35%" />
        		<col width="10%" />
        		<col width="10%" />
        		<col width="10%" />
        	</colgroup>
            <thead>            
	            <tr>
	                <th>项目<i class="w_table_split"></i></th>
	                <th>结算价<i class="w_table_split"></i></th>
	                <th>采购价<i class="w_table_split"></i></th>
	                <th>二级协议价<i class="w_table_split"></i></th>
	                <th>方向<i class="w_table_split"></i></th>
	                <th>备注<i class="w_table_split"></i></th>
	                <th>操作</th>
	            </tr>
            </thead>
            <tbody id="DeliveryPriceRow">
			<c:forEach items="${supplierContractVo.priceVoList}" var="priceVo" varStatus="s">
                <tr>
                    <td>
                        <input type="hidden" id="priceVoList[${s.index}].supplierContractPrice.id" name="priceVoList[${s.index}].supplierContractPrice.id" value="${priceVo.supplierContractPrice.id}" />
                        <input type="hidden" id="priceVoList[${s.index}].supplierContractPrice.contractId" name="priceVoList[${s.index}].supplierContractPrice.contractId" value="${priceVo.supplierContractPrice.contractId}" />
                        <select id="priceVoList[${s.index}].supplierContractPrice.itemType" name="priceVoList[${s.index}].supplierContractPrice.itemType"
                                onchange="$(this).next('input').val(this.options[this.selectedIndex].text);" >
                            <option value="">请选择</option>
                            <c:if test="${supplierContractVo.supplierInfo.supplierType eq 16}">
                            <c:forEach items="${dictTypeList}" var="type">
                                <option value="${type.id}" <c:if test="${priceVo.supplierContractPrice.itemType == type.id}">selected</c:if>>${type.value}</option>
                            </c:forEach></c:if>
                        </select>
                        <input id="priceVoList[${s.index}].supplierContractPrice.itemTypeName" type="hidden" name="priceVoList[${s.index}].supplierContractPrice.itemTypeName" value="${priceVo.supplierContractPrice.itemTypeName}"/>
                    </td>
                	 <!--11 一级结算价 -->
                	 <td>
                          <input id="priceVoList[${s.index}].supplierContractPrice.contractPrice" type="text" style="width: 40px;"
                                 name="priceVoList[${s.index}].supplierContractPrice.contractPrice" value="${priceVo.supplierContractPrice.contractPrice}" /> 元
                      </td>
                       <!--11 一级销售价 -->
                      <td>
                          <input id="priceVoList[${s.index}].supplierContractPrice.contractSale" type="text" style="width: 40px;"
                                 name="priceVoList[${s.index}].supplierContractPrice.contractSale" value="${priceVo.supplierContractPrice.contractSale}" /> 元
                      </td>
                    <td id="secondLevelPrice_${s.index}">
                        <table>
                            <thead>
                            <tr>
                                <td width="20%">线路品牌</td>
                                <td width="8%" >结算价</td>
                                <td width="8%" >采购价</td>
                                <td width="7%">操作</td>
                            </tr>
                            </thead>
                            <tbody id="secondLevelPriceRow_${s.index}" >
                            
                            <c:forEach items="${priceVo.priceExtVoList}" var="priceExtVo" varStatus="s2">
                                <tr>
                                    <td>
                                        <input type="hidden" id="priceVoList[${s.index}].priceExtVoList[${s2.index}].supplierContractPriceExt.id" name="priceVoList[${s.index}].priceExtVoList[${s2.index}].supplierContractPriceExt.id" value="${priceExtVo.supplierContractPriceExt.id}" />
                                        <input type="hidden" id="priceVoList[${s.index}].priceExtVoList[${s2.index}].supplierContractPriceExt.priceId" name="priceVoList[${s.index}].priceExtVoList[${s2.index}].supplierContractPriceExt.priceId" value="${priceExtVo.supplierContractPriceExt.priceId}" />
                                        <select id="priceVoList[${s.index}].priceExtVoList[${s2.index}].supplierContractPriceExt.brandId" name="priceVoList[${s.index}].priceExtVoList[${s2.index}].supplierContractPriceExt.brandId"
                                                onchange="$(this).next('input').val(this.options[this.selectedIndex].text);" >
                                            <option value="">请选择</option>
                                            <c:forEach items="${dictSecLevelTypeList}" var="type">
                                                <option value="${type.id}" <c:if test="${priceExtVo.supplierContractPriceExt.brandId == type.id}">selected</c:if>>${type.value}</option>
                                            </c:forEach>
                                        </select>
                                        <input type="hidden" id="priceVoList[${s.index}].priceExtVoList[${s2.index}].supplierContractPriceExt.brandName"
                                               name="priceVoList[${s.index}].priceExtVoList[${s2.index}].supplierContractPriceExt.brandName"
                                               value="${priceExtVo.supplierContractPriceExt.brandName}"/>
                                    </td>
                                    <td>
                                        <input id="priceVoList[${s.index}].priceExtVoList[${s2.index}].supplierContractPriceExt.price" type="text" style="width: 40px;"
                                               name="priceVoList[${s.index}].priceExtVoList[${s2.index}].supplierContractPriceExt.price" value="${priceExtVo.supplierContractPriceExt.price}" /> 元
                                    </td>
                                    <td>
                                        <input id="priceVoList[${s.index}].priceExtVoList[${s2.index}].supplierContractPriceExt.salePrice" type="text" style="width: 40px;"
                                               name="priceVoList[${s.index}].priceExtVoList[${s2.index}].supplierContractPriceExt.salePrice" value="${priceExtVo.supplierContractPriceExt.salePrice}" /> 元
                                    </td>
                                    <td>
                                        <a class="def" href="javascript:void(0)" onclick="deleteSecondLevelPrice(this, '${s.index}','${priceExtVo.supplierContractPriceExt.id}');">删除</a>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                        <a href="javascript:void(0);" onclick="addSecLevelPriceInfoRow('${s.index}', 'secondLevelPriceRow_${s.index}', 'secondLevelPriceData');">添加</a>
                    </td>
                    <!--55 方向 -->
                    <td>
                		<label >
                			<input type="radio" id="priceVoList[${s.index}].supplierContractPrice.receivablePayable" 
                				name="priceVoList[${s.index}].supplierContractPrice.receivablePayable" 
                				value="0" <c:if test="${priceVo.supplierContractPrice.receivablePayable == '0'}"> checked="checked" </c:if> />
                				<span>应收</span></label>
						<label >
							<input type="radio" id="priceVoList[${s.index}].supplierContractPrice.receivablePayable" 
								name="priceVoList[${s.index}].supplierContractPrice.receivablePayable" 
								value="1" <c:if test="${priceVo.supplierContractPrice.receivablePayable == 1 }"> checked="checked" </c:if> />
								<span>应付</span></label>
								
                    </td>
                    <td>
                        <textarea id="priceVoList[${s.index}].supplierContractPrice.note" class="control-row4 input-large" style="text-align:center;" name="priceVoList[${s.index}].supplierContractPrice.note" >${priceVo.supplierContractPrice.note}</textarea>
                    </td>
                    <td><a class="def" href="javascript:void(0)" onclick="deletePrice(this);">删除</a></td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
    </c:when>
    
    <c:when test="${HOTEL == supplierContractVo.supplierInfo.supplierType}">
    <div id="hotelPrice" style="display: none;">
        <button type="button" onclick="addPriceInfoRow('hotelPriceRow', 'hotelPriceData');" class="button button-primary button-small">添加</button>
        <table cellspacing="0" class="w_table">
            <colgroup>
                <col width="15%" />
                <%--<col width="10%" />--%>
                <col width="15%" />
                <col width="15%" />
                <col width="30%" />
                <col width="20%" />
                <col width="10%" />
            </colgroup>
            <thead>
            <tr>
                <th>类别<i class="w_table_split"></i></th>
                <%--<th>房型<i class="w_table_split"></i></th>--%>
                <th>结算价<i class="w_table_split"></i></th>
                <th>采购价<i class="w_table_split"></i></th>
                <th>减免政策<i class="w_table_split"></i></th>
                <th>备注<i class="w_table_split"></i></th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody id="hotelPriceRow">
            <c:forEach items="${supplierContractVo.priceVoList}" var="priceVo" varStatus="s">
                <tr>
                    <td>
                        <input type="hidden" id="priceVoList[${s.index}].supplierContractPrice.id" name="priceVoList[${s.index}].supplierContractPrice.id" value="${priceVo.supplierContractPrice.id}" />
                        <input type="hidden" id="priceVoList[${s.index}].supplierContractPrice.contractId" name="priceVoList[${s.index}].supplierContractPrice.contractId" value="${priceVo.supplierContractPrice.contractId}" />
                        <select id="priceVoList[${s.index}].supplierContractPrice.itemType" name="priceVoList[${s.index}].supplierContractPrice.itemType"
                                onchange="$(this).next('input').val(this.options[this.selectedIndex].text);" >
                            <option value="">请选择</option>
                            <c:if test="${supplierContractVo.supplierInfo.supplierType eq 3}">
                            <c:forEach items="${dictTypeList}" var="type">
                                <option value="${type.id}" <c:if test="${priceVo.supplierContractPrice.itemType == type.id}">selected</c:if>>${type.value}</option>
                            </c:forEach></c:if>
                        </select>
                        <input type="hidden" id="priceVoList[${s.index}].supplierContractPrice.itemTypeName" name="priceVoList[${s.index}].supplierContractPrice.itemTypeName"
                               value="${priceVo.supplierContractPrice.itemTypeName}"/>
                    </td>
                    <td>
                        <input id="priceVoList[${s.index}].supplierContractPrice.contractPrice"  type="text" style="width: 40px;"
                               name="priceVoList[${s.index}].supplierContractPrice.contractPrice"
                               value="${priceVo.supplierContractPrice.contractPrice}"  /> 元
                    </td>
                    <td>
                        <input id="priceVoList[${s.index}].supplierContractPrice.contractSale"  type="text" style="width: 40px;"
                               name="priceVoList[${s.index}].supplierContractPrice.contractSale"
                               value="${priceVo.supplierContractPrice.contractSale}"  /> 元
                    </td>
                    <td>
                        满 <input id="priceVoList[${s.index}].supplierContractPrice.derateReach" type="text"
                                 name="priceVoList[${s.index}].supplierContractPrice.derateReach" style="width: 40px;"
                                 value="${priceVo.supplierContractPrice.derateReach}" /> 免 <input
                            id="priceVoList[${s.index}].supplierContractPrice.derateReduction" type="text" style="width: 40px;"
                            name="priceVoList[${s.index}].supplierContractPrice.derateReduction"
                            value="${priceVo.supplierContractPrice.derateReduction}" />
                    </td>
                    <td>
                            <textarea id="priceVoList[${s.index}].supplierContractPrice.note" class="control-row4 input-large" style="text-align:center;"
                                      name="priceVoList[${s.index}].supplierContractPrice.note" >${priceVo.supplierContractPrice.note}</textarea>
                    </td>
                    <td><a class="def" href="javascript:void(0)" onclick="deletePrice(this);">删除</a></td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>

    </c:when>
    <c:otherwise>
    <div id="commonPrice" style="display: none;">
        <button type="button" onclick="addPriceInfoRow('commonPriceRow', 'commonPriceData');" class="button button-primary button-small" >添加</button>
        <table cellspacing="0" class="w_table">
            <colgroup>
                <col width="10%" />
                <col width="10%" />
                <col width="10%" />
                <col width="20%" />
                <col width="10%" />
                <col width="30%" />
                <col width="10%" />
            </colgroup>
            <thead>
            <tr>
                <th>项目<i class="w_table_split"></i></th>
                <th>结算价<i class="w_table_split"></i></th>
                <th>采购价<i class="w_table_split"></i></th>
                <th>减免政策<i class="w_table_split"></i></th>
              	<th>方向<i class="w_table_split"></i></th>
                <th>备注<i class="w_table_split"></i></th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody id="commonPriceRow">
            <c:forEach items="${supplierContractVo.priceVoList}" var="priceVo" varStatus="s">
                <tr>
                    <td>
                        <input type="hidden" id="priceVoList[${s.index}].supplierContractPrice.id" name="priceVoList[${s.index}].supplierContractPrice.id" value="${priceVo.supplierContractPrice.id}" />
                        <input type="hidden" id="priceVoList[${s.index}].supplierContractPrice.contractId" name="priceVoList[${s.index}].supplierContractPrice.contractId" value="${priceVo.supplierContractPrice.contractId}" />
                        <select id="priceVoList[${s.index}].supplierContractPrice.itemType" name="priceVoList[${s.index}].supplierContractPrice.itemType"
                                onchange="$(this).next('input').val(this.options[this.selectedIndex].text);" >
                            <option value="">请选择</option>
                            <c:choose>
                        
                        	<c:when test="${supplierContractVo.supplierInfo.supplierType eq 5 }">
                        	<c:forEach items="${dictTypeList}" var="type">
                            <option value="${type.id}" <c:if test="${priceVo.supplierContractPrice.itemType == type.id}">selected</c:if>>${type.itemName}</option>
                        </c:forEach>
                        	</c:when>
                        	<c:when test="${supplierContractVo.supplierInfo.supplierType ne 1 and supplierContractVo.supplierInfo.supplierType ne 6 and supplierContractVo.supplierInfo.supplierType ne 3 and supplierContractVo.supplierInfo.supplierType ne 4 }">
                        	
                        <c:forEach items="${dictTypeList}" var="type">
                            <option value="${type.id}" <c:if test="${priceVo.supplierContractPrice.itemType == type.id}">selected</c:if>>${type.value}</option>
                        </c:forEach>
                        	</c:when>
                        </c:choose>
                        
                        
                            <%-- <c:forEach items="${dictTypeList}" var="type">
                                <option value="${type.id}" <c:if test="${priceVo.supplierContractPrice.itemType == type.id}">selected</c:if>>${type.value}</option>
                            </c:forEach> --%>
                        </select>
                        <input type="hidden" id="priceVoList[${s.index}].supplierContractPrice.itemTypeName" name="priceVoList[${s.index}].supplierContractPrice.itemTypeName"
                               value="${priceVo.supplierContractPrice.itemTypeName}"/>
                    </td>
                    <td>
                        <input id="priceVoList[${s.index}].supplierContractPrice.contractPrice" type="text" style="width: 40px;"
                               name="priceVoList[${s.index}].supplierContractPrice.contractPrice" value="${priceVo.supplierContractPrice.contractPrice}" /> 元
                    </td>
                    <td>
                        <input id="priceVoList[${s.index}].supplierContractPrice.contractSale"  type="text" style="width: 40px;"
                               name="priceVoList[${s.index}].supplierContractPrice.contractSale"
                               value="${priceVo.supplierContractPrice.contractSale}"  /> 元
                    </td>
                    
                    <td>
                        满 <input id="priceVoList[${s.index}].supplierContractPrice.derateReach" type="text" style="width: 40px;"
                                 name="priceVoList[${s.index}].supplierContractPrice.derateReach" value="${priceVo.supplierContractPrice.derateReach}" /> 免
                        <input id="priceVoList[${s.index}].supplierContractPrice.derateReduction" type="text" style="width: 40px;"
                               name="priceVoList[${s.index}].supplierContractPrice.derateReduction" value="${priceVo.supplierContractPrice.derateReduction}" />
                    </td>
                   <!--55 方向 -->
                    <td>
                		<label >
                			<input type="radio" id="priceVoList[${s.index}].supplierContractPrice.receivablePayable" 
                				name="priceVoList[${s.index}].supplierContractPrice.receivablePayable" 
                				value="${priceVo.supplierContractPrice.receivablePayable}" <c:if test="${priceVo.supplierContractPrice.receivablePayable == 0}"> checked="checked" </c:if> />
                				<span>应收</span></label>
						<label >
							<input type="radio" id="priceVoList[${s.index}].supplierContractPrice.receivablePayable" 
								name="priceVoList[${s.index}].supplierContractPrice.receivablePayable" 
								value="${priceVo.supplierContractPrice.receivablePayable}" <c:if test="${priceVo.supplierContractPrice.receivablePayable == 1 }"> checked="checked" </c:if> />
								<span>应付</span></label>
								
                    </td>
                    <td>
                        <textarea id="priceVoList[${s.index}].supplierContractPrice.note" class="control-row4 input-large" style="text-align:center;"
                                  name="priceVoList[${s.index}].supplierContractPrice.note" >${priceVo.supplierContractPrice.note}</textarea>
                    </td>
                    <td><a class="def" href="javascript:void(0)" onclick="deletePrice(this);">删除</a></td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>

    </c:otherwise>
</c:choose>


<%--price data columns--%>

<div id="commonPriceData" style="display : none;">
    <table class="table-style1">
        <tbody>
        <tr>
            <td>
                <select id="priceVoList[$index].supplierContractPrice.itemType" name="priceVoList[$index].supplierContractPrice.itemType" onchange="$(this).next('input').val(this.options[this.selectedIndex].text);">
                    <option value="">请选择</option>
                    <c:choose>
                        
                        	<c:when test="${supplierContractVo.supplierInfo.supplierType eq 5 }">
                        	<c:forEach items="${dictTypeList}" var="type">
                            <option value="${type.id}">${type.itemName}</option>
                        </c:forEach>
                        	</c:when>
                        	<c:when test="${supplierContractVo.supplierInfo.supplierType ne 1 and supplierContractVo.supplierInfo.supplierType ne 6 and supplierContractVo.supplierInfo.supplierType ne 3 and supplierContractVo.supplierInfo.supplierType ne 4 }">
                        	
                        <c:forEach items="${dictTypeList}" var="type">
                            <option value="${type.id}">${type.value}</option>
                        </c:forEach>
                        	</c:when>
                        </c:choose>
                        
                    <%-- <c:forEach items="${dictTypeList}" var="type">
                        <option value="${type.id}">${type.value}</option>
                    </c:forEach> --%>
                </select>
                <input type="hidden" id="priceVoList[$index].supplierContractPrice.itemTypeName" name="priceVoList[$index].supplierContractPrice.itemTypeName" value="" />
            </td>
            <td>
                <input id="priceVoList[$index].supplierContractPrice.contractPrice" style="width: 40px;" type="text" name="priceVoList[$index].supplierContractPrice.contractPrice" value="0" /> 元
            </td>
            <td>
                <input id="priceVoList[$index].supplierContractPrice.contractSale" style="width: 40px;" type="text" name="priceVoList[$index].supplierContractPrice.contractSale" value="0" /> 元
            </td>
            <td>
                满 <input id="priceVoList[$index].supplierContractPrice.derateReach" style="width: 40px;" type="text" name="priceVoList[$index].supplierContractPrice.derateReach" value="0" /> 免 <input value="0" id="priceVoList[$index].supplierContractPrice.derateReduction" style="width: 40px;" type="text" name="priceVoList[$index].supplierContractPrice.derateReduction" />
            </td>
            <td>
                <textarea id="priceVoList[$index].supplierContractPrice.note" class="control-row4 input-large" style="text-align:center;" name="priceVoList[$index].supplierContractPrice.note" ></textarea>
            </td>
            <td>
                <a class="def" href="javascript:void(0)" onclick="deletePrice(this);">删除</a>
            </td>
        </tr>
        </tbody>
    </table>
</div>

<div id="shopPriceData" style="display : none;">
    <table class="table-style1">
        <tbody>
        <tr>
            <td>
                <select id="priceVoList[$index].supplierContractPrice.itemType" name="priceVoList[$index].supplierContractPrice.itemType" onchange="$(this).next('input').val(this.options[this.selectedIndex].text);">
                    <option  value="">请选择</option>
                    <c:if test="${supplierContractVo.supplierInfo.supplierType eq 6 }">
                    <c:forEach items="${dictTypeList}" var="type">
                        <option value="${type.id}">${type.itemName}</option>
                    </c:forEach></c:if>
                </select>
                <input type="hidden" id="priceVoList[$index].supplierContractPrice.itemTypeName" name="priceVoList[$index].supplierContractPrice.itemTypeName" value="" />
            </td>
            <%--<td>--%>
                <%--<select id="priceVoList[$index].supplierContractPrice.itemType2" name="priceVoList[$index].supplierContractPrice.itemType2" onchange="$(this).next('input').val(this.options[this.selectedIndex].text);">--%>
                    <%--<option value="1" selected="selected">正价</option>--%>
                    <%--<option value="2">特价</option>--%>
                <%--</select>--%>
                <%--<input type="hidden" id="priceVoList[$index].supplierContractPrice.itemType2Name" name="priceVoList[$index].supplierContractPrice.itemType2Name" value="正价" />--%>
            <%--</td>--%>
            <td>
                <input type="hidden" name="priceVoList[$index].supplierContractPrice.rebateMethod" value="1"  />按销售金额返款&nbsp;&nbsp;返款&nbsp;<input id="priceVoList[$index].supplierContractPrice.rebateAmountPercent" value="0" style="width:40px;" type="text" name="priceVoList[$index].supplierContractPrice.rebateAmountPercent" /> %
                 </td>
            <td>
                <textarea id="priceVoList[$index].supplierContractPrice.note" class="control-row4 input-large" style="text-align:center;" name="priceVoList[$index].supplierContractPrice.note" ></textarea>
            </td>
            <td><a class="def" href="javascript:void(0)" onclick="deletePrice(this);">删除</a></td>
        </tr>
        </tbody>
    </table>
</div>

<div id="fleetPriceData" style="display : none;">
    <table class="table-style1">
        <tbody>
        <tr>
            <td>
                <select id="priceVoList[$index].supplierContractPrice.itemType" name="priceVoList[$index].supplierContractPrice.itemType" onchange="$(this).next('input').val(this.options[this.selectedIndex].text);">
                    <option  value="">请选择</option>
                     <c:if test="${supplierContractVo.supplierInfo.supplierType eq 4}">
                    <c:forEach items="${dictTypeList}" var="type">
                        <option value="${type.id}">${type.value}</option>
                    </c:forEach></c:if>
                </select>
                <input type="hidden" id="priceVoList[$index].supplierContractPrice.itemTypeName" name="priceVoList[$index].supplierContractPrice.itemTypeName" value="" />
            </td>
            <td>
                <input id="priceVoList[$index].supplierContractPrice.itemType2" type="hidden" style="width: 40px;" name="priceVoList[$index].supplierContractPrice.itemType2" />
                <input id="priceVoList[$index].supplierContractPrice.itemType2Name" style="width: 40px;" type="text" name="priceVoList[$index].supplierContractPrice.itemType2Name" value="0" onblur="$(this).prev().val($(this).val());" /> 座 -
                <input id="priceVoList[$index].supplierContractPrice.itemType3" type="hidden" style="width: 40px;" name="priceVoList[$index].supplierContractPrice.itemType3" />
                <input id="priceVoList[$index].supplierContractPrice.itemType3Name" style="width: 40px;" type="text" name="priceVoList[$index].supplierContractPrice.itemType3Name" value="0" onblur="$(this).prev().val($(this).val());" /> 座
            </td>
            <%--<td>--%>
                <%--<input id="priceVoList[$index].supplierContractPrice.contractPrice" style="width: 40px;" type="text" name="priceVoList[$index].supplierContractPrice.contractPrice" /> 元--%>
            <%--</td>--%>
            <td id="secondLevelPrice_$index">
                <table>
                    <thead>
                    <tr>
                        <td width="20%">线路品牌</td>
                        <td width="8%">结算价</td>
                        <td width="8%">采购价</td>
                        <td width="7%">操作</td>
                    </tr>
                    </thead>
                    <tbody id="secondLevelPriceRow_$index">

                    </tbody>
                </table>
                <a href="javascript:void(0);" onclick="addSecLevelPriceInfoRow('$index', 'secondLevelPriceRow_$index', 'secondLevelPriceData');">添加</a>
            </td>
            <td>
                <textarea id="priceVoList[$index].supplierContractPrice.note" class="control-row4 input-large" style="text-align:center;" name="priceVoList[$index].supplierContractPrice.note" ></textarea>
            </td>
            <td><a class="def" href="javascript:void(0)" onclick="deletePrice(this);">删除</a></td>
        </tr>
        </tbody>
    </table>
</div>

<div id="DeliveryPriceData" style="display : none;">
        <table class="table-style1">
            <tbody>
            <tr>
                <td>
                    <select id="priceVoList[$index].supplierContractPrice.itemType" 
                    		name="priceVoList[$index].supplierContractPrice.itemType" 
                    		onchange="$(this).next('input').val(this.options[this.selectedIndex].text);">
                        <option  value="">请选择</option>
                         <c:if test="${supplierContractVo.supplierInfo.supplierType eq 16}">
                        <c:forEach items="${dictTypeList}" var="type">
                            <option value="${type.id}">${type.value}</option>
                        </c:forEach></c:if>
                    </select>
                    <input type="hidden" id="priceVoList[$index].supplierContractPrice.itemTypeName" 
                    name="priceVoList[$index].supplierContractPrice.itemTypeName" 
                    value="" />
                </td>
                <!--22 一级结算价 -->
                <td><input type="text" id="priceVoList[$index].supplierContractPrice.contractPrice" style="width: 40px;" 
                		name="priceVoList[$index].supplierContractPrice.contractPrice" 
                		value="0.0" />元</td>
                <!--22 一级销售价 -->	
                <td><input type="text" id="priceVoList[$index].supplierContractPrice.contractSale" style="width: 40px;" 
                		name="priceVoList[$index].supplierContractPrice.contractSale" 
                		value="0.0" />元</td>
               
                <td id="secondLevelPrice_$index">
                    <table>
                        <thead>
                            <tr>
                                <td width="20%">线路品牌</td>
                                <td width="8%">结算价</td>
                                <td width="8%">采购价</td>
                                <td width="7%">操作</td>
                            </tr>
                        </thead>
                        <tbody id="secondLevelPriceRow_$index">

                        </tbody>
                    </table>
                    <a href="javascript:void(0);" onclick="addSecLevelPriceInfoRow('$index', 'secondLevelPriceRow_$index', 'secondLevelPriceData');" class="def">添加</a>
                </td>
                 <!--66 方向 -->
                 <td>
                	<label >
                			<input type="radio" id="priceVoList[$index].supplierContractPrice.receivablePayable" 
                				name="priceVoList[$index].supplierContractPrice.receivablePayable" 
                				value="0" />
                				<span>应收</span></label>
					<label >
						<input type="radio" id="priceVoList[$index].supplierContractPrice.receivablePayable" 
							name="priceVoList[$index].supplierContractPrice.receivablePayable" 
							value="1" />
							<span>应付</span></label>
                 </td>
                <td>
                    <textarea id="priceVoList[$index].supplierContractPrice.note" class="control-row4 input-large"  style="text-align:center;" name="priceVoList[$index].supplierContractPrice.note" ></textarea>
                </td>
                <td>
                    <a class="def" href="javascript:void(0)" onclick="deletePrice(this);">删除</a>
                </td>
            </tr>
            </tbody>
        </table>
    </div>

<div id="hotelPriceData" style="display : none;">
    <table class="table-style1">
        <tbody>
        <tr>
            <td>
                <select id="priceVoList[$index].supplierContractPrice.itemType" name="priceVoList[$index].supplierContractPrice.itemType" onchange="$(this).next('input').val(this.options[this.selectedIndex].text);">
                    <option  value="">请选择</option>
                    <c:if test="${supplierContractVo.supplierInfo.supplierType eq 3}">
                    <c:forEach items="${dictTypeList}" var="type">
                        <option value="${type.id}">${type.value}</option>
                    </c:forEach></c:if>
                </select>
                <input type="hidden" id="priceVoList[$index].supplierContractPrice.itemTypeName" name="priceVoList[$index].supplierContractPrice.itemTypeName" value="" />
            </td>
            <%--<td>--%>
                <%--<select id="priceVoList[$index].supplierContractPrice.itemType2" name="priceVoList[$index].supplierContractPrice.itemType2" onchange="$(this).next('input').val(this.options[this.selectedIndex].text);">--%>
                    <%--<option value="">请选择</option>--%>
                    <%--<c:forEach items="${dictType2List}" var="type">--%>
                        <%--<option value="${type.id}">${type.value}</option>--%>
                    <%--</c:forEach>--%>
                <%--</select>--%>
                <%--<input type="hidden" id="priceVoList[$index].supplierContractPrice.itemType2Name" style="width: 40px;" name="priceVoList[$index].supplierContractPrice.itemType2Name" value="" />--%>
            <%--</td>--%>
            <td>
                <input id="priceVoList[$index].supplierContractPrice.contractPrice" style="width: 40px;" type="text" name="priceVoList[$index].supplierContractPrice.contractPrice" value="0" /> 元
            </td>
            <td>
                <input id="priceVoList[$index].supplierContractPrice.contractSale" style="width: 40px;" type="text" name="priceVoList[$index].supplierContractPrice.contractSale" value="0" /> 元
            </td>
            <td>
                满 <input id="priceVoList[$index].supplierContractPrice.derateReach" style="width: 40px;" type="text" name="priceVoList[$index].supplierContractPrice.derateReach" value="0" /> 免 <input id="priceVoList[$index].supplierContractPrice.derateReduction" value="0" style="width: 40px;" type="text" name="priceVoList[$index].supplierContractPrice.derateReduction" />
            </td>
            <td>
                <textarea id="priceVoList[$index].supplierContractPrice.note" class="control-row4 input-large" style="text-align:center;" name="priceVoList[$index].supplierContractPrice.note" ></textarea>
            </td>
            <td>
                <a class="def" href="javascript:void(0)" onclick="deletePrice(this);">删除</a>
            </td>
        </tr>
        </tbody>
    </table>
</div>

<div id="secondLevelPriceData" style="display: none;">
    <table class="table-style1">
        <tbody>
        <tr>
            <td width="20%">
                <select id="priceVoList[$index].priceExtVoList[$secLevel].supplierContractPriceExt.brandId" name="priceVoList[$index].priceExtVoList[$secLevel].supplierContractPriceExt.brandId" onchange="$(this).next('input').val(this.options[this.selectedIndex].text);">
                    <option  value="">请选择</option>
                    <c:forEach items="${dictSecLevelTypeList}" var="type">
                        <option value="${type.id}">${type.value}</option>
                    </c:forEach>
                </select>
                <input type="hidden" id="priceVoList[$index].priceExtVoList[$secLevel].supplierContractPriceExt.brandName" name="priceVoList[$index].priceExtVoList[$secLevel].supplierContractPriceExt.brandName" value="" />
            </td>
            <td width="10%">
                <input id="priceVoList[$index].priceExtVoList[$secLevel].supplierContractPriceExt.price" style="width: 40px;" type="text" name="priceVoList[$index].priceExtVoList[$secLevel].supplierContractPriceExt.price" value="0" /> 元
            </td>
            <td width="10%">
                <input id="priceVoList[$index].priceExtVoList[$secLevel].supplierContractPriceExt.salePrice" style="width: 40px;" type="text" name="priceVoList[$index].priceExtVoList[$secLevel].supplierContractPriceExt.salePrice" value="0" /> 元
            </td>
            <td width="10%">
                <a class="def" href="javascript:void(0)" onclick="deleteSecondLevelPrice(this, '$index',0);">删除</a>
            </td>
        </tr>
        </tbody>
    </table>
</div>

<script type="text/html" id="imgTemp">
    <span class="ulImg">
        <img src="$src" alt="$name"><i class="icon_del delImg" ></i>
        <input type="hidden" name="attachments[$index].imgName" value="$name" />
        <input type="hidden" name="attachments[$index].imgPath" value="$path" />
        <input type="hidden" name="attachments[$index].bussniessType" value="3" />
        </span>
</script>
<script type="text/javascript">
    var path = '<%=path%>';
    $(function () {
        var $contractInfo = $('#contractInfo');
        var $priceTable = $('#priceTable');
        var $commonPriceTable = $('#commonPrice');
        var $shopPriceTable = $('#shopPrice');
        var $fleetPriceTable = $('#fleetPrice');
        var $hotelPriceTable = $('#hotelPrice');
        var $deliveryPriceTable = $('#DeliveryPrice');
        
        var supplierType = $('#supplierType').val();
        if (supplierType == 1) {
            $contractInfo.html($('#agency').html());
        } else {
            $contractInfo.html($('#others').html());
            if (supplierType == '${SHOPPING}') {
                $('#priceTable').html($shopPriceTable.html());
//                    addPriceInfoRow('shopPriceRow', 'shopPriceData');
            } else if('temp' == '${deliveryType}'){
                //console.log($deliveryPriceTable.html());
                $('#priceTable').html($deliveryPriceTable.html());
                //addPriceInfoRow('DeliveryPriceRow', 'DeliveryPriceData');
                //addSecLevelPriceInfoRow('0', 'secondLevelPriceRow_0', 'secondLevelPriceData');
            }else if (supplierType == '${FLEET}') {
                $('#priceTable').html($fleetPriceTable.html());
//                    addPriceInfoRow('fleetPriceRow', 'fleetPriceData');
//                    addSecLevelPriceInfoRow('0', 'secondLevelPriceRow_0', 'secondLevelPriceData');
            } else if (supplierType == '${HOTEL}') {
                $('#priceTable').html($hotelPriceTable.html());
//                    addPriceInfoRow('hotelPriceRow', 'hotelPriceData');
            } else {
                $('#priceTable').html($commonPriceTable.html());
//                    addPriceInfoRow('commonPriceRow', 'commonPriceData');
            }
        }
        $(".delImg").live("click",function(){
            var siblings = $(this).parent().siblings();
            $(this).parent().remove();
            siblings.each(function(index){
                var founds = $(this).find("[name^='attachments']");
                founds.each(function(){
                    $(this).attr('name', $(this).attr('name').replace(/attachments\[\d+]/g, 'attachments[' + index + ']'));
                });

            });
        });
    });
</script>

</body>
</html>
