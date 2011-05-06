/* 
 * Extendiendo jquery con funciones propias
 */

// Obtiene los valores de los checkboxes seleccionados
//
jQuery.fn.getCheckboxValues = function(){
    var values = [];
    var i = 0;
    this.each(function(){
        // guarda los valores en un array
        values[i++] = $(this).val();
    });
    // devuelve un array con los checkboxes seleccionados
    return values;
} 
