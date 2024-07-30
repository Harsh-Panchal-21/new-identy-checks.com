function CheckForm() { 
 var name = survey.company.value;
 if (name == "") { 
    alert("Please enter your company name."); 
    survey.company.focus();
    return false; 
}
 var name = survey.name.value;
 if (name == "") { 
    alert("Please enter your name."); 
    survey.name.focus();
    return false; 
}
 if (survey.email.value.indexOf ('@',0) == -1 ||survey.email.value.indexOf ('.',0) == -1){
    alert ("The email address you entered is not valid. Please enter your correct email address.")
    survey.email.focus();
    valid = false; 
    return false ;
}
 myOption = -1;
 for (i=survey.interested.length-1; i > -1; i--) {
 if (survey.interested[i].checked) {
	myOption = i; i = -1;
}
}
 if (myOption == -1) {
	alert("Please select Yes or No for Question 1.");
	return false;
}
 return true; 
}
