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
//= require application/orders
//= require_tree ./admin/
//= require bootstrap-datepicker


function onUpdatePrice(e)
{
	price = $("#new_price").val();
	
	recurrent_price = $("#recurrent_new_price").val();
	
	if(price && recurrent_price)
	{
		$.ajax({
          url: "/admin/orders/update_price",
          data: { 
              price: price, recurrent_price:recurrent_price
          }
      });
	}
	else
	{
		alert("Please enter price");
	}
	
	e.preventDefault();
	e.stopPropagation(); 
}
