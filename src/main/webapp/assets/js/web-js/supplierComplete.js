var eKeyDown = $.Event('keydown');
eKeyDown.keyCode = 40; // DOWN
var supplierComplete={
	  source: function( request, response ) {
		  var keyword = request.term;
		  var supplierType = supplierComplete.supplierType.val();
		  $.ajax({
			  type : "get",
			  url : ctx+"/supplier/searchSupplier.do?supplierType="+supplierType+"&keyword="+keyword,
			  dataType : "json",
			  success : function(data){
				  if(data && data.success == 'true'){
					  response($.map(data.result,function(v){
						  return {label : v.nameFull, id:v.id};
					  }));
				  }
			  },
			  error : function(data,msg){}
		  });
	  },
	  focus: function(event, ui) {},
	  minLength : 0,
	  delay : 300,
	  supplierType: $("#sel_supplier_type"),
	  supplierId: $("input[name='supplierId']")
};