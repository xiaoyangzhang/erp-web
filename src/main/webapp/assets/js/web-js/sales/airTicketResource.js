var eKeyDown = $.Event('keydown');
eKeyDown.keyCode = 40; // DOWN

var cityComplete={
  source : function( request, response ) {
	  $.ajax({
		  type : "get",
	  url : "fuzzyDepCityList.do",
	  data : {
		  depCity : request.term
	  },
	  dataType : "json",
	  success : function(data){
		  if(data && data.success == 'true'){
				  response($.map(data.result,function(v){
					  return {
						  label : v,
						  value : v
					  }
				  }));
			  }
		  },
		  error : function(data,msg){
			  
		  }
	  });
  },
  minLength : 1,
  delay : 300
};

var lineTemplateComplete={
	  source: function( request, response ) {
		  var name=encodeURIComponent(request.term);
		  $.ajax({
			  type : "get",
			  url : ctx+"/airticket/resource/getLineTemplateList.do",
			  data : {
				  name : name
			  },
			  dataType : "json",
			  success : function(data){
				  if(data && data.success == 'true'){
					  response($.map(data.result,function(v){
						  return {label : v, value : v};
					  }));
				  }
			  },
			  error : function(data,msg){}
		  });
	  },
	  focus: function(event, ui) {},
	  minLength : 0,
	  delay : 300
};


var resourceAirPortComplete={
		  source: function( request, response ) {
			  $.ajax({
				  type : "get",
				  url : "fuzzyAirPortList.do",
				  data : {cityName : request.term},
				  dataType : "json",
				  success : function(data){
					  if(data && data.success == 'true'){
						  response($.map(data.result,function(v){
							  return {label : v.label,  value : v.value};
						  }));
					  }
				  },
				  error : function(data,msg){}
			  });
		  },
		  minLength : 1,
		  delay : 300
	}

var resourceAirCodeComplete={
		  source: function( request, response ) {
			  var name=encodeURIComponent(request.term);
			  $.ajax({
				  type : "get",
				  url : "<%=staticPath %>/airticket/resource/airLineList.do",
				  data : { name : name},
				  dataType : "json",
				  success : function(data){
					  if(data && data.success == 'true'){
						  response($.map(data.result,function(v){
							  return {
								  label : v.air_code,
								  value : v.air_code
							  };
						  }));
					  }
				  },
				  error : function(data,msg){}
			  });
		  },
		  focus: function(event, ui) {
			    $(".adress_input_box li.result").removeClass("selected");
			    $("#ui-active-menuitem")
			        .closest("li")
			        .addClass("selected");
			},
		  minLength : 0,
		  delay : 300
	};

/*function monthFirstDay(){
	var date_ = new Date();  
	var year = date_.getYear() + 1900; 
	var month = date_.getMonth() + 1;  
	var firstDay = year + '-' + month + '-01';
	return firstDay;
}
function monthLastDay(){
	var date_ = new Date();  
	var year = date_.getYear()+1900; 
	var month = date_.getMonth() + 1;  
	var day = new Date(year,month,0);
	var lastDay = year + '-' + month + '-' + day.getDate();
	return lastDay;
}*/
