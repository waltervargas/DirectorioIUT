var tabla;

$(document).ready(function(){

    tabla = $("#lista_grupos").dataTable({
		"sAjaxSource": '/ajax/grupos',
		"bJQueryUI": true,
    });

});
