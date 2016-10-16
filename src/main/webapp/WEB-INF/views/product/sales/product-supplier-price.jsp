<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>散客预定</title>
    <%@ include file="/WEB-INF/include/top.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=staticPath%>/assets/css/product/product_detail.css"/>
</head>
<body>
<div class="mainbody"> 
	<table border="0" cellspacing="0" cellpadding="0" class="searchTab">
		<colgroup>
			<col width="20%" />
			<col width="" />
		</colgroup>
		<tr>
			<td>日期：</td>
			<td>
				
			</td>			
		</tr>
		<tr>
			<td>余位：</td>
			<td>
				
			</td>			
		</tr>
		<tr>
			<td>组团社名称：</td>
			<td>
				<input type="hidden" name="groupOrder.supplierId" id="supplierId"  value="744" />
				<input name="groupOrder.supplierName" id="supplierName" type="text" class="IptText300" value="浙江建设国际旅行社环球旅游部（畅享之旅）" />
				<a href="javascript:void(0)" onclick="selectSupplier();">请选择</a>
			</td>			
		</tr>
		<tr>
			<td>组团社联系人：</td>
			<td>
				<input type="text" name="groupOrder.contactName" id="contactName" class="IptText100" placeholder="姓名" value="张平" />
				<input type="text" name="groupOrder.contactTel" id="contactTel" class="IptText100" placeholder="座机" value="13805724800" />
				<input type="text" name="groupOrder.contactMobile" id="contactMobile" class="IptText100" placeholder="手机" value="13805724800" />
				<input type="text" name="groupOrder.contactFax" id="contactFax" class="IptText100" placeholder="传真" value="0571--87980989 " />
				<a href="javascript:void(0)" onclick="selectContact();">请选择</a>
			</td>			
		</tr>
		<tr>
			<td></td>
			<td id="groupList">
				
			</td>			
		</tr>
	</table>
</div>
</body>
<script type="text/javascript">
var supplierNameComplete={
	  source: function( request, response ) {
		  var keyword = request.term;
		  $.ajax({
			  type : "post",
			  url : "<%=ctx%>/tourGroup/getSupplierName",
			  data : {
				  supplierType : 1,
				  keyword:keyword
			  },
			  dataType : "json",
			  success : function(data){
				  if(data && data.success == 'true'){
					  response($.map(data.result,function(v){
						  return {label:v.nameFull,id:v.id};
					  }));
				  }
			  },
			  error : function(data,msg){}
		  });
	  },
	  focus: function(event, ui) {},
	  minLength : 0,
	  delay : 300
	
};

$(function(){
	//组团社
	supplierNameComplete.select = function(event, v){
		$("#supplierName").val(v.item.label);
		$("#supplierId").val(v.item.id);
	};
	$("#supplierName").autocomplete(supplierNameComplete);
	$("#supplierName").click(function(){$(this).trigger(eKeyDown);});
});

/** * 选择组团社 */
function selectSupplier(){
	layer.openSupplierLayer({
		title : '选择组团社',
		content : '<%=ctx%>/component/supplierList.htm?supplierType=1',
		callback: function(arr){
			if(arr.length==0){
				$.warn("请选组团社");
				return false;
			}
			$("#supplierName").val(arr[0].name);
			$("#supplierId").val(arr[0].id);
	    }
	});
}

function selectContact(){
	var supplierId=$("input[name='groupOrder.supplierId']").val();
	if(supplierId==''){
		$.info('请先选择组团社');
		return
	}
	var win;
	layer.open({ 
		type : 2,
		title : '选择联系人',
		closeBtn : false,
		area : [ '550px', '450px' ],
		shadeClose : false,
		content : '../component/contactMan.htm?supplierId='+supplierId,// 参数为供应商id
		btn: ['确定', '取消'],
		success:function(layero, index){
			win = window[layero.find('iframe')[0]['name']];
		},
		yes: function(index){
			// manArr返回的是联系人对象的数组
			var arr = win.getChkedContact();    				
			if(arr.length==0){
				$.error('请选择联系人')
				return false;
			}
			
			for(var i=0;i<arr.length;i++){
				$("input[name='groupOrder.contactName']").val(arr[i].name);
				$("input[name='groupOrder.contactTel']").val(arr[i].tel);
				$("input[name='groupOrder.contactMobile']").val(arr[i].mobile);
				$("input[name='groupOrder.contactFax']").val(arr[i].fax);
			}
			// 一般设定yes回调，必须进行手工关闭
	        layer.close(index); 
	    },cancel: function(index){
	    	layer.close(index);
	    }
	});
}
</script>
</html>
