# Ausbleden der Navigation für Mobile, bei Klick auf einen Navigationspunkt
$('ul.nav > li > a:not(.dropdown-toggle)').click ->
  if $('nav .navbar-collapse').hasClass('in')
    $("button.navbar-toggle").trigger "click"

# Schliessen von Bereichen innerhalb der Subnavigation
$('ul.nav ul.dropdown-menu a').click ->
  if $('nav .navbar-collapse').hasClass('in')
    $("button.navbar-toggle").trigger "click"


# Aktivieren des ausgewählten Navigationselementes
$('ul.nav li a').click ->
  $('ul.nav li.active').removeClass('active')
  $(this).parent('li').addClass('active')

# Deaktivieren der Navigation bei Klick auf den .navbar-brand
$('.navbar-brand').click ->
  $('ul.nav li.active').removeClass('active')
  
