function my_hover () {    

//  $(".dataTable td").each(function(){
 
  //  $(this).addClass("ui-widget-content");
 
//  });

  $(".dataTable tr").hover(
     function()
     {
      $(this).addClass("fila-hover");
     },
     function()
     {
      $(this).removeClass("fila-hover");
     }
    );
}
