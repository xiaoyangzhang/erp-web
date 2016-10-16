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
			<b>酒店</b>
		</p>
   			<div class="dd_top"  style="margin-left: 5%;margin-bottom: 5px">
   				<c:if test="${stateFinance!=1}">
   					<button href="#" class="button button-primary button-small" onclick="newGrogShop();">新增</button>
   				</c:if>
   			</div>
   			<div class="dd_right" style="width:70%;margin-left: 5%">
               	<table cellspacing="0" cellpadding="0" class="w_table" > 
		        	<thead>
		            	<tr>
		             		<th>序号<i class="w_table_split"></i></th>
		             		<th>日期<i class="w_table_split"></i></th>
		             		<th>区域<i class="w_table_split"></i></th>
		             		<th>星级<i class="w_table_split"></i></th>
		             		<th>单人间<i class="w_table_split"></i></th>
		             		<th>三人间<i class="w_table_split"></i></th>
		             		<th>标准间<i class="w_table_split"></i></th>
		             		<th>陪房<i class="w_table_split"></i></th>
							<th>加床<i class="w_table_split"></i></th>
		             		<th>备注<i class="w_table_split"></i></th>
		             		<th>操作</th>
		             	</tr>
		             </thead>
		             <tbody> 
		             	<c:forEach items="${grogShopList}" var="gsl" varStatus="v">
		             		<tr>
			                  <td width="5%">${v.index+1}</td>
			                  <td width="15%">${gsl.requireDate}</td> 
			                  <td width="5%">${gsl.area}</td>
			                  <td width="10%">
				                  <c:forEach items="${jdxjList}" var="v" varStatus="vs">
									<c:if test="${v.id==gsl.hotelLevel}">${v.value}</c:if>
								  </c:forEach>
							  </td>
			                  <td width="9%">${gsl.countSingleRoom}</td>
			                  <td width="9%">${gsl.countTripleRoom}</td>
			                  <td width="9%">${gsl.countDoubleRoom}</td>
			                  <td width="9%">${gsl.peiFang}</td>
							  <td width="9%">${gsl.extraBed}</td>
			                  <td width="10%" style="text-align: left;line-height: 15px;">${gsl.remark}</td>
			                  <td width="10%">
			                  	<c:if test="${stateFinance!=1}">
			                  		<a href="javascript:void(0);" onclick="toEditGrogShop(${gsl.id})"  class="def">修改</a>&nbsp;&nbsp;
			                  		<a href="javascript:void(0);" onclick="deleteGrogShopById(this,${gsl.id})"  class="def">删除</a>
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
		<div id="addOrEditGrogShop" style="display: none;">
	 		<form id="addOrEditGrogShopForm" method="post" action="">
				<div class="p_container" >
			        <div class="p_container_sub" >
			    		<input type="hidden" name="id" id="id"/>
			    		<input type="hidden" name="orderId" value="${orderId}"/>
			    		<input type="hidden" name="groupId" value="${groupId}"/>
		                <input type="hidden" name="supplierType" value="3"/>
			    		<dl class="p_aragraph_content" style="margin-top: 10px">
			    			<dd>
			    				<div class="dd_left"><i class="red">*</i>日期:</div>
			    				<input type="text" id="requireDate" name="requireDate" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd '})" />
			    			</dd>
    					</dl>
    					<dl class="p_aragraph_content" style="margin-top: 10px">
			    			<dd>
			    				<div class="dd_left">区域:</div>
			    				<input type="text" name="area" id="area" value="" class="IptText301"/>
			    			</dd>
    					</dl>
    					<dl class="p_aragraph_content" style="margin-top: 10px">
			    			<dd>
			    				<div class="dd_left"><i class="red">*</i>星级:</div>
			    				<select id="hotelLevel" name="hotelLevel" class="select160" style="width: 160px;text-align: right">
		                			<c:forEach items="${jdxjList}" var="v" varStatus="vs">
										<option value="${v.id}" style="height: 23px;text-align: right">${v.value}</option>
									</c:forEach>
	                			</select>
			    			</dd>
    					</dl>
    					<dl class="p_aragraph_content" style="margin-top: 10px">
			    			<dd>
			    				<div class="dd_left">单人间:</div>
			    				<input type="text" name="countSingleRoom" id="countSingleRoom" value="0" class="IptText301"/>
			    			</dd>
    					</dl>
    					<dl class="p_aragraph_content" style="margin-top: 10px">
			    			<dd>
			    				<div class="dd_left">三人间:</div>
			    				<input type="text" name="countTripleRoom" id="countTripleRoom" value="0" class="IptText301"/>
			    			</dd>
    					</dl>
    					<dl class="p_aragraph_content" style="margin-top: 10px">
			    			<dd>
			    				<div class="dd_left">标准间:</div>
			    				<input type="text" name="countDoubleRoom" id="countDoubleRoom" value="0" class="IptText301"/>
			    			</dd>
    					</dl>
    					<dl class="p_aragraph_content" style="margin-top: 10px">
			    			<dd>
			    				<div class="dd_left">陪房:</div>
			    				<input type="text" name="peiFang" id="hotelPeiFang"  value="0" class="IptText301"/>
			    			</dd>
    					</dl>
    					<dl class="p_aragraph_content" style="margin-top: 10px">
			    			<dd>
			    				<div class="dd_left">加床:</div>
			    				<input type="text" name="extraBed" id="hotelExtraBed" value="0" class="IptText301"/>
			    			</dd>
    					</dl>
    					<dl class="p_aragraph_content" style="margin-top: 10px">
			    			<dd>
			    				<div class="dd_left">备注:</div>
			    				<textarea id="remark" class="l_textarea" name="remark" style="width:270px;"></textarea>
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
