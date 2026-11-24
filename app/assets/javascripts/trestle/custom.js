// This file may be used for providing additional customizations to the Trestle
// admin. It will be automatically included within all admin pages.
//
// For organizational purposes, you may wish to define your customizations
// within individual partials and `require` them here.
//
//  e.g. //= require "trestle/custom/my_custom_js"

(function () {
  var zone = window.Intl && Intl.DateTimeFormat().resolvedOptions().timeZone;
  if (zone) {
    document.cookie = "time_zone=" + encodeURIComponent(zone) + "; path=/admin; max-age=31536000; SameSite=Lax";
  }
})();
