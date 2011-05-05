var tabla;
var tabla2;
var tabla3;

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

    tabla3 = $("#lista_miembros_grupo").dataTable({
		"sAjaxSource": '/ajax/miembros_grupo',
		"bJQueryUI": true,
	    "fnDrawCallback": function () {
            my_hover();
        }
    });

    tabla4 = $("#lista_grupos_persona").dataTable({
		"sAjaxSource": '/ajax/grupos_persona',
		"bJQueryUI": true,
	    "fnDrawCallback": function () {
            my_hover();
        }
    });
});
