#import <Cordova/CDV.h>
#import <Cordova/CDVPlugin.h>

@interface PhonegapTwitter : CDVPlugin

- (void)postAccessTokenRequest:(CDVInvokedUrlCommand *)command;
- (void)postStatusUpdate:(CDVInvokedUrlCommand *)command;
@end

