function CheckPassword(inputtxt1, inputtxt2, alertspan) 
{
  //alert('Here');
  var passw = /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{6,20}$/;
  if(inputtxt1.value.match(passw)) 
  { 
    //alert('Correct, try another...');
    if (inputtxt1.value != inputtxt2.value)
    {
      //alertspan.innerHTML = 'Password and Confirmation do not match.';
      document.getElementById(alertspan).innerHTML = '<br />Password and Confirmation do not match.';
      //alert('No match');
      return false;
    }
    else
    {
      //alert('Correct, try another...');
      return true;
    }
  }
  else
  { 
    //alert('Wrong');
    document.getElementById(alertspan).innerHTML = '<br />Password does not meet the requirements';
    //alert("Wrong2")
    return false;
  }
} 