'use strict';

$(function() {
  window.App = function() {
    this.defaults();
    this.binds();
  };

  App.prototype.markDirty = function() {
    if (!window._isDirty) {
      $(window).bind('beforeunload', function(e){
        var message = window.I18n.t('js.forms.unsaved.default');

        e = e || window.event;
        if (e) {
          e.returnValue = message;
        }

        return message;
      });
    }
    window._isDirty = true;
  };

  App.prototype.clearDirty = function() {
    window._isDirty = false;
    $(window).unbind('beforeunload');
  };

  App.prototype.binds = function() {
    $('[data-toggle=tooltip]').on('click', function(e) {
      e.preventDefault();
    }).tooltip();

    $('[data-form-submit]').on('click', function(e) {
      var form = $("[action='" + $(this).data('form-submit') + "']");

      if (form.find('input[type="submit"]').length > 0) {
        form.find('input[type="submit"]').click();
      } else {
        form.submit();
      }

      e.preventDefault();
    });

    $('body').on('mouseup', 'tr[data-href] td:not([data-no-href])', function(e) {
      Turbolinks.visit($(this).parents('tr:first').data('href'));
    });

    $('.show-action-label').append('<div class="clearfix"></div>');

    $('.check-all').on('click', function(e) {
      e.preventDefault();
      $(this).parent().find('input[type=checkbox]').prop('checked', true);
    });

    $('.uncheck-all').on('click', function(e) {
      e.preventDefault();
      $(this).parent().find('input[type=checkbox]').prop('checked', false);
    });

    $('.table-responsive').on('show.bs.dropdown', function() {
      $('.table-responsive').css('overflow', 'inherit');
    });

    $('.table-responsive').on('hide.bs.dropdown', function() {
      $('.table-responsive').css('overflow', 'auto');
    });

    if ($('.chosen-container').length > 0) {
      $('[chosen]').data('chosen').results_none_found = window.I18n.t('js.chosen.results_none_found');
      $('.chosen-container').attr('style', 'width: 100%');
    }
  };

  window.App.prototype.defaults = function() {
    swal.setDefaults({
      confirmButtonColor: '#1ab394',
      cancelButtonColor: '#f3f3f4',
      confirmButtonText: window.I18n.t('js.buttons.ok'),
      cancelButtonText: window.I18n.t('js.buttons.cancel')
    });
  };
});

$(document).on('turbolinks:load', function() {
  setTimeout(function() {
    window.app = new window.App();
  });

  if ($('[fake-password]').length > 0 && !$($('[fake-password]').parent()).hasClass('has-error')) {
    window.fakePassword = Math.random().toString(36).substring(8);
    $('[fake-password]').val(window.fakePassword);

    $('[fake-password]').on('focus', function() {
      if ($(this).val() === window.fakePassword) {
        $(this).val('');
      }
    });

    $('[fake-password]').on('blur', function() {
      if ($(this).val().length <= 0) {
        $(this).val(window.fakePassword);
      }
    });

    $('form').on('submit', function() {
      $('[fake-password]').each(function() {
        if ($(this).val() === window.fakePassword) {
          $(this).val('');
        }
      });
    });
  }

  $('.datetimepicker').each(function() {
    var target = $(this);
    var initialValue = target.val();

    target.wrap('<div class="input-group date"></div>');
    $(target.parent()).append(
      '<label for="' + target.attr('id') + '" class="input-group-addon">' +
      '<i class="fa fa-calendar"></i>' +
      '</label>'
    );

    target.datetimepicker({
      useCurrent: false
    });

    if (initialValue) {
      target.data('DateTimePicker').date(new Date(initialValue));
    }
  });

  $.rails.allowAction = function(link) {
    if (!link.attr('data-confirm')) {
      return true;
    }
    $.rails.showConfirmDialog(link);
    return false;
  };

  $.rails.confirmed = function(link) {
    if (link.attr('data-method')) {
      link.removeAttr('data-confirm');
      link.trigger('click.rails');
    } else {
      window.Turbolinks.visit(link.attr('href'));
    }
  };

  $.rails.showConfirmDialog = function(link) {
    var message = link.attr('data-confirm');
    window.swal({
      title: window.I18n.t('js.messages.titles.sure'),
      text: message,
      type: 'warning',
      showCancelButton: true,
      customClass: 'data-confirm-swal'
    });

    $('.data-confirm-swal .confirm, .data-confirm-swal .cancel').off('click');
    $('.data-confirm-swal .confirm').on('click', function() { $.rails.confirmed(link); });
    $('.data-confirm-swal .cancel').on('click', function() { $('.data-confirm-swal .confirm').off('click'); });
  };
});

$(document).on('turbolinks:before-visit', function(e) {
  if (window._isDirty && !confirm(window.I18n.t('js.forms.unsaved.quit'))) {
    e.preventDefault();
  } else {
    app.clearDirty();
  }
});

$(document).on('turbolinks:load', function(e) {
  $('div.protected form *').on('change', function() {
    app.markDirty();
  });

  $('div.protected form').on('submit', function() {
    app.clearDirty();
  });
});
