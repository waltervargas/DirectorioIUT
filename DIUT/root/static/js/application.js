var tabla;
var tabla2;
var tabla3;
var tabla4;
var sel = true;

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


    // Add member to group
    $("form#form_add_member").submit(function(){ return false; });


    // Boton agregar personas a un grupo. 
    $("button#add_member").click(function(){
        var uid = $("textarea#personas").val();
        var personas = uid.split(',');
        var gid = $("span.gidNumber").html();
        var datos = ({'personas': personas, 'gid':gid});
        var jsoon = $.JSON.encode(datos);
			$.ajax({
				url: "/ajax/grupos/add", 
				type: "PUT",
                data: jsoon, 
				dataType: "json",
				contentType: 'application/json',
			    processData: false,
				complete: function (data) {
                    $("#personas").val('');
                    $( "#mensaje" ).dialog({ buttons: { "Ok": function() { $(this).dialog("close"); } } });
                    tabla4.fnReloadAjax();
                }
	        }); // Fin de ajax
    });

    $("button#remove_from_group").click(function(){
        var uids = $("input:checked").getCheckboxValues();
        var gid = $("span.gidNumber").html();
        var datos = ({'personas': uids, 'gid':gid});
        var jsoon = $.JSON.encode(datos);
			$.ajax({
				url: "/ajax/grupos/del", 
				type: "PUT",
                data: jsoon, 
				dataType: "json",
				contentType: 'application/json',
			    processData: false,
				complete: function (data) {
                    $("div#mensaje").html("Las personas fueron removidas del grupo exitosamente");
                    $( "#mensaje" ).dialog({ buttons: { "Ok": function() { $(this).dialog("close"); } } });
                    tabla4.fnReloadAjax();
                }
	        }); // Fin de ajax

    });

    $("button#select_all").click(function(){
        if (sel){
            $("input:checkbox").attr('checked', true);
            $("button#select_all").html("Desmarcar todos");
            sel = false;
        } else {
            $("input:checkbox").attr('checked', false);
            $("button#select_all").html("Marcar todos");
            sel = true;
        
        }
    });

    $("button#select_all_off").click(function(){
        $("input:checkbox").attr('checked', false);
    });
});
