var addHotel=function(str){
	var html = $("#hotel_template").html();
	var count = $("#"+str).children('tr').length;
	html = template('hotel_template', {index : count});
	$("#"+str).append(html);
	var requireTime =  $("input[name='hotelGroupRequirementList["+count+"].requireDate']");
	if(requireTime.length > 0){
		requireTime.rules("add",{required : true});
	}
	
	var countSingleRoom =  $("input[name='hotelGroupRequirementList["+count+"].countSingleRoom']");
	if(countSingleRoom.length > 0){
		countSingleRoom.rules("add",{required : true,number:true});
	}
	
	
	var countDoubleRoom =  $("input[name='hotelGroupRequirementList["+count+"].countDoubleRoom']");
	if(countDoubleRoom.length > 0){
		countDoubleRoom.rules("add",{required : true,number:true});
	}
	
	var countTripleRoom =  $("input[name='hotelGroupRequirementList["+count+"].countTripleRoom']");
	if(countTripleRoom.length > 0){
		countTripleRoom.rules("add",{required : true,number:true});
	}
	
	var peiFang =  $("input[name='hotelGroupRequirementList["+count+"].peiFang']");
	if(peiFang.length > 0){
		peiFang.rules("add",{required : true,number:true});
	}
	
	var extraBed =  $("input[name='hotelGroupRequirementList["+count+"].extraBed']");
	if(extraBed.length > 0){
		extraBed.rules("add",{required : true,number:true});
	}
	
	
	
	
	
	
}
var delHotelTable=function(el){
	var p = $(el).parent('td').parent('tr');
    var siblings = p.siblings();
    p.remove();
    siblings.each(function(index, element){
        var founds = $(element).find("[name^='hotelGroupRequirementList']");
        founds.each(function(){
            $(this).attr('name', $(this).attr('name').replace(/hotelGroupRequirementList\[\d+]/g, 'hotelGroupRequirementList[' + index + ']'));
        });
    });
}

//--------------------------------车队-----------------------------------
var addFleet=function(str){
	var html = $("#fleet_template").html();
	var count = $("#"+str).children('tr').length;
	html = template('fleet_template', {index : count});
	$("#"+str).append(html);
	var requireFleet=  $("input[name='fleetGroupRequirementList["+count+"].requireDate']");
	if(requireFleet.length > 0){
		requireFleet.rules("add",{required : true});
	}
	
	var countSeat =  $("input[name='fleetGroupRequirementList["+count+"].countSeat']");
	if(countSeat.length > 0){
		countSeat.rules("add",{number:true});
	}
}
var delFleetTable=function(el){
	var p = $(el).parent('td').parent('tr');
    var siblings = p.siblings();
    p.remove();
    siblings.each(function(index, element){
        var founds = $(element).find("[name^='fleetGroupRequirementList']");
        founds.each(function(){
            $(this).attr('name', $(this).attr('name').replace(/fleetGroupRequirementList\[\d+]/g, 'fleetGroupRequirementList[' + index + ']'));
        });
    });
}

//--------------------------------导游-----------------------------------
var addGuide=function(str){
	var html = $("#guide_template").html();
	var count = $("#"+str).children('tr').length;
	html = template('guide_template', {index : count});
	$("#"+str).append(html);
	var language=  $("input[name='guideGroupRequirementList["+count+"].language']");
	if(language.length > 0){
		language.rules("add",{required : true});
	}
	
	var ageLimit=  $("input[name='guideGroupRequirementList["+count+"].ageLimit']");
	if(ageLimit.length > 0){
		ageLimit.rules("add",{required : true});
	}
	
}
var delGuideTable=function(el){
	var p = $(el).parent('td').parent('tr');
    var siblings = p.siblings();
    p.remove();
    siblings.each(function(index, element){
        var founds = $(element).find("[name^='guideGroupRequirementList']");
        founds.each(function(){
            $(this).attr('name', $(this).attr('name').replace(/guideGroupRequirementList\[\d+]/g, 'guideGroupRequirementList[' + index + ']'));
        });
    });
}

//--------------------------------餐厅-----------------------------------
var addRestaurant=function(str){
	var html = $("#restaurant_template").html();
	var count = $("#"+str).children('tr').length;
	html = template('restaurant_template', {index : count});
	$("#"+str).append(html);
	var hotelRequireDate=  $("input[name='restaurantGroupRequirementList["+count+"].requireDate']");
	if(hotelRequireDate.length > 0){
		hotelRequireDate.rules("add",{required : true});
	}
	var hotelcountRequire=  $("input[name='restaurantGroupRequirementList["+count+"].countRequire']");
	if(hotelcountRequire.length > 0){
		hotelcountRequire.rules("add",{required : true,number:true});
	}
}
var delRestaurantTable=function(el){
	var p = $(el).parent('td').parent('tr');
    var siblings = p.siblings();
    p.remove();
    siblings.each(function(index, element){
        var founds = $(element).find("[name^='restaurantGroupRequirementList']");
        founds.each(function(){
            $(this).attr('name', $(this).attr('name').replace(/restaurantGroupRequirementList\[\d+]/g, 'restaurantGroupRequirementList[' + index + ']'));
        });
    });
}
