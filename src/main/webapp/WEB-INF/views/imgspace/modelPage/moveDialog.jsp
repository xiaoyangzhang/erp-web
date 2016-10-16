<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
 <%
 String path = request.getContextPath();
 request.setAttribute("path",path);
 %>
  

<script type="text/javascript">
  var info = "";
	
		 $.fn.zTree.init($("#J_ModalTree_1_ul"), moveSetting, ${dirs});
		   var treeObj = $.fn.zTree.getZTreeObj("J_ModalTree_1_ul");
		   treeObj.expandAll(true);
		   var moveSetting = {
					check: {
						enable: false
					},
					data: {
						simpleData: {
							enable: true
						}
					},
					view: {
						showIcon: false,
						selectedMulti: false
				    },
				    callback:{
				    	onClick: moveZtreeOnClick
				    }
				};

		   function moveZtreeOnClick(event, treeId, treeNode){
			   moveImageF(treeNode.id);
		   }
		  function moveImageF(imageId){
			  $("#moveImageId").val(imageId);
		  }
</script>

<div class="modal-content" id="anps">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal"/>
			<h3 class="modal-title">移动到</h3> <div class="modal-subTitle"></div>
	</div>
	<div class="modal-body">
		<div class="move-file ztree" id="J_ModalTree">
			<li id="J_MainTree_1" class="level0" tabindex="0" hidefocus="true" treenode=""><span id="J_MainTree_1_switch" title="" class="button level0 switch root_open" treenode_switch=""></span><a id="J_MainTree_1_a" class="level0 curSelectedNode" treenode_a="" onclick="moveImageF('0')" title="我的图片"><span id="J_MainTree_1_ico" title="" treenode_ico="" class="button ico_open"></span><span id="J_MainTree_1_span">我的图片</span></a>
                 <ul id="J_ModalTree_1_ul" class="level0" >
                 
                 </ul>
            </li>
		</div>
	</div>
	<div class="modal-footer">
		<button type="button" class="btn btn-primary" id="moveDialogBtn" data-type="">确定</button>
		<button type="button" class="btn btn-default" data-dismiss="modal" id="closeDialogBtn">取消</button>
	</div>
</div>

<script type="text/javascript">
	$("#moveDialogBtn").on("click",function(){
		var parentId = $("#moveImageId").val();
		var imageId = $("#deleteImageId").val();
		var imageType = $("#imageType").val();
		$.ajax({
            url:"<%=path%>/images/moveImage",
            type: "post",  
            data:{imageId:imageId,parentId:parentId},
            dataType: "json",
            async:false,  
            cache:false, 
            success:function(data){
                if(data.sucess){
                    layer.close(moveDialog);
                    layer.msg('文件移动成功', {icon:6,time:1500}); 
                    if(imageType == 1){
                        floadDubble(parentId);
                    }else{
                        window.location = "<%=path%>";
                    }
                }
            },error:function(){
                layer.close(moveDialog);
                layer.msg('服务器未响应', {icon:3,time:1500}); 
            }
        });
		
	});
	
	 $("#closeDialogBtn").on("click",function(){
	        layer.close(moveDialog);
	 });
</script>

