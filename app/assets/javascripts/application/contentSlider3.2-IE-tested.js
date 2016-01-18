$(document).ready(function(){
		
// ********************************************************************************* DO NOT EDIT ********************************************************************************* //
	
	// GLOBAL VARIABLES - DO NOT CHANGE
	var currentPosition = $(".slidesContainer > li").index($(".first"));
	var slidesContainerWidth = $(".slidesContainer").width();	
	var slidesTotal = $(".slidesContainer > li").length;
	var autoSlide;
	var restartSlideDelay = autoSlideDelay;
	var selectorClasses = selectorLinkClasses;
	var pauseActivated = false;
	var playActivated = false;
	
	//IE6 ADJUSTMENTS
	$(".slidesContainer > li").addClass("slide");  		// B/C IE6 DOES NOT LIKE CHILD SELECTORS
	$(".slideSelectors > li").addClass("selector");		// B/C IE6 DOES NOT LIKE CHILD SELECTORS
	
	$("a, .control").hover(function(){					// B/C IE6 DOES NOT A TAGS WITHOUT AN HREF OR RESPECT :HOVER
		$(this).css({"cursor":"pointer"});
	});
	
	// ADD selectorClasses TO .first SLIDE'S SELECTOR LINK
	var selectorClassStart = $(".first").attr("id");
	$(".slideSelectors > li a[rel=#" + selectorClassStart + "]").addClass(selectorClasses);
	
	// SLIDE FROM OPTIONS ("left" || "right")
	if(slideFromThe == "right"){
	
		slideDirection = -slidesContainerWidth;	
	
	} else if(slideFromThe == "left"){
	
		slideDirection = slidesContainerWidth;
		
	}
	
	// INITIAL SLIDE POSTIONS
	$(".slidesContainer > li").css({"left": slideDirection });
	$(".first").css({"left": "0" });
	
	// FUNCTION - NEXT SLIDE
	function slideNext() {
		
		var currentSlide = $(".slidesContainer > li").eq(currentPosition);
		
		
		
		$(currentSlide).
			animate({
				"left":slideDirection
			}).
			next("li").
				css({
					"left":-slideDirection
				}).
				animate({
					"left":"0"
				});
		
		if(currentPosition == slidesTotal-1){
			
			$(".slidesContainer > li").
				eq(0).
				css({
					"left":-slideDirection
				}).
				animate({
					"left":"0"
				});
			
			currentPosition = 0;
			
			// CHANGE BACKGROUNDS OF THE NEXT .slideSelector li
			var getNextID = $(".slidesContainer > li").eq(currentPosition).attr("id");
	
			$(".slideSelectors > li a").removeClass(selectorClasses);
		
			$(".slideSelectors > li a[rel=#" + getNextID + "]").addClass(selectorClasses);
			
		} else {
			
			currentPosition++;
			
			// CHANGE BACKGROUNDS OF THE NEXT .slideSelector li
			var getNextID = $(currentSlide).next("li").attr("id");
			
			$(".slideSelectors > li a").removeClass(selectorClasses);
		
			$(".slideSelectors > li a[rel=#" + getNextID + "]").addClass(selectorClasses);
		
		}
	} // END FUNCTION
	
	
	// FUNCTION - PREVIOUS SLIDE
	function slidePrev() {
		
		var currentSlide = $(".slidesContainer > li").eq(currentPosition);
		
		$(currentSlide).
			animate({
				"left":-slideDirection
			}).
			prev("li").
				css({
					"left":slideDirection
				}).
				animate({
					"left":"0"
				});
		
		if(currentPosition == 0){
			
			$(".slidesContainer > li").
				eq(slidesTotal-1).
				css({
					"left":slideDirection
				}).
				animate({
					"left":"0"
				});
			
			currentPosition = slidesTotal-1;
			
			// CHANGE BACKGROUNDS OF THE PREVIOUS .slideSelector li
			var getPreviousID = $(".slidesContainer > li").eq(slidesTotal-1).attr("id");
		
			$(".slideSelectors > li a").removeClass(selectorClasses);
		
			$(".slideSelectors > li a[rel=#" + getPreviousID + "]").addClass(selectorClasses);
			
		} else {
			
			currentPosition--;
			
			// CHANGE BACKGROUNDS OF THE PREVIOUS .slideSelector li
			var getPreviousID = $(currentSlide).prev("li").attr("id");
			
			$(".slideSelectors > li a").removeClass(selectorClasses);
		
			$(".slideSelectors > li a[rel=#" + getPreviousID + "]").addClass(selectorClasses);
		
		}
		
		
	}// END FUNCTION - 'Previous' Button
	
	// FUNCTION - 'Slide Selectors' Button
	$(".slideSelectors a").click(function(){
		
		if(autoSlideIs == "on" ){
			clearInterval(autoSlide);
		}
		
		var currentSlide = $(".slidesContainer > li").eq(currentPosition);
		var mySlide = $(this).attr("rel");
		var mySlidePosition = $(".slidesContainer > li").index($(mySlide));
		
		if(currentPosition==mySlidePosition){
			return false;
		} else {
		
			$(mySlide).
				css({
					"left":-slideDirection
				}).
				animate({
					"left":"0"
				});
			
			$(currentSlide).
				animate({
					"left":slideDirection	
				});
				
			currentPosition = mySlidePosition;
			
			// CHANGE BACKGROUNDS OF THE NEXT .slideSelector li
		
			$(".slideSelectors > li a").removeClass(selectorClasses);
		
			$(this).addClass(selectorClasses);
		
		}
		
	}); // END FUNCTION
	
	// START AUTO SLIDE
	if(autoSlideIs == "on" ){
		autoSlide = setInterval(function(){
			slideNext();
		}, autoSlideDelay);
	}else if(autoSlideIs == "off" ){
		autoSlide;	
	}
	
	// PAUSE AUTO SLIDE WHEN HOVERING OVER THE FOLLOWING SELECTORS
	$(".slidesContainer > li, #previous, #next, .slideSelectors a").hover(function() {
		if(autoSlideIs == "on" ){
			clearInterval(autoSlide);
		}
	}, function() {
		if(autoSlideIs == "on" && pauseActivated == false ){
			autoSlide =	setInterval(function(){
				slideNext();
			}, autoSlideDelay);
		}
	});
	
	// ADD FUNCTION  - Next Button
	$("#next").click(function(){
		
		slideNext();
		
	});
	
	// ADD FUNCTION - Previous Button
	$("#previous").click(function(){
		
		slidePrev();
		
	});
	
	// ADD FUNCTION  - Pause Button
	$("#pause").click(function(){
		
		pauseActivated = true;
		
		if(autoSlideIs == "on" ){
			clearInterval(autoSlide);
		}
		
	});
	
	// ADD FUNCTION - Play Button
	$("#play").click(function(){
		
		pauseActivated = false;
		
		if(autoSlideIs == "on" ){
			autoSlide =	setInterval(function(){
				slideNext();
			}, autoSlideDelay);
		}
		
	});
	
	// SHOW || HIDE PAUSE & PLAY BUTTONS IF OPTION IS ON || OFF
	if(autoSlideIs == "on" ){
		$("#play, #pause").show();
	}else if(autoSlideIs == "off" ){
		$("#play, #pause").hide();
	}
	
});

var autoSlideDelay = 3000; // Adjust the Slide Delay in milliseconds, 1000 = 1 second
var slideFromThe = "right"; // "right" or "left"; Determine which direction to slide from
var autoSlideIs = "on"; // "on" or "off"; Turn auto-sliding on or off
var selectorLinkClasses = "selected"; // Add the classes that will style the selector links when it's relative slide is selected
