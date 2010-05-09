@interface GraphAPI : NSObject 
{
	NSString* _accessToken;

	NSURLConnection* _connection;
	NSData* _responseData;
}

@property (nonatomic, retain) NSString* _accessToken;
@property (nonatomic, retain) NSURLConnection* _connection;
@property (nonatomic, retain) NSData* _responseData;

-(id)initWithAccessToken:(NSString*)access_token;

-(NSString*)getObject:(NSString*)obj_id;
-(UIImage*)getProfilePhotoForObject:(NSString*)obj_id;

@end
