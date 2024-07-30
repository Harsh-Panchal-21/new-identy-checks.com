<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<!--#include file="head.asp" -->
<center>

<!-- *************************************** MAIN CONTENT AREA *************************************** -->
<table width="619px" height="419" cellpadding="0" cellspacing="0" border="0">
    <tr>
        <td width="610px" valign="top" align="center">
            <table width="590px" cellpadding="0" cellspacing="0" border="0">
                <tr align="left">
                    <td><h4>Online Bill Payment</h4>
                    	<form id="paymentform" name="paymentform" method="post" action="">
  <table width="100%" border="0" cellpadding="6" cellspacing="0">
	<tr>
	  <td colspan="2"><strong>Payment Information</strong></td>
    </tr>
    <tr>
      <td width="25%">Invoice Number</td>
      <td><input type="text" name="InvoiceNum" id="InvoiceNum" size="10" /></td>
    </tr>
    <tr>
      <td>Invoice Amount</td>
      <td><input type="text" name="InvoiceAmt" id="InvoiceAmt" size="10" /></td>
    </tr>
    <tr>
      <td>Cardholder Name</td>
      <td><input type="text" name="CardName" id="CardName" size="54" /></td>
    </tr>
    <tr>
      <td>Address</td>
      <td><input type="text" name="Address1" id="Address1" size="54" /></td>
    </tr>
    <tr>
      <td></td>
      <td><input type="text" name="Address2" id="Address2" size="54" /></td>
    </tr>
    <tr>
      <td>City, State, Zip</td>
      <td><input type="text" name="City" id="City" size="30" />
      	  <select name="State" id="Zip">
			<option value=""></option>
            <option value="AK">AK</option>
            <option value="AL">AL</option>
            <option value="AR">AR</option>
            <option value="AZ">AZ</option>
            <option value="CA">CA</option>
            <option value="CO">CO</option>
            <option value="CT">CT</option>
            <option value="DC">DC</option>
            <option value="DE">DE</option>
            <option value="FL">FL</option>
            <option value="GA">GA</option>
            <option value="HI">HI</option>
            <option value="IA">IA</option>
            <option value="ID">ID</option>
            <option value="IL">IL</option>
            <option value="IN">IN</option>
            <option value="KS">KS</option>
            <option value="KY">KY</option>
            <option value="LA">LA</option>
            <option value="MA">MA</option>
            <option value="MD">MD</option>
            <option value="ME">ME</option>
            <option value="MI">MI</option>
            <option value="MN">MN</option>
            <option value="MO">MO</option>
            <option value="MS">MS</option>
            <option value="MT">MT</option>
            <option value="NC">NC</option>
            <option value="ND">ND</option>
            <option value="NE">NE</option>
            <option value="NH">NH</option>
            <option value="NJ">NJ</option>
            <option value="NM">NM</option>
            <option value="NV">NV</option>
            <option value="NY">NY</option>
            <option value="OH">OH</option>
            <option value="OK">OK</option>
            <option value="OR">OR</option>
            <option value="PA">PA</option>
            <option value="RI">RI</option>
            <option value="SC">SC</option>
            <option value="SD">SD</option>
            <option value="TN">TN</option>
            <option value="TX">TX</option>
            <option value="UT">UT</option>
            <option value="VA">VA</option>
            <option value="VT">VT</option>
            <option value="WA">WA</option>
            <option value="WI">WI</option>
            <option value="WV">WV</option>
            <option value="WY">WY</option>
	      </select>
          <input type="text" name="Zip" id="Zip" size="10" />
      </td>
    </tr>
    <tr>
      <td>Phone Number</td>
      <td><input type="text" name="Phone" id="Phone" size="54" /></td>
    </tr>
    <tr>
      <td></td>
      <td><img src="images/creditcards.png" /></td>
    </tr>
    <tr>
      <td>Card Type</td>
      <td>
      	  <select name="CardType" id="CardType">
			<option value="">Select Type</option>
			<option value="">Discover</option>
			<option value="">Mastercard</option>
			<option value="">Visa</option>
			<option value="">American Express</option>
          </select>
      </td>
    </tr>
    <tr>
      <td>Card Number</td>
      <td><input type="text" name="CardNum" id="CardNum" size="54" /></td>
    </tr>
    <tr>
      <td>Exp. Date</td>
      <td>
      	  <select name="CardExpMonth" id="CardExpMonth">
            <option value="">Mo</option>
          <% for x=1 to 12 
          	if x<10 then %>
			  <option value="0<%=x%>">0<%=x%></option>
           <% else %>
              <option value="<%=x%>"><%=x%></option>
          <% end if
		  next %>
          </select>
          /
      	  <select name="CardExpYear" id="CardExpYear">
			<option value="">Year</option>
			<option value="<%=Year(date)%>"><%=Year(date)%></option>
            <% for x=(Year(date)+1) to (year(date)+4) %>
			  <option value="<%=x%>"><%=x%></option>
            <% next %>
          </select>
      </td>
    </tr>
    <tr>
      <td>CVV2 Code</td>
      <td><input type="text" name="CVV2" id="CVV2" size="5" /></td>
    </tr>
    <tr>
      <td></td>
      <td>
        <input type="submit" name="Submit" value="Process Credit Card Payment" />
	  </td>
	</tr>
  </table>
</form>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<!-- ************************************* END MAIN CONTENT AREA ************************************* -->

    </div>    
    <div id="right">&nbsp;</div>
</div>
<!--#include file="foot.asp" -->

</body>
</html>
