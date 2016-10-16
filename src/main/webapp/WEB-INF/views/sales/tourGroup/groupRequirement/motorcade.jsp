<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
</head>
	<body>
		<p class="p_paragraph_title">
			<b>车队</b>
		</p>
   			<div class="dd_top"  style="margin-left: 5%;margin-bottom: 5px">
   				<c:if test="${stateFinance!=1}">
   					<button href="#" class="button button-primary button-small" onclick="newMotorcade();">新增</button>
   				</c:if>
   				<%-- <c:if test="${stateFinance==1}">
   					<button disabled="disabled" href="#" class="button button-primary button-small" onclick="newMotorcade();">新增</button>
   				</c:if> --%>
   			</div>
   			<div class="dd_right" style="width:60%;margin-left: 5%">
               	<table cellspacing="0" cellpadding="0" class="w_table" > 
		        	<thead>
		            	<tr>
		             		<th>序号<i class="w_table_split"></i></th>
		             		<th>日期<i class="w_table_split"></i></th>
		             		<th>型号<i class="w_table_split"></i></th>
		             		<th>座位数<i class="w_table_split"></i></th>
		             		<th>车辆年限<i class="w_table_split"></i></th>
		             		<th>备注<i class="w_table_split"></i></th>
		             		<th>操作</th>
		             	</tr>
		             </thead>
		             <tbody> 
		             	<c:forEach items="${motorcadeList}" var="ml" varStatus="v">
		             		<tr>
			                  <td width="10%">${v.index+1}</td>
			                  <td width="15%">${ml.requireDate}-${ml.requireDateTo}</td> 
			                  <td width="10%">
				                  <c:forEach items="${ftcList}" var="v">
									  <c:if test="${v.id==ml.modelNum}">${v.value}</c:if>
								  </c:forEach>
			                  </td>
			                  <td width="10%">${ml.countSeat}</td>
			                  <td width="15%">${ml.ageLimit}</td>
			                  <td width="22%" style="text-align: left;line-height: 15px;">${ml.remark}</td>
			                  <td width="18%">
			                  	<c:if test="${stateFinance!=1}">
			                  		<a href="javascript:void(0);" onclick="toEditMotorcade(${ml.id})"  class="def">修改</a>&nbsp;&nbsp;
			                  		<a href="javascript:void(0);" onclick="deleteMotorcadeById(this,${ml.id})"  class="def">删除</a>
			                  	</c:if>
			                  	<c:if test="${stateFinance==1}">
			                  		<a href="javascript:void(0);" class="def">修改</a>&nbsp;&nbsp;
			                  		<a href="javascript:void(0);" class="def">删除</a>
			                  	</c:if>
			                  </td>
		               		</tr>
		             	</c:forEach>
		             </tbody>
          		 </table>
   			</div>
   			<div class="clear"></div>
		<div id="addOrEditMotorcade" style="display: none;">
	 		<form id="addOrEditMotorcadeForm" method="post" action="">
				<div class="p_container" >
			        <div class="p_container_sub" >
				    		<input type="hidden" id="orderId" name="orderId" value="${orderId}"/>
				    		<input type="hidden" name="groupId" value="${groupId}"/>
				    		<input type="hidden" name="id" id="motorcadeId"/>
			                <input type="hidden" name="supplierType" value="4"/>
			                
			                <dl class="p_aragraph_content" style="margin-top: 10px">
				    			<dd>
				    				<div class="dd_left"><i class="red">*</i>日期:</div>
				    				<input type="text" id="motorcadeRequireDate" name="requireDate" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd '})" />-<input type="text" id="motorcadeRequireDateTo" name="requireDateTo" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd '})" />
				    			</dd>
    						</dl>
    						<dl class="p_aragraph_content" style="margin-top: 10px">
				    			<dd>
				    				<div class="dd_left">型号:</div>
				    				<select id="modelNum" name="modelNum" class="select160" style="width: 160px;text-align: right">
			                			<c:forEach items="${ftcList}" var="v" varStatus="vs">
											<option value="${v.id}" style="height: 23px;text-align: right">${v.value}</option>
										</c:forEach>
	                				</select>
				    			</dd>
    						</dl>
    						<dl class="p_aragraph_content" style="margin-top: 10px">
				    			<dd>
				    				<div class="dd_left"><i class="red">*</i>座位数:</div>
				    				<input type="text" name="countSeat" id="countSeat" value="" class="IptText301"/>
				    			</dd>
    						</dl>
    						<dl class="p_aragraph_content" style="margin-top: 10px">
				    			<dd>
				    				<div class="dd_left"><i class="red">*</i>车辆年限:</div>
				    				<input type="text" name="ageLimit" id="ageLimit" value="" class="IptText301"/>
				    			</dd>
    						</dl>
    						<dl class="p_aragraph_content" style="margin-top: 10px">
				    			<dd>
				    				<div class="dd_left">备注:</div>
				    				<textarea id="motorcadeRemark" class="l_textarea" name="remark" style="width:270px;"></textarea>
				    			</dd>
		    				</dl>
			        </div>
			    </div>
				<div class="modal-footer" style="margin-left: 43%;">
					<button type="submit" class="button button-primary button-small">保存</button>
				</div>
		    </form>
		</div>
	</body>
</html>
