function onChangePlan(offer) {   
	$('#bottom_order_div').hide();
	$('#top_order_div').hide();
	if (offer == "bonus") { 

		$('#oneRadio').hide();
		$('#bonusRadio').show();
		$('#text').show();
		 
		product = $("#productType").val();
	
		$.ajax({
          type: "GET",
          url: "/add_product_to_cart?type=bonus&product="+product, 
          dataType: "script",
     	}); 
		$('#top_order_div').show(); 
	} else if (offer == "one") {
		$('#ActionQuantity0').val(0);
		$('#bonusRadio').hide();
		$('#text').hide();
		$('#oneRadio').slideDown();  
		$('#bottom_order_div').show();
	} 
	else 
	{ 

		$('#ActionQuantity0').val(0);
		$('#ActionQuantity1').val(0);
		$('#ActionQuantity2').val(0);
		$('#ActionQuantity3').val(0);
		$('#ActionQuantity4').val(0);
		$('#ActionQuantity5').val(0);
		$('#ActionQuantity6').val(0);
		$('#ActionQuantity7').val(0);
		$('#ActionQuantity8').val(0); 
	} 
	$.ajax({
          type: "GET",
          url: "/clear_all" ,
          dataType: "script",
     	}); 
}
 
	function setProductType(type)
	{
		$("#orderType").val("recurrent"); 
		$("#productType").val(type);
		
		$.ajax({
          type: "GET",
          url: "/add_product_to_cart?type=recurrent&val="+type,
          dataType: "script",
     	}); 
	}
	

function onChangeQty()
{
	jb_quantity = $("#ActionQuantity1").val();
	black_quantity = $("#ActionQuantity2").val();
	dark_brown_quantity = $("#ActionQuantity3").val();
	brown_quantity = $("#ActionQuantity4").val();
	light_brown_quantity = $("#ActionQuantity5").val();
	aubrown_quantity = $("#ActionQuantity6").val();
	blonde_quantity = $("#ActionQuantity7").val();
	light_blonde_quantity = $("#ActionQuantity8").val();
	
	$.ajax({
          type: "GET",
          url: "/add_product_to_cart?type=normal&jet_black="+jb_quantity+"&black="+black_quantity+"&dark_brown="+dark_brown_quantity+"&brown="+brown_quantity+"&light_brown="+light_brown_quantity+"&aubrown="+aubrown_quantity+"&blonde="+blonde_quantity+"&light_blonde="+light_blonde_quantity ,
          dataType: "script",
     	}); 
}

function onClickAgentOrder()
{
	error = ""
	if (!$("#referrer").val())
	{
		error = error + "Please choose your agent name.\n" 
	}
	if (!$("#CardNumber").val())
	{
		error = error + "Please enter card number.\n" 
	}
	if (!$("#CardCvv2").val())
	{
		error = error + "Please enter CCV number.\n" 
	}
	if (!$("#first_name").val())
	{
		error = error + "Please enter First Name.\n" 
	}
	if (!$("#last_name").val())
	{
		error = error + "Please enter Last Name.\n" 
	}
	if (!$("#address1").val())
	{
		error = error + "Please enter Address.\n" 
	}
	if (!$("#email").val())
	{
		error = error + "Please enter Email Address.\n" 
	} 
	if (!$("#cb_country").val())
	{
		error = error + "Please select Country.\n" 
	}
	if (!$("#country_state").val())
	{
		error = error + "Please select State.\n" 
	}
	if (!$("#city").val())
	{
		error = error + "Please enter City.\n" 
	}
	if (!$("#zip").val())
	{
		error = error + "Please enter Zip Code.\n";
	}
	if (!$("#phone").val())
	{
		error = error + "Please enter Phone.\n" ;
	}
 
	if(error == "")
	{
		document.getElementById("submit_button").src = "assets/Processing.gif"; 
		$("#AcceptOfferButton").hide();
			$.ajax({
          type: "post",
          url: "/create_agent_order",
          data:{ first_name: $("#first_name").val(), last_name: $("#last_name").val(), address1:$("#address1").val(), 
          		 address2:$("#address2").val(), email:$("#email").val(), cb_country: $("#cb_country").val(), order_state: $("#country_state").val(),
          		 city: $("#city").val(), zip:$("#zip").val(), phone:$("#phone").val(), card_number:$("#CardNumber").val(), cvv:$("#CardCvv2").val(), month:$("#CardExpirationMonth").val(), exp_year:$("#CardExpirationYear").val()}
     	}); 
	}
	else
	{
		alert(error);
	}  	
}

function onClickOrder()
{   
	error = ""
	if (!$("#CardNumber").val())
	{
		error = error + "Please enter card number.\n" 
	}
	if (!$("#CardCvv2").val())
	{
		error = error + "Please enter CCV number.\n" 
	}
	if (!$("#first_name").val())
	{
		error = error + "Please enter First Name.\n" 
	}
	if (!$("#last_name").val())
	{
		error = error + "Please enter Last Name.\n" 
	}
	if (!$("#address1").val())
	{
		error = error + "Please enter Address.\n" 
	}
	if (!$("#email").val())
	{
		error = error + "Please enter Email Address.\n" 
	} 
	if (!$("#cb_country").val())
	{
		error = error + "Please select Country.\n" 
	}
	if (!$("#country_state").val())
	{
		error = error + "Please select State.\n" 
	}
	if (!$("#city").val())
	{
		error = error + "Please enter City.\n" 
	}
	if (!$("#zip").val())
	{
		error = error + "Please enter Zip Code.\n";
	}
	if (!$("#phone").val())
	{
		error = error + "Please enter Phone.\n" ;
	}
 
	if(error == "")
	{
		document.getElementById("submit_button").style.height = "100px";
		document.getElementById("submit_button").style.backgroundImage = "url('assets/Processing.gif')";
		$("#AcceptOfferButton").hide();
			$.ajax({
          type: "post",
          url: "/create_order",
          data:{ first_name: $("#first_name").val(), last_name: $("#last_name").val(), address1:$("#address1").val(), 
          		 address2:$("#address2").val(), email:$("#email").val(), cb_country: $("#cb_country").val(), order_state: $("#country_state").val(),
          		 city: $("#city").val(), zip:$("#zip").val(), phone:$("#phone").val(), card_number:$("#CardNumber").val(), cvv:$("#CardCvv2").val(), month:$("#CardExpirationMonth").val(), exp_year:$("#CardExpirationYear").val()}
     	}); 
	}
	else
	{
		alert(error);
	}  
}




 
