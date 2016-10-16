/**
 * 
 */
$(function() {

	$("#provinceCode").change(
			function() {
				if ($("#provinceCode").val() != '-1') {
					$("#provinceName").val($("#provinceCode").find("option:selected").text());
					$("#cityName").val('');
					var defCityId = $("#defCityId").val();
					$.getJSON("../basic/getRegion.do?id="
							+ $("#provinceCode").val(), function(data) {
						data = eval(data);
						var s = "<option value=''>请选择市</option>";
						$.each(data, function(i, item) {
							s += "<option value='" + item.id + "' "+(item.id==defCityId?"selected":"")+" >" + item.name + "</option>";
						});
						$("#cityCode").html(s);
						
					});
				}else {
					$("#cityCode").html("<option value='-1'>请选择市</option>");
					$("#provinceName").val('');
					$("#cityName").val('');
				}

			});
	
	$("#cityCode").change(
			function() {
				if($("#cityCode").val()!='-1'){
					$("#cityName").val($("#cityCode").find("option:selected").text());
				}else{
					$("#cityName").val('');
				}
			});
	
	$("#sourceTypeCode").change(function(){
		if($("#sourceTypeCode").val()!='-1'){
			$("#sourceTypeName").val($("#sourceTypeCode").find("option:selected").text());
		}else{
			$("#sourceTypeName").val('');
		}
		
	});
	
})