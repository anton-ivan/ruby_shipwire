/*
	Last Update: 2/29/2012
*/

if (window != top)
    top.location.href = location.href

function MM_openBrWindow(theURL, winName, features) {
    window.open(theURL, winName, features);
}

function toggleCardInfo() {
    if (!$('#ValidateCardInfo').attr('checked'))
        $('#paymentForm').show();
    else
        $('#paymentForm').hide();
}

function toggleShipping() {
    if (jQuery.prototype.jquery == '1.9.1' || jQuery.prototype.jquery == '1.11.1') {
        if ($('#ShippingIsDifferentThanBilling').is(':checked'))
            $('#shippingInformation').show();
        else
            $('#shippingInformation').hide();
    } else {
        if ($('#ShippingIsDifferentThanBilling').attr('checked'))
            $('#shippingInformation').show();
        else
            $('#shippingInformation').hide();
    }
}

function ischeckedss() {
    if (jQuery.prototype.jquery == '1.9.1' || jQuery.prototype.jquery == '1.11.1') {
        return $('#ShippingIsDifferentThanBilling').is(':checked');
    } else {
        return $('#ShippingIsDifferentThanBilling').attr('checked');
    }
}

function validateForm(e) {
    var messages = "";
    if ((typeof $('input[name=OrderType]:checked').val() === "undefined") || $('input[name=OrderType]:checked').val() == '') {
        try {
            trimOrderFields();
            if ($('#CardNumber').length > 0 && ($('#ValidateCardInfo').length == 0 || !$('#ValidateCardInfo').attr('checked'))) {
                if (isEmpty('CardNumber')) {
                    messages += "\tCredit card number is required\n";
                }
                else {
                    if (CheckCardNum($('#CardNumber').val()) == 0)
                        messages += "\tCredit card number is invalid\n";

                    if ($('#CardCvv2').val().length < 3 || isNaN($('#CardCvv2').val()) || isEmpty('CardCvv2'))
                        messages += "\tCVV2 is invalid\n";
                }

                if ($('#CardExpirationMonth').length > 0) {
                    var month = $('#CardExpirationMonth').val();
                    var year = $('#CardExpirationYear').val();
                    if (!IsValidCreditCardDate(month, year))
                        messages += "\tCredit Card Expiration Date is not valid\n";
                }
            }

            if ($('#BillingPrefix').length > 0) {
                if (isEmpty("BillingPrefix"))
                    messages += "\tTitle is required\n";
            }

            if ($('#BillingFirstName').length > 0) {
                if (isEmpty("BillingFirstName"))
                    messages += "\tFirst Name is required\n";

                if (isEmpty("BillingLastName"))
                    messages += "\tLast Name is required\n";

                if ((typeof (verifyBStreet) == 'undefined' || verifyBStreet) && isEmpty("BillingStreet"))
                    messages += "\tAddress is required\n";

                if ((typeof (verifyBCity) == 'undefined' || verifyBCity) && isEmpty("BillingCity"))
                    messages += "\tCity is required\n";

                if ((typeof (verifyBState) == 'undefined' || verifyBState) && isEmpty("BillingState"))
                    messages += "\tState is required\n";

                if ((typeof (verifyBZip) == 'undefined' || verifyBZip) && isEmpty("BillingZip"))
                    messages += "\tZip is required\n";

                if ((typeof (verifyBCountry) == 'undefined' || verifyBCountry) && isEmpty("BillingCountry"))
                    messages += "\tCountry is required\n";
            }

            if ((typeof (verifyPhone) == 'undefined' || verifyPhone) && $('#Phone').length > 0) {
                if (isEmpty("Phone")) {
                    messages += "\tPhone is required\n";
                }
                else {
                    var phone = $('#Phone').val().replace(/[^0-9]/g, "");
                    if (phone.length != 10) {
                        messages += "\tPhone is invalid. Please enter a phone number in the format ###-###-####\n";
                    }
                }
            }

            if ((typeof (verifyEmail) == 'undefined' || verifyEmail) && $('#Email').length > 0) {

                if (isEmpty("Email")) {
                    messages += "\tEmail is required\n";
                }
                else {
                    var reg = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
                    var address = document.getElementById("Email").value

                    if (reg.test(address) == false) {
                        messages += "\tInvalid Email Address\n";
                    }
                }

            }

            if ($('#ShippingFirstName').length > 0 && ischeckedss()) {
                if (isEmpty("ShippingFirstName"))
                    messages += "\tShipping First Name is required\n";

                if (isEmpty("ShippingLastName"))
                    messages += "\tShipping Last Name is required\n";

                if ((typeof (verifySStreet) == 'undefined' || verifySStreet) && isEmpty("ShippingStreet"))
                    messages += "\tShipping Address is required\n";

                if ((typeof (verifySCity) == 'undefined' || verifySCity) && isEmpty("ShippingCity"))
                    messages += "\tShipping City is required\n";

                if ((typeof (verifySState) == 'undefined' || verifySState) && isEmpty("ShippingState"))
                    messages += "\tShipping State is required\n";

                if ((typeof (verifySZip) == 'undefined' || verifySZip) && isEmpty("ShippingZip"))
                    messages += "\tShipping Zip is required\n";

                if ((typeof (verifySCountry) == 'undefined' || verifySCountry) && isEmpty("ShippingCountry"))
                    messages += "\tShipping Country is required\n";
            }
        }
        catch (err) {
            alert(err);
            e.preventDefault();
        }

        try {
            if (messages.length == 0)
                cleanExit = true;
            if (messages.length > 0) {
                e.preventDefault();
                messages = "Please correct the following issues:\n" + messages;
                alert(messages);
            }
            else if (typeof (QASValidate) != 'undefined' && QASValidate) {
                e.preventDefault();
                qasValidateAddress();
            }
        }
        catch (err) {
        }
    }
}

function isEmpty(fieldId) {
    var value = $('#' + fieldId).val();
    var str = value.replace(/^\s\s*/, '').replace(/\s\s*$/, '')
    return str.length == 0;
}


var errorcolor = "#FCFCC2"
var normalcolor = "#FFFFFF"
var errormessage = ""

function CheckCardNum(cardnum) {
    if (cardnum == '') {
        return 0;
    }
    if (isNaN(cardnum)) {
        return 0;
    }
    if (parseInt(cardnum) <= 0) {
        return 0;
    }
    if (!CheckLUHN(cardnum)) {
        return 0;
    }

    //Checks card length based of card type
    var regex = new RegExp("^(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|6(?:011|5[0-9][0-9])[0-9]{12}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|(?:2131|1800|35\\d{3})\\d{11})$");
    if (!regex.test(cardnum)) {
        return 0;
    }
    return 1;
}

function CheckLUHN(cardnum) {
    var RevNum = new String(cardnum);
    RevNum = Reverse(RevNum);

    var total = new Number(0);
    for (var i = 0; i < RevNum.length; i += 1) {
        var temp = 0;
        if (i % 2) {
            temp = RevNum.substr(i, 1) * 2;
            if (temp >= 10) {
                var splitstring = new String(temp);
                temp = parseInt(splitstring.substr(0, 1)) + parseInt(splitstring.substr(1, 1));
            }
        }
        else {
            temp = RevNum.substr(i, 1);
        }
        total += parseInt(temp);
    }
    // if there's no remainder, we return 1 (true)
    return (total % 10) ? 0 : 1;
}

function IsValidCreditCardDate(cardExpirationMonth, cardExpirationYear) {
    var currentDate = new Date();

    if (cardExpirationYear == currentDate.getFullYear() && (cardExpirationMonth - 1) < currentDate.getMonth()) {
        return false;
    }
    return true;
}

function Reverse(strToReverse) {
    var strRev = new String;
    var i = strToReverse.length;

    while (i--) {
        strRev += strToReverse.charAt(i);
    }
    return strRev;
}

function validate_email() {
    var reg = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
    var address = document.getElementById("email_address").value
    if (reg.test(address) == false) {
        return false;
    }
    return true;
}

function trimOrderFields() {
    $('#CardNumber').val($.trim($('#CardNumber').val()));
    $('#CardCvv2').val($.trim($('#CardCvv2').val()));
    $('#BillingZip').val($.trim($('#BillingZip').val()));
}

function validateCheckOutForm(e) {
    if ((typeof $('input[name=OrderType]:checked').val() === "undefined") || $('input[name=OrderType]:checked').val() == '') {
        var messages = '';
        try {
            trimOrderFields();
            var isContinueCCCheck = true;

            isContinueCCCheck = ($("input[name='CardSelection']:checked").val() == undefined)
            if (!isContinueCCCheck)
                isContinueCCCheck = ($("input[name='CardSelection']:checked").val().length == 0)
            if (isContinueCCCheck && $('#CardNumber').length > 0 && ($('#ValidateCardInfo').length == 0 || !$('#ValidateCardInfo').attr('checked'))) {

                if (isEmpty('CardNumber')) {
                    messages += "\tCredit card number is required\n";
                }
                else {
                    if (CheckCardNum($('#CardNumber').val()) == 0)
                        messages += "\tCredit card number is invalid\n";

                    //                if (isEmpty("NameOnCard"))
                    //                    messages += "\tName On Card is required\n";
                }
                if ($('#CardExpirationMonth').length > 0) {
                    var month = $('#CardExpirationMonth').val();
                    var year = $('#CardExpirationYear').val();

                    if (!IsValidCreditCardDate(month, year))
                        messages += "\tCredit Card Expiration Date is not valid\n";
                }
            }

            if ($('#CardCvv2').val().length < 3 || isNaN($('#CardCvv2').val()) || isEmpty('CardCvv2'))
                messages += "\tCVV2 is invalid\n";


            if ($('#BillingFirstName').length > 0) {
                if (isEmpty("BillingFirstName"))
                    messages += "\tFirst Name is required\n";

                if (isEmpty("BillingLastName"))
                    messages += "\tLast Name is required\n";

                if (document.getElementById('BillingStreet').value.length == 0)
                    messages += "\tAddress is required\n";

                if (document.getElementById('BillingCity').value.length == 0)
                    messages += "\tCity is required\n";

                if (document.getElementById('BillingState').value.length == 0)
                    messages += "\tState is required\n";

                if (document.getElementById('BillingZip').value.length == 0)
                    messages += "\tZip is required\n";

                if (document.getElementById('BillingCountry').value.length == 0)
                    messages += "\tCountry is required\n";
            }

            if ($('#Phone').length > 0) {
                if (isEmpty("Phone")) {
                    messages += "\tPhone is required\n";
                }

                if (!isEmpty("Phone")) {
                    phone = $('#Phone').val().replace(/[^0-9]/g, "");
                    if (phone.length != 10) {
                        messages += "\tPhone is invalid. Please enter a phone number in the format ###-###-####\n";
                    }
                }
            }

            if ($('#Email').length > 0) {

                if (isEmpty("Email")) {
                    messages += "\tEmail is required\n";
                }
                else {
                    var reg = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
                    var address = document.getElementById("Email").value

                    if (reg.test(address) == false) {
                        messages += "\tInvalid Email Address\n";
                    }
                }
            }

            if (typeof (isLoggedIn) != 'undefined' && !isLoggedIn && ($("input[name='LoginSelection']:checked").val() == undefined || $("input[name='LoginSelection']:checked").val() != "anonymous")) {
                if (isEmpty("CurrentCustomer_Password"))
                    messages += "\tPassword is required\n";

                if (isEmpty("ConfirmPassword"))
                    messages += "\tConfirm Password is required\n";

                if ($('#CurrentCustomer_Password').val() != $('#ConfirmPassword').val())
                    messages += "\tPassword and Confirm Password must match\n";
            }

            if (ischeckedss()) {

                if (document.getElementById('ShippingStreet').value.length == 0)
                    messages += "\tShipping Address is required\n";

                if (document.getElementById('ShippingCity').value.length == 0)
                    messages += "\tShipping City is required\n";

                if (document.getElementById('ShippingState').value.length == 0)
                    messages += "\tShipping State is required\n";

                if (document.getElementById('ShippingZip').value.length == 0)
                    messages += "\tShipping Zip is required\n";

                if (document.getElementById('ShippingCountry').value.length == 0)
                    messages += "\tShipping Country is required\n";
            }
        }
        catch (err) {
            alert(err);
            e.preventDefault();
        }
        if (messages.length > 0) {
            e.preventDefault();
            messages = "Please correct the following issues:\n" + messages;
            alert(messages);
        }
        //    else if (QASValidate != null && QASValidate == true) {
        //        e.preventDefault();
        //        qasValidateAddress();
        //    }
    }
}

$(document).ready(function () {
    $('#formWrap').find('input').each(function () {
        $(this).val($(this).val().replace(/^\*(\w*\s*)+/g, ''));
    });
    checkVSCookie();
});

function loadCookie(cname) {
    var name = cname + "=";
    var ca = document.cookie.split(';');
    for (var i = 0; i < ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) == ' ') c = c.substring(1);
        if (c.indexOf(name) != -1) return c.substring(name.length, c.length);
    }
    return "";
}

function checkVSCookie() {
    if (loadCookie('visitorSession') === '') {
        setTimeout('checkVSCookie()', 250);
    }
    else {
        if (typeof OnVSCookieLoaded == "function") {
            OnVSCookieLoaded();
        }
		checkGeo();
    }
}

function checkGeo() {
	try{
    $.post('/Shared/geo/geo_pu.aspx', { t: new Date().getTime() }, function (r) {
        if (r.v) {
            var s = document.createElement('script');
            s.setAttribute('src', '/Shared/geo/geo_pu.aspx?m=s&t=' + new Date().getTime() + '&pc=' + r.pc);
            document.body.appendChild(s);
        }
    });
	}catch(e){
		console.log('checkgeo ' + e);
	}
}

var messagesEnglish = {
    billingStreetAutofillPlaceholder: 'Street Address',
    billingNameOnCardLabel: 'Full Name',
    billingNameOnCardPlaceholder: '*Full Name:',
    billingStreetPlaceholder: '*Address:',
    billingCityPlaceholder: '*City:',
    billingZipPlaceholder: '*Zip:',
    phonePlaceholder: '*Phone:',
    emailPlaceholder: '*Email:',
    shippingStreetAutofillPlaceholder: 'Street Address',
    shippingNameOnCardLabel: 'Full Name',
    shippingNameOnCardPlaceholder: '*Full Name:',
    shippingStreetPlaceholder: '*Address:',
    shippingCityPlaceholder: '*City:',
    shippingZipPlaceholder: '*Zip:'
}

var messagesFrench = {
    billingStreetAutofillPlaceholder: 'Adresse de la rue',
    billingNameOnCardLabel: 'Nom et prénom',
    billingNameOnCardPlaceholder: '*Nom et prénom:',
    billingStreetPlaceholder: '*Adresse:',
    billingCityPlaceholder: '*Ville:',
    billingZipPlaceholder: '*Le code postal:',
    phonePlaceholder: '*Numéro de téléphone:',
    emailPlaceholder: '*Email:',
    shippingStreetAutofillPlaceholder: 'Adresse de la rue',
    shippingNameOnCardLabel: 'Nom et prénom',
    shippingNameOnCardPlaceholder: '*Nom et prénom:',
    shippingStreetPlaceholder: '*Adresse:',
    shippingCityPlaceholder: '*Ville:',
    shippingZipPlaceholder: '*Le code postal:'
}