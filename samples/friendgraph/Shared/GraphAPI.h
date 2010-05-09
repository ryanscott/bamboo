@interface GraphAPI : NSObject 
{
	NSString* _accessToken;

	NSURLConnection* _connection;
	NSMutableData* _responseData;
}

@property (nonatomic, retain) NSString* _accessToken;
@property (nonatomic, retain) NSURLConnection* _connection;
@property (nonatomic, retain) NSMutableData* _responseData;

-(id)initWithAccessToken:(NSString*)access_token;

-(NSString*)getObject:(NSString*)obj_id;

@end
