  var subnavToggle = function(){
    return $('#subnavBtn').on( "click", function(){
    $('#subnav').toggleClass("hidden");
    });
  };

  $(document).on('page:update', subnavToggle);

  var showNavBar = function(){
    return $('#navbar').on('mouseenter', function(){
      $('#subnav').removeClass("hidden");      
    });
  };

  $(document).on('page:update', showNavBar);

var hideNavBar = function(){
    return $('#subnav').on('mouseleave', function(){
      $('#subnav').addClass("hidden");      
    });
  };

  $(document).on('page:update', hideNavBar);