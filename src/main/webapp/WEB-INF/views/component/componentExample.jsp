<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>首页</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<%@ include file="../../include/top.jsp"%>
<link rel="stylesheet" type="text/css" href="<%=ctx %>/assets/css/ztree/zTreeStyle/zTreeStyle.css" />
    <script type="text/javascript" src="<%=ctx %>/assets/js/ztree/jquery.ztree.core-3.5.min.js"></script>
    <script type="text/javascript" src="<%=ctx %>/assets/js/ztree/jquery.ztree.excheck-3.5.min.js"></script>
    <script type="text/javascript" src="<%=ctx %>/assets/js/json2.js"></script>
    <script type="text/javascript" src="<%=ctx %>/assets/js/card/card.js"></script>
    <script type="text/javascript" src="<%=ctx %>/assets/js/card/native-info.js"></script>
    <script type="text/javascript" src="<%=ctx %>/assets/js/card/region-card-data.js"></script>
    <script type="text/javascript">
    	function selectUser(){
    		var win;
    		layer.open({ 
    			type : 2,
    			title : '选择人员',
    			closeBtn : false,
    			area : [ '400px', '590px' ],
    			shadeClose : false,
    			content : 'orgUserTree.htm?type=single',//单选地址为orgUserTree.htm，多选地址为orgUserTree.htm?type=multi
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
    				
    				for(var i=0;i<userArr.length;i++){
    					console.log("id:"+userArr[i].id+",name:"+userArr[i].name+",pos:"+userArr[i].pos+",mobile:"+userArr[i].mobile+",phone:"+userArr[i].phone+",fax:"+userArr[i].fax);
    				}
    				//一般设定yes回调，必须进行手工关闭
    		        layer.close(index); 
    		    },cancel: function(index){
    		    	layer.close(index);
    		    }
    		});
    	}
    	
    	function myConfirm(){
    		$.confirm("确认删除吗？",function(){
    			$.info('确认删除');
    		},function(){
    			$.info('取消删除');
    		})
    	}
    	
    	function selectOrg(){
    		var win;
    		layer.open({ 
    			type : 2,
    			title : '选择组织机构',
    			closeBtn : false,
    			area : [ '400px', '590px' ],
    			shadeClose : false,
    			content : 'orgTree.htm?type=multi',//单选地址为orgUserTree.htm，多选地址为
    			btn: ['确定', '取消'],
    			success:function(layero, index){
    				win = window[layero.find('iframe')[0]['name']];
    			},
    			yes: function(index){
    				//orgArr返回的是org对象的数组
    				var orgArr = win.getOrgList();    				
    				if(orgArr.length==0){
    					$.warn("请选择组织结构");
    					return false;
    				}
    				
    				for(var i=0;i<orgArr.length;i++){
    					console.log("id:"+orgArr[i].id+",name:"+orgArr[i].name);
    				}
    				//一般设定yes回调，必须进行手工关闭
    		        layer.close(index); 
    		    },cancel: function(index){
    		    	layer.close(index);
    		    }
    		});
    	}
    	
    	function selectSupplier(){
    		var win;
    		layer.open({ 
    			type : 2,
    			title : '选择酒店',
    			closeBtn : false,
    			area : [ '900px', '610px' ],
    			shadeClose : false,
    			content : 'supplierList.htm?type=multi&stypes=1,2',//参数：操作类型（type:单选(single)、多选(multi)）供应商类型supplierType=1,stypes=1,2为供应商过滤范围
    			btn: ['确定', '取消'],
    			success:function(layero, index){
    				win = window[layero.find('iframe')[0]['name']];
    			},
    			yes: function(index){
    				//orgArr返回的是org对象的数组
    				var arr = win.getChkedSupplier();    				
    				if(arr.length==0){
    					$.warn("请选择酒店");
    					return false;
    				}
    				
    				for(var i=0;i<arr.length;i++){
    					console.log("id:"+arr[i].id+",name:"+arr[i].name+",type:"+arr[i].type+",typename:"+arr[i].typename+",province:"+arr[i].province+",city:"+arr[i].city+",area:"+arr[i].area+",town:"+arr[i].town);
    				}
    				//一般设定yes回调，必须进行手工关闭
    		        layer.close(index); 
    		    },cancel: function(index){
    		    	layer.close(index);
    		    }
    		});
    	}
    	
    	function selectAttachment(){
    		var win;
    		layer.open({ 
    			type : 2,
    			title : '选择图片/文件',
    			closeBtn : false,
//    			area : [ '980px', '620px' ],
				area : [{minLength : '1200px', areas : ['980px', '620px']}, {minLength : '768px', maxLength : '1100px', areas : ['600px', '450px']}],
    			shadeClose : false,
    			content : 'imgSelect.htm',
    			btn: ['确定', '取消'],
    			success:function(layero, index){
    				win = window[layero.find('iframe')[0]['name']];
    			},
    			yes: function(index){
    				//orgArr返回的是org对象的数组
    				var arr = win.getImgSelected();    				
    				if(arr.length==0){
    					$.warn("请选择图片");
    					return false;
    				}
    				
    				for(var i=0;i<arr.length;i++){
    					console.log("name:"+arr[i].name+",path:"+arr[i].path+",thumb:"+arr[i].thumb);
    				}
    				//一般设定yes回调，必须进行手工关闭
    		        layer.close(index); 
    		    },cancel: function(index){
    		    	layer.close(index);
    		    }
    		});
    	}
    	
    	function div(){
    		var win;
    		layer.open({
    		    type: 1,
    		    skin: 'layui-layer-rim', //加上边框
    		    area: ['420px', '240px'], //宽高
    		    content: $("#content"),
    		    btn: ['确定', '取消'],
    			success:function(layero, index){
    				win = layero;
    			},
    			yes: function(index){
    				
    				//一般设定yes回调，必须进行手工关闭
    		        layer.close(index); 
    		    },cancel: function(index){
    		    	layer.close(index);
    		    }
    		});
    	}
    	
    	function selectContact(){
    		var win;
    		layer.open({ 
    			type : 2,
    			title : '选择联系人',
    			closeBtn : false,
    			area : [ '550px', '450px' ],
    			shadeClose : false,
    			content : 'contactMan.htm?supplierId=31',//参数为供应商id
    			btn: ['确定', '取消'],
    			success:function(layero, index){
    				win = window[layero.find('iframe')[0]['name']];
    			},
    			yes: function(index){
    				//manArr返回的是联系人对象的数组
    				var arr = win.getChkedContact();    				
    				if(arr.length==0){
    					$.warn("请选择联系人");
    					return false;
    				}
    				
    				for(var i=0;i<arr.length;i++){
    					console.log("id:"+arr[i].id+",name:"+arr[i].name+",tel:"+arr[i].tel+",mobile:"+arr[i].mobile+",fax:"+arr[i].fax);
    				}
    				//一般设定yes回调，必须进行手工关闭
    		        layer.close(index); 
    		    },cancel: function(index){
    		    	layer.close(index);
    		    }
    		});
    	}
    	
    	function getCardInfo(){
    		var c = new Card("520202198911171217");  
    		c.init(function(data){
    			console.log( data.age);
        		console.log(data.sex);
        		console.log(data.addr);        		
    		});
    		
    		var c = new Card("379006197507182627");  
    		c.init(function(data){
    			console.log( data.age);
        		console.log(data.sex);
        		console.log(data.addr);        		
    		});
    		
    		
    		/* $.ajax({
   			   type: "GET",
   			   url: "idCard.jsn",
   			   //headers:{apikey:"ef89fd4959959d0e6721677e569fe560"},
   			   data: {id:'370224197803132638',apiKey:"ef89fd4959959d0e6721677e569fe560"}, 
   			   dataType : "json",
   			   success: function(data){
   				   if(data.retMsg=='success'){   					   
	   			     alert( data.retData.address );
   				   }else{
   					   
   				   } 
   				},
   			   error: function (XMLHttpRequest, textStatus, errorThrown) {
	   			   debugger
   				}
   			}); */
   			
    	}
    	
    	function selectDriver(){
    		var win;
    		layer.open({ 
    			type : 2,
    			title : '选择司机',
    			closeBtn : false,
    			area : [ '950px', '670px' ],
    			shadeClose : false,
    			content : 'driverList.htm?supplierId=42',//参数为供应商id
    			btn: ['确定', '取消'],
    			success:function(layero, index){
    				win = window[layero.find('iframe')[0]['name']];
    			},
    			yes: function(index){
    				//manArr返回的是联系人对象的数组
    				var driver = win.getSelectedDriver();    				
    				if(driver==null){
    					$.warn("请选择司机");
    					return false;
    				}
    				
    				
    				console.log("id:"+driver.id+",name:"+driver.name+",mobile:"+driver.mobile);
    				
    				//一般设定yes回调，必须进行手工关闭
    		        layer.close(index); 
    		    },cancel: function(index){
    		    	layer.close(index);
    		    }
    		});
    	}
    	
    	function download(){
    		window.open("<%=ctx%>/component/download.htm?path="+encodeURI('http://192.168.1.88/group1/M00/00/0D/wKgBWFWd40eAOMoeAAJQAFsSZf4761.doc')+"&name="+encodeURI(encodeURI('测试文档.doc')));
    	}
    	
    	function navtiveInfo(){
    		var nativeinfo = new nativeInfo('西藏自治区那曲地区申扎县');
    		var proinfo = eval("("+ nativeinfo.province()+")" ); 
    		console.log(proinfo.proid+"      "+proinfo.proname);
    	}
    	
    	function selectProductSupplier(){
    		var win;
    		layer.open({ 
    			type : 2,
    			title : '选择组团社',
    			closeBtn : false,
    			area : [ '800px', '520px' ],
    			shadeClose : false,
    			content : 'productSupplierList.htm?productId=106&outSupplierId=1732&single=0',//参数为供应商id
    			btn: ['确定', '取消'],
    			success:function(layero, index){
    				win = window[layero.find('iframe')[0]['name']];
    			},
    			yes: function(index){
    				//manArr返回的是联系人对象的数组
    				var supplierArr = win.getChkedSupplier();    				
    				if(supplierArr.length == 0){
    					$.warn("请选择组团社");
    					return false;
    				}
    				
    				console.log("id:"+supplierArr[0].id+",name:"+supplierArr[0].name);
    				
    				//一般设定yes回调，必须进行手工关闭
    		        layer.close(index); 
    		    },cancel: function(index){
    		    	layer.close(index);
    		    }
    		});
    	}
    	/* function uploadRegion(){
    		$.ajax({
    			url:"updateRegion.do",
    			type: 'POST',
    	       
    	        dataType: 'json',
    	        success: function(data) {
    	        	if (data.success ) {		
    	            	$.success("刷新成功");
    	        	}
    	        	else{
    	        		$.error("刷新失败");
    	        	}
    	        	
    	        },
    	        error: function(data,msg) {
		            $.error("服务器忙，请稍后再试");
		        }
    			
    		})
    	} */
    </script>
</head>
<body>
	<button type="button" onclick="selectProductSupplier()" >选择产品组团社</button><br/><br/>
	<button type="button" onclick="selectUser()" >选择用户</button><br/><br/>
	<button type="button" onclick="selectOrg()" >选择单位</button><br/><br/>
	<button type="button" onclick="$.info('测试信息提示')" >信息提示</button><br/><br/>
	<button type="button" onclick="$.success('测试成功提示')" >成功提示</button><br/><br/>
	<button type="button" onclick="$.error('测试失败提示')" >失败提示</button><br/><br/>
	<button type="button" onclick="$.warn('测试警告提示')" >警告提示</button><br/><br/>
	<button type="button" onclick="myConfirm()" >确认提示</button><br/><br/>
	<button type="button" onclick="selectSupplier()" >选择供应商</button><br/><br/>	
	<button type="button" onclick="selectContact()" >选择联系人</button><br/><br/>
	<button type="button" onclick="selectAttachment()" >选择文件</button><br/><br/>
	<button type="button" onclick="div()" >div层</button><br/><br/>
	<button type="button" onclick="getCardInfo()" >获取身份证中信息</button><br/><br/>
	<button type="button" onclick="selectDriver()" >选择司机</button><br/><br/>
	<button type="button" onclick="download()" >下载</button><br/><br/>
	<button type="button" onclick="navtiveInfo()" >籍贯</button><br/><br/>
	<!-- <button type="button" onclick="uploadRegion()" >刷新地区</button><br/><br/> -->
	<div id="content" style="display:none;width:100px;height:100px;">
		<input type="text" id="name" />		
	</div>
</body>
</html>

