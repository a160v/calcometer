import jstz from "jstz";

function setCookie(name, value) {
  var expires = new Date();
  expires.setTime(expires.getTime() + 24 * 60 * 60 * 1000);
  document.cookie = name + "=" + value + ";expires=" + expires.toUTCString();
}

// Rails doesn't support every timezone that Intl supports
function findTimeZone() {
  const oldIntl = window.Intl;
  try {
    window.Intl = undefined;
    const tz = jstz.determine().name();
    window.Intl = oldIntl;
    return tz;
  } catch (e) {
    return jstz.determine().name();
  }
}

const timezone = findTimeZone();
setCookie("timezone", timezone);
