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
			<b>餐厅</b>
		</p>
   			<div class="dd_top"  style="margin-left: 5%;margin-bottom: 5px">
   				<c:if test="${stateFinance!=1}">
   					<button href="#" class="button button-primary button-small" onclick="newRestaurant();">新增</button>
   				</c:if>
   				<%-- <c:if test="${stateFinance==1}">
   					<button disabled="disabled" href="#" class="button button-primary button-small" onclick="newRestaurant();">新增</button>
   				</c:if> --%>
   			</div>
   			<div class="dd_right" style="width:50%;margin-left: 5%">
               	<table cellspacing="0" cellpadding="0" class="w_table" > 
		        	<thead>
		            	<tr>
		             		<th>序号<i class="w_table_split"></i></th>
		             		<th>日期<i class="w_table_split"></i></th>
		             		<th>区域<i class="w_table_split"></i></th>
		             		<th>人数<i class="w_table_split"></i></th>
		             		<th>备注<i class="w_table_split"></i></th>
		             		<th>操作</th>
		             	</tr>
		             </thead>
		             <tbody> 
		             	<c:forEach items="${restaurantList}" var="rl" varStatus="v">
		             		<tr>
			                  <td width="10%">${v.index+1}</td>
			                  <td width="20%">${rl.requireDate}</td> 
			                  <td width="10%">${rl.area}</td>
			                  <td width="10%">${rl.countRequire}</td>
			                  <td width="20%" style="text-align: left;line-height: 15px;">${rl.remark}</td>
			                  <td width="25%">
			                  	<c:if test="${stateFinance!=1}">
			                  		<a href="javascript:void(0);" onclick="toEditRestaurant(${rl.id})"  class="def">修改</a>&nbsp;&nbsp;
			                  		<a href="javascript:void(0);" onclick="deleteRestaurantById(this,${rl.id})"  class="def">删除</a>
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
		<div id="addOrEditRestaurant" style="display: none;">
	 		<form id="addOrEditRestaurantForm" method="post" action="">
				<div class="p_container" >
			        <div class="p_container_sub" >
			    		<input type="hidden" name="id" id="restaurantId"/>
			    		<input type="hidden" id="orderId" name="orderId" value="${orderId}"/>
			    		<input type="hidden" name="groupId" value="${groupId}"/>
		                <input type="hidden" name="supplierType" value="2"/>
		                <dl class="p_aragraph_content" style="margin-top: 10px">
			    			<dd>
			    				<div class="dd_left"><i class="red">*</i>日期:</div>
			    				<input type="text" id="restaurantRequireDate" name="requireDate" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd '})" />
			    			</dd>
   						</dl>
		                <dl class="p_aragraph_content" style="margin-top: 10px">
			    			<dd>
			    				<div class="dd_left">区域:</div>
			    				<input type="text" name="area" id="restaurantArea" value="" class="IptText301"/>
			    			</dd>
   						</dl>
   						<dl class="p_aragraph_content" style="margin-top: 10px">
			    			<dd>
			    				<div class="dd_left"><i class="red">*</i>人数:</div>
			    				<input type="text" name="countRequire" id="restaurantCountRequire" value="" class="IptText301"/>
			    			</dd>
   						</dl>
   						<dl class="p_aragraph_content" style="margin-top: 10px">
			    			<dd>
			    				<div class="dd_left">备注:</div>
			    				<textarea id="restaurantRemark" class="l_textarea" name="remark" style="width:270px;"></textarea>
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
