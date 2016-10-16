<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@ include file="../../../include/top.jsp"%>
<script type="text/javascript" src="<%=ctx%>/assets/js/web-js/sales/regional.js"></script>
<style type="text/css">
	.help-block{color:red;}
</style>
</head>
<body>
	<div class="p_container">
		
			<p class="p_paragraph_title"><b>咨询登记:</b></p>
			
			<dl class="p_paragraph_content">
	    		<dd>
	    			<div class="dd_left"><i class="red">* </i>姓名：</div> 
	    			<div class="dd_right">
	    				<input name="name" value="${guestConsult.name }" disabled="disabled" type="text" class="IptText300"  />
	    			</div>
					<div class="clear"></div>
	    		</dd> 
	    		<dd>
	    			<div class="dd_left"><i class="red">* </i>电话：</div> 
	    			<div class="dd_right">
	    				<input name="phone" value="${guestConsult.phone }" disabled="disabled" id="phone" type="text" class="IptText300"  />
					</div>
					<div class="clear"></div>
	    		</dd> 
	    		<dd>
	    			<div class="dd_left">性别：</div> 
	    			<div class="dd_right">
	    				<input name="sex" type="radio" disabled="disabled" <c:if test="${guestConsult.sex == 'M' }">checked</c:if>    value="M"  />男&nbsp;&nbsp;&nbsp;
	    				<input name="sex" type="radio" disabled="disabled" <c:if test="${guestConsult.sex == 'F' }">checked</c:if>  value="F" />女
					</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left">籍贯：</div> 
	    			<div class="dd_right">
	    				<select name="provinceId" id="provinceCode" class="input-small">
							<option value="">请选择省</option>
							<c:forEach items="${allProvince}" var="province">
								<option value="${province.id }" disabled="disabled" <c:if test="${guestConsult.provinceId == province.id }">selected</c:if>>${province.name }</option>
							</c:forEach>
						</select> <select name="cityId" id="cityCode" class="input-small">
							<option value="">请选择市</option>
							<c:if test="${guestConsult.cityId!=null }">
							<c:forEach items="${cityList}" var="city">
								<option value="${city.id }" disabled="disabled" <c:if test="${guestConsult.cityId == city.id }">selected</c:if>>${city.name }</option>
							</c:forEach>
							</c:if>
						</select>
						<input name="provinceName" id="provinceName" type="hidden"  value="" />
						<input name="cityName" id="cityName" type="hidden"  value="" />
					</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
					
						<div class="dd_left">QQ：</div>
						<div class="dd_right">
							<input name="qq" value="${guestConsult.qq }" disabled="disabled"  type="text" class="IptText300"  />
						</div>
						<div class="clear"></div>
					</dd><dd>
						<div class="dd_left">微信：</div>
						<div class="dd_right">
							<input name="wechat" value="${guestConsult.wechat }" disabled="disabled" type="text" class="IptText300"  />
						</div>
						<div class="clear"></div>
					</dd><dd>
						<div class="dd_left">E-mail：</div>
						<div class="dd_right">
							<input name="email" value="${guestConsult.email }" disabled="disabled" type="text" class="IptText300"  />
						</div>
						<div class="clear"></div>
					</dd><dd>
						<div class="dd_left">咨询日期：</div>
						<div class="dd_right">
						<input type="text" name="consultDate" class="Wdate"
							onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" disabled="disabled" value='<fmt:formatDate value="${guestConsult.consultDate }" pattern="yyyy-MM-dd"/>' readonly="readonly"  />
							
						</div>
						<div class="clear"></div>
					</dd><dd>
						<div class="dd_left">咨询主题：</div>
						<div class="dd_right">
							<input name="topic" value="${guestConsult.topic }" disabled="disabled" type="text" class="IptText300"  />
						</div>
						<div class="clear"></div>
					</dd><dd>
						<div class="dd_left">咨询内容：</div>
						<div class="dd_right">
							<textarea class="AreaDef" disabled="disabled"  rows="10" cols="20" name="content">${guestConsult.content }</textarea>
						</div>
						<div class="clear"></div>
					</dd><dd>
						<div class="dd_left">备注：</div>
						<div class="dd_right">
							<textarea class="AreaDef" disabled="disabled" rows="10" cols="20" name="note">${guestConsult.note }</textarea>
						</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left">客人来源：</div>
						<div class="dd_right">
							<c:forEach items="${guestSources }" var="guest">
								<input name="guestSourceId" disabled="disabled" type="radio"  value="${guest.id }" <c:if test="${guestConsult.guestSourceId == guest.id }">checked</c:if> /><span>${guest.value }</span>
							</c:forEach>
								<input name="guestSourceName" id="guestSourceName" type="hidden"  value="" />
						</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left">意向游玩：</div>
						<div class="dd_right">
							<c:forEach items="${intentionDests }" var="dest">
								<input name="intentionDestId" disabled="disabled" type="radio"  value="${dest.id }" <c:if test="${guestConsult.intentionDestId == dest.id }">checked</c:if> /><span>${dest.value }</span>
							</c:forEach>
							<input name="intentionDestName" id="intentionDestName" type="hidden"  value="" />
						</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left">信息渠道：</div>
						<div class="dd_right">
							<c:forEach items="${infoSources }" var="info">
								<input name="infoSourceId" disabled="disabled" type="radio"  value="${info.id }" <c:if test="${guestConsult.infoSourceId == info.id }">checked</c:if> /><span>${info.value }</span>
							</c:forEach>
							<input name="infoSourceName" id="infoSourceName" type="hidden"  value="" />
						</div>
					<div class="clear"></div>
	    		</dd>
	    		
    	</dl>
		
	</div>
	<div class="p_container">
			<p class="p_paragraph_title"><b>跟进情况:</b></p>
			<table cellspacing="0" cellpadding="0" class="w_table">
				<col width="5%"/><col width="8%"/><col width="12%"/><col width="8%"/><col width="67%"/>
				<thead>
					<th>序号</th>
					<th>跟进人</th>
					<th>跟进方式</th>
					<th>跟进时间</th>
					<th>根据内容</th>
				</thead>
				<tbody>
				<c:forEach items="${consultFollows }" var="v" varStatus="vs"> 
					<tr>
						<td>${vs.count }</td>
						<td>${v.followerName }</td>
						<td>${v.methodName }</td>
						<td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${v.createTime }" /></td>
						<td>${v.content }</td>
					</tr>
				</c:forEach>
				</tbody>
			</table>
			<dl class="p_paragraph_content">
			
		<form action="" id="followForm" method="post">
			<input name="consultId" id="consultId" type="hidden" value="${guestId }"  />
		
				<dd>
				<div class="dd_left">跟进方式：</div>
						<div class="dd_right">
							<c:forEach items="${followWays }" var="way">
								<input name="methodId" type="radio"  value="${way.id }"  /><span>${way.value }</span>
							</c:forEach>
							<input name="methodName" id="methodName" type="hidden"   />
						</div>
					<div class="clear"></div>
				</dd>
				<dd>
				<div class="dd_left">跟进内容：</div>
						<div class="dd_right">
						<textarea class="AreaDef"  rows="10" cols="20" name="content"></textarea>

						</div>
					<div class="clear"></div>
				</dd>
				<dd>
	    		<button type="submit" class="button button-primary button-small" onclick="save(1)" >保存</button>&nbsp;&nbsp;&nbsp;
	    		<button type="submit" class="button button-primary button-small" onclick="save(2)">已成团</button>&nbsp;&nbsp;&nbsp;
	    		<button type="submit" class="button button-primary button-small" onclick="save(3)">跟进结束</button>&nbsp;&nbsp;&nbsp;
	    		<a href="javascript:void(0)" onclick="closeWindow()" class="button button-primary button-small">关闭</a>
	    		</dd>
				</form>
			</dl>
	</div>
	<script type="text/javascript">
		var path = '<%=ctx%>';
		$(function () {
	        $(".AreaDef").autoTextarea({ minHeight: 80 });
	        
	    });
		function save(num){
			$("#methodName").val($("input[name='methodId']:checked+span").text());
			var options={
				url:"saveConsultFollow.do",
				type:"post",
				dataType:"json",
				data:{
					type:num
				},
				success:function(data){
					if(data.success){
						$.success("保存成功");
						location.href="<%=ctx%>/consult/followConsult.htm?guestId=${guestConsult.id}";
					}
				},
				error:function(data,msg){
					$.error("保存失败，请稍后再试");
				}
				
			};
			$("#followForm").ajaxSubmit(options);
		}
	</script>
	
</body>
</html>