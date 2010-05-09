#import "FBConnect/FBConnect.h"

@interface FacebookProxy : NSObject <NSCoding, FBSessionDelegate, FBDialogDelegate, FBRequestDelegate>
{
	FBSession* _session;
	FBUID _uid;

	NSString* _oAuthAccessToken;
	
	id _authTarget;
	SEL _authCallback;

	NSMutableData* _authResponse;
	NSMutableData* _accessTokenResponse;
	
	NSString* _codeString;
	
//	NSURLRequest* _authConnection;
//	NSURLRequest* _accessTokenConnection;
	NSURLConnection* _authConnection;
	NSURLConnection* _accessTokenConnection;
}

@property (nonatomic, retain) FBSession* _session;
@property (nonatomic, assign) FBUID _uid;

@property (nonatomic, retain) NSString* _oAuthAccessToken;

@property (nonatomic, assign) id _authTarget;
@property (nonatomic, assign) SEL _authCallback;

@property (nonatomic, retain) NSMutableData* _authResponse;
@property (nonatomic, retain) NSMutableData* _accessTokenResponse;
@property (nonatomic, retain) NSString* _codeString;

@property (nonatomic, retain) NSURLConnection* _authConnection;
@property (nonatomic, retain) NSURLConnection* _accessTokenConnection;


+(FacebookProxy*)instance;
+(void)loadDefaults;
//+(void)updateDefaults;

//-(void)postMessageToWall:(NSString*)message delegate:(id<FBDialogDelegate>)inDelegate;

-(void)loginAndAuthorizeWithTarget:(id)target callback:(SEL)authCallback;

@end

//graph = Koala::Facebook::GraphAPI.new(oauth_access_token)
//profile = graph.get_object("me")
//friends = graph.get_connections("me", "friends")
//graph.put_object("me", "feed", :message => "I am writing on my wall!")

