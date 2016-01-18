$ ->
  $('#new_order').submit ->
    $(this).find(':submit').hide()
    $(this).find('#order-submit-spinner').show()

  $('.order-quantity').change ->
    total_price = 0
    total_quantity = 0

    $('.order-quantity').each ->
      total_quantity += parseInt($(this).val())
      total_price += parseInt($(this).val()) * $(this).data('price')

    $('#order-total-price').text(total_price.toFixed(2))

    # Medium priority flat rate $11.30 for up to 30 bottles.
    # Large priority flat rate $15.80 for 30-50 bottles.
    total_shipping = Math.floor(total_quantity / 50) * 15.80

    if (total_quantity % 50) <= 30
      total_shipping = total_shipping + 11.30
    else
      total_shipping = total_shipping + 15.80

    $('#order-shipping-price').text(total_shipping.toFixed(2))
