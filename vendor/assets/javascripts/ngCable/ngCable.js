'use strict';

angular.module('ngCable', [])
.factory('$cable', ['$channel', '$rootScope', function($channel, $rootScope) {

  function AngularCable(url) {
    if (!(this instanceof AngularCable)) {
      return new AngularCable(url);
    }
    this.client = ActionCable.createConsumer(url);
    this.connection = this.client.connection;
    this.channels = {};
  };

  AngularCable.prototype = {
    subscribe: function (channelName, callback) {
      var mixin = typeof callback === 'function' ? {received: callback} : callback;
      var newMixin = {};
      Object.keys(mixin).forEach(function(key) {
        if (typeof mixin[key] === 'function') {
          newMixin[key] = function() {
            mixin[key].apply(this, arguments);
            $rootScope.$applyAsync();
          }
        }
      });

      var channel = this.client.subscriptions.create(channelName, newMixin);
      channel = $channel(channel, this);
      this.channels[channel.name] = channel;
      return channel;
    },
    unsubscribe: function (channelName) {
      var channel = this.channels[channelName];
      if (channel) {
        var removed = this.client.subscriptions.remove(channel.baseChannel);
        if (removed){
          removed.unsubscribe();
          delete this.channels[channelName];
        }
        return removed;
      }
      return false;
    }
  };
  return AngularCable;
}])

.factory('$channel', function () {
  function $channel(baseChannel, cable) {
    if (!(this instanceof $channel)) {
      return new $channel(baseChannel, cable);
    }

    this.baseChannel = baseChannel;
    this.client = cable;
    this.name = baseChannel.name;
  }

  $channel.prototype = {
    send: function (data) {
      return this.baseChannel.send(data);
    },
    unsubscribe: function () {
      return this.client.client.subscriptions.remove(this.baseChannel);
    },
    perform: function() {
      return this.baseChannel.perform.apply(this, arguments);
    }
  };

  return $channel;
});
