var $password = $("#newInputPassword");
var $passwordC = $("#inputPasswordConfirmation");

$("#passwordSpan").hide();
$("#passwordCSpan").hide();

function isPasswordValid(){
	return $password.val().length > 7;
}

function arePasswordsMatching() {
	return $password.val() === $passwordC.val();
}

function canSubmit() {
	return isPasswordValid() && arePasswordsMatching();
}

function passwordEvent(){
	//find if valid
	if(isPasswordValid()){
		//hide hint
		$("#passwordSpan").hide();
	}else{
		//show hint
		$("#passwordSpan").show();
	}
}

function passwordCEvent(){
	//if they match
	if(arePasswordsMatching()){
		//hide hint
		$("#passwordCSpan").hide();
	}else{
		//show hint
		$("#passwordCSpan").show();
	}
}

function enableSubmitEvent(){
	$("#submit").prop("disabled", !canSubmit());
}

//When event happens on the password input
$password.focus(passwordEvent).keyup(passwordEvent).keyup(passwordCEvent).keyup(enableSubmitEvent);

//When event happens on the confirmation input
$passwordC.focus(passwordCEvent).keyup(passwordCEvent).keyup(passwordCEvent).keyup(enableSubmitEvent);

enableSubmitEvent();
