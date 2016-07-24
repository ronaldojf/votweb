$(function() {
  window.Turbolinks.enableProgressBar();

  window.localizedPath = function(args) {
    var pathPrefix = [].shift.apply(arguments);
    var urlSuffix = '';

    if ((arguments[0] || {}).url) {
      urlSuffix = '_url';
      delete arguments[0].url;
    } else {
      urlSuffix = '_path';
    }

    return window.Routes[pathPrefix + '_' + window.I18n.pathLocale + urlSuffix].apply(this, arguments);
  };

  $(document).on('submit', 'form[data-turboform]', function(e) {
    window.Turbolinks.visit(this.action + (this.action.indexOf('?') == -1 ? '?' : '&') + $(this).serialize());
    return false;
  });
});
