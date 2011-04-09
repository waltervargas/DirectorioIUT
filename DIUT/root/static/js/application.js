$(document).ready(function(){
    // Cuando el mouse pasa por encima
    $("div#menu button").hover(function(){
        $(this).css('background-color', '#848484');
        $(this).css('cursor', 'pointer');
    // Cuando el mouse se quita de encima 
    }, function(){
        $(this).css('background-color', '#E6E6E6');
    });

    $("button#Persona").click(function(){
        $("#formulario_inside").load("personas");
    });
    $("button#Grupo").click(function(){
        $("#formulario_inside").load("grupos");
    });
});
