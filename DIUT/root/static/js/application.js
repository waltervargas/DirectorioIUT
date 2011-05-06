var tabla;
var tabla2;
var tabla3;
var tabla4;
var sel = true;

$(document).ready(function(){
    
    $.ajaxSetup({ scriptCharset: "utf-8" , contentType: "application/json; charset=utf-8"});
    

    tabla = $("#lista_grupos").dataTable({
		"sAjaxSource": '/ajax/grupos',
		"bJQueryUI": true,
 		"oLanguage": {
            "sUrl": "/static/js/dataTables.spanish.txt"
        },
	    "fnDrawCallback": function () {
            my_hover();
        }
    });

    tabla2 = $("#lista_personas").dataTable({
		"sAjaxSource": '/ajax/personas',
		"bJQueryUI": true,
 		"oLanguage": {
            "sUrl": "/static/js/dataTables.spanish.txt"
        },
	    "fnDrawCallback": function () {
            my_hover();
        }
    });

    tabla3 = $("#lista_detalle_persona").dataTable({
		"sAjaxSource": '/ajax/miembros_grupo',
 		"oLanguage": {
            "sUrl": "/static/js/dataTables.spanish.txt"
        },
		"bJQueryUI": true,
	    "fnDrawCallback": function () {
            my_hover();
        }
    });

    var gidNumber = $("span.gidNumber").html();
    
    tabla4 = $("#lista_miembros_grupo").dataTable({
		"sAjaxSource": '/ajax/groupmembers/'+gidNumber,
 		"oLanguage": {
            "sUrl": "/static/js/dataTables.spanish.txt"
        },
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
                    $("div#mensaje").html("Las personas fueron agregadas al grupo exitosamente");
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
				type: "DELETE",
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

    $("a.eliminar").click(function(){
        return false;
        $("div#all").append('<div id="mensaje"> </div>');
        $("div#mensaje").html("Las personas fueron removidas del grupo exitosamente");
        $( "#mensaje" ).dialog({ buttons: { "Ok": function() { $(this).dialog("close"); return false; } } });
    
    });

    // Eliminar grupos
    $("button#remove_group").click(function(){
        var gids = $("input:checked").getCheckboxValues();
        var datos = ({'gids': gids});
        var jsoon = $.JSON.encode(datos);
			$.ajax({
				url: "/ajax/delete/groups", 
				type: "DELETE",
                data: jsoon, 
				dataType: "json",
				contentType: 'application/json; charset=utf-8',
			    processData: false,
				complete: function (data) {
                    if (data.status == 200)
                    {
                        $("div#all").append('<div id="mensaje"> </div>');
                        $("div#mensaje").html("Registros eliminados exitosamente");
                        tabla.fnReloadAjax();
                        $( "#mensaje" ).dialog({ buttons: { "Ok": function() { $(this).dialog("close"); } } });
                    }
                }
	        }); // Fin de ajax

    });


    $("button#remove_person").click(function(){
        var uids = $("input:checked").getCheckboxValues();
        var datos = ({'uids': uids});
        var jsoon = $.JSON.encode(datos);
			$.ajax({
				url: "/ajax/delete/persons", 
				type: "DELETE",
                data: jsoon, 
				dataType: "json",
				contentType: 'application/json; charset=utf-8',
			    processData: false,
				complete: function (data) {
                    if (data.status == 200)
                    {
                        $("div#all").append('<div id="mensaje"> </div>');
                        $("div#mensaje").html("Registros eliminados exitosamente");
                        tabla2.fnReloadAjax();
                        $( "#mensaje" ).dialog({ buttons: { "Ok": function() { $(this).dialog("close"); } } });
                    }
                }
	        }); // Fin de ajax

    });
});
