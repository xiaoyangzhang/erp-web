<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
</head>
	<body>
		<div id="editBudgetItem" style="display: none;">
	 		<form id="editBudgetItemForm" method="post" action="">
				<div class="p_container" >
			        <div class="p_container_sub" >
			    		<dl class="p_aragraph_content" style="margin-top: 20px">
			    			<dd>
			    				<input type="hidden" id="item1" name="itemName"/>
		                   		<input type="hidden" name="orderId" id="order1" value="${orderId}"/>
		                		<input type="hidden" name="id" id="id"/>
			    				<div class="dd_left">项目:</div>
			    				<div class="dd_right">
			                		<select id="sl1" name="itemId" class="select160" style="width: 160px;text-align: right">
				                		<c:forEach items="${lysfxmList}" var="lysfxm">
											<option value="${lysfxm.id}">${lysfxm.value }</option>
										</c:forEach>
			                		</select>
			                	</div>
			                	<div class="clear"></div>
			    			</dd>
	    				</dl>
		    			<dl class="p_aragraph_content" style="margin-top: 10px">
			    			<dd>
			    				<div class="dd_left"><i class="red">*</i>单价:</div>
			    				<div class="dd_right">
			    					<input type="text" name="unitPrice" id="unitPrice1" value="" class="IptText301"/>
			    				</div>
			    				<div class="clear"></div>
			    			</dd>
		    			</dl>
		    			<dl class="p_aragraph_content" style="margin-top: 10px" >
			    			<dd>
			    				<div class="dd_left"><i class="red">*</i>次数:</div>
			    				<div class="dd_right">
			    					<input type="text" name="numTimes" id="numTimes1" value="" class="IptText301"/>
			    				</div>
			    				<div class="clear"></div>
			    			</dd>
		    			</dl>
		    			<dl class="p_aragraph_content" style="margin-top: 10px">
			    			<dd>
			    				<div class="dd_left"><i class="red">*</i>人数:</div>
			    				<div class="dd_right">
			    					<input type="text" name="numPerson" id="numPerson1" value="" class="IptText301"/>
			    				</div>
			    				<div class="clear"></div>
			    			</dd>
		    			</dl>
		    			<dl class="p_aragraph_content" style="margin-top: 10px">
			    			<dd>
			    				<div class="dd_left">金额:</div>
			    				<div class="dd_right">
			    					<input type="text" name="totalPrice" id="totalPrice1" readonly="readonly" class="IptText301"/>
			    				</div>
			    				<div class="clear"></div>
			    			</dd>
		    			</dl>
		    			<dl class="p_aragraph_content" style="margin-top: 10px">
			    			<dd>
			    				<div class="dd_left">备注:</div>
			    				<div class="dd_right">
			    					<textarea id="remark1" class="l_textarea" name="remark" style="width:270px;"></textarea>
			    				</div>
			    				<div class="clear"></div>
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