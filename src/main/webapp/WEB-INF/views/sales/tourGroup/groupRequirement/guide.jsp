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
			<b>导游</b>
		</p>
   			<div class="dd_top"  style="margin-left: 5%;margin-bottom: 5px">
   				<c:if test="${stateFinance!=1}">
   					<button href="#" class="button button-primary button-small" onclick="newGuide();">新增</button>
   				</c:if>
   				<%-- <c:if test="${stateFinance==1}">
   					<button disabled="disabled" href="#" class="button button-primary button-small" onclick="newGuide();">新增</button>
   				</c:if> --%>
   			</div>
   			<div class="dd_right" style="width:50%;margin-left: 5%">
               	<table cellspacing="0" cellpadding="0" class="w_table" > 
		        	<thead>
		            	<tr>
		             		<th>序号<i class="w_table_split"></i></th>
		             		<th>语种<i class="w_table_split"></i></th>
		             		<th>性别<i class="w_table_split"></i></th>
		             		<th>年限<i class="w_table_split"></i></th>
		             		<th>备注<i class="w_table_split"></i></th>
		             		<th>操作</th>
		             	</tr>
		             </thead>
		             <tbody> 
		             	<c:forEach items="${guideList}" var="gl" varStatus="v">
		             		<tr>
			                  <td width="10%">${v.index+1}</td>
			                  <td width="15%">${gl.language}</td> 
			                  <td width="15%"><c:if test="${gl.gender==0}">男</c:if> <c:if
									test="${gl.gender==1}">女</c:if><c:if
									test="${gl.gender==2}">不限</c:if></td>
			                  
			                  <td width="15%">${gl.ageLimit}</td>
			                  <td width="20%" style="text-align: left;line-height: 15px;">${gl.remark}</td>
			                  <td width="25%">
			                  	<c:if test="${stateFinance!=1}">
			                  		<a href="javascript:void(0);" onclick="toEditGuide(${gl.id})" class="def">修改</a>&nbsp;&nbsp;
			                  		<a href="javascript:void(0);" onclick="deleteGuideById(this,${gl.id})" class="def">删除</a>
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
		<div id="addOrEditGuide" style="display: none;">
	 		<form id="addOrEditGuideForm" method="post" action="">
				<div class="p_container" >
			        <div class="p_container_sub" >
			    		<input type="hidden" id="orderId" name="orderId" value="${orderId}"/>
			    		<input type="hidden" name="groupId" value="${groupId}"/>
			    		<input type="hidden" name="id" id="guideId"/>
		                <input type="hidden" name="supplierType" value="8"/>
		                <dl class="p_aragraph_content" style="margin-top: 10px">
			    			<dd>
			    				<div class="dd_left"><i class="red">*</i>语种:</div>
			    				<input type="text" name="language" id="language" value="" class="IptText301"/>
			    			</dd>
   						</dl>
   						<dl class="p_aragraph_content" style="margin-top: 10px">
			    			<dd>
			    				<div class="dd_left">性别:</div>
			    				<div class="dd_right">
			    				<input type="radio"  name="gender" value="2" checked="checked"/>不限
								<input type="radio"  name="gender" value="0" />男
								<input type="radio"  name="gender" value="1" />女
								</div>
								<div class="clear"></div>
			    			</dd>
   						</dl>
   						<dl class="p_aragraph_content" style="margin-top: 10px">
			    			<dd>
			    				<div class="dd_left"><i class="red">*</i>年限:</div>
			    				<input type="text" name="ageLimit" id="guideAgeLimit" value="" class="IptText301"/>
			    			</dd>
   						</dl>
		               <dl class="p_aragraph_content" style="margin-top: 10px">
			    			<dd>
			    				<div class="dd_left">备注:</div>
			    				<textarea id="guideRemark" class="l_textarea" name="remark" style="width:270px;"></textarea>
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
