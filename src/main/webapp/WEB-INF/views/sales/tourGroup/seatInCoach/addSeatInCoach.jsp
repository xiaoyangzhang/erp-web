<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
</head>
	<body>
		<div id="addSeatInCoachItem" style="display: none;">
	 		<form id="addSeatInCoachItemForm" method="post" action="">
				<div class="p_container" >
			        <div class="p_container_sub" >
		    			<input type="hidden" id="id" name="id" value=""/>
		    			<input type="hidden" id="orderId" name="orderId" value="${orderId}"/>
						<dl class="p_aragraph_content" style="margin-top: 10px">
	    					<dd>
		    					<div class="dd_left">线路类型:</div>
		    					<div class="dd_right">
			                		<select name="sourceType" id="sourceType" class="select160" style="width: 160px;">
										<option value="1">省外交通</option>
										<option value="0">省内交通</option>
									</select>
		                		</div>
		                		<div class="clear"></div>
	    					</dd>
 						</dl>
						<dl class="p_aragraph_content" style="margin-top: 10px;">
	    					<dd>
	    						<div class="dd_left">接送方式:</div>
	    						<div class="dd_right">
		    						<input type="radio" id="type" name="type" value="0">接
									<input type="radio" id="type" name="type" value="1"  checked="checked">送
								</div>
								<div class="clear"></div>
	    					</dd>
 						</dl>
 						<dl class="p_aragraph_content" style="margin-top: 10px">
	    					<dd>
		    					<div class="dd_left">交通方式:</div>
		    					<div class="dd_right">
			    					<select id="s" name="method" class="select160" style="width: 160px;">
			                			<c:forEach items="${transportTypeList}" var="v" varStatus="vs">
											<option id="it" value="${v.id}">${v.value}</option>
										</c:forEach>
			                		</select>
		                		</div>
		                		<div class="clear"></div>
	    					</dd>
 						</dl>
 						<dl class="p_aragraph_content" style="margin-top: 10px">
	    					<dd>
	    						<div class="dd_left"><i class="red">*</i>出发城市:</div>
	    						<div class="dd_right">
	    							<input type="text" name="departureCity" id="departureCity" value="" class="IptText301"/>
	    						</div>
		                		<div class="clear"></div>
	    					</dd>
 						</dl>
 						<dl class="p_aragraph_content" style="margin-top: 10px">
	    					<dd>
	    						<div class="dd_left"><i class="red">*</i>到达城市:</div>
	    						<div class="dd_right">
	    							<input type="text" id="arrivalCity" name="arrivalCity" value="" class="IptText301"/>
	    						</div>
		                		<div class="clear"></div>
	    					</dd>
 						</dl>
						<dl class="p_aragraph_content" style="margin-top: 10px">
							<dd>
	    						<div class="dd_left">班次/车次:</div>
	    						<div class="dd_right">
	    							<input type="text" name="classNo" id="classNo" value="" class="IptText301"/>
	    						</div>
		                		<div class="clear"></div>
	    					</dd>
	    				</dl>
	    				<dl class="p_aragraph_content" style="margin-top: 10px">
	    					<dd>
	    						<div class="dd_left">出发时间:</div>
	    						<div class="dd_right">
	    							<input style="width: 150px;" type="text" id="departureTime" name="departureTime" class="Wdate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm'})"/>
	    						</div>
		                		<div class="clear"></div>
	    					</dd>
	    				</dl>
	    				<dl class="p_aragraph_content" style="margin-top: 10px">
	    					<dd>
	    						<div class="dd_left">到达时间:</div>
	    						<div class="dd_right">
	    							<input style="width: 150px;" type="text" id="departureDate" name="departureDate" class="Wdate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm'})"/>
	    						</div>
		                		<div class="clear"></div>
	    					</dd>
 						</dl>
 						<dl class="p_aragraph_content" style="margin-top: 10px">
	    					<dd>
	    						<div class="dd_left">目的地:</div>
	    						<div class="dd_right">
	    							<input type="text" name="destination" id="destination" value="" class="IptText301"/>
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