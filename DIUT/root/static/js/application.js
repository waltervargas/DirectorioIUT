var tabla;
var tabla2;

$(document).ready(function(){

    tabla = $("#lista_grupos").dataTable({
		"sAjaxSource": '/ajax/grupos',
		"bJQueryUI": true,
	    "fnDrawCallback": function () {
            my_hover();
        }
    });

    tabla2 = $("#lista_personas").dataTable({
		"sAjaxSource": '/ajax/personas',
		"bJQueryUI": true,
	    "fnDrawCallback": function () {
            my_hover();
        }
    });

});
