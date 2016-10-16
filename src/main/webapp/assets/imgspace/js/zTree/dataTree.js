	//显示树框
	function showTree(event){
		document.getElementById("tbox").style.display="block";
		document.getElementById("myTree").style.display="block";
		document.getElementById("treeClose").style.display="block";
		//var xx=event.x;
		//if(xx>0) xx=107;
		var y = event.y || event.pageY;
		$("#tbox").css({"left":104,"top":y+12,"position":"absolute"});
	}
	
	//关闭树框
	function treeClose(){
		document.getElementById("tbox").style.display="none";
		document.getElementById("myTree").style.display="none";
		document.getElementById("treeClose").style.display="none";
		
		//var nodes = zTreeCheck.getCheckedNodes();
		//document.getElementById("treeValue").value="";
   			//for(i=0;i<nodes.length;i++){
   				//document.getElementById("treeValue").value+=nodes[i].name+",";
   			//}
		}
	
	//显示树框
	function showTreemokuai(event){
		document.getElementById("tboxmokuai").style.display="block";
		document.getElementById("myTreemokuai").style.display="block";
		document.getElementById("treeClosemokuai").style.display="block";
		var y = event.y || event.pageY;
		$("#tboxmokuai").css({"left":104,"top":y+12,"position":"absolute"});
	}
	
	//关闭树框
	function treeClosemokuai(){
		document.getElementById("tboxmokuai").style.display="none";
		document.getElementById("myTreemokuai").style.display="none";
		document.getElementById("treeClosemokuai").style.display="none";
		
		//var nodes = zTreeCheck.getCheckedNodes();
		//document.getElementById("treeValue").value="";
   			//for(i=0;i<nodes.length;i++){
   				//document.getElementById("treeValue").value+=nodes[i].name+",";
   			//}
		}
