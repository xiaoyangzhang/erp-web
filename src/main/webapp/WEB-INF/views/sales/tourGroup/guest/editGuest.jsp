<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
</head>
	<body>
		<div id="editGuest" style="display: none;">
	 		<form id="editGuestForm" method="post" action="">
				<div class="p_container">
				<div class="p_container_sub">
					<input type="hidden" id="guestId" name="id"/>
					<input type="hidden" id="orderId" name="orderId" value="${orderId}" />
					<dl class="p_aragraph_content">
						<dd>
							<div class="dd_left"><i class="red">* </i>姓名:</div>
							<div class="dd_right">
								<input type="text" name="name" id="guestName1" value=""
									class="IptText301" />
							</div>
							<div class="dd_left">性别:</div>
							<div class="dd_right">
								<input type="radio" id="guestGender1" name="gender" value="1" checked="checked" />男
								<input type="radio" id="guestGender1" name="gender" value="0" />女
							</div>
							<div class="clear"></div>
						</dd>
					</dl>
					<dl class="p_aragraph_content">
						<dd>
							<div class="dd_left"><i class="red">* </i>证件号码:</div>
							<div class="dd_right">
								<input type="text" id="guestCertificateNum1"
									name="certificateNum" class="IptText301" />
							</div>
							<div class="dd_left">证件类别:</div>
							<div class="dd_right">
								<select id="guestSl1" name="certificateTypeId" class="select160"
									style="width: 160px; text-align: right">
									<c:forEach items="${zjlxList}" var="v"
										varStatus="vs">
										<option id="it" value="${v.id}">${v.value}</option>
									</c:forEach>
								</select>
							</div>
							<div class="clear"></div>
						</dd>
					</dl>
					<dl class="p_aragraph_content" style="margin-top: 10px">
						<dd>
							<div class="dd_left">年龄:</div>
							<div class="dd_right">
								<input type="text" name="age" id="guestAge1" value=""
									class="IptText301" />
							</div>
							<div class="dd_left">类别:</div>
							<div class="dd_right">
								<select id="guestTypeSl1" name="type" class="select160"
									style="width: 160px; text-align: right">
									<option id="it" value="1">成人</option>
									<option id="it" value="2">儿童</option>
									<option id="it" value="3">全陪</option>
								</select>
							</div>
							<div class="clear"></div>
						</dd>
					</dl>
					<dl class="p_aragraph_content" style="margin-top: 10px">
						<dd>
							<div class="dd_left">手机号码:</div>
							<div class="dd_right">
								<input type="text" name="mobile" id="guestMobile1" value=""
									class="IptText301" />
							</div>
							<div class="dd_left">是否单房:</div>
							<div class="dd_right">
								<input type="radio" id="guestIsSingleRoom1" name="isSingleRoom"
									value="1" />是 <input type="radio" id="guestIsSingleRoom1"
									name="isSingleRoom" value="0" checked="checked" />否
							</div>
							<div class="clear"></div>
						</dd>
					</dl>
					<dl class="p_aragraph_content" style="margin-top: 10px">
						<dd>
							<div class="dd_left">籍贯:</div>
							<div class="dd_right">
								<input type="text" name="nativePlace" id="guestNativePlace1"
									value="" class="IptText301" />
							</div>
							<div class="dd_left">是否领队:</div>
							<div class="dd_right">
								<input type="radio" id="guestIsLeader1" name="isLeader" value="1" />是
								<input type="radio" id="guestIsLeader1" name="isLeader" value="0" checked="checked" />否
							</div>
							<div class="clear"></div>
						</dd>
					</dl>
					<dl class="p_aragraph_content" style="margin-top: 10px">
						<dd>
							<div class="dd_left">职业:</div>
							<div class="dd_right">
								<input type="text" name="career" id="guestCareer1" value=""
									class="IptText301" />
							</div>
							<div class="dd_left">是否全陪:</div>
							<div class="dd_right">
								<input type="radio" id="guideIsGuide1" name="isGuide" value="1" />是
								<input type="radio" id="guideIsGuide1" name="isGuide" value="0" checked="checked" />否
							</div>
							<div class="clear"></div>
						</dd>
					</dl>
					<dl class="p_aragraph_content" style="margin-top: 10px">
						<dd>
							<div class="dd_left">备注:</div>
							<div class="dd_right">
								<textarea id="guestMark1" class="l_textarea" name="remark" style="width:270px;"></textarea>
							</div>
							<div class="clear"></div>
						</dd>
					</dl>
				</div>
			</div>
			<div class="modal-footer" style="margin-left: 43%;">
				<button type="submit"
					class="button button-primary button-small">保存</button>
			</div>
		    </form>
		</div>
	</body>
</html>