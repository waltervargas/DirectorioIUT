/* 
Archivo: 	Covetel.Usuario.js
Autor: 		Walter Vargas <walter@covetel.com.ve>
Descripción: Esta libreria se encarga de manejar los datos del usuario y sus respectivos roles.
*/

function Covetel_usuario (){
	// Busco los datos del usuario via AJAX al Servidor.
	this.datos = eval('('+$.ajax({
		async: false,
		url: '/ajax/usuario/datos/',
		dataType: "json",
		complete: this.set,
	}).responseText+')');
	
	// Declaro los atributos del usuario.
	this.cn = this.datos.cn;
	this.roles = new Array();
	this.roles = this.datos.roles;
	this.uid = this.datos.uid;

	// Este método busca el rol, en la lista de roles. 
	this.check_any_user_roles = function (r){
		for (key in this.roles){
			if (r == this.roles[key]) {return true;};
		}
	}

}

function error_passwords(){
		//Leo el valor del passwd1 y lo comparo con el valor de passwd2
		var p1 = $("#passwd").val();
		var p2 = $("#passwd2").val();
		if (p1 != p2) {

			$("#passwd").val('');
			$("#passwd2").val('');
			$("#passwd").focus();
			$("#passwd").parent().addClass("error error_constraint_required");
			$("#passwd2").parent().addClass("error error_constraint_required");
		
			$("#passwd").qtip({
				content: 'Las contraseñas no coinciden',
				show: { ready: true },
				position: { adjust: {x: 0, y: -20} }
			});

		} else {
			$("#passwd").parent().removeClass("error error_constraint_required");
			$("#passwd2").parent().removeClass("error error_constraint_required");
		}
}

function element_error(element,msj){
	element.val('');
	element.focus();
	element.parent().addClass("error error_constraint_required");

	element.parent().append();

	element.before('<div class="element_msj_error"> '+msj+' </div>');
	/*element.qtip({
		content: msj,
		show: { ready: true, solo: true },
		position: { adjust: {x: 0, y: -50} }
	});*/

}

var usersTable = null;

//if (!usuario){
	//var usuario = new Covetel_usuario();
//}

$(document).ready(function(){
	

	// Autocreate del uid.
	$("#apellido").blur(function(){
		//Busco el nombre 
		var nombre = $("#nombre").val();
		//Busco el apellido
		var apellido = $("#apellido").val();
		//Llevo todo a minusculas.
		nombre = nombre.toLowerCase();
		apellido = apellido.toLowerCase();	
		//Saco la primera letra del nombre para el uid
		var uid = nombre.charAt(0);
		uid += apellido;
		//Asigo al valor de uid. 
		$("#uid").val(uid);
	});

	//Valido que el uid no este ya registrado en el LDAP. 
	$("#uid").blur(function(){
		var uid = $("#uid").val();
		if (uid != ''){
			$("#uid").parent().removeClass("error error_constraint_required");
			$(".element_msj_error").remove();	
			$.ajax({
				url: "/ajax/usuario/exists/"+uid, 
				type: "GET",
				dataType: "json",
				complete: function (data) {
					var datos = $.parseJSON(data.responseText);
					if (datos.exists) {
						$(".element_msj_error").remove();	
						element_error($("#uid"),'El Identificador '+uid+' esta siendo usado por otro usuario, por favor ingrese un identifador diferente');
					} else {
						$("#uid").parent().removeClass("error error_constraint_required");
					}
				},
			}); // Fin de ajax
		} else {
			$(".element_msj_error").remove();	
			element_error($("#uid"),'Debe ingresar un Identificador válido');
		}
	});

	//Valido que las contraseñas sean iguales.
	$("#passwd2").blur(function(){
		//Leo el valor del passwd1 y lo comparo con el valor de passwd2
		var p1 = $("#passwd").val();
		var p2 = $("#passwd2").val();
		if (p1 != p2) {

			$("#passwd").val('');
			$("#passwd2").val('');
			$("#passwd").focus();
			$("#passwd").parent().addClass("error error_constraint_required");
			$("#passwd2").parent().addClass("error error_constraint_required");
		
			$("#passwd").qtip({
				content: 'Las contraseñas no coinciden',
				show: { ready: true },
				position: { adjust: {x: 0, y: -20} }
			});

		} else {
			$("#passwd").parent().removeClass("error error_constraint_required");
			$("#passwd2").parent().removeClass("error error_constraint_required");
		}
	});



	// Population to table users.
	usersTable = $("#tabla_usuarios").dataTable({
		"sAjaxSource": '/ajax/tabla/usuarios',
        "bAutoWidth": false,
		"bProcessing": false,
		"bJQueryUI": true,
		//"aaSorting": [[ 8, "desc" ]],
 		"oLanguage": {
            "sUrl": "/static/javascripts/dataTables.spanish.txt",
        },
	});

	// Si ocurrio un error en el campo entidad verificadora, muestro el field. 
	$(".error_validator_cnti1409_existe_entidadusuario").ready(function(){
		$("#fielset_entidad_verificadora").show();	
	});

	//Información del usuario. 
	$("div#usuario_tabs").tabs();	

	//Cuando hagan click sobre el boton de crear usuario 
	$("input#crear_usuario_submit").click(function(){
		var rol = $("#rol :selected").val();
		if (rol == '-'){
			alert("Debe seleccionar un Rol para el usuario");
			return false;
		} else {
			return true;
		}
	});

	//Cuando hagan click en el boton eliminar usuario.
	$("input#eliminar_usuario_submit").click(function(){
		if (confirm("¿ Realmente desea eliminar este usuario ?")){
			return true;
		} else {
			return false;
		}	
	});


	// Cuando hacen click en actualizar contraseñas, valido que ambas contraseñas sean iguales. 
	$("input#usuario_cambiar_password_submit").click(function(){
		var p1 = $("#passwd").val();
		var p2 = $("#passwd2").val();
		if (p1 == '' && p2 == ''){
			alert("Error: Debe indicar un par de contraseñas válidas");
			return false;
		} 
		
		if (p1 != p2){
			error_passwords();
			return false; 
		}
		
	});
	
	

});
