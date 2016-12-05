<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>首页</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<%@ include file="../../../include/top.jsp"%>
	<script type="text/javascript" src="<%=staticPath %>/assets/js/jquery.idTabs.min.js"></script>
	<script type="text/javascript" src="<%=ctx %>/assets/js/sys/emp.js"></script>
	<script type="text/javascript" src="<%=ctx %>/assets/js/json2.js?v=1"></script>
	
<script type="text/javascript">
	function del(str){
		if(confirm("是否确认删除！")){
			$.post("delOrg", { orgId: str},
					   function(data){
					     if(data.success){
					    	 $.success("删除成功！");
					    	 //location.href="treeIndex";
					     }else{
					    	 $.error("删除失败，存在下级！");
					     }
					   },"json");
		}
		
	}

	$(function(){
		$("#editForm").validate({
			errorElement : 'span',
			errorClass : 'help-block',
			focusInvalid : false,
			onkeyup : false,
		
			highlight : function(element) {
				$(element).closest('.form-group').addClass(
						'has-error');
			},
			success : function(label) {
				label.closest('.form-group').removeClass(
						'has-error');
				label.remove();
			},
			errorPlacement : function(error, element) {
				element.parent('span').append(error);
			},
			submitHandler : function(form) {
				//console.log(111);
				$.ajax({
	                type: "post",
	                cache:false,
	                url:"saveOrg",
	                data:$('#editForm').serialize(),// 你的formid
	                async: false,
	                dataType: 'json',
	                success: function(data) {
	                	if(data.success){
	                		$.success("添加成功",function(){
	                			window.location.href="getOrg?orgId="+data.orgId;
	                			//location.href="treeIndex";
	                		});	
	                	}else{
	                		$.error("添加失败",function(){location.reload();});	
	                		
	                		
	                	}
	                },
	                error:function(XMLHttpRequest, textStatus, errorThrown){
	                	alert(textStatus);
	                }
	            });
			}
		});
	})
	

</script>
</head>
<body>
	<div class="p_container">
		 
		
	<c:if test="${org.orgId!=null}">
		<div class="widget-toolbar col-xs-12" >
			<a class="button button-primary button-small" href="toCreateOrg?orgId=${org.orgId }&sysId=${org.sysId}">添加子部门 </a>
			<c:if test="${org.parentId!=0 }">
				<a class="button button-primary button-small"   onClick="del(${org.orgId})">删除当前部门</a>
			</c:if>
		</div>
		<hr>
	</c:if>
		<div class="p_container_sub" >
			<form class="form-horizontal center" role="form" id="editForm">
				<%-- <input type="hidden" id="bizId" name="bizId" value="${org.bizId} }" /> --%>
				<dl class="p_paragraph_content">
					<dd>
	    			<div class="dd_left"><i class="red">* </i>组织名称:</div> 
	    			<div class="dd_right">
	    				<input type="text" id="form-field-1" name="name"
							value="${org.name }" class="IptText300"  >
							
						<input type="hidden" name="orgId" value="${org.orgId }"/>
						<input type="hidden" name="sysId" value="${org.sysId }"/>
						<input type="hidden" name="parentId" value="${org.parentId }"/>		
					</div>
					<div class="clear"></div>
	    			</dd> 
					
				
					
					<dd>
	    			<div class="dd_left">编码:</div> 
	    			<div class="dd_right"><input type="text" id="form-field-1" name="code"
							value="${org.code }" class="IptText300"></div>
					<div class="clear"></div>
	    			</dd> 
					
				
					
					<dd>
	    			<div class="dd_left"> 顺序:</div> 
	    			<div class="dd_right"><input type="text" id="form-field-1" name="seqNum"
							value="${org.seqNum }" class="IptText300"></div>
					<div class="clear"></div>
	    			</dd> 
				
				
					
					<dd>
	    			<div class="dd_left"> 描述: </div> 
	    			<div class="dd_right"><input type="text" id="form-field-1" name="comment"
							value="${org.comment }" class="IptText300"></div>
					<div class="clear"></div>
	    			</dd> 
				
					<dd>
		    			<div class="dd_left"> 映射客户Id: </div> 
		    			<div class="dd_right"><input type="text" id="form-field-1" name="mappingSupplierId"
								value="${org.mappingSupplierId }" class="IptText300"></div>
						<div class="clear"></div>
	    			</dd> 
					<dd>
	    			<div class="dd_left">是否启用: </div> 
	    			<div class="dd_right" style="width: auto;">
	    					<input name="status" id="is" type="radio" class="ace" value="1"
							<c:if test="${org.status==true}"> checked=true</c:if> />  <span
							class="lbl">是</span> 
							<input name="status" id="not" type="radio"
							class="ace" value="0" <c:if test="${org.status==false}">checked=true </c:if> /> 
						<span class="lbl">否</span>
						</div>
					<div class="clear"></div>
	    			</dd> 
				<dd>
					<div class="dd_left"> LOGO: </div> 
 					
                	<div class="dd_right addImg"  style="width: auto;">
							<c:if test="${!empty org.logo}">
								<span class="ulImg" id="logoSpan"> 
									<img src="${config.imgServerUrl }${org.logo }" id="imgs" /> 
									<i class="icon_del"  id="delImg" style="display: none"></i> 
									<input type="hidden" name="logo" id="logo" value="${org.logo }" /> 
			                	</span>
							</c:if>
							<c:if test="${empty org.logo}">
								<span class="ulImg" style="display:none;" id="logoSpan">
									<img src="" id="imgs"/> 
									<i class="icon_del"  id="delImg" style="display: none"></i> 
									<input type="hidden" name="logo" id="logo" value="" /> 
			                	</span>
							</c:if>
							
	                </div>
	                <label onclick="selectAttachment(this)" class="ulImgBtn"></label>
	                <div class="clear"></div>
				</dd>
				</div>
		

					<dd>
					<div class="dd_left"></div>
					<div class="dd_right">
	    			<input type="submit" class="button button-primary button-small" value="提交"  />&nbsp;&nbsp;&nbsp;&nbsp;
	    			
					<input class="button button-primary button-small" type="reset"  value="重置表单" />&nbsp;&nbsp;&nbsp;&nbsp;
					<c:if test="${org.orgId!=null}">
						<input type="button" class="button button-primary button-small" value="组团社权限"  onclick="OrgSupplierAuth('${org.orgId}')" />
					</c:if>
					</div>
					<div class="clear"></div>
	    			</dd> 
				


			</form>

			</div>
			</div>
<script type="text/html" id="imgCopy">
	<div id="imgTemp" >
					<span class="ulImg"> <img src="$src" />
						<input type="hidden" name="logo"	value="$path" /> 
						
						
					</span>
				</div>
</script>
</body>
</html>
<script type="text/javascript">
			$(function(){
				var imgDelete=function () {
					$(".icon_del").unbind("click").click(function(){
						//$(".ulImg").remove();
						$(".ulImg").hide();
						$("#imgs").attr("src","");
						$("#logo").val("");
					})
				};
				imgDelete();
			});
function OrgSupplierAuth(orgid){
	layer.openOrgSupplierAuthLayer({
		title : '选择组团社',
		content :'<%=ctx %>/org/orgSupplierAuth.htm?supplierType=1&type=multi&orgid='+orgid,//参数：操作类型（type:单选(single)、多选(multi)）供应商类型supplierType=1
		callback: function(authsMap,getTableTemplate){
			//保存组织机构的组团社权限
			authsMap && (authsMap["orgid"] = orgid);
			$.ajax("<%=ctx %>/org/saveOrgAuthSuppliers.do",{
				contentType:"application/json;charset=utf-8",
				type:"post",
				data:JSON.stringify(authsMap),
				success:function(){
					$.info("授权成功");
					getTableTemplate();
				},
				error:function(){
					$.error("服务器异常");
				}
			});
	    }
	});
}	
</script>

