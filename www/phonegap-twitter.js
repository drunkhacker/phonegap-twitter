function Twitter() {
}

Twitter.prototype.getAccessToken =
  function(successCallback, errorCallback) {
    cordova.exec(successCallback, errorCallback, "PhonegapTwitter", "postAccessTokenRequest", []);
  };

Twitter.prototype.updateStatus = 
  function(successCallback, errorCallback, message) { 
    cordova.exec(successCallback, errorCallback, "PhonegapTwitter", "postStatusUpdate", [message]);
  };


Twitter.install = function() {
  if (!window.plugins) {
    window.plugins = {};
  }

  window.plugins.twitter = new Twitter();
  return window.plugins.twitter;
};

cordova.addConstructor(Twitter.install);
