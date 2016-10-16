function Region(ctx,provinceId,cityId,areaId,townId){
	this.init=function(){	
		$("#"+provinceId).change(
				function() {
					if(cityId){
						$("#"+cityId).html("<option value=''>请选择市</option>");	
						if($("#"+provinceId).val()!=''){
						$.getJSON(ctx+"/basic/getRegion.do?id="
								+ $("#"+provinceId).val(), function(data) {
							data = eval(data);
							var s = "<option value=''>请选择市</option>";
							$.each(data, function(i, item) {
								s += "<option value='" + item.id + "'>" + item.name
								+ "</option>";
							});
							$("#"+cityId).html(s);								
						});
						}
					}
					if(areaId){
						$("#"+areaId).html("<option value=''>请选择区县</option>");					
					}
					if(townId){
						$("#"+townId).html("<option value=''>请选择街道</option>");					
					}
				});
		
		if(cityId){
			$("#"+cityId).change(
				function() {
					if(areaId){
						$("#"+areaId).html("<option value=''>请选择区县</option>");
						if($("#"+cityId).val()!=''){
						$.getJSON(ctx+"/basic/getRegion.do?id=" + $("#"+cityId).val(),
								function(data) {
							data = eval(data);
							var s = "<option value=''>请选择区县</option>";
							$.each(data, function(i, item) {
								s += "<option value='" + item.id + "'>"
								+ item.name + "</option>";
							});
							$("#"+areaId).html(s);
							
						});	
						}
					}
					if(townId){
						$("#"+townId).html("<option value=''>请选择街道</option>");					
					}
				});
		}
		if(areaId && townId){		
			$("#"+areaId).change(function() {			
				$("#"+townId).html("<option value=''>请选择街道</option>");
				if($("#"+areaId).val()!=''){
				$.getJSON(ctx+"/basic/getRegion.do?id=" + $("#"+areaId).val(),
						function(data) {
							data = eval(data);
							var s = "<option value=''>请选择街道</option>";
							$.each(data, function(i, item) {
								s += "<option value='" + item.id + "'>"
										+ item.name + "</option>";
							});
							$("#"+townId).html(s);
		
						});
				}
				});
		}
	}
}