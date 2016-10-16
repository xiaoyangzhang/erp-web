<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>基本信息</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<%@ include file="../../include/top.jsp"%>
<%
	String path = ctx;
%>


</head>
<body class="blank_body_bg">
	 <div class="p_container blank_page_bg"  >
	    	<form id="saveResourceForm">
	    	<dl class="p_paragraph_content">
				<input type="hidden" name="trafficRes.id"value="${trafficRes.id}" />
	    		<dd>
	    			<div class="dd_left"><i class="red">*</i>资源名称：</div> 
	    			<div class="dd_right"><c:if test="${trafficRes.id>=0}">${trafficRes.resName }</c:if>
	    			<c:if test="${trafficRes.id==null}"><input type="text" name="trafficRes.resName" value="${trafficRes.resName }" class="IptText300"></c:if></div>
					<div class="clear"></div>
	    		</dd> 
	    		
	    		<dd>
	    			<div class="dd_left"><i class="red">*</i>资源类型：</div> 
	    			<div class="dd_right">
	    			<select name="trafficRes.resMethod" id="trafficRes.resMethod" class="IptText300"  <c:if test="${trafficRes.id>=0}">disabled="disabled"</c:if>>
								<option value="AIR" <c:if test="${trafficRes.resMethod=='AIR' }"> selected="selected" </c:if>>飞机</option>
								<option value="TRAIN" <c:if test="${trafficRes.resMethod=='TRAIN' }"> selected="selected" </c:if>>火车</option>
								<option value="CAR" <c:if test="${trafficRes.resMethod=='CAR' }"> selected="selected" </c:if>>汽车</option>
							</select>
							</div>
					<div class="clear"></div>
	    		</dd> 
	    		
	    		
                <dd>
	    			<div class="dd_left">总量：</div> 
	    			<div class="dd_right"><c:if test="${trafficRes.id>=0}">${trafficRes.numStock}</c:if>
	    				<c:if test="${trafficRes.id==null}"><input type="text" name="trafficRes.numStock" value="${(empty trafficRes.numStock)?0:trafficRes.numStock}" style="width:96px"></c:if></div>
	    			<div class="dd_left">机动位：</div> 
	    			<div class="dd_right"><c:if test="${trafficRes.id>=0}">${trafficRes.numDisable}</c:if>
	    			<c:if test="${trafficRes.id==null}"><input type="text" name="trafficRes.numDisable" value="${(empty trafficRes.numDisable)?0:trafficRes.numDisable}" style="width:96px"></c:if></div>
					<div class="clear"></div>
	    		</dd>
	    		
	    		 <dd>
	    			<div class="dd_left">成本价:</div> 
	    			<div class="dd_right"><c:if test="${trafficRes.id>=0}"><fmt:formatNumber value="${trafficRes.costPrice}" pattern="#.##"/></c:if>
	    			<c:if test="${trafficRes.id==null}"><input type="text" name="trafficRes.costPrice" value="${(empty trafficRes.costPrice)?0:trafficRes.costPrice}" " class="IptText300"></c:if></div>
					<div class="clear"></div>
	    		</dd> 
	    		
	    		<dd>
	    			<div class="dd_left"><i class="red">*</i>开始日期：</div> 
	    			<div class="dd_right"><c:if test="${trafficRes.id>=0}">${trafficRes.dateStart}</c:if>
	    			<c:if test="${trafficRes.id==null}"><input name="trafficRes.dateStart" type="text" value="${trafficRes.dateStart}" style="width:120px;"
							       class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})"/></c:if></div>
					<div class="clear"></div>
	    		</dd> 
	    		<dd>
	    			<div class="dd_left"><i class="red">*</i>最晚预定:</div> 
	    			<div class="dd_right"><c:if test="${trafficRes.id>=0}">${trafficRes.dateLatest}</c:if>
	    			<c:if test="${trafficRes.id==null}"><input name="trafficRes.dateLatest" type="text" value="${trafficRes.dateLatest}" style="width:120px;"
							       class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm'})"/></c:if>
						</div>
					<div class="clear"></div>
	    		</dd> 
	  
	    	 <p class="p_paragraph_title"><b>交通信息：</b></p>
            <dl class="p_paragraph_content">
	    		<dd>
	    			<div class="dd_left"><span class="btnTianjia"><i></i>&nbsp;&nbsp;</span></div> 
	    			<div class="dd_right" style="width:80%">
                        <table cellspacing="0" cellpadding="0" class="w_table" > 
		             <col width="14%" /><col width="15%" /><col width="14%" /><col width="14%" /><col width="14%" /><col width="14%" /><col width="10%" /><col width="5%" />
		             <thead>
		             	<tr>
		             		<th>日期<i class="w_table_split"></i></th>
		             		<th>班次/航班号<i class="w_table_split"></i></th>
		             		<th>出发地<i class="w_table_split"></i></th>
		             		<th>到达地<i class="w_table_split"></i></th>
		             		<th>起飞时间<i class="w_table_split"></i></th>
		             		<th>落地时间<i class="w_table_split"></i></th>
		             		<th width="5%"><a href="javascript:;" onclick="addResLine();" class="def">增加</a></th>
		             	</tr>
		             </thead>
		             <tbody id="addContacts">
		             	<c:forEach items="${trafficResLine}" var="line" varStatus="index">
		             <tr>
							<td> <input name="trafficResLine[${index.index}].lineDate" type="text" value="${line.lineDate}" style="width:90px;" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})"/> 
							                                <input name="trafficResLine[${index.index}].id" type="hidden" value="${line.id}" /> </td>
							<td><input name="trafficResLine[${index.index}].classNo" type="text" value="${line.classNo}" /> </td>
							<td><input name="trafficResLine[${index.index}].departureCity" type="text" value="${line.departureCity}" /> </td>
							<td><input name="trafficResLine[${index.index}].arrivalCity" type="text" value="${line.arrivalCity}" /> </td>
							<td><input name="trafficResLine[${index.index}].departureTime" type="text" value="${line.departureTime}" style="width:90px;" class="Wdate" onClick="WdatePicker({dateFmt:'HH:mm'})"/> </td>
							<td><input name="trafficResLine[${index.index}].arrivalTime" type="text" value="${line.arrivalTime}" style="width:90px;" class="Wdate" onClick="WdatePicker({dateFmt:'HH:mm'})"/> </td>
							<td><a href="javascript:void(0);" onclick="delResLine(this)" class="def">删除</a></td>
					</tr>
					</c:forEach>
		             </tbody>
	          		</table>
	    			</div>
					<div class="clear"></div>
				</dd>
	    		<dd>
	    			<div class="dd_left">资源备注：</div> 
	    			<div class="dd_right"><textarea id="trafficRes.remark" class="w_textarea" style="width:790px !important;" name="trafficRes.remark">${trafficRes.remark}</textarea></div>
					<div class="clear"></div>
	    		</dd> 
            </dl>
            


            <div class="Footer">
            <dl class="p_paragraph_content">
	    		<dd>
	    			<div class="dd_left"></div> 
	    			<div class="dd_right">
            			<button  type="submit" class="button button-primary button-small">保存</button>
            			<button  type="button" class="button button-primary button-small" id="returnBtn">关闭</button>
					</div>
				</dd>
			</dl>
		 	</div>
            </form>		
            

</body>

<script type="text/javascript">
var path = '<%=path%>';
$("#saveResourceForm").validate({
	rules : {
		'trafficRes.resName' : {
			required : true,
		},
		'trafficRes.resMethod' : {
			required : true,
		},
		'trafficRes.dateStart' : {
			required : true,
		},
		'trafficRes.dateLatest' : {
			required : true,
		}
	},
	submitHandler : function(form) {
				var options = {
					url : "save.do",
					type : "post",
					dataType : "json",
					success : function(data) {

						if (data.success) {
							$.success('操作成功', function(){
                                refreshWindow("编辑产品", path + '/resTraffic/edit.do?id=' + data["id"]);
							});
							//$.success("操作成功", function(){
							//	window.location = path + '/productInfo/list.htm?state=1';
							//});
						} else {
							$.error(data.msg);
						}
					},
					error : function(XMLHttpRequest, textStatus,
									 errorThrown) {
						$.error('服务器忙，稍后再试');
					}
				};

				$(form).ajaxSubmit(options);
			},
			invalidHandler : function(form, validator) { // 不通过回调
				return false;
			}
		});
		
function addResLine(){
		var count = $("#addContacts").children('tr').length;
		var html = template('resLine_template', {index : count});
		$("#addContacts").append(html);
		var lineDate=$("input[name='trafficResLine["+count+"].lineDate']");
		var classNo =  $("input[name='trafficResLine["+count+"].classNo']");
		var departureCity =  $("input[name='trafficResLine["+count+"].departureCity']");
		var arrivalCity =  $("input[name='trafficResLine["+count+"].arrivalCity']");
		var departureTime =  $("input[name='trafficResLine["+count+"].departureTime']");
		var arrivalTime =  $("input[name='trafficResLine["+count+"].arrivalTime']");
}

 function delResLine(el){ 
	 $(el).parent('td').parent('tr').remove(); 
}


$('#returnBtn').on('click', function(){
        closeWindow();
});
</script>
<script type="text/html" id="resLine_template">
					<tr>
							<td> 
								<input type="hidden" name="trafficResLine[{{index}}].id"  value="${line.id}" /> 
							<input name="trafficResLine[{{index}}].lineDate" type="text" value="${line.lineDate}" style="width:90px;" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})"/> </td>
							<td><input name="trafficResLine[{{index}}].classNo" type="text" value="${line.classNo}" /> </td>
							<td><input name="trafficResLine[{{index}}].departureCity" type="text" value="${line.departureCity}" /> </td>
							<td><input name="trafficResLine[{{index}}].arrivalCity" type="text" value="${line.arrivalCity}" /> </td>
							<td><input name="trafficResLine[{{index}}].departureTime" type="text" value="${line.departureTime}" style="width:90px;" class="Wdate" onClick="WdatePicker({dateFmt:'HH:mm'})"/> </td>
							<td><input name="trafficResLine[{{index}}].arrivalTime" type="text" value="${line.arrivalTime}" style="width:90px;" class="Wdate" onClick="WdatePicker({dateFmt:'HH:mm'})"/> </td>
						    <td><a href="javascript:void(0);" onclick="delResLine(this)" class="def">删除</a></td>
					</tr>
</script>

</html>
