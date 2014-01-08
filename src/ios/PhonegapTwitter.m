#import "PhonegapTwitter.h"
#import "STTwitter.h"

@interface PhonegapTwitter ()
@property (nonatomic, retain) STTwitterAPI *twitterOS;
@property (nonatomic, retain) STTwitterAPI *twitterOAuth;
@end

@implementation PhonegapTwitter
- (void)pluginInitialize {
    [super pluginInitialize];
    self.twitterOS = [STTwitterAPI twitterAPIOSWithFirstAccount];
    NSString *consumerKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"TwitterConsumerKey"];
    NSString *consumerSecret = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"TwitterConsumerSecret"];
    
    self.twitterOAuth = [STTwitterAPI twitterAPIWithOAuthConsumerKey:consumerKey consumerSecret:consumerSecret];
}

- (void)postAccessTokenRequest:(CDVInvokedUrlCommand *)command {
    NSString *callbackId = command.callbackId;
    
    void (^errorBlock)(NSError *error) = ^(NSError *error) {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error.description];
        [self writeJavascript:[pluginResult toErrorCallbackString: callbackId]];
    };
    
    [self.twitterOS verifyCredentialsWithSuccessBlock:^(NSString *username) {
        [self.twitterOAuth postReverseOAuthTokenRequest:^(NSString *authenticationHeader) {
            [self.twitterOS postReverseAuthAccessTokenWithAuthenticationHeader:authenticationHeader
                                                                successBlock:^(NSString *oAuthToken, NSString *oAuthTokenSecret, NSString *userID, NSString *screenName) {
                                                                    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                                                                                  messageAsDictionary:@{
                                                                                                                                        @"oauth_token": oAuthToken,
                                                                                                                                        @"oauth_token_secret": oAuthTokenSecret,
                                                                                                                                        @"user_id": userID,
                                                                                                                                        @"screen_name": screenName
                                                                                                                                        }];
                                                                    [self writeJavascript:[pluginResult toSuccessCallbackString: callbackId]];
                                                                } errorBlock:errorBlock];
        } errorBlock:errorBlock];
    } errorBlock:errorBlock];
    
}

- (void)postStatusUpdate:(CDVInvokedUrlCommand *)command {
    NSString *callbackId = command.callbackId;
    
    void (^errorBlock)(NSError *error) = ^(NSError *error) {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error.description];
        [self writeJavascript:[pluginResult toErrorCallbackString: callbackId]];
    };
    
    if (command.arguments.count < 1) {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"argument count is zero"];
        [self writeJavascript:[pluginResult toErrorCallbackString: callbackId]];
        return;
    }
    
    NSString *status = command.arguments[0];
    
    [self.twitterOS verifyCredentialsWithSuccessBlock:^(NSString *username) {
        [self.twitterOS postStatusUpdate:status
                     inReplyToStatusID:nil
                              latitude:nil
                             longitude:nil
                               placeID:nil
                    displayCoordinates:nil
                              trimUser:nil
                          successBlock:^(NSDictionary *status) {
                              CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary: status];
                              [self writeJavascript:[pluginResult toSuccessCallbackString: callbackId]];
                          }
                            errorBlock:errorBlock];

    } errorBlock:errorBlock];
}


@end




