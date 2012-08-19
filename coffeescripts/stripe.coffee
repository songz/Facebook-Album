Stripe.setPublishableKey('pk_iCbmZWvEwfXLnuOACl9YgSibT7R20')

validateNumber = (event) ->
  if window.event
    key = event.keyCode
  else
    key = event.which

  if event.keyCode == 8 or event.keyCode == 46 or event.keyCode == 37 or event.keyCode == 39
    return true
  else if key < 48 or key > 57
    return false
  else return true
 
$('.integer').keypress(validateNumber)


$("#payment-form").submit (event) ->
  $('.submit-button').attr("disabled", "disabled")
  ee = $('#em').val()
  Stripe.createToken
    number: $('.card-number').val(),
    cvc: $('.card-cvc').val(),
    exp_month: $('.card-expiry-month').val(),
    exp_year: $('.card-expiry-year').val(),
    email: $('#em').val()
  , stripeResponseHandler
  return false

stripeResponseHandler = (status, response) ->
  if (response.error)
    $(".payment-errors").text(response.error.message)
    $(".submit-button").removeAttr("disabled")
  else
    form$ = $('#payment-form')
    token = response['id']
    console.log status
    form$.append("<input type='hidden' name='stripeToken' value='" + token + "'/>")
    form$.get(0).submit()
