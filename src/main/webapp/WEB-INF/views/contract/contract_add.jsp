<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
    <style>
        .help-block{
            display: inline-block;
        }
    </style>
    <!-- <script>
    	$(function(){
    		if(!$("input[name='supplierContract.signDate']")){
    			var curDate=new Date();
    			var signDate=curDate.getFullYear()+"-"+(curDate.getMonth()+1)+"-"+curDate.getDay();
    			$("input[name='supplierContract.signDate']").val(signDate);
    		}
    	})
    </script> -->
</head>
<body>
    <div class="p_container">
        <div class="p_container_sub">
            <form id="contractForm" action="" onsubmit="return false;" method="post" enctype="multipart/form-data" >
                <input type="hidden" name="supplierContract.shopSupplierId" value="${supplierContractVo.bizSupplierRelation.id}" />
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
                    <input id="contractName_agency" type="text" name="supplierContract.contractName" />
                </div>
                <div class="clear"></div>
            </dd>

            <dd>
                <div class="dd_left"><i class="red">* </i>开始日期：</div>
                <div class="dd_right">
                    <input id="startDate_agency" type="text" name="supplierContract.startDate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
                </div>

                <div class="dd_left"><i class="red">* </i>结束日期：</div>
                <div class="dd_right">
                    <input id="endDate_agency" type="text" name="supplierContract.endDate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd', minDate:'#F{$dp.$D(\'startDate_agency\')}'})" />
                </div>

                <div class="dd_left"><i class="red">* </i>签订日期：</div>
                <div class="dd_right">
                    <input id="signDate_agency" type="text" name="supplierContract.signDate" value="<fmt:formatDate value='${signDate}'
														pattern='yyyy-MM-dd' />"  onfocus="WdatePicker({dateFmt:'yyyy-MM-dd', maxDate:'#F{$dp.$D(\'endDate_agency\')}'})" />
                </div>
                <div class="clear"></div>
            </dd>

            <dd>
                <div class="dd_left"><i class="red">* </i>日期优先级：</div>
                <div class="dd_right">
                    <select id="datePriority_agency" name="supplierContract.datePriority">
                        <option value="1">1</option>
                        <option value="2">2</option>
                        <option value="3">3</option>
                        <option value="4">4</option>
                        <option value="5">5</option>
                    </select>
                    <%--<input id="datePriority_agency" type="text" name="supplierContract.datePriority" /> <i class="grey ml-10">请填写数字</i>--%>
                </div>
                <div class="clear"></div>
            </dd>

            <dd>
                <div class="dd_left">结算方式：</div>
                <div class="dd_right">
                    <input type="text" name="supplierContract.settlementDays" placeholder="45" />天，
                    <input type="text" name="supplierContract.settlementDesp" placeholder="一个半月结清" />
                </div>
                <div class="clear"></div>
            </dd>

            <dd>
                <div class="dd_left">团类别：</div>
                <div class="dd_right">
                    <label>
                        <input type="radio" name="supplierContract.groupType" value="1" />所有
                    </label>
                    <label>
                        <input type="radio" name="supplierContract.groupType" value="2" />团队(代订\会展)
                    </label>
                    <label>
                        <input type="radio" name="supplierContract.groupType" value="3" />散客
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
                    <input id="exceedDays_agency" type="text" name="supplierContract.exceedDays" />
                </div>
                <div class="clear"></div>
            </dd>

            <dd>
                <div class="dd_left">最大欠款额度：</div>
                <div class="dd_right">
                    <input id="maxDebt_agency" type="text" name="supplierContract.maxDebt" />
                </div>
                <div class="clear"></div>
            </dd>

            <dd>
                <div class="dd_left">超出额度：</div>
                <div class="dd_right">
                    <input id="exceedAmount_agency" type="text" name="supplierContract.exceedAmount" />
                </div>
                <div class="clear"></div>
            </dd>

            <dd>
                <div class="dd_left">开票要求：</div>
                <div class="dd_right">
                    <textarea id="billDemand_agency" class="w_textarea" name="supplierContract.billDemand" ></textarea>
                </div>
                <div class="clear"></div>
            </dd>

            <dd>
                <div class="dd_left">备注：</div>
                <div class="dd_right">
                    <textarea id="note_agency" class="w_textarea" name="supplierContract.note" ></textarea>
                </div>

                <div class="clear"></div>
            </dd>

            <dd>
                <div class="dd_left">返款政策：</div>
                <div class="dd_right">
                    <textarea id="rebatePolicy_agency" class="w_textarea" name="supplierContract.rebatePolicy" ></textarea>
                </div>
                <div class="clear"></div>
            </dd>

            <dd>
                <div class="dd_left">文档图片：</div>
                <div class="dd_right addImg" >

                </div>
                <label onclick="selectAttachment(this, '#imgTemp')" class="ulImgBtn"></label> <i class="grey ml-10">请把合同协议拍照后，按顺序上传，gif 、jpg、png格式的图片。</i>
                <div class="clear"></div>
            </dd>
        </dl>

    <%--<dl class="p_paragraph_content">--%>
			<%--<dd>--%>
	   			<%--<div class="dd_left"><i class="red">* </i>合同名称：</div> --%>
	   			<%--<div class="dd_right">--%>
	   				<%--<input id="contractName_agency" type="text" name="supplierContract.contractName"  class="IptText300"/>--%>
	   			<%--</div>--%>
				<%--<div class="clear"></div>--%>
	   		<%--</dd> --%>
	   		<%----%>
	   		<%--<dd>--%>
	   			<%--<div class="dd_left"><i class="red">* </i>开始日期：</div> --%>
	   			<%--<div class="dd_right">--%>
	   				<%--<input id="startDate_agency" type="text" name="supplierContract.startDate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})" class="Wdate"/>--%>
	   			<%--</div>--%>
				<%----%>
				<%--<div class="dd_left"><i class="red">* </i>结束日期：</div> --%>
	   			<%--<div class="dd_right">--%>
	   				 <%--<input id="endDate_agency" type="text" name="supplierContract.endDate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd', minDate:'#F{$dp.$D(\'startDate_agency\')}'})" class="Wdate"/>--%>
	   			<%--</div>--%>
	   			<%----%>
	  				<%--<div class="dd_left"><i class="red">* </i>签订日期：</div> --%>
	   			<%--<div class="dd_right">--%>
	   				  <%--<input id="signDate_agency" type="text" name="supplierContract.signDate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd', maxDate:'#F{$dp.$D(\'endDate_agency\')}'})" class="Wdate"/>--%>
	   			<%--</div>--%>
				<%--<div class="clear"></div>--%>
	   		<%--</dd> --%>
	   		<%----%>
	   		<%--<dd>--%>
	  			<%--<div class="dd_left"><i class="red">* </i>日期优先级：</div> --%>
	   			<%--<div class="dd_right">--%>
	   				<%--<input id="datePriority_agency" type="text" name="supplierContract.datePriority" class="IptText300"/>--%>
	   			<%--</div>--%>
	   			<%--<div class="clear"></div>--%>
	   		<%--</dd> --%>
	   		<%----%>
	   		<%--<dd>--%>
	   			<%--<div class="dd_left"><i class="red">* </i>结算方式：</div> --%>
	   			<%--<div class="dd_right">--%>
	  				        <%--<label for="settlementMethodElement1"><input id="settlementMethodElement1" type="checkbox" name="settlementMethodList" value="1" />签单</label>--%>
	             				<%--<label for="settlementMethodElement2"><input id="settlementMethodElement2" type="checkbox" name="settlementMethodList" value="2" />现付</label>--%>
	   			<%--</div>--%>
	   			<%--<div class="clear"></div>--%>
	   		<%--</dd>--%>

            <%--<dd>--%>
                <%--<div class="dd_left">团类别：</div>--%>
                <%--<div class="dd_right">--%>
                    <%--<label>--%>
                        <%--<input type="radio" name="supplierContract.groupType" value="1" />所有--%>
                    <%--</label>--%>
                    <%--<label>--%>
                        <%--<input type="radio" name="supplierContract.groupType" value="2" />团队(代订\会展)--%>
                    <%--</label>--%>
                    <%--<label>--%>
                        <%--<input type="radio" name="supplierContract.groupType" value="3" />散客--%>
                    <%--</label>--%>
                <%--</div>--%>
                <%--<div class="clear"></div>--%>
            <%--</dd>--%>

            <%--<dd>--%>
	   			<%--<div class="dd_left"><i class="red">* </i>备注：</div> --%>
	   			<%--<div class="dd_right">--%>
	   				<%--<textarea id="note" class="w_textarea" name="supplierContract.note"></textarea>--%>
	   			<%--</div>--%>
	   			<%----%>
	   			<%--<div class="clear"></div>--%>
	   		<%--</dd> --%>
	   		<%----%>
	   		<%--<dd>--%>
	   			<%--<div class="dd_left"><i class="red">* </i>返款政策：</div> --%>
	   			<%--<div class="dd_right">--%>
	   				<%--<textarea id="rebatePolicy" class="w_textarea" name="supplierContract.rebatePolicy"></textarea>--%>
	   			<%--</div>--%>
	   			<%--<div class="clear"></div>--%>
	   		<%--</dd> --%>
	   		<%----%>
	   		<%--<dd>--%>
	   			<%--<div class="dd_left"><i class="red">* </i>文档图片：</div> --%>
	   			<%--<div class="dd_right">--%>
	   				 <%--<input id="picture" type="file" name="supplierContract.picture" />--%>
	   			<%--</div>--%>
				<%--<div class="clear"></div>--%>
	   		<%--</dd> --%>
		<%--</dl>--%>
    </div>

    <div id="others" style="display: none;">
        <dl class="p_paragraph_content">
            <dd>
            	<div class="dd_left"><i class="red">* </i>合同名称：</div>
            	<div class="dd_right">
                	<input id="contractName" type="text" name="supplierContract.contractName" class="IptText300" />
            	</div>
            	<div class="clear"></div>
            </dd>
            <dd>
            	<div class="dd_left"><i class="red">* </i>开始日期：</div>
            	<div class="dd_right">
                	<input id="startDate" type="text" name="supplierContract.startDate" class="Wdate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
            	</div>
            	<div class="clear"></div>
            </dd>
            <dd>
            	<div class="dd_left"><i class="red">* </i>结束日期：</div>
            	<div class="dd_right">                	
                	<input id="endDate" type="text" name="supplierContract.endDate" class="Wdate"  onfocus="WdatePicker({dateFmt:'yyyy-MM-dd', minDate:'#F{$dp.$D(\'startDate\')}'})" />
            	</div>   
            	<div class="clear"></div>         	
            </dd>
            <dd>
            	<div class="dd_left"><i class="red">* </i>签订日期：</div>
            	<div class="dd_right">                	
                	<input id="signDate" type="text" name="supplierContract.signDate" value="<fmt:formatDate value='${signDate}'
														pattern='yyyy-MM-dd' />"  class="Wdate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd', maxDate:'#F{$dp.$D(\'endDate\')}'})" />
            	</div>  
            	<div class="clear"></div>          	
            </dd>
            <dd>
            	<div class="dd_left">返款政策：</div>
            	<div class="dd_right">                	
                	<textarea id="rebatePolicy" class="w_textarea" name="supplierContract.rebatePolicy"></textarea>
            	</div> 
            	<div class="clear"></div>           	
            </dd>
            <dd>
            	<div class="dd_left">日期优先级：</div>
            	<div class="dd_right">
                    <select id="datePriority" name="supplierContract.datePriority">
                        <option value="1">1</option>
                        <option value="2">2</option>
                        <option value="3">3</option>
                        <option value="4">4</option>
                        <option value="5">5</option>
                    </select>
                    <%--<input id="datePriority" class="IptText300" type="text" name="supplierContract.datePriority" /> <i class="grey ml-10">请填写数字</i>--%>
            	</div>   
            	<div class="clear"></div>         	
            </dd>
            <dd>
            	<div class="dd_left">备注：</div>
            	<div class="dd_right">                	
                	<textarea id="note" class="w_textarea" name="supplierContract.note"></textarea>
            	</div>  
            	<div class="clear"></div>          	
            </dd>
            <dd>
            	<div class="dd_left">结算方式：</div>
            	<div class="dd_right"> 
            	<select name="supplierContract.settlementMethod" id="settlementMethod">
				
				<option></option>
					<c:forEach items="${cashTypes }" var="type">
						<option value="${type.id }" >${type.value }</option>
					</c:forEach>
								
							</select>               	
                	<!-- <label><input id="settlementMethodElement1" type="checkbox" name="settlementMethodList" value="1" />签单</label>
                    <label><input id="settlementMethodElement2" type="checkbox" name="settlementMethodList" value="2" />现付</label> -->
            	</div>  
            	<div class="clear"></div>          	
            </dd>
            <dd>
	   			<div class="dd_left">文档图片：</div>
	   			<div class="dd_right addImg">

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
    <%--price table heads--%>
    <div id="commonPrice" style="display: none;">
    	<button type="button" onclick="addPriceInfoRow('commonPriceRow', 'commonPriceData');" class="button button-primary button-small" >添加</button>    	
        <table cellspacing="0" class="w_table">
        	<colgroup>
        		<col width="15%" />
        		<col width="20%" />
        		<col width="25%" />
        		<col width="30%" />
        		<col width="10%" />
        	</colgroup>
            <thead>            	
	            <tr>
	                <th>项目<i class="w_table_split"></i></th>
	                <th>协议价<i class="w_table_split"></i></th>
	                <th>减免政策<i class="w_table_split"></i></th>
	                <th>备注<i class="w_table_split"></i></th>
	                <th>操作</th>
	            </tr>
            </thead>
            <tbody id="commonPriceRow">
            </tbody>
        </table>
    </div>

    <div id="shopPrice" style="display: none;">
    	<button type="button" onclick="addPriceInfoRow('shopPriceRow', 'shopPriceData');" class="button button-primary button-small" >添加</button>
        <table cellspacing="0" class="w_table">
        	<colgroup>
        		<col width="25%" />
        		<%--<col width="20%" />--%>
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
            </tbody>
        </table>
    </div>

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

            </tbody>
        </table>
    </div>

    <div id="hotelPrice" style="display: none;">
    	<button type="button" onclick="addPriceInfoRow('hotelPriceRow', 'hotelPriceData');" class="button button-primary button-small">添加</button>
        <table cellspacing="0" class="w_table">
        	<colgroup>
        		<col width="15%" />
        		<%--<col width="10%" />--%>
        		<col width="15%" />
        		<col width="40%" />
        		<col width="20%" />
        		<col width="10%" />
        	</colgroup>
            <thead>
	            <tr>
	                <th>类别<i class="w_table_split"></i></th>
	                <%--<th>房型<i class="w_table_split"></i></th>--%>
	                <th>协议价<i class="w_table_split"></i></th>
	                <th>减免政策<i class="w_table_split"></i></th>
	                <th>备注<i class="w_table_split"></i></th>
	                <th>操作</th>
	            </tr>
            </thead>
            <tbody id="hotelPriceRow">

            </tbody>
        </table>
    </div>



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
                    </select>
                    <input type="hidden" id="priceVoList[$index].supplierContractPrice.itemTypeName" name="priceVoList[$index].supplierContractPrice.itemTypeName" value="" />
                </td>
                <td>
                    <input id="priceVoList[$index].supplierContractPrice.contractPrice" type="text" style="width: 40px;" value="0" name="priceVoList[$index].supplierContractPrice.contractPrice" /> 元
                </td>
                <td>
                    满 <input id="priceVoList[$index].supplierContractPrice.derateReach" type="text" style="width: 40px;" value="0" name="priceVoList[$index].supplierContractPrice.derateReach" /> 免 <input id="priceVoList[$index].supplierContractPrice.derateReduction" type="text" value="0" style="width: 40px;" name="priceVoList[$index].supplierContractPrice.derateReduction" />
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
                    <input type="hidden" name="priceVoList[$index].supplierContractPrice.rebateMethod" value="1"  />按销售金额返款&nbsp;&nbsp;返款&nbsp;<input id="priceVoList[$index].supplierContractPrice.rebateAmountPercent" style="width:40px;" value="0" type="text" name="priceVoList[$index].supplierContractPrice.rebateAmountPercent" /> %
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
                    <input id="priceVoList[$index].supplierContractPrice.itemType2" type="hidden" style="width: 40px;"  name="priceVoList[$index].supplierContractPrice.itemType2" />
                    <input id="priceVoList[$index].supplierContractPrice.itemType2Name" type="text" style="width: 40px;" value="0" name="priceVoList[$index].supplierContractPrice.itemType2Name"  onblur="$(this).prev().val($(this).val());" /> 座 -
                    <input id="priceVoList[$index].supplierContractPrice.itemType3" type="hidden" style="width: 40px;"  name="priceVoList[$index].supplierContractPrice.itemType3" />
                    <input id="priceVoList[$index].supplierContractPrice.itemType3Name" type="text" style="width: 40px;" value="0" name="priceVoList[$index].supplierContractPrice.itemType3Name"  onblur="$(this).prev().val($(this).val());"  /> 座
                </td>
                <%--<td>--%>
                    <%--<input id="priceVoList[$index].supplierContractPrice.contractPrice" type="text" style="width: 40px;" name="priceVoList[$index].supplierContractPrice.contractPrice" /> 元--%>
                <%--</td>--%>
                <td id="secondLevelPrice_$index">
                    <table>
                        <thead>
                            <tr>
                                <td width="20%">线路品牌</td>
                                <td width="10%">价格/元</td>
                                <td width="10%">操作</td>
                            </tr>
                        </thead>
                        <tbody id="secondLevelPriceRow_$index">

                        </tbody>
                    </table>
                    <a href="javascript:void(0);" onclick="addSecLevelPriceInfoRow('$index', 'secondLevelPriceRow_$index', 'secondLevelPriceData');" class="def">添加</a>
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
                    <%--<input type="hidden" id="priceVoList[$index].supplierContractPrice.itemType2Name" name="priceVoList[$index].supplierContractPrice.itemType2Name" value="" />--%>
                <%--</td>--%>
                <td>
                    <input id="priceVoList[$index].supplierContractPrice.contractPrice" type="text" style="width: 40px;" value="0" name="priceVoList[$index].supplierContractPrice.contractPrice" /> 元
                </td>
                <td>
                    满 <input id="priceVoList[$index].supplierContractPrice.derateReach" type="text" value="0" style="width: 40px;" name="priceVoList[$index].supplierContractPrice.derateReach" /> 免 <input id="priceVoList[$index].supplierContractPrice.derateReduction" type="text" style="width: 40px;" value="0" name="priceVoList[$index].supplierContractPrice.derateReduction" />
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
                    </td >
                    <td width="10%">
                    
                    	
                        <input id="priceVoList[$index].priceExtVoList[$secLevel].supplierContractPriceExt.price" type="text" style="width: 40px;" value="0" name="priceVoList[$index].priceExtVoList[$secLevel].supplierContractPriceExt.price" /> 元
                   
                    </td>
                    <td width="10%">
                        <a class="def" href="javascript:void(0)" onclick="deleteSecondLevelPrice(this, '$index');">删除</a>
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
    <script src="<%=ctx %>/assets/js/web-js/contract_add.js"></script>
    <script type="text/javascript">
        var path = '<%=path%>';
        var supplierId = '${supplierId}';
        $(function(){
            var $contractInfo = $('#contractInfo');
            var $priceTable = $('#priceTable');
            var $commonPriceTable = $('#commonPrice');
            var $shopPriceTable = $('#shopPrice');
            var $fleetPriceTable = $('#fleetPrice');
            var $hotelPriceTable = $('#hotelPrice');
            var supplierType = $('#supplierType').val();
            if(supplierType == 1){
                $contractInfo.html($('#agency').html());
            }else{
                $priceTable.empty();
                $contractInfo.html($('#others').html());
                if(supplierType == '${SHOPPING}'){
                    $('#priceTable').html($shopPriceTable.html());
                    addPriceInfoRow('shopPriceRow', 'shopPriceData');
                }else if(supplierType == '${FLEET}'){
                    $('#priceTable').html($fleetPriceTable.html());
                    addPriceInfoRow('fleetPriceRow', 'fleetPriceData');
                    addSecLevelPriceInfoRow('0', 'secondLevelPriceRow_0', 'secondLevelPriceData');
                }else if(supplierType == '${HOTEL}'){
                    $('#priceTable').html($hotelPriceTable.html());
                    addPriceInfoRow('hotelPriceRow', 'hotelPriceData');
                }else {
                    $('#priceTable').html($commonPriceTable.html());
                    addPriceInfoRow('commonPriceRow', 'commonPriceData');
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
