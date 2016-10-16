<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>首页-菜单信息编辑</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<%@ include file="../../../include/top.jsp"%>

    <script type="text/javascript" src="assets/js/jquery.idTabs.min.js"></script>
<script type="text/javascript">
	function del(str){
		if(confirm("是否确认删除！")){
			$.post("delMenu", { menuId: str},
					   function(data){
					     if(data.sucess){
					    	 $("body").tip({ynclose : true,status : "right",content :"删除成功！"});
					    	 setTimeout(function(){ $(window.parent.location.reload());},1000);
					     }else if(data.error)
				    	 {
				    	 	$.error(data.msg);
				    	 }
					   },"json");
		}
		
	}
</script>
</head>
<body>
	 <div class="p_container" >
		<c:if test="${platformMenuPo.menuId!=null}">
			<div class="widget-toolbar col-xs-12">
				<a class="btn btn-small btn-success"
					href="toCreateMenu?menuId=${platformMenuPo.menuId }&sysId=${platformMenuPo.sysId}">添加子级菜单
				</a> <a class="btn btn-small btn-danger" href="#"
					onClick="del(${platformMenuPo.menuId})">删除</a>
			</div>

		</c:if>
		<div class="widget-main col-xs-12">
			<form class="form-horizontal center" role="form" action="" id="form1"
				method="post">
				
				<div class="p_container_sub" >
				<dl class="p_paragraph_content">
					<dd>
	    			<div class="dd_left"><i class="red">* </i>菜单名称:</div> 
	    			<div class="dd_right">
	    				<input type="hidden" name="menuId" class="menuId"
							value="${platformMenuPo.menuId }" /> 
						<input type="hidden"
							name="sysId" value="${platformMenuPo.sysId }" /> 
						<input
							type="hidden" name="parentId" class="parentId"
							value="${platformMenuPo.parentId }" />
						<input type="text" id="form-field-1" name="name" value="${platformMenuPo.name }" class="IptText300" />
	    			</div>
					<div class="clear"></div>
	    		</dd>
				
				<%-- <div class="form-group"><p class="pb-5">
					<label class="col-sm-3 control-label no-padding-right"
						for="form-field-1"> 菜单名称: </label>

					<!-- <div class="col-sm-9"> -->
						<input type="hidden" name="menuId" class="menuId"
							value="${platformMenuPo.menuId }" /> 
						<input type="hidden"
							name="sysId" value="${platformMenuPo.sysId }" /> 
						<input
							type="hidden" name="parentId" class="parentId"
							value="${platformMenuPo.parentId }" />
						 <input type="text"
							id="form-field-1" name="name" value="${platformMenuPo.name }"
							class="col-xs-10 col-sm-5 menuName" /></p>
					<!-- </div> -->
				</div> --%>
				
				<dd>
					<div class="dd_left">菜单URL:</div>
					<div class="dd_right">
						<input type="text" id="form-field-1" name="url"
							value="${platformMenuPo.url }" class="IptText300" />
					</div>
					<div class="clear"></div>
				</dd>

				<%-- <div class="space-4"></div>
				<div class="form-group"><p class="pb-5">
					<label class="col-sm-3 control-label no-padding-right"
						for="form-field-1"> 菜单URL: </label>

					<!-- <div class="col-sm-9"> -->
						<input type="text" id="form-field-1" name="url"
							value="${platformMenuPo.url }" class="col-xs-10 col-sm-5 menuUrl" /></p>
					<!-- </div> -->
				</div> --%>
				
				<dd>
					<div class="dd_left">菜单编码:</div>
					<div class="dd_right">
						<input type="text" id="form-field-1" name="code"
							value="${platformMenuPo.code }" class="IptText300" />
					</div>
					<div class="clear"></div>
				</dd>
				
				<%-- <div class="space-4"></div>
				<div class="form-group"><p class="pb-5">
					<label class="col-sm-3 control-label no-padding-right"
						for="form-field-1"> 菜单编码: </label>

					<!-- <div class="col-sm-9"> -->
						<input type="text" id="form-field-1" name="code"
							value="${platformMenuPo.code }" class="col-xs-10 col-sm-5" /></p>
					<!-- </div> -->
				</div> --%>

				<dd>
					<div class="dd_left">顺序: </div>
					<div class="dd_right">
						<input type="text" id="form-field-1" name="seqNum"
							value="${platformMenuPo.seqNum }"
							onkeyup="this.value=this.value.replace(/\D/g,'')" class="IptText300" />
					</div>
					<div class="clear"></div>
				</dd>
				
				<%-- <div class="space-4"></div>
				<div class="form-group"><p class="pb-5">
					<label class="col-sm-3 control-label no-padding-right"
						for="form-field-1"> 顺序: </label>

					<!-- <div class="col-sm-9"> -->
						<input type="text" id="form-field-1" name="seqNum"
							value="${platformMenuPo.seqNum }"
							onkeyup="this.value=this.value.replace(/\D/g,'')"
							class="col-xs-10 col-sm-5" /></p>
					<!-- </div> -->
				</div> --%>

				<dd>
					<div class="dd_left">菜单样式: </div>
					<div class="dd_right">
						<input type="text" id="form-field-1" name="css"
							value="${platformMenuPo.css }" class="IptText300" />
					</div>
					<div class="clear"></div>
				</dd>
				
				<%-- <div class="space-4"></div>
				<div class="form-group"><p class="pb-5">
					<label class="col-sm-3 control-label no-padding-right"
						for="form-field-1">菜单样式: </label>

					<!-- <div class="col-sm-9"> -->
						<input type="text" id="form-field-1" name="css"
							value="${platformMenuPo.css }" class="col-xs-10 col-sm-5" /></p>
					<!-- </div> -->
				</div> --%>

				<dd>
					<div class="dd_left">描述: </div>
					<div class="dd_right">
						<input type="text" id="form-field-1" name="comment"
							value="${platformMenuPo.comment }"  class="IptText300" />
					</div>
					<div class="clear"></div>
				</dd>
				
				<%-- <div class="space-4"></div>
				<div class="form-group"><p class="pb-5">
					<label class="col-sm-3 control-label no-padding-right"
						for="form-field-1"> 描述: </label>

					<!-- <div class="col-sm-9"> -->
						<input type="text" id="form-field-1" name="comment"
							value="${platformMenuPo.comment }" class="col-xs-10 col-sm-5" /></p>
					<!-- </div> -->
				</div> --%>
				
				<dd>
					<div class="dd_left">操作类型:  </div>
					<div class="dd_right" style="width: auto;">
						<input name="resourceType" type="radio" class="ace" value="1" <c:if test="${platformMenuPo.resourceType==1 }">checked="checked"</c:if>  />
						<span class="lbl">菜单</span> 
							<input name="resourceType"
							type="radio" class="ace" value="0" <c:if test="${platformMenuPo.resourceType==0}"> checked="checked"</c:if> /> 
						<span class="lbl">操作</span>
					</div>
					<div class="clear"></div>
				</dd>
				
				<%-- <div class="space-4"></div>
				<div class="form-group"><p class="pb-5">
					<label class="col-sm-3 control-label no-padding-right"
						for="form-field-1">操作类型: </label>

					<!-- <div class="col-sm-2"> -->
						
							<input name="resourceType" type="radio" class="ace" value="1" <c:if test="${platformMenuPo.resourceType==1 }">checked="checked"</c:if>  />
						<span class="lbl">菜单</span> 
							<input name="resourceType"
							type="radio" class="ace" value="0" <c:if test="${platformMenuPo.resourceType==0}"> checked="checked"</c:if> /> 
						<span class="lbl">操作</span></p >
					<!-- </div> -->
				</div> --%>

				<dd>
					<div class="dd_left">是否启用: </div>
					<div class="dd_right" style="width: auto;">
						 <input name="status" type="radio" class="ace" value="1" <c:if test="${platformMenuPo.status==1 }">checked="checked" </c:if>/>  
						<span class="lbl">启用</span> 
							 <input name="status" type="radio" class="ace" value="0" <c:if test="${platformMenuPo.status==0}">checked="checked" </c:if> /> 
						<span class="lbl">禁用</span>
					</div>
					<div class="clear"></div>
				</dd>
				
				<%-- <div class="space-4"></div>
				<div class="form-group"><p class="pb-5">
					<label class="col-sm-3 control-label no-padding-right"
						for="form-field-1">是否启用: </label>

					<!-- <div class="col-sm-2"> -->
						
							 <input name="status" type="radio" class="ace" value="1" <c:if test="${platformMenuPo.status==1 }">checked="checked" </c:if>/>  
						<span class="lbl">启用</span> 
							 <input name="status" type="radio" class="ace" value="0" <c:if test="${platformMenuPo.status==0}">checked="checked" </c:if> /> 
						<span class="lbl">禁用</span></p>
					<!-- </div> -->
				</div> --%>
				<input name="delStatus" type="hidden" class="ace" value="1" />
				<%-- 
				<div class="space-4"></div>
				<div class="form-group">
					<label class="col-sm-3 control-label no-padding-right"
						for="form-field-1"> 是否删除: </label>

					<div class="col-sm-2">
						<input name="delStatus" type="radio" class="ace" value="1"
							<c:if test="${platformMenuPo.delStatus==1}"> checked="checked" </c:if> /> <span
							class="lbl">未删除</span> <input name="delStatus" type="radio"
							class="ace" value="0"
							<c:if test="${platformMenuPo.delStatus==0}"> checked="checked" </c:if> />
						<span class="lbl">逻辑删除</span>
					</div>
				</div>
 --%>
 				<dd>
					<div class="dd_left"></div>
					<div class="dd_right">
						<input class="button button-primary button-small" type="button" id="tag_set" value="提交" />
						&nbsp; &nbsp; &nbsp;<input class="button button-primary button-small" type="reset" value="重置表单" />
					</div>
					<div class="clear"></div>
				</dd>
				
				<!-- <div class="space-4"></div>
				<div class="clearfix form-actions">
					<div class="col-md-9">
						<input class="button button-primary button-small" type="button" id="tag_set" value="提交" />
						&nbsp; &nbsp; &nbsp;<input class="button button-primary button-small" type="reset" value="重置表单" />
					</div>
				</div> -->

			</form>

		</div>
	</div>
	<script type="text/javascript">
		var menuNameFlag = 0;
		function checkMenuName(menuName,parentMenuId,exceptMenuId){
			    $.ajax({
                    url: "commons/valideteMenuName",
                    type: "post",
                    dataType: 'json',
                    data:{
                    	"menuName":menuName,
                    	"parentMenuId":parentMenuId,
                    	"exceptMenuId":exceptMenuId
                    },
                    success: function (data) {
                      	if(data.success==true){
                      		menuNameFlag = 1;
                      		$("body").tip({ynclose : true,status : "right",content :"菜单名可以使用！"});
                      	}else{
                      		menuNameFlag = 0;
                      		$("body").tip({ynclose : 'y',status : "error",content :"菜单名已存在！"});
                      	}
                    },
                    error: function () {
                    	$("body").tip({ynclose : 'y',status : "error",content :"网络错误！"});
                    }
                });
				
				
			}
	
			$(document).ready(function(){
				$("#form-field-1").focus();
				$(".menuName").blur(function(){
					var menuName = $.trim($(this).val());
					if(menuName==''){
						menuNameFlag = 0;
						$("body").tip({ynclose : 'y',status : "error",content :"必须输入菜单名！"});
					}else{
						checkMenuName(menuName,$(".parentId").val(),$(".menuId").val());
					}
					
				});
				$(".menuUrl").blur(function(){
					if(!/^\/.+$/ig.test($(".menuUrl").val())){
						$("body").tip({ynclose : 'y',status : "error",content :"菜单URL不正确！"});
					}else{
						$("body").tip({ynclose : true,status : "right",content :"菜单URL正确！"});
					}
					
				});
				
				$("#tag_set").click(function () {
					
					if(menuNameFlag ==0)
						return false;
					
					if(!/^\/.+$/ig.test($(".menuUrl").val())){
						$("body").tip({ynclose : 'y',status : "error",content :"菜单URL不正确！"});
						return false;
					}
					
					$("body").tip({status:"statusing",content:"正在提交,请稍后...",ynclose:false});
                    $.ajax({
                        url: "saveMenu",
                        type: "post",
                        dataType: 'json',
                        data:$("#form1").serialize(),
                        success: function (data) {
                           //alert(data.error);
                           if(data.error==0)
                           {
                        	 $("body").tip({ynclose : true,status : "right",content :"操作成功！"});
                        	 
                        	 setTimeout(function(){ $(window.parent.location.reload());},1000);
                        	
                           	 //$("#errorMsg1").html("<font color=red>消息模板ID不存在，请到微信后台添加！见使用教程</font>");
                           	 //G.ui.tips.err("发送失败！");
                           }else if(data.error==1){
                        	   $("body").tip({ynclose : 'y',status : "error",content :"操作失败！"});
                           	//G.ui.tips.suc("信息发送中...,请稍候查看发送历史!");
                           	//$this.text("提交中...").addClass("disabled").attr("disabled", "disabled");
                            //$this.text("确定").removeClass("disabled").removeAttr("disabled");
                            //$("#errorMsg1").html("<font color=green style='font-size: 14px;'>群发消息需要一段时间，您可以关闭此对话框，操作其它功能。请稍候查看发送历史!<br/>  [信息发送中...]</font>");
                           // $('#myModal1').modal('hide');
                           }
                        },
                        error: function () {
                            //alert("设置失败....");
                            G.ui.tips.err("发送失败！");
                            $this.text("重试").removeClass("disabled").removeAttr("disabled");
                        }
                    });
                });
			});
	
          	
          </script>
</body>
</html>

