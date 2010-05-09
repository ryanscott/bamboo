@interface GraphAPI : NSObject 
{
	NSString* _accessToken;
}

@property (nonatomic, retain) NSString* _accessToken;

-(id)initWithAccessToken:(NSString*)access_token;

@end
