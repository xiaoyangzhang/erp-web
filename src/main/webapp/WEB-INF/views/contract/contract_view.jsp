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

</head>
<body>
<div class="p_container">
    <div class="p_container_sub">
        <form id="contractForm" action="" method="post" enctype="multipart/form-data">
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

            <p class="p_paragraph_title"><b>合同信息:</b></p>
            <div id="contractInfo">


            </div>
            <dl class="p_paragraph_content">
                <dd class="Footer">
                    <div class="dd_left"></div>
                    <div class="dd_right">
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
                <input id="contractName_agency" type="text" name="supplierContract.contractName" readonly value="${supplierContractVo.supplierContract.contractName}" />
            </div>
            <div class="clear"></div>
        </dd>

        <dd>
            <div class="dd_left"><i class="red">* </i>开始日期：</div>
            <div class="dd_right">
                <input id="startDate_agency" type="text" name="supplierContract.startDate" readonly value="<fmt:formatDate value='${supplierContractVo.supplierContract.startDate}' pattern='yyyy-MM-dd' />" />
            </div>

            <div class="dd_left"><i class="red">* </i>结束日期：</div>
            <div class="dd_right">
                <input id="endDate_agency" type="text" name="supplierContract.endDate" readonly value="<fmt:formatDate value='${supplierContractVo.supplierContract.endDate}' pattern='yyyy-MM-dd' />" />
            </div>

            <div class="dd_left"><i class="red">* </i>签订日期：</div>
            <div class="dd_right">
                <input id="signDate_agency" type="text" name="supplierContract.signDate" readonly
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
                <%--<input id="datePriority_agency" type="text" name="supplierContract.datePriority" readonly value="${supplierContractVo.supplierContract.datePriority}" /> <i class="grey ml-10">请填写数字</i>--%>
            </div>
            <div class="clear"></div>
        </dd>

        <dd>
            <div class="dd_left">结算方式：</div>
            <div class="dd_right">
                <input type="text" name="supplierContract.settlementDays" readonly value="${supplierContractVo.supplierContract.settlementDays}" placeholder="45" />天，
                <input type="text" name="supplierContract.settlementDesp" readonly value="${supplierContractVo.supplierContract.settlementDesp}" placeholder="一个半月结清" />
            </div>
            <div class="clear"></div>
        </dd>

        <dd>
            <div class="dd_left">团类别：</div>
            <div class="dd_right">
                <label>
                    <input type="radio" name="supplierContract.groupType" value="1" <c:if
                            test="${supplierContractVo.supplierContract.groupType == 1}">checked</c:if> disabled />所有
                </label>
                <label>
                    <input type="radio" name="supplierContract.groupType" value="2" <c:if
                            test="${supplierContractVo.supplierContract.groupType == 2}">checked</c:if> disabled />团队(代订\会展)
                </label>
                <label>
                    <input type="radio" name="supplierContract.groupType" value="3" <c:if
                            test="${supplierContractVo.supplierContract.groupType == 3}">checked</c:if> disabled />散客
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
                <input id="exceedDays_agency" type="text" name="supplierContract.exceedDays" value="${supplierContractVo.supplierContract.exceedDays}" readonly />
            </div>
            <div class="clear"></div>
        </dd>

        <dd>
            <div class="dd_left">最大欠款额度：</div>
            <div class="dd_right">
                <input id="maxDebt_agency" type="text" name="supplierContract.maxDebt" value="${supplierContractVo.supplierContract.maxDebt}" readonly />
            </div>
            <div class="clear"></div>
        </dd>

        <dd>
            <div class="dd_left">超出额度：</div>
            <div class="dd_right">
                <input id="exceedAmount_agency" type="text" name="supplierContract.exceedAmount" value="${supplierContractVo.supplierContract.exceedAmount}" readonly />
            </div>
            <div class="clear"></div>
        </dd>

        <dd>
            <div class="dd_left">开票要求：</div>
            <div class="dd_right">
                <textarea id="billDemand_agency" class="w_textarea" name="supplierContract.billDemand" readonly >${supplierContractVo.supplierContract.billDemand}</textarea>
            </div>
            <div class="clear"></div>
        </dd>

        <dd>
            <div class="dd_left">备注：</div>
            <div class="dd_right">
                <textarea id="note_agency" class="w_textarea" name="supplierContract.note" readonly >${supplierContractVo.supplierContract.note}</textarea>
            </div>

            <div class="clear"></div>
        </dd>

        <dd>
            <div class="dd_left">返款政策：</div>
            <div class="dd_right">
                <textarea id="rebatePolicy_agency" class="w_textarea" name="supplierContract.rebatePolicy" readonly>${supplierContractVo.supplierContract.rebatePolicy}</textarea>
            </div>
            <div class="clear"></div>
        </dd>

        <dd>
            <div class="dd_left">文档图片：</div>
            <div class="dd_right" id="attachments">
                <c:forEach items="${supplierContractVo.attachments}" var="attachment" varStatus="a">
	    				<span class="ulImg">
							<img src="${config.images200Url }${cf:thumbnail(attachment.imgPath,'200x200')}" alt="">
							<input type="hidden" name="attachments[${a.index }].imgName" value="${attachment.imgName }" />
							<input type="hidden" name="attachments[${a.index }].imgPath" value="${attachment.imgPath}" />
							<input type="hidden" name="attachments[${a.index }].bussniessType" value="3" />
						</span>
                </c:forEach>
                <!-- <span class="ulImg"><img src="imgTemp/upImgDefault.png" alt=""><i class="w_icon_del"></i></span> -->

            </div>
            <div class="clear"></div>
        </dd>
    </dl>

</div>

<div id="others" style="display: none;">
    <dl class="p_paragraph_content">
        <dd>
            <div class="dd_left"><i class="red">* </i>合同名称：</div>
            <div class="dd_right">
                <input id="contractName" type="text" name="supplierContract.contractName" value="${supplierContractVo.supplierContract.contractName}" readonly class="IptText300" />
            </div>
            <div class="clear"></div>
        </dd>
        <dd>
            <div class="dd_left"><i class="red">* </i>开始日期：</div>
            <div class="dd_right">
                <input id="startDate" type="text" name="supplierContract.startDate" value="<fmt:formatDate value='${supplierContractVo.supplierContract.startDate}' pattern='yyyy-MM-dd' />" readonly />
            </div>
            <div class="clear"></div>
        </dd>
        <dd>
            <div class="dd_left"><i class="red">* </i>结束日期：</div>
            <div class="dd_right">
                <input id="endDate" type="text" name="supplierContract.endDate" value="<fmt:formatDate value='${supplierContractVo.supplierContract.endDate}' pattern='yyyy-MM-dd' />" readonly />
            </div>
            <div class="clear"></div>
        </dd>
        <dd>
            <div class="dd_left"><i class="red">* </i>签订日期：</div>
            <div class="dd_right">
                <input id="signDate" type="text" name="supplierContract.signDate" value="<fmt:formatDate value='${supplierContractVo.supplierContract.signDate}' pattern='yyyy-MM-dd' />" readonly />
            </div>
            <div class="clear"></div>
        </dd>
        <dd>
            <div class="dd_left">返款政策：</div>
            <div class="dd_right">
            <c:if test="${optMap['SUPPLIER_CONTRACT_EDIT']}">
                <textarea id="rebatePolicy" class="w_textarea" name="supplierContract.rebatePolicy" readonly >${supplierContractVo.supplierContract.rebatePolicy}</textarea>
                </c:if>
            </div>
            <div class="clear"></div>
        </dd>
        <dd>
            <div class="dd_left"><i class="red">* </i>日期优先级：</div>
            <div class="dd_right">
                <select id="datePriority" name="supplierContract.datePriority">
                    <option value="1" <c:if test="${supplierContractVo.supplierContract.datePriority == 1}">selected="selected"</c:if> >1</option>
                    <option value="2" <c:if test="${supplierContractVo.supplierContract.datePriority == 2}">selected="selected"</c:if> >2</option>
                    <option value="3" <c:if test="${supplierContractVo.supplierContract.datePriority == 3}">selected="selected"</c:if> >3</option>
                    <option value="4" <c:if test="${supplierContractVo.supplierContract.datePriority == 4}">selected="selected"</c:if> >4</option>
                    <option value="5" <c:if test="${supplierContractVo.supplierContract.datePriority == 5}">selected="selected"</c:if> >5</option>
                </select>
                <%--<input id="datePriority" type="text" name="supplierContract.datePriority" value="${supplierContractVo.supplierContract.datePriority}" readonly /> <i class="grey ml-10">请填写数字</i>--%>
            </div>
            <div class="clear"></div>
        </dd>
        <dd>
            <div class="dd_left">备注：</div>
            <div class="dd_right">
                <textarea id="note" class="w_textarea" name="supplierContract.note" readonly >${supplierContractVo.supplierContract.note}</textarea>
            </div>
            <div class="clear"></div>
        </dd>
        <dd>
            <div class="dd_left">结算方式：</div>
            <div class="dd_right">
            <select name="supplierContract.settlementMethod" id="settlementMethod" disabled>
								
								
								
										<option ></option>
									<c:forEach items="${cashTypes }" var="type">
										<option <c:if test="${supplierContractVo.supplierContract.settlementMethod eq type.id }">selected</c:if>  >${type.value }</option>
									</c:forEach>
								
							</select>
                <%-- <label for="settlementMethodElement1"><input id="settlementMethodElement1" type="checkbox" disabled
                                                             name="settlementMethodList" value="1" <c:if test="${supplierContractVo.supplierContract.settlementMethod == 1 or supplierContractVo.supplierContract.settlementMethod == 3}">checked</c:if> />签单</label>
                <label for="settlementMethodElement2"><input id="settlementMethodElement2" type="checkbox" disabled
                                                             name="settlementMethodList" value="2" <c:if test="${supplierContractVo.supplierContract.settlementMethod == 2 or supplierContractVo.supplierContract.settlementMethod == 3}">checked</c:if> />现付</label>
            --%> </div>
            <div class="clear"></div>
        </dd>
        <dd>
            <div class="dd_left">文档图片：</div>
            <div class="dd_right" id="attachments">
                <c:forEach items="${supplierContractVo.attachments}" var="attachment" varStatus="a">
	    				<span class="ulImg">
							<img src="${config.images200Url }${cf:thumbnail(attachment.imgPath,'200x200')}" alt="">
							<input type="hidden" name="attachments[${a.index }].imgName" value="${attachment.imgName }" />
							<input type="hidden" name="attachments[${a.index }].imgPath" value="${attachment.imgPath}" />
							<input type="hidden" name="attachments[${a.index }].bussniessType" value="3" />
						</span>
                </c:forEach>
                <!-- <span class="ulImg"><img src="imgTemp/upImgDefault.png" alt=""><i class="w_icon_del"></i></span> -->

            </div>
            <div class="clear"></div>
        </dd>
    </dl>


    <p class="p_paragraph_title"><b>价格信息:</b></p>
    <dl class="p_paragraph_content">
        <dd>
            <div class="dd_left"></div>
            <div class="dd_right" style="width:80%" id="priceTable">

            </div>
            <div class="clear"></div>
        </dd>
    </dl>

</div>

<c:choose>
    <c:when test="${SHOPPING == supplierContractVo.supplierInfo.supplierType}">
        <div id="shopPrice" style="display: none;">
            <%--<button type="button" onclick="addPriceInfoRow('shopPriceRow', 'shopPriceData');" class="button button-primary button-small" >添加</button>--%>
            <table cellspacing="0" class="w_table">
                <colgroup>
                    <col width="30%" />
                    <col width="30%" />
                    <col width="40%" />
                    <%--<col width="30%" />--%>
                    <%--<col width="10%" />--%>
                </colgroup>
                <thead>
                <tr>
                    <th>商品类别<i class="w_table_split"></i></th>
                    <%--<th>正/特价<i class="w_table_split"></i></th>--%>
                    <th>返款模式<i class="w_table_split"></i></th>
                    <th>备注<i class="w_table_split"></i></th>
                    <%--<th>操作</th>--%>
                </tr>
                </thead>
                <tbody id="shopPriceRow">
                <c:forEach items="${supplierContractVo.priceVoList}" var="priceVo" varStatus="s">
                    <tr>
                        <td>
                            <input type="hidden" id="priceVoList[${s.index}].supplierContractPrice.id" name="priceVoList[${s.index}].supplierContractPrice.id" value="${priceVo.supplierContractPrice.id}" />
                            <input type="hidden" id="priceVoList[${s.index}].supplierContractPrice.contractId" name="priceVoList[${s.index}].supplierContractPrice.contractId" value="${priceVo.supplierContractPrice.contractId}" />
                            <select id="priceVoList[${s.index}].supplierContractPrice.itemType" name="priceVoList[${s.index}].supplierContractPrice.itemType" disabled
                                    onchange="$(this).next('input').val(this.options[this.selectedIndex].text);" >
                                <option value="">请选择</option>
                                <c:if test="${supplierContractVo.supplierInfo.supplierType eq 6 }">
                            <c:forEach items="${dictTypeList}" var="type">
                                <option value="${type.id}" <c:if test="${priceVo.supplierContractPrice.itemType == type.id}">selected</c:if>>${type.itemName}</option>
                            </c:forEach></c:if>
                            
                                <%-- <c:forEach items="${dictTypeList}" var="type">
                                    <option value="${type.id}" <c:if test="${priceVo.supplierContractPrice.itemType == type.id}">selected</c:if>>${type.value}</option>
                                </c:forEach> --%>
                            </select>
                            <input type="hidden" id="priceVoList[${s.index}].supplierContractPrice.itemTypeName" name="priceVoList[${s.index}].supplierContractPrice.itemTypeName"
                                   value="${priceVo.supplierContractPrice.itemTypeName}"/>
                        </td>
                        <%--<td>--%>
                            <%--<select id="priceVoList[${s.index}].supplierContractPrice.itemType2" name="priceVoList[${s.index}].supplierContractPrice.itemType2" disabled--%>
                                    <%--onchange="$(this).next('input').val(this.options[this.selectedIndex].text);" >--%>
                                <%--<option value="1" <c:if test="${priceVo.supplierContractPrice.itemType2 == 1}">selected="selected"</c:if>>正价</option>--%>
                                <%--<option value="2" <c:if test="${priceVo.supplierContractPrice.itemType2 == 2}">selected="selected"</c:if>>特价</option>--%>
                            <%--</select>--%>
                            <%--<input type="hidden" id="priceVoList[${s.index}].supplierContractPrice.itemType2Name" name="priceVoList[${s.index}].supplierContractPrice.itemType2Name"--%>
                                   <%--value="<c:if test="${priceVo.supplierContractPrice.itemType2 == 1}">正价</c:if><c:if test="${priceVo.supplierContractPrice.itemType2 == 2}">特价</c:if>"/>--%>
                        <%--</td>--%>
                        <td>
                            	按销售金额返款&nbsp;&nbsp;返款&nbsp;<input
                                id="priceVoList[${s.index}].supplierContractPrice.rebateAmountPercent" type="text" readonly style="width: 40px;"
                                name="priceVoList[${s.index}].supplierContractPrice.rebateAmountPercent" value="<c:if test="${priceVo.supplierContractPrice.rebateMethod == 1}">${priceVo.supplierContractPrice.rebateAmount}</c:if>" /> %
                            <%-- <br/>
                            <input type="radio" name="priceVoList[${s.index}].supplierContractPrice.rebateMethod" value="2" style="width: 40px;" readonly <c:if test="${priceVo.supplierContractPrice.rebateMethod == 2}">checked</c:if> />按销售数量返款&nbsp;&nbsp;返款&nbsp;<input
                                id="priceVoList[${s.index}].supplierContractPrice.rebateAmount" type="text" readonly style="width: 40px;"
                                name="priceVoList[${s.index}].supplierContractPrice.rebateAmount" value="<c:if test="${priceVo.supplierContractPrice.rebateMethod == 2}">${priceVo.supplierContractPrice.rebateAmount}</c:if>" /> 元
                        --%> </td>
                        <td>
                            <textarea id="priceVoList[${s.index}].supplierContractPrice.note" class="control-row4 input-large" name="priceVoList[${s.index}].supplierContractPrice.note" readonly>${priceVo.supplierContractPrice.note}</textarea>
                        </td>
                        <%--<td><a class="button button-rounded button-tinier" href="javascript:void(0)" onclick="deletePrice(this);">删除</a></td>--%>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>

    </c:when>
    <c:when test="${FLEET == supplierContractVo.supplierInfo.supplierType}">
        <div id="fleetPrice" style="display: none;">
            <%--<button type="button" onclick="addPriceInfoRow('fleetPriceRow', 'fleetPriceData');" class="button button-primary button-small" >添加</button>--%>
            <table cellspacing="0" class="w_table">
                <colgroup>
                    <col width="15%" />
                    <col width="15%" />
                    <%--<col width="20%" />--%>
                    <col width="50%" />
                    <col width="20%" />
                    <%--<col width="10%" />--%>
                </colgroup>
                <thead>
                <tr>
                    <th>车型<i class="w_table_split"></i></th>
                    <th>座位数<i class="w_table_split"></i></th>
                    <%--<th>协议价<i class="w_table_split"></i></th>--%>
                    <th>二级协议价<i class="w_table_split"></i></th>
                    <th>备注<i class="w_table_split"></i></th>
                    <%--<th>操作</th>--%>
                </tr>
                </thead>
                <tbody id="fleetPriceRow">
                <c:forEach items="${supplierContractVo.priceVoList}" var="priceVo" varStatus="s">
                    <tr>
                        <td>
                            <input type="hidden" id="priceVoList[${s.index}].supplierContractPrice.id" name="priceVoList[${s.index}].supplierContractPrice.id" value="${priceVo.supplierContractPrice.id}" />
                            <input type="hidden" id="priceVoList[${s.index}].supplierContractPrice.contractId" name="priceVoList[${s.index}].supplierContractPrice.contractId" value="${priceVo.supplierContractPrice.contractId}" />
                            <select id="priceVoList[${s.index}].supplierContractPrice.itemType" name="priceVoList[${s.index}].supplierContractPrice.itemType" disabled
                                    onchange="$(this).next('input').val(this.options[this.selectedIndex].text);" >
                                <option value="">请选择</option>
                                <c:if test="${supplierContractVo.supplierInfo.supplierType eq 4}">
                            <c:forEach items="${dictTypeList}" var="type">
                                <option value="${type.id}" <c:if test="${priceVo.supplierContractPrice.itemType == type.id}">selected</c:if>>${type.value}</option>
                            </c:forEach></c:if>
                               <%--  <c:forEach items="${dictTypeList}" var="type">
                                    <option value="${type.id}" <c:if test="${priceVo.supplierContractPrice.itemType == type.id}">selected</c:if>>${type.value}</option>
                                </c:forEach> --%>
                            </select>
                            <input id="priceVoList[${s.index}].supplierContractPrice.itemTypeName" type="hidden" name="priceVoList[${s.index}].supplierContractPrice.itemTypeName" value="${priceVo.supplierContractPrice.itemTypeName}"/>
                        </td>
                        <td>
                            <input id="priceVoList[${s.index}].supplierContractPrice.itemType2" type="hidden" style="width: 40px;" name="priceVoList[${s.index}].supplierContractPrice.itemType2" value="${priceVo.supplierContractPrice.itemType2}" />
                            <input id="priceVoList[${s.index}].supplierContractPrice.itemType2Name" type="text" readonly style="width: 40px;" onblur="$(this).prev().val($(this).val());"
                                   name="priceVoList[${s.index}].supplierContractPrice.itemType2Name" value="${priceVo.supplierContractPrice.itemType2Name}" /> 座 -
                            <input id="priceVoList[${s.index}].supplierContractPrice.itemType3" type="hidden" style="width: 40px;" name="priceVoList[${s.index}].supplierContractPrice.itemType3" value="${priceVo.supplierContractPrice.itemType3}" />
                            <input id="priceVoList[${s.index}].supplierContractPrice.itemType3Name" type="text" readonly style="width: 40px;" onblur="$(this).prev().val($(this).val());"
                                   name="priceVoList[${s.index}].supplierContractPrice.itemType3Name" value="${priceVo.supplierContractPrice.itemType3Name}" /> 座
                        </td>
                        <%--<td>--%>
                            <%--<input id="priceVoList[${s.index}].supplierContractPrice.contractPrice" type="text" readonly style="width: 40px;"--%>
                                   <%--name="priceVoList[${s.index}].supplierContractPrice.contractPrice" value="${priceVo.supplierContractPrice.contractPrice}" /> 元--%>
                        <%--</td>--%>
                        <td id="secondLevelPrice_${s.index}">
                            <table>
                                <thead>
                                <tr>
                                    <td width="15%">线路品牌</td>
                                    <td width="10%" >备注</td>
                                    <td width="8%">采购价</td>
                                    <td width="8%">结算价</td>
                                    <!-- <td>价格/元</td> -->
                                    <%--<td>操作</td>--%>
                                </tr>
                                </thead>
                                <tbody id="secondLevelPriceRow_${s.index}" >
                                <c:forEach items="${priceVo.priceExtVoList}" var="priceExtVo" varStatus="s2">
                                    <tr>
                                        <td>
                                            <input type="hidden" id="priceVoList[${s.index}].priceExtVoList[${s2.index}].supplierContractPriceExt.id" name="priceVoList[${s.index}].priceExtVoList[${s2.index}].supplierContractPriceExt.id" value="${priceExtVo.supplierContractPriceExt.id}" />
                                            <input type="hidden" id="priceVoList[${s.index}].priceExtVoList[${s2.index}].supplierContractPriceExt.priceId" name="priceVoList[${s.index}].priceExtVoList[${s2.index}].supplierContractPriceExt.priceId" value="${priceExtVo.supplierContractPriceExt.priceId}" />
                                            <select id="priceVoList[${s.index}].priceExtVoList[${s2.index}].supplierContractPriceExt.brandId" name="priceVoList[${s.index}].priceExtVoList[${s2.index}].supplierContractPriceExt.brandId" disabled
                                                    onchange="$(this).next('input').val(this.options[this.selectedIndex].text);" >
                                                <option value="">请选择</option>
                                                <c:forEach items="${dictSecLevelTypeList}" var="type">
                                                    <option value="${type.id}" <c:if test="${priceExtVo.supplierContractPriceExt.brandId == type.id}">selected</c:if>>${type.value}</option>
                                                </c:forEach>
                                            </select>
                                            <input type="hidden" id="priceVoList[${s.index}].priceExtVoList[${s2.index}].supplierContractPriceExt.brandName" readonly style="width: 40px;"
                                                   name="priceVoList[${s.index}].priceExtVoList[${s2.index}].supplierContractPriceExt.brandName"
                                                   value="${priceExtVo.supplierContractPriceExt.brandName}"/>
                                        </td>
                                         <!-- 备注1 -->
	                                    <td><input type="text" id="priceVoList[${s.index}].priceExtVoList[${s2.index}].supplierContractPriceExt.remark" style="width: 90%;"
	                                               name="priceVoList[${s.index}].priceExtVoList[${s2.index}].supplierContractPriceExt.remark"
	                                               value="${priceExtVo.supplierContractPriceExt.remark}"/>
	                                    </td>
                                        <td>
                                            <input id="priceVoList[${s.index}].priceExtVoList[${s2.index}].supplierContractPriceExt.price" type="text" readonly style="width: 40px;"
                                                   name="priceVoList[${s.index}].priceExtVoList[${s2.index}].supplierContractPriceExt.price" value="${priceExtVo.supplierContractPriceExt.price}" /> 元
                                        </td>
                                        <td>
                                            <input id="priceVoList[${s.index}].priceExtVoList[${s2.index}].supplierContractPriceExt.salePrice" type="text" readonly style="width: 40px;"
                                                   name="priceVoList[${s.index}].priceExtVoList[${s2.index}].supplierContractPriceExt.salePrice" value="${priceExtVo.supplierContractPriceExt.salePrice}" /> 元
                                        </td>
                                        <%--<td>--%>
                                            <%--<a class="button button-rounded button-tinier" href="javascript:void(0)" onclick="deleteSecondLevelPrice(this, '${s.index}');">删除</a>--%>
                                        <%--</td>--%>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </td>
                        <td>
                            <textarea id="priceVoList[${s.index}].supplierContractPrice.note" class="control-row4 input-large" name="priceVoList[${s.index}].supplierContractPrice.note" readonly >${priceVo.supplierContractPrice.note}</textarea>
                        </td>
                        <%--<td><a class="button button-rounded button-tinier" href="javascript:void(0)" onclick="deletePrice(this);">删除</a></td>--%>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>



        <%--<div id="fleetPrice" style="display: none;">--%>
        <%--<table class="table table-bordered table-hover definewidth m10">--%>
        <%--<thead>--%>
        <%--<tr>--%>
        <%--<td colspan="6">价格明细--%>
        <%--<button type="button" onclick="addPriceInfoRow('fleetPriceRow', 'fleetPriceData');"--%>
        <%--style="float: right">添加--%>
        <%--</button>--%>
        <%--</td>--%>
        <%--</tr>--%>
        <%--<tr>--%>
        <%--<td>车型</td>--%>
        <%--<td>座位数</td>--%>
        <%--<td>协议价</td>--%>
        <%--<td>二级协议价</td>--%>
        <%--<td>备注</td>--%>
        <%--<td>操作</td>--%>
        <%--</tr>--%>
        <%--</thead>--%>
        <%--<tbody id="fleetPriceRow">--%>
        <%----%>
        <%--</tbody>--%>
        <%--</table>--%>
        <%--</div>--%>
    </c:when>
    
    <c:when test="${HOTEL == supplierContractVo.supplierInfo.supplierType}">
        <div id="hotelPrice" style="display: none;">
            <%--<button type="button" onclick="addPriceInfoRow('hotelPriceRow', 'hotelPriceData');" class="button button-primary button-small">添加</button>--%>
            <table cellspacing="0" class="w_table">
                <colgroup>
                    <col width="10%" />
<%--                     <col width="10%" />
 --%>                    <col width="30%" />
                    <col width="40%" />
                    <col width="20%" />
                    <%--<col width="10%" />--%>
                </colgroup>
                <thead>
                <tr>
                    <th>类别<i class="w_table_split"></i></th>
                    <!-- <th>房型<i class="w_table_split"></i></th> -->
                    <th>采购价<i class="w_table_split"></i></th>
                    <th>结算价<i class="w_table_split"></i></th>
                    <th>减免政策<i class="w_table_split"></i></th>
                    <th>备注<i class="w_table_split"></i></th>
                    <%--<th>操作</th>--%>
                </tr>
                </thead>
                <tbody id="hotelPriceRow">
                <c:forEach items="${supplierContractVo.priceVoList}" var="priceVo" varStatus="s">
                    <tr>
                        <td>
                            <input type="hidden" id="priceVoList[${s.index}].supplierContractPrice.id" name="priceVoList[${s.index}].supplierContractPrice.id" value="${priceVo.supplierContractPrice.id}" />
                            <input type="hidden" id="priceVoList[${s.index}].supplierContractPrice.contractId" name="priceVoList[${s.index}].supplierContractPrice.contractId" value="${priceVo.supplierContractPrice.contractId}" />
                            <select id="priceVoList[${s.index}].supplierContractPrice.itemType" name="priceVoList[${s.index}].supplierContractPrice.itemType" disabled
                                    onchange="$(this).next('input').val(this.options[this.selectedIndex].text);" >
                                <option value="">请选择</option>
                                <c:if test="${supplierContractVo.supplierInfo.supplierType eq 3}">
                            <c:forEach items="${dictTypeList}" var="type">
                                <option value="${type.id}" <c:if test="${priceVo.supplierContractPrice.itemType == type.id}">selected</c:if>>${type.value}</option>
                            </c:forEach></c:if>
                               <%--  <c:forEach items="${dictTypeList}" var="type">
                                    <option value="${type.id}" <c:if test="${priceVo.supplierContractPrice.itemType == type.id}">selected</c:if>>${type.value}</option>
                                </c:forEach> --%>
                            </select>
                            <input type="hidden" id="priceVoList[${s.index}].supplierContractPrice.itemTypeName" name="priceVoList[${s.index}].supplierContractPrice.itemTypeName"
                                   value="${priceVo.supplierContractPrice.itemTypeName}"/>
                        </td>
                       <%--  <td>
                            <select id="priceVoList[${s.index}].supplierContractPrice.itemType2" name="priceVoList[${s.index}].supplierContractPrice.itemType2" disabled
                                    onchange="$(this).next('input').val(this.options[this.selectedIndex].text);" >
                                <option value="">请选择</option>
                                <c:forEach items="${dictType2List}" var="type">
                                    <option value="${type.id}" <c:if test="${priceVo.supplierContractPrice.itemType2 == type.id}">selected</c:if>>${type.value}</option>
                                </c:forEach>
                            </select>
                            <input type="hidden" id="priceVoList[${s.index}].supplierContractPrice.itemType2Name" name="priceVoList[${s.index}].supplierContractPrice.itemType2Name" value="${priceVo.supplierContractPrice.itemType2Name}" />
                        </td> --%>
                        <td>
                            <input id="priceVoList[${s.index}].supplierContractPrice.contractPrice"  type="text" readonly style="width: 40px;"
                                   name="priceVoList[${s.index}].supplierContractPrice.contractPrice"
                                   value="${priceVo.supplierContractPrice.contractPrice}"  /> 元
                        </td>
                        <td>
                            <input id="priceVoList[${s.index}].supplierContractPrice.contractSale"  type="text" readonly style="width: 40px;"
                                   name="priceVoList[${s.index}].supplierContractPrice.contractSale"
                                   value="${priceVo.supplierContractPrice.contractSale}"  /> 元
                        </td>
                        <td>
                            满 <input id="priceVoList[${s.index}].supplierContractPrice.derateReach" type="text" readonly style="width: 40px;"
                                     name="priceVoList[${s.index}].supplierContractPrice.derateReach"
                                     value="${priceVo.supplierContractPrice.derateReach}" /> 免 <input readonly
                                id="priceVoList[${s.index}].supplierContractPrice.derateReduction" type="text" style="width: 40px;"
                                name="priceVoList[${s.index}].supplierContractPrice.derateReduction"
                                value="${priceVo.supplierContractPrice.derateReduction}" />
                        </td>
                        <td>
                            <textarea id="priceVoList[${s.index}].supplierContractPrice.note" class="control-row4 input-large" readonly
                                      name="priceVoList[${s.index}].supplierContractPrice.note" >${priceVo.supplierContractPrice.note}</textarea>
                        </td>
                        <%--<td><a class="button button-rounded button-tinier" href="javascript:void(0)" onclick="deletePrice(this);">删除</a></td>--%>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>


        <%--<div id="hotelPrice" style="display: none;">--%>
        <%--<table class="table table-bordered table-hover definewidth m10">--%>
        <%--<thead>--%>
        <%--<tr>--%>
        <%--<td colspan="6">价格明细--%>
        <%--<button type="button" onclick="addPriceInfoRow('hotelPriceRow', 'hotelPriceData');"--%>
        <%--style="float: right">添加--%>
        <%--</button>--%>
        <%--</td>--%>
        <%--</tr>--%>
        <%--<tr>--%>
        <%--<td>类别</td>--%>
        <%--<td>房型</td>--%>
        <%--<td>协议价</td>--%>
        <%--<td>减免政策</td>--%>
        <%--<td>备注</td>--%>
        <%--<td>操作</td>--%>
        <%--</tr>--%>
        <%--</thead>--%>
        <%--<tbody id="hotelPriceRow">--%>
        <%----%>
        <%--</tbody>--%>
        <%--</table>--%>
        <%--</div>--%>
    </c:when>
    <c:otherwise>
        <div id="commonPrice" style="display: none;">
            <%--<button type="button" onclick="addPriceInfoRow('commonPriceRow', 'commonPriceData');" class="button button-primary button-small" >添加</button>--%>
            <table cellspacing="0" class="w_table">
                <colgroup>
                    <col width="20%" />
                    <col width="20%" />
                    <col width="30%" />
                    <col width="30%" />
                    <%--<col width="10%" />--%>
                </colgroup>
                <thead>
                <tr>
                    <th>项目<i class="w_table_split"></i></th>
                    <th>采购价<i class="w_table_split"></i></th>
                    <th>结算价<i class="w_table_split"></i></th>
                    <th>减免政策<i class="w_table_split"></i></th>
                    <th>备注<i class="w_table_split"></i></th>
                    <%--<th>操作</th>--%>
                </tr>
                </thead>
                <tbody id="commonPriceRow">
                <c:forEach items="${supplierContractVo.priceVoList}" var="priceVo" varStatus="s">
                    <tr>
                        <td>
                            <input type="hidden" id="priceVoList[${s.index}].supplierContractPrice.id" name="priceVoList[${s.index}].supplierContractPrice.id" value="${priceVo.supplierContractPrice.id}" />
                            <input type="hidden" id="priceVoList[${s.index}].supplierContractPrice.contractId" name="priceVoList[${s.index}].supplierContractPrice.contractId" value="${priceVo.supplierContractPrice.contractId}" />
                            <select id="priceVoList[${s.index}].supplierContractPrice.itemType" name="priceVoList[${s.index}].supplierContractPrice.itemType" disabled
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
                            <input id="priceVoList[${s.index}].supplierContractPrice.contractPrice" type="text" readonly style="width: 40px;"
                                   name="priceVoList[${s.index}].supplierContractPrice.contractPrice" value="${priceVo.supplierContractPrice.contractPrice}" /> 元
                        </td>
                         <td>
                            <input id="priceVoList[${s.index}].supplierContractPrice.contractSale" type="text" readonly style="width: 40px;"
                                   name="priceVoList[${s.index}].supplierContractPrice.contractSale" value="${priceVo.supplierContractPrice.contractSale}" /> 元
                        </td>
                        <td>
                            满 <input id="priceVoList[${s.index}].supplierContractPrice.derateReach" type="text" readonly style="width: 40px;"
                                     name="priceVoList[${s.index}].supplierContractPrice.derateReach" value="${priceVo.supplierContractPrice.derateReach}" /> 免
                            <input id="priceVoList[${s.index}].supplierContractPrice.derateReduction" type="text" readonly style="width: 40px;"
                                   name="priceVoList[${s.index}].supplierContractPrice.derateReduction" value="${priceVo.supplierContractPrice.derateReduction}" />
                        </td>
                        <td>
                        <textarea id="priceVoList[${s.index}].supplierContractPrice.note" class="control-row4 input-large" readonly
                                  name="priceVoList[${s.index}].supplierContractPrice.note" >${priceVo.supplierContractPrice.note}</textarea>
                        </td>
                        <%--<td><a class="button button-rounded button-tinier" href="javascript:void(0)" onclick="deletePrice(this);">删除</a></td>--%>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>


        <%--<div id="commonPrice" style="display: none;">--%>
        <%--<table class="table table-bordered table-hover definewidth m10">--%>
        <%--<thead>--%>
        <%--<tr>--%>
        <%--<td colspan="5">价格明细--%>
        <%--<button type="button" onclick="addPriceInfoRow('commonPriceRow', 'commonPriceData');"--%>
        <%--style="float: right">添加--%>
        <%--</button>--%>
        <%--</td>--%>
        <%--</tr>--%>
        <%--<tr>--%>
        <%--<td>项目</td>--%>
        <%--<td>协议价</td>--%>
        <%--<td>减免政策</td>--%>
        <%--<td>备注</td>--%>
        <%--<td>操作</td>--%>
        <%--</tr>--%>
        <%--</thead>--%>
        <%--<tbody id="commonPriceRow">--%>
        <%----%>
        <%--</tbody>--%>
        <%--</table>--%>
        <%--</div>--%>
    </c:otherwise>
</c:choose>


<%--price data columns--%>

<div id="commonPriceData" style="display : none;">
    <table class="table-style1">
        <tbody>
        <tr>
            <td>
                <select id="priceVoList[$index].supplierContractPrice.itemType" disabled name="priceVoList[$index].supplierContractPrice.itemType" onchange="$(this).next('input').val(this.options[this.selectedIndex].text);">
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
                <input id="priceVoList[$index].supplierContractPrice.contractPrice" readonly type="text" style="width: 40px;" name="priceVoList[$index].supplierContractPrice.contractPrice" /> 元
            </td>
            <td>
                满 <input id="priceVoList[$index].supplierContractPrice.derateReach" readonly type="text" style="width: 40px;" name="priceVoList[$index].supplierContractPrice.derateReach" /> 免 <input id="priceVoList[$index].supplierContractPrice.derateReduction" style="width: 40px;" readonly type="text" name="priceVoList[$index].supplierContractPrice.derateReduction" />
            </td>
            <td>
                <textarea id="priceVoList[$index].supplierContractPrice.note" readonly class="control-row4 input-large" name="priceVoList[$index].supplierContractPrice.note" ></textarea>
            </td>
            <%--<td>--%>
                <%--<a class="button button-rounded button-tinier" href="javascript:void(0)" onclick="deletePrice(this);">删除</a>--%>
            <%--</td>--%>
        </tr>
        </tbody>
    </table>
</div>


<div id="commonPriceData" style="display : none;">
    <table class="table-style1">
        <tbody>
        <tr>
            <td>
                <select name="priceVoList[$index].supplierContractPrice.itemType" disabled
                        onchange="$(this).next('input').val(this.options[this.selectedIndex].text);">
                    <option value="">请选择</option>
                </select>
                <input type="hidden" id="itemTypeName" name="priceVoList[$index].supplierContractPrice.itemTypeName"
                       value=""/>
            </td>
            <td>
                <input id="priceVoList[$index].supplierContractPrice.contractPrice" type="text" readonly style="width: 40px;"
                       name="priceVoList[$index].supplierContractPrice.contractPrice"/> 元
            </td>
            <td>
                满 <input id="priceVoList[$index].supplierContractPrice.derateReach" type="text" readonly style="width: 40px;"
                         name="priceVoList[$index].supplierContractPrice.derateReach"/> 免 <input readonly style="width: 40px;"
                    id="priceVoList[$index].supplierContractPrice.derateReduction" type="text"
                    name="priceVoList[$index].supplierContractPrice.derateReduction"/>
            </td>
            <td>
                <textarea id="priceVoList[$index].supplierContractPrice.note" class="control-row4 input-large" readonly
                          name="priceVoList[$index].supplierContractPrice.note"></textarea>
            </td>
            <%--<td><a class="button button-rounded button-tinier" href="javascript:void(0)" onclick="deletePrice(this);">删除</a></td>--%>
        </tr>
        </tbody>
    </table>
</div>
<div id="shopPriceData" style="display : none;">
    <table class="table-style1">
        <tbody>
        <tr>
            <td>
                <select disabled id="priceVoList[$index].supplierContractPrice.itemType" name="priceVoList[$index].supplierContractPrice.itemType" onchange="$(this).next('input').val(this.options[this.selectedIndex].text);">
                    <option  value="">请选择</option>
                     <c:if test="${supplierContractVo.supplierInfo.supplierType eq 6 }">
                    <c:forEach items="${dictTypeList}" var="type">
                        <option value="${type.id}">${type.itemName}</option>
                    </c:forEach></c:if>
                   <%--  <c:forEach items="${dictTypeList}" var="type">
                        <option value="${type.id}">${type.value}</option>
                    </c:forEach> --%>
                </select>
                <input type="hidden" id="priceVoList[$index].supplierContractPrice.itemTypeName" name="priceVoList[$index].supplierContractPrice.itemTypeName" value="" />
            </td>
            <%--<td>--%>
                <%--<select disabled id="priceVoList[$index].supplierContractPrice.itemType2" name="priceVoList[$index].supplierContractPrice.itemType2" onchange="$(this).next('input').val(this.options[this.selectedIndex].text);">--%>
                    <%--<option value="1" selected="selected">正价</option>--%>
                    <%--<option value="2">特价</option>--%>
                <%--</select>--%>
                <%--<input type="hidden" id="priceVoList[$index].supplierContractPrice.itemType2Name" name="priceVoList[$index].supplierContractPrice.itemType2Name" value="正价" />--%>
            <%--</td>--%>
            <td>
                按销售金额返款&nbsp;&nbsp;返款&nbsp;<input id="priceVoList[$index].supplierContractPrice.rebateAmountPercent" style="width: 40px;" type="text" name="priceVoList[$index].supplierContractPrice.rebateAmountPercent" /> %
                <!-- <br/>
                <input readonly type="radio" name="priceVoList[$index].supplierContractPrice.rebateMethod" value="2" />按销售数量返款&nbsp;&nbsp;返款&nbsp;<input id="priceVoList[$index].supplierContractPrice.rebateAmount" style="width: 40px;" type="text" name="priceVoList[$index].supplierContractPrice.rebateAmount" /> 元
           -->  </td>
            <td>
                <textarea readonly id="priceVoList[$index].supplierContractPrice.note" class="control-row4 input-large" name="priceVoList[$index].supplierContractPrice.note" ></textarea>
            </td>
            <%--<td><a class="button button-rounded button-tinier" href="javascript:void(0)" onclick="deletePrice(this);">删除</a></td>--%>
        </tr>
        </tbody>
    </table>
</div>

<div id="fleetPriceData" style="display : none;">
    <table class="table-style1">
        <tbody>
        <tr>
            <td>
                <select disabled id="priceVoList[$index].supplierContractPrice.itemType" name="priceVoList[$index].supplierContractPrice.itemType" onchange="$(this).next('input').val(this.options[this.selectedIndex].text);">
                    <option  value="">请选择</option>
                    <c:if test="${supplierContractVo.supplierInfo.supplierType eq 4}">
                    <c:forEach items="${dictTypeList}" var="type">
                        <option value="${type.id}">${type.value}</option>
                    </c:forEach></c:if>
                   <%--  <c:forEach items="${dictTypeList}" var="type">
                        <option value="${type.id}">${type.value}</option>
                    </c:forEach> --%>
                </select>
                <input type="hidden" id="priceVoList[$index].supplierContractPrice.itemTypeName" name="priceVoList[$index].supplierContractPrice.itemTypeName" value="" />
            </td>
            <td>
                <input id="priceVoList[$index].supplierContractPrice.itemType2" type="hidden" style="width: 40px;" name="priceVoList[$index].supplierContractPrice.itemType2" />
                <input readonly id="priceVoList[$index].supplierContractPrice.itemType2Name" style="width: 40px;" type="text" onblur="$(this).prev().val($(this).val());" name="priceVoList[$index].supplierContractPrice.itemType2Name" /> 座 -
                <input id="priceVoList[$index].supplierContractPrice.itemType3" type="hidden" style="width: 40px;" name="priceVoList[$index].supplierContractPrice.itemType3" />
                <input readonly id="priceVoList[$index].supplierContractPrice.itemType3Name" style="width: 40px;" type="text" onblur="$(this).prev().val($(this).val());" name="priceVoList[$index].supplierContractPrice.itemType3Name" /> 座
            </td>
            <%--<td>--%>
                <%--<input readonly id="priceVoList[$index].supplierContractPrice.contractPrice" style="width: 40px;" type="text" name="priceVoList[$index].supplierContractPrice.contractPrice" /> 元--%>
            <%--</td>--%>
            <td id="secondLevelPrice_$index">
                <table>
                    <thead>
                    <tr>
                        <td>线路品牌</td>
                        <td>价格/元</td>
                        <%--<td>操作</td>--%>
                    </tr>
                    </thead>
                    <tbody id="secondLevelPriceRow_$index">

                    </tbody>
                </table>
                <%--<a href="javascript:void(0);" onclick="addSecLevelPriceInfoRow('$index', 'secondLevelPriceRow_$index', 'secondLevelPriceData');">添加</a>--%>
            </td>
            <td>
                <textarea readonly id="priceVoList[$index].supplierContractPrice.note" class="control-row4 input-large" name="priceVoList[$index].supplierContractPrice.note" ></textarea>
            </td>
            <%--<td><a class="button button-rounded button-tinier" href="javascript:void(0)" onclick="deletePrice(this);">删除</a></td>--%>
        </tr>
        </tbody>
    </table>
</div>
<div id="hotelPriceData" style="display : none;">
    <table class="table-style1">
        <tbody>
        <tr>
            <td>
                <select disabled id="priceVoList[$index].supplierContractPrice.itemType" name="priceVoList[$index].supplierContractPrice.itemType" onchange="$(this).next('input').val(this.options[this.selectedIndex].text);">
                    <option  value="">请选择</option>
                    <c:if test="${supplierContractVo.supplierInfo.supplierType eq 3}">
                    <c:forEach items="${dictTypeList}" var="type">
                        <option value="${type.id}">${type.value}</option>
                    </c:forEach></c:if>
                  <%--   <c:forEach items="${dictTypeList}" var="type">
                        <option value="${type.id}">${type.value}</option>
                    </c:forEach> --%>
                </select>
                <input type="hidden" id="priceVoList[$index].supplierContractPrice.itemTypeName" name="priceVoList[$index].supplierContractPrice.itemTypeName" value="" />
            </td>
            <td>
                <select disabled id="priceVoList[$index].supplierContractPrice.itemType2" name="priceVoList[$index].supplierContractPrice.itemType2" onchange="$(this).next('input').val(this.options[this.selectedIndex].text);">
                    <option value="">请选择</option>
                    <c:forEach items="${dictType2List}" var="type">
                        <option value="${type.id}">${type.value}</option>
                    </c:forEach>
                </select>
                <input type="hidden" id="priceVoList[$index].supplierContractPrice.itemType2Name" name="priceVoList[$index].supplierContractPrice.itemType2Name" value="" />
            </td>
            <td>
                <input readonly id="priceVoList[$index].supplierContractPrice.contractPrice" style="width: 40px;" type="text" name="priceVoList[$index].supplierContractPrice.contractPrice" /> 元
            </td>
            <td>
                满 <input readonly id="priceVoList[$index].supplierContractPrice.derateReach" style="width: 40px;" type="text" name="priceVoList[$index].supplierContractPrice.derateReach" /> 免 <input readonly id="priceVoList[$index].supplierContractPrice.derateReduction" style="width: 40px;" type="text" name="priceVoList[$index].supplierContractPrice.derateReduction" />
            </td>
            <td>
                <textarea readonly id="priceVoList[$index].supplierContractPrice.note" class="control-row4 input-large" name="priceVoList[$index].supplierContractPrice.note" ></textarea>
            </td>
            <%--<td>--%>
                <%--<a class="button button-rounded button-tinier" href="javascript:void(0)" onclick="deletePrice(this);">删除</a>--%>
            <%--</td>--%>
        </tr>
        </tbody>
    </table>
</div>

<div id="secondLevelPriceData" style="display: none;">
    <table class="table-style1">
        <tbody>
        <tr>
            <td>
                <select disabled id="priceVoList[$index].priceExtVoList[$secLevel].supplierContractPriceExt.brandId" name="priceVoList[$index].priceExtVoList[$secLevel].supplierContractPriceExt.brandId" onchange="$(this).next('input').val(this.options[this.selectedIndex].text);">
                    <option  value="">请选择</option>
                    <c:forEach items="${dictSecLevelTypeList}" var="type">
                        <option value="${type.id}">${type.value}</option>
                    </c:forEach>
                </select>
                <input type="hidden" id="priceVoList[$index].priceExtVoList[$secLevel].supplierContractPriceExt.brandName" name="priceVoList[$index].priceExtVoList[$secLevel].supplierContractPriceExt.brandName" value="" />
            </td>
            <td>
                <input readonly id="priceVoList[$index].priceExtVoList[$secLevel].supplierContractPriceExt.price" style="width: 40px;" type="text" name="priceVoList[$index].priceExtVoList[$secLevel].supplierContractPriceExt.price" /> 元
            </td>
            <%--<td>--%>
                <%--<a class="button button-rounded button-tinier" href="javascript:void(0)" onclick="deleteSecondLevelPrice(this, '$index');">删除</a>--%>
            <%--</td>--%>
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
        var supplierType = $('#supplierType').val();
        if (supplierType == 1) {
            $contractInfo.html($('#agency').html());
        } else {
            $contractInfo.html($('#others').html());
            if (supplierType == '${SHOPPING}') {
                $('#priceTable').html($shopPriceTable.html());
//                    addPriceInfoRow('shopPriceRow', 'shopPriceData');
            } else if (supplierType == '${FLEET}') {
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
    });
</script>
<script src="<%=ctx %>/assets/js/web-js/contract_edit.js"></script>
</body>
</html>
