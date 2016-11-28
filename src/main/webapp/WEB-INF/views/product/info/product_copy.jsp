<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib uri="http://yihg.com/custom-taglib" prefix="cf" %>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>基本信息</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<%@ include file="../../../include/top.jsp"%>
<%
	String path = ctx;
%>
<link rel="stylesheet" type="text/css" href="<%=ctx %>/assets/css/ztree/zTreeStyle/zTreeStyle.css" />
<script type="text/javascript" src="<%=ctx %>/assets/js/ztree/jquery.ztree.core-3.5.min.js"></script>
<script type="text/javascript" src="<%=ctx %>/assets/js/ztree/jquery.ztree.excheck-3.5.min.js"></script>
<script type="text/javascript" src="<%=ctx %>/assets/js/json2.js"></script>
<script type="text/javascript" src="<%=ctx %>/assets/js/web-js/product/product_copy.js"></script>
</head>
<body>
	 <div class="p_container" >
	    <ul class="w_tab">
	    	<li><a href="javascript:void(0)" class="selected">基本信息</a></li>
	    	<li class="clear"></li>
	    </ul>

	    <div class="p_container_sub" id="tab1">
	    	<form id="saveProdectInfoForm">
	    	<p class="p_paragraph_title"><b>基本信息</b></p>
	    	<dl class="p_paragraph_content">
	    		<dd>
	    			<div class="dd_left"><i class="red">* </i>编码</div> 
	    			<div class="dd_right"><input type="text" name="productInfo.code" value="" class="IptText300" placeholder="若不填系统自动生成" ></div>
					<div class="clear"></div>
	    		</dd> 
	    		<%-- <dd>
	    			<div class="dd_left">产品类型</div> 
	    			<div class="dd_right">
	    				<label class="radio" for=""><input type="radio" <c:if test="${vo.productInfo.type eq 1}">checked="checked"</c:if> name="productInfo.type" value="1">国内长线</label>&nbsp;&nbsp;&nbsp;
						<label class="radio" for=""><input type="radio" <c:if test="${vo.productInfo.type eq 2}">checked="checked"</c:if> name="productInfo.type" value="2">周边短线</label>
						<label class="radio" for=""><input type="radio" <c:if test="${vo.productInfo.type eq 3}">checked="checked"</c:if> name="productInfo.type" value="3">出境线路</label>
	    			</div>
					<div class="clear"></div>
	    		</dd>  --%>
	    		<dd>
	    			<div class="dd_left">产品来源</div> 
	    			<div class="dd_right">
	    				<label class="radio" for=""><input type="radio" name="productInfo.sourceType" value="0" <c:if test="${vo.productInfo.sourceType == 0}"> checked="checked" </c:if> >自有</label>&nbsp;&nbsp;&nbsp;
						<label class="radio" for=""><input type="radio" name="productInfo.sourceType" value="1" <c:if test="${vo.productInfo.sourceType == 1}"> checked="checked" </c:if> >采购</label>
	    			</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left">产品名称</div> 
	    			<div class="dd_right">
	    			<p class="pb-5">
	    			<input type="hidden" name="productInfo.brandName" id="brandName" value="${vo.productInfo.brandName }">
	    			<select class="select160"  name="productInfo.brandId" id="brandId">
		    			<option value="">选择品牌</option>
		    			<c:forEach items="${brandList}" var="brand">
							<option value="${brand.id }" <c:if test="${vo.productInfo.brandId eq brand.id}"> selected </c:if>>${brand.value }</option>
						</c:forEach>
	    			</select><input type="text" id="txt_pcity" placeholder="产品名称" name="productInfo.nameCity" class="IptText300" value="${vo.productInfo.nameCity}">
	    				</p>
						<p class="pb-5">
						
                       <%--  <input type="text" id="txt_pday" placeholder="n晚n天"  name="productInfo.nameDuration" class="IptText60" value="${vo.productInfo.nameDuration}">
                        <input type="text" id="txt_ptraffic" name="productInfo.nameTravelMode" placeholder="长线交通" class="IptText60" value="${vo.productInfo.nameTravelMode}">
                        <input type="text" id="txt_pstar" name="productInfo.nameStarLevel" placeholder="星级" class="IptText60" value="${vo.productInfo.nameStarLevel}">
                        <input type="text" id="txt_ptype" name="productInfo.nameMode" placeholder="纯玩" class="IptText60" value="${vo.productInfo.nameMode}">  <i class="grey">游</i> --%>
	    				</p>
                        <p class="pb-5">
	    				<!-- <label id="productHint"></label> -->
                        </p>
	    			</div>
					<div class="clear"></div>
	    		</dd>
	    		 <dd>
	    			<div class="dd_left">操作计调</div> 
	    			<div class="dd_right"><input type="text" name="productInfo.operatorName" readonly="readonly" id="operatorName" value="${vo.productInfo.operatorName==null?operatorName:vo.productInfo.operatorName}" class="IptText300">
	    			<a href="javascript:void(0);" onclick="selectUser()">修改</a>
	    			<input type="hidden" name="productInfo.operatorId" id="operatorId" value="${vo.productInfo.operatorId==null?operatorId:vo.productInfo.operatorId}" >
	    			</div>
					<div class="clear"></div>
	    		</dd>
	    		 
	    		<%--
	    		<dd>
	    			<div class="dd_left">产品后缀</div> 
	    			<div class="dd_right"><input type="text" name="productInfo.nameBrief" value="${vo.productInfo.nameBrief}" class="IptText300"><i class="grey ml-10">例：牛人爆款升级，最高减600.</i></div>
					<div class="clear"></div>
	    		</dd> 
                <dd>
	    			<div class="dd_left">排序</div> 
	    			<div class="dd_right"><input type="text" name="productInfo.orderNum" value="${vo.productInfo.orderNum}" class="IptText300"><i class="grey ml-10">填写数字，数字越大，越在前面显示</i></div>
					<div class="clear"></div>
	    		</dd>
	    		  <dd>
	    			<div class="dd_left">目的地</div> 
	    			<div class="dd_right">
	    				<select name="productInfo.destProvinceId" id="provinceCode">
	    					<option value="">请选择省</option>
	    					<c:forEach items="${allProvince}" var="province">
								
								<option value="${province.id }"  <c:if test="${vo.productInfo.destProvinceId eq province.id}"> selected="selected" </c:if>>${province.name }</option>
							</c:forEach>
	    				</select>
	    				<select name="productInfo.destCityId" id="cityCode" >
	    					<option value="">请选择市</option>
	    					<c:forEach items="${allCity}" var="city">
								<option value="${city.id }"  <c:if test="${vo.productInfo.destCityId eq city.id}"> selected="selected" </c:if>>${city.name }</option>
							</c:forEach>
	    				</select>
	    				<input type="hidden" name="productInfo.destProvinceName" id="provinceVal" value="${vo.productInfo.destProvinceName}">
	    				<input type="hidden" name="productInfo.destCityName" id="cityVal" value="${vo.productInfo.destCityName }">
	    			</div>
					<div class="clear"></div>
	    		</dd> --%>
	    	</dl>

	    	<%-- <p class="p_paragraph_title"><b>负责人信息</b></p>
            <dl class="p_paragraph_content">
	    		<dd>
	    			<div class="dd_left"><span class="btnTianjia"><i></i>&nbsp;&nbsp;</span></div> 
	    			<div class="dd_right" style="width:80%">
	    				<div class="mb-5">
	    				<a href="#" onclick="selectUser()" class="button button-primary button-small">添加</a>
	    				</div>
                        <table cellspacing="0" cellpadding="0" class="w_table" > 
		             <col width="15%" /><col width="15%" /><col width="15%" /><col width="15%" /><col width="15%" /><col width="15%" /><col width="10%" />
		             <thead>
		             	<tr>
		             		<th>职务<i class="w_table_split"></i></th>
		             		<th>姓名<i class="w_table_split"></i></th>
		             		<th>手机<i class="w_table_split"></i></th>
		             		<th>座机<i class="w_table_split"></i></th>
		             		<th>传真<i class="w_table_split"></i></th>
		             		
		             		<th>操作</th>
		             	</tr>
		             </thead>
		              <tbody id="contacts">
		             	 <c:forEach items="${vo.productContacts}" var="contact" varStatus="a">
							 <tr>
								 <td>${contact.typeName }<input type="hidden" name="productContacts[${a.index}].typeName" value="${contact.typeName }"></td>
								 <td>${contact.name }<input type="hidden" name="productContacts[${a.index}].name" value="${contact.name }"></td>
								 <td>${contact.mobile }<input type="hidden" name="productContacts[${a.index}].mobile" value="${contact.mobile }"></td>
								 <td>${contact.tel }<input type="hidden" name="productContacts[${a.index}].tel" value="${contact.tel }"></td>
								 <td>${contact.fax }<input type="hidden" name="productContacts[${a.index}].fax" value="${contact.fax }"></td>
				                  <td><span class="btnDelete"><a href="javascript:void(0)" class="delcon def">删除</a></span></td>
		              		</tr>
						</c:forEach>
		             </tbody>
		             <tbody id="addContacts">
		             </tbody>
		             
	          		</table>
	    			</div>
					<div class="clear"></div>
	    		</dd>
            </dl>
 --%>


	    	<p class="p_paragraph_title"><b>图片</b></p>
	    	<dl class="p_paragraph_content">
	    		<dd>
	    			<div class="dd_left">首图</div> 
	    			<div class="dd_right addImg" id="attachments">
	    			 <c:forEach items="${vo.productAttachments}" var="attachment" varStatus="a">
	    				<span class="ulImg">
							<img src="${config.images200Url }${cf:thumbnail(attachment.path,'200x200')}" alt="${attachment.name }"><i class="icon_del delImg" style="display: none;" ></i>
							<input type="hidden" name="productAttachments[${a.index }].name" value="${attachment.name }" />
							<input type="hidden" name="productAttachments[${a.index }].path" value="${attachment.path}" />
							<input type="hidden" name="productAttachments[${a.index }].type" value="1" />
						</span>
					</c:forEach>
	    				<!-- <span class="ulImg"><img src="imgTemp/upImgDefault.png" alt=""><i class="w_icon_del"></i></span> -->
	    				
	    			</div>
	    			<label type="button" onclick="selectImg(this, '#imgTemp')" class="ulImgBtn"></label>
					<div class="clear"></div>
	    		</dd> 
	    		<dd>
	    			<div class="dd_left">附件</div> 
	    			<div class="dd_right addAttachment">
                        <c:if test="${ not empty vo.attachments}">
							<c:forEach items="${vo.attachments}" var="attachment" varStatus="a">
							<span class="ulImg">
								<c:choose>
									<c:when test="${fn:endsWith(attachment.path, '.doc')}"><img src="<%=path%>/assets/imgspace/images/thumbnail-word.jpg" alt="${attachment.name}"></c:when>
									<c:otherwise><img src="${config.images200Url }${cf:thumbnail(attachment.path,'200x200')}" alt="${attachment.name }"></c:otherwise>
								</c:choose><i class="icon_del delAtt" style="display: none;" ></i>
								<input type="hidden" name="attachments[${a.index}].name" value="${attachment.name }" />
								<input type="hidden" name="attachments[${a.index}].path" value="${attachment.path}" />
								<input type="hidden" name="attachments[${a.index}].type" value="2" />
							</span>
							</c:forEach>
                        </c:if>
					</div>
					<input type="button" name="" onclick="selectAttachment(this, '#attTemp')" value="附件" class="button button-primary button-small">
					<div class="clear"></div>
	    		</dd>
	    	</dl>
	    	<%@ include file="product_route_edit.jsp"%>
	    	
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
            <!-- 责任人模版 -->
            <div style="display: none;">
				<table>
					<tbody id="contactsTemp" style="display: none">
						<tr>
						  <td><input name="productContacts[$index].typeName" type="hidden" value="$typeName"/>$typeName</td>
		                  <td><input name="productContacts[$index].name" type="hidden" value="$name"/>$name</td>
		                  <td><input name="productContacts[$index].mobile" type="hidden" value="$mobile"/>$mobile</td>
		                  <td><input name="productContacts[$index].tel" type="hidden" value="$tel"/>$tel</td>
		                  <td><input name="productContacts[$index].fax" type="hidden" value="$fax"/>$fax</td>
		                  <td><span class="btnDelete"><a href="javascript:void(0)" class="delcon def">删除</a></span></td>
		                  </tr>
					</tbody>
				</table>
			</div>

			<!-- 图片模版 
			<div id="imgTemp" style="display: none">
				<span class="ulImg">
					<img src="$src" alt="$name"><i class="icon_del delImg" ></i>
					<input type="hidden" name="productAttachments[$index].name" value="$name" />
					<input type="hidden" name="productAttachments[$index].path" value="$path" />
					<input type="hidden" name="productAttachments[$index].type" value="1" />
				</span>
			</div>

			<div id="attTemp" style="display: none">
				<span class="ulImg">
					<img src="$src" alt="$name"><i class="icon_del delImg" ></i>
					<input type="hidden" name="attachment.name" value="$name" />
					<input type="hidden" name="attachment.path" value="$path" />
					<input type="hidden" name="attachment.type" value="2" />
				</span>
			</div>-->
	    </div>
     
        
    </div>
</body>
<script type="text/html" id="imgTemp">
<span class="ulImg">
<img src="$src" alt="$name"><i class="icon_del delImg" style="display: none;" ></i>
<input type="hidden" name="productAttachments[$index].name" value="$name" />
<input type="hidden" name="productAttachments[$index].path" value="$path" />
<input type="hidden" name="productAttachments[$index].type" value="1" />
</span>
</script>
<script type="text/html" id="attTemp">
<span class="ulImg">
<img src="$src" alt="$name"><i class="icon_del delAtt" style="display: none;" ></i>
<input type="hidden" name="attachments[$index].name" value="$name" />
<input type="hidden" name="attachments[$index].path" value="$path" />
<input type="hidden" name="attachments[$index].type" value="2" />
</span>
</script>
<script type="text/javascript">
var path = '<%=path%>';
function selectUser(){
	var win=0;
	layer.open({
		type : 2,
		title : '选择人员',
		shadeClose : true,
		shade : 0.5,
		area : [ '400px', '470px' ],
		content : '../component/orgUserTree.htm',//单选地址为orgUserTree.htm，多选地址为
		btn: ['确定', '取消'],
		success:function(layero, index){
			win = window[layero.find('iframe')[0]['name']];
		},
		yes: function(index){
			//userArr返回的是user对象的数组，user包含属性：用户id(id),职位(pos)，名称（name），mobile（手机）,phone（电话）,fax（传真）
			var userArr = win.getUserList();    				
			if(userArr.length==0){
				$.warn("请选择人员");
				return false;
			}
			
			//操作计调
			
				$("#operatorId").val(userArr[0].id);
				$("#operatorName").val(userArr[0].name);
			
			//一般设定yes回调，必须进行手工关闭
	        layer.close(index); 
	    },cancel: function(index){
	    	layer.close(index);
	    }
	});
}
</script>

</html>
