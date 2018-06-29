import "phoenix_html"

import socket from "./socket"

require("materialize-css")


M.AutoInit();

M.Collapsible.init($(".collapsible.expandable"), {accordion: false});

// Hide submit button
$(document).ready(function() {
  $("#logout").hide();
  $("#logout").parent().submit();
});




function getUrlParameter(sParam) {
  var sPageURL = decodeURIComponent(window.location.search.substring(1)),
    sURLVariables = sPageURL.split('&'), sParameterName, i;

  for (i = 0; i < sURLVariables.length; i++) {
    sParameterName = sURLVariables[i].split('=');

    if (sParameterName[0] === sParam) {
      return sParameterName[1] === undefined ? true : sParameterName[1];
    }
  }
}
