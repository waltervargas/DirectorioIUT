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

    tabla3 = $("#lista_detalle_persona").dataTable({
		"sAjaxSource": '/ajax/miembros_grupo',
		"bJQueryUI": true,
	    "fnDrawCallback": function () {
            my_hover();
        }
    });

    var gidNumber = $("span.gidNumber").html();
    
    tabla4 = $("#lista_miembros_grupo").dataTable({
		"sAjaxSource": '/ajax/groupmembers/'+gidNumber,
		"bJQueryUI": true,
	    "fnDrawCallback": function () {
            my_hover();
        }
    });
});
