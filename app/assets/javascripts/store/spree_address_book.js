//= require store/spree_core

(function($) {
  $(document).ready(function(){
    var cha = $('.checkout_addresses');
    if ($(".select_address").length) {
      $('input#order_use_billing').unbind("click");
      $(".inner",cha).hide();
      $(".inner input",cha).prop("disabled", true);
      $(".inner select",cha).prop("disabled", true);
      if ($('input#order_use_billing').is(':checked')) {
        $("#shipping .select_address").hide();
      }
      
      $('input#order_use_billing').click(function() {
        if ($(this).is(':checked')) {
          $("#shipping .select_address").hide();
          hide_address_form('shipping');
        } else {
          $("#shipping .select_address").show();
          if ($("input[name='order[ship_address_id]']:checked").val() == '0') {
            show_address_form('shipping');
          }
        }
      });

      $("input[name='order[bill_address_id]']:radio").change(function(){
        if ($("input[name='order[bill_address_id]']:checked").val() == '0') {
          show_address_form('billing');
        } else {
        }
      });

      $("input[name='order[ship_address_id]']:radio").change(function(){
        if ($("input[name='order[ship_address_id]']:checked").val() == '0') {
          show_address_form('shipping');
        } else {
          hide_address_form('shipping');
        }
      });
    }
  });
  
  function hide_address_form(address_type){
    var cha = $('.checkout_addresses');
    $(".inner",cha).hide();
    $(".inner input",cha).prop("disabled", true);
    $(".inner select",cha).prop("disabled", true);
  }
  
  function show_address_form(address_type){
    var cha = $('.checkout_addresses');
    $(".inner",cha).show();
    $(".inner input",cha).prop("disabled", false);
    $(".inner select",cha).prop("disabled", false);
  }
})(jQuery);
