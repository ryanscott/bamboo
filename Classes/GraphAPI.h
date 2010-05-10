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

-(NSString*)getConnections:(NSString*)connection_name forObject:(NSString*)obj_id;

-(NSString*)searchTerms:(NSString*)search_terms objectType:(NSString*)objType;

// This doesn't appear to be working right now
-(NSString*)searchNewsFeedForUser:(NSString*)user_id searchTerms:(NSString*)search_terms;

@end


// search method objectType parameter values
extern NSString* const kSearchPosts;
extern NSString* const kSearchUsers;
extern NSString* const kSearchPages;
extern NSString* const kSearchEvents;
extern NSString* const kSearchGroups;

