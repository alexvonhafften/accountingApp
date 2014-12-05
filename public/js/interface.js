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
$(".delete-group").hide();

var isPaymentFormHidden = true;
var isNewGroupFormHidden = true;

$(".user-share").each(function(){
	var paymentAmount = parseFloat($(this).text());
	$(this).text(numeral(paymentAmount).format('$0,0.00'));

})

$(".payment-size").each(function(){
	var paymentAmount = parseFloat($(this).text()); //value of money either (-)owed to @user or (+) owed to the group

	if (paymentAmount < 0){
		//@user is owed money
		$(this).text("Owes You "+numeral(paymentAmount*(-1)).format('$0,0.00'));//format and print amount owed using http://numeraljs.com/

	}else if(paymentAmount == 0){
		$(this).text("Even");//format and print amount owed
	}else{
		//@user owes the group money
		$(this).text("You owe the group "+numeral(paymentAmount*(-1)).format('$0,0.00'))//format and print amount owed
	}
})

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
  $(this).find(".delete-group").toggle();
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