<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<html>
<head>
<title>云旅游ERP系统</title>
<%@ include file="../include/top.jsp" %>
</head>
<body>
	<div class="header">
		<div class="head">
			<div class="logo">
				<span class="fl mt-5"><img src="assets/img/logo.png"></span> <span
					class="logo-word fl ml-15 mt-10">旅道 云旅游ERP系统</span>
			</div>
			<div class="msg-title">
				<span class="return mr-20 fl"><em class="re-icon icon"></em>返回官网</span>
				<span class="mr-20 fl">帮助</span> <span class="mr-50 fl">通讯录</span> <span
					class="fl pr-20 sms"> <span class="fl">消息</span> <em
					class="ml-10 icon yellow-icon"></em> <strong class="num">12</strong>
					<ul class="newDown">
						<li>公告</li>
						<li>内容</li>
						<li>私信</li>
					</ul>
				</span> <span class="fl mr-10"><span class="fl">提醒</span><em
					class="ml-10 icon yellow-icon"></em><strong class="num">12</strong></span>
				<span class="fl name"> <span class="fl mt-3 mr-10"> <img
						src="assets/img/head-img.png"></span> <span class="fl mr-10">${user.name }</span>
					<em class="icon icon-down"></em>
					<ul class="nameDown">
						<li>修改密码</li>
						<li>个人资料</li>
						<li><a href="logout.do">退出</a></li>
					</ul>
				</span>
			</div>
		</div>
	</div>
	<div class="content">
		<ul id="J_NavContent" class="dl-tab-conten">
		</ul>
	</div>
	<script type="text/javascript" src="<%=ctx %>/assets/js/index.js"></script>

	<script type="text/javascript">
    BUI.use('common/main',function(){
      var config = [{
          id:'supplier', 
          homePage : 'angency',
          menu:
        	  [
        	   	{
              		text:'供应商管理',
              		items:[
		                {id:'angency',text:'旅行社',href:'supplier/toSuplierList.htm?supplierType=1&page=1',closeable : false},
		                {id:'restaurant',text:'餐厅',href:'supplier/toSuplierList.htm?supplierType=2&page=1'},
		                {id:'hotel',text:'酒店',href:'supplier/toSuplierList.htm?supplierType=3&page=1'},
		                {id:'motorcade',text:'车队',href:'supplier/toSuplierList.htm?supplierType=4&page=1'},
						{id:'scenic',text:'景区',href:'supplier/toSuplierList.htm?supplierType=5&page=1'},
						{id:'shopping',text:'购物',href:'supplier/toSuplierList.htm?supplierType=6&page=1'},
						{id:'entertainment',text:'娱乐',href:'supplier/toSuplierList.htm?supplierType=7&page=1'},
						{id:'guide',text:'导游',href:'supplier/toSuplierList.htm?supplierType=8&page=1'},
						{id:'airticket',text:'机票代理',href:'supplier/toSuplierList.htm?supplierType=9&page=1'},
						{id:'trainticket',text:'火车票',href:'supplier/toSuplierList.htm?supplierType=10&page=1'},
						{id:'golf',text:'高尔夫',href:'supplier/toSuplierList.htm?supplierType=11&page=1'},
						{id:'other',text:'其他',href:'supplier/toSuplierList.htm?supplierType=12&page=1'},
						{id:'contract',text:'合同协议',href:'contract/list.htm'}
              		]
            	},
            	{
                	text:'产品管理',
    			    collapsed:true,
                    items:[
	                    {id:'operation',text:'产品列表',href:'basic/dicTypeIndex.htm'},
	                    {id:'quick',text:'新增产品',href:'basic/dicIndex.htm'},
	                    {id:'quick',text:'品牌定义',href:'basic/regIndex.htm'},
	                    {id:'quick',text:'标签定义',href:'basic/regIndex.htm'} ,
	                    {id:'quick',text:'产品回收站',href:'basic/regIndex.htm'} 
                  	]
                },
                {
              		text:'系统管理',
			  		collapsed:true,
              		items:[
		                {id:'dictype',text:'字典类型管理',href:'basic/dicTypeIndex.htm'},
		                {id:'dic',text:'字典管理',href:'basic/dicIndex.htm'},
		                {id:'region',text:'区域管理',href:'basic/regIndex.htm'} 
		            ]
            	},
                {
              		text:'销售管理',
			  		collapsed:true,
              		items:[
		                {id:'dictype',text:'团队管理',href:'tourGroup/tourGroupManage.htm'},
		                {id:'dic',text:'散客订单管理',href:''},
		                {id:'region',text:'散客团管理',href:''} ,
		                {id:'dic',text:'订单信息',href:''}
		               
		            ]
            	},
            	{
              		text:'用户管理',
			  		collapsed:true,
              		items:[
		                {id:'user',text:'用户管理',href:'employee/listtreeEmployee'},
		                {id:'role',text:'角色管理',href:'role/roleList'},
		                {id:'menu',text:'菜单管理',href:'platFormMenu/treeIndex'} ,
		                {id:'org',text:'组织机构管理',href:'org/treeIndex'}
		               
		            ]
            	}
			]
          }];
      new PageUtil.MainPage({
        modulesConfig : config
      });
    });
  </script>
</body>
</html>