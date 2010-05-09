#import "GraphAPI.h"

@implementation GraphAPI

@synthesize _accessToken;

-(id)initWithAccessToken:(NSString*)access_token
{
	if ( self = [super init] )
	{
		self._accessToken = access_token;
	}
	return self;	
}

@end
