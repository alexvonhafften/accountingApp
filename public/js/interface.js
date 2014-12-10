/******* index.erb ********/

//Hide login and registration forms
$("#login-form").hide();
$("#register-form").hide();

//login form
$("#login").click(function(){
  $("#login-form").toggle();
  $("#welcome").hide();
  $(".pitch").hide();
});

//registration form
$("#register").click(function(){
  $("#welcome").hide();
  $("#register-form").toggle();
  $(".pitch").hide();
});


//cancel registration or login
$(".cancel").click(function(event){
	event.preventDefault();
	
	$("#login-form").hide();
	$("#register-form").hide();
	$("#welcome").show();
	$(".pitch").show();
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
$(".member-email-span").hide();

var isPaymentFormHidden = true;
var isNewGroupFormHidden = true;

/****** Adding a new Payment  input sanitization and validation submit enabling ******/
function enablePaymentSubmitEvent(){
	$("#submitPayment").prop("disabled", !canSubmitPayment());
}

function canSubmitPayment(){
	console.log(isInputAmountValid() && isNameValid());
	return isInputAmountValid() && isNameValid();
}

function isInputAmountValid(){
	if(parseFloat($("#inputAmount").val()) > 0){
		return true;
	}
	return false;
}

function isNameValid(){
	if($("#inputPaymentName").val() === ''){
		return false;
	}
	return true;
}


function inputAmountEvent(){
	newPaymentAmount = $("#inputAmount").val();
	formatted = numeral(newPaymentAmount).format('0,0.00');
	$("#inputAmount").val(formatted);
}

$("#inputAmount").focusout(inputAmountEvent).keyup(enablePaymentSubmitEvent);
$("#inputPaymentName").keyup(enablePaymentSubmitEvent);


/****** Adding new members to the group, input sanitization and validation, interfacing ********/

function isEmailStringValid(){
	return true;
}


function inputEmailEvent(){
	if(isEmailStringValid()){//ensure there is a valid string in the input.
		$(".member-email-span").hide();
	}else{
		$(".member-email-span").show();
	}
}


function enableSubmitEvent(){

}



$("#inputEmail").focus(inputEmailEvent).keyup(inputEmailEvent).keyup(enableSubmitEvent);


/***** DISPLAY CURRENCIES PROPERLY *******/

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
		$(this).text("You owe the group "+numeral(paymentAmount).format('$0,0.00'))//format and print amount owed
	}
})



/******* Handling creation of new payments and groups interfacing *******/

$(".new-payment").click(function(){
	if (isPaymentFormHidden){
		$("#new-payment-button").hide();
		$("#new-payment-form").show();
		isPaymentFormHidden = false;
	}else{
		isPaymentFormHidden = true;
	}
})


$(".group").click(function(){//hide ".groupInfo" for all groups then display the clicked one
	$(".groupInfo").each(function(){
		$(this).hide();
	});
	$(this).css("cursor", "auto")
  $(this).find(".groupInfo").show();
  $(this).find(".payment-size").hide();
  $(this).find(".delete-group").show();
  currentOpenGroup = $(this).find(".groupInfo");
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
	if(!isPaymentFormHidden){ //reset the payment form
		$("#new-payment-form").hide();
		$("#new-payment-button").show();
		$("#new-payment-form")[0].reset();
	}

	if(!isNewGroupFormHidden){ //reset the new-group form
		$("#new-group-form").hide();
		$("#new-group-button").show();
		$("#new-group-form")[0].reset();
	}


})