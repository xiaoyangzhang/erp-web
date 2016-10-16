$(function(){
	headSlide();
})
	function headSlide(){
		//head下拉
		$(".sms").hover(function(){
			
			$(this).find(".newDown").stop().slideDown();
			$(this).find(".newDown").css('index','9999');
		},function(){
			$(this).find(".newDown").stop().slideUp()
		});
		$(".name").hover(function(){
			$(this).find(".nameDown").stop().slideDown()
			$(this).find(".nameDown").css('index','9999');
		},function(){
			$(this).find(".nameDown").stop().slideUp()
		})	;
	}

	
	
	
	
	
	
	