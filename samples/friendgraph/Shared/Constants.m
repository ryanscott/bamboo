#import "Constants.h"

// Facebook API

// these values are from Koala, a ruby version of this same API by Alex Koppel
// the temporary client ID & url values are from the oAuth Playground Alex setup for testing of apps in development
// http://github.com/arsduo/koala
// http://oauth.twoalex.com/

NSString* const kFBAPIKey = @"25e1cec0df2b3bfa781da3ed78da3a1e";
NSString* const kFBAppSecret = @"e45e55a333eec232d4206d2703de1307";

NSString* const kFBClientID = @"119908831367602";
NSString* const kFBRedirectURI = @"http://oauth.twoalex.com/";

NSString* const kFBAuthURLFormat = @"https://graph.facebook.com/oauth/authorize?client_id=%@&redirect_uri=%@";
NSString* const kFBAccessTokenURLFormat = @"https://graph.facebook.com/oauth/access_token?client_id=%@&redirect_uri=%@&client_secret=%@&code=%@";

// Sharing text
NSString* const kShareEmailSubject = @"Check out my awesome iPhone application";
NSString* const kShareText = @"This is a test, of my awesome iPhone application";
NSString* const kTwitterShareText = @"This is a tweet, from my awesome iPhone application";

// App Constants
//
//@implementation Globals
//
//@synthesize kScreenFrame;
//
//-(void)initialize
//{
//	kScreenFrame = CGRectMake( kApplicationFrame.origin.x, kApplicationFrame.origin.y + kTopBarHeight, kApplicationFrame.size.width, kApplicationFrame.size.height - kTopBarHeight - kGridMenuBarHeight );
//}
