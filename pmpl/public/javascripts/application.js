// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery(function($) {
  $("#vehicle_brand_id").change(function() {
    // make a POST call and replace the content
    var brand = $('select#vehicle_brand_id :selected').val();
    if(brand == "") brand = "0";
    jQuery.get('/vehicles/update_carmodels_select/' + brand, function(data){
		$("#vehicle_carmodel_id").html(data);
    })
    return false;
  });

  $("#vehicle_historic_vehicle_id").change(function() {
    // make a POST call and replace the content
    var vehicle = $('select#vehicle_historic_vehicle_id :selected').val();
    if(vehicle == "") vehicle = "0";
    jQuery.get('update_oil_select/' + vehicle, function(data){
		$("#vehicle_historic_oil_id").html(data);
    })
    return false;
  });

$("#machine_historic_vehicle_id").change(function() {
    // make a POST call and replace the content
    var vehicle = $('select#machine_historic_vehicle_id :selected').val();
    if(vehicle == "") vehicle = "0";
    jQuery.get('update_oil_select/' + vehicle, function(data){
		$("#machine_historic_oil_id").html(data);
    })
    return false;
  });

  $("input.oil_check").click(function() {
	if($(this).parent().next().css("display") == "none"){
		$(this).parent().next().show()
	} else {
		$(this).parent().next().children().children().next().val("")
		$(this).parent().next().children().next().children().val("")
		$(this).parent().next().val("")
		$(this).parent().next().hide()
	}
  });
})