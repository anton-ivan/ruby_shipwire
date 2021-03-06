// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//

//= require jquery
//= require jquery_ujs
//= require ckeditor-jquery
//= require bootstrap.min 
//= require_tree ./application/
//= require bootstrap-datepicker

function onChangeCounty(from)
{
	if(from == 'forum_country')
	{
		country = $("#forum_country").val(); 
	}
	else
	{
		country = $("#search_country").val(); 
	} 
	$.ajax({
    	type: "GET",
        url: "/get_states?parent_region="+ country  ,
        dataType: "script",
    });
}

function onClickBuyUpsell(event, user_id,order_id)
{
	var txt;
	var r = confirm("Are you sure?");
	if (r == true) {
	    $.ajax({
    	type: "GET",
        url: "/buy_upsell?user_id="+ user_id+"&order_id="+order_id ,
        dataType: "script",
    	});
	}
} 

function onBuyUpsell(page,number)
{
	if(number ==2)
	{
		document.getElementById("second_upsell").src = "assets/Processing.gif"
	}
	if(number ==3)
	{
		document.getElementById("third_upsell").src = "assets/Processing.gif"
	}
	if(number ==1)
	{
		document.getElementById("first_upsell").src = "assets/Processing.gif"
	} 
	
	$.ajax({
    	type: "GET",
        url: "/buy_upsell?type="+page+"&number="+number ,
        dataType: "script",
    	});
}

function onCancelUpsell(page)
{ 
	$.ajax({
    	type: "GET",
        url: "/next_upsell?type="+page ,
        dataType: "script",
    	}); 
}

function onEnterAgent(e)
{
	if (!$("#agent_id").val())
	{
		alert("please enter agent id/name");
		e.preventDefault();
		e.stopPropagation(); 
		return;
	
	}
	else
	{
		 $.ajax({
          url: "/get_agent_form",
          data: { 
              agent_id: $("#agent_id").val()
          }
      });
	}
}
