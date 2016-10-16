<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
    <title>日志信息</title>
    <meta charset="UTF-8">
   	<%@ include file="../../../include/top.jsp"%>  
</head>
<body>	
	<div class="p_container" >		
		<div id="divCenter" class="p_container_sub" >
			
<table class="w_table">
	<colgroup>
		<col width="5%">
		<col width="7%">
		<col width="9%">
		<col width="79%">
    </colgroup>
	<thead>
		<tr>	
			<th>序号<i class="w_table_split"></i></th>
			<th>操作人<i class="w_table_split"></i></th>					
			<th>操作时间<i class="w_table_split"></th>
			<th>日志内容<i class="w_table_split"></i></th>					
		</tr>
	</thead>
	<c:forEach items="${list}" var="log" varStatus="v">
		<tr class="trRow">
			<td>${v.count}</td>
			<td>${log.editUser}</td>					
			<td >
				<fmt:parseDate value="${fn:replace(log.editTime, ':00.0', ':00')}" pattern="yyyy-MM-dd HH:mm:ss" var="date1"></fmt:parseDate>  
            	<fmt:formatDate pattern="yyyy-MM-dd" value="${date1}" /><br/>
            	<fmt:formatDate pattern="HH:mm:ss" value="${date1}" />
			</td>
			<td>
			<div name="divLogContiner" class="log_container"></div>
			<input type="hidden" name="hTitle" value="">
			<input type="hidden" name="hLogText" value='${log.listDetail }'>
			</td>					
		</tr>
	</c:forEach>
</table>
		</div>

	</div>
<SCRIPT type="text/javascript">
$(function(){
	formatLog();
});

var formatLog = function(){
	
	$(".trRow").each(function(){
		var infoBlock = [];
		var hTitle = $(this).find("input[name='hTitle']").val();
		var hLogText = $(this).find("input[name='hLogText']").val();
		var logObj = jQuery.parseJSON(hLogText);
		var rowContainer = $(this).find("div[name='divLogContiner']");
		
		//用title来分块显示
		$.each(logObj, function(index, value) {
			//console.log(value);
			$.each(value, function(rowName, rowVal) { 
				if (rowName == "tableTitle"){
                    var info=null;
                    for(var i=0; i<infoBlock.length; i++){
                    	if (infoBlock[i].title == rowVal){      
                            info = infoBlock[i];
                        }
                    }
                    if (info != null){
                        info.len = info.len + 1;
                    }else{
                        infoBlock.push({"title":rowVal, "len":1, "action":value.action});
                    }
                }
                
			});
		});
		//console.log(infoBlock);
		
		//循环显示
		var outputAry = [];
		for(var i = 0; i < infoBlock.length; i++){
			var title = infoBlock[i].title, len = infoBlock[i].len;
			outputAry.push("<span class='logRadius title'>"+title+"</span>");
			if (infoBlock[i].len == 1){
				outputAry.push(GetText.getAction(infoBlock[i].action));
			}
			outputAry.push("<div class='log_box'>");
			$.each(logObj, function(index, value) {
				if (value.tableTitle == title){
                    //console.log(value.logText);
                    if (value.logText != ""){
	                    var logDetail = jQuery.parseJSON(value.logText);
	                    if (logDetail.length > 0){
	                    	 if (infoBlock[i].len > 1) 
	                             outputAry.push(GetText.getAction(value.action));
	                    	 
	                        $.each(logDetail, function(di, dv){
	                            if (dv.fieldAction == "UPDATE")
	                                outputAry.push(GetText.getRowEdit(dv));
	                            else
	                                outputAry.push(GetText.getRowAdd(dv));
	                        });
	                        
	                        if (infoBlock[i].len > 1) 
	                            outputAry.push("<p class='log_line'></p>");
	                        
	                    }else{
	                        outputAry.push("<span class='brief'>"+value.logBrief+"</span>");
	                    }
					}else{
						outputAry.push("<span class='brief'>"+value.logBrief+"</span>");
					}
				}
			});
            outputAry.push("</div>");
		}
		
		rowContainer.html(outputAry.join(''));
		
	});
	
	
}

var GetText = {
	getAction: function(action){
		var showText = "";
		if (action == "INSERT") showText = "新增";
		if (action == "UPDATE") showText = "更新";
		if (action == "DELETE") showText = "删除";
		return "<span class='log_action "+action.toLowerCase()+"'>"+showText+"</span>";
	},
	getRowEdit : function(rowObj){
	    var str = "<p><span class='chgField'>["+rowObj.fieldDescription+"]</span>";
	    str += "<span class='logRadius chgBeforeBg'>由</span>";
	    str += "<span class='chgBefore'>"+rowObj.valueOrigin+"</span>";
	    str += "<span class='logRadius chgAfterBg'>改为</span>";
	    str += "<span class='chgAfter'>"+rowObj.valueEdit+"</span></p>";
	    return str;
	},
	getRowAdd : function(rowObj){
	    var str = "<span class='chgField'>["+rowObj.fieldDescription+"]</span>";
	    str += "<span class='chgAfter'>"+rowObj.valueEdit+"</span>、";
	    return str;
	}
}
</SCRIPT>	
</body>
</html>