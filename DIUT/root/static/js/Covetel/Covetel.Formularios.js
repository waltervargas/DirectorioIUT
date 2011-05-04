/* 
Archivo: 	Covetel.Formularios.js
Autor: 		Walter Vargas <walter@covetel.com.ve>
Descripción: Esta libreria se encarga de gestionar los formularios. 
*/

(function($){
 $.fn.campo_requerido = function(opciones){

	// Opciones 
	var defaults = {
		mensaje: 'Campo Obligatorio',
		asterisk: true,
	};
	
	var opciones = $.extend(defaults, opciones);	
	
	return this.each(function(){
		obj = $(this);

		// limpieza primero 
        obj.children(".requerido").remove();

		if (opciones.asterisk){
			obj.prepend('<span class="requerido"> * </span>');
		}
		obj.append('<div class="requerido"> '+opciones.mensaje+' </div>');
	});
 };
})(jQuery);

// Implementando la libreria.

$(document).ready(function(){
	$("div.constraint_required").campo_requerido();	
});
