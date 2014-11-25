/******* index.erb ********/
$("#login-form").hide();
$("#register-form").hide();


$("#login").click(function(){
  $("#login-form").toggle();
  $("#welcome").hide();
});

$("#register").click(function(){
  $("#welcome").hide();
  $("#register-form").toggle();
});


$(".cancel").click(function(event){
	event.preventDefault();
	//home page logic
	$("#login-form").hide();
	$("#register-form").hide();
	$("#welcome").show();
})

$("#register-from-login").click(function(event){
	event.preventDefault();
	$("#login-form").hide();
	$("#register-form").show();
})

/******* user.erb ********/
$(".groupInfo").hide();
$("#new-group-form").hide();
$("#new-payment-form").hide();

var isPaymentFormHidden = true;
var isNewGroupFormHidden = true;


$(".new-payment").click(function(){
	if (isPaymentFormHidden){
		$("#new-payment-button").hide();
		$("#new-payment-form").show();
		isPaymentFormHidden = false;
	}else{
		isPaymentFormHidden = true;
	}
})

$(".group").click(function(){
  $(this).find(".groupInfo").toggle();
  $(this).find(".payment-size").toggle();
})

$(".new-group").click(function(){
	if (isNewGroupFormHidden){
		$("#new-group-form").show();
		$("#new-group-button").hide();
		isNewGroupFormHidden = false;
	}else{
		isNewGroupFormHidden = true;
	}
})

$(".cancel-user").click(function(event){ //hide forms when user clicks 'cancel'
	event.preventDefault();

	console.log(isPaymentFormHidden);
	if(!isPaymentFormHidden){
		$("#new-payment-form").hide();
		$("#new-payment-button").show();
	}

	if(!isNewGroupFormHidden){
		$("#new-group-form").hide();
		$("#new-group-button").show();
	}
})











