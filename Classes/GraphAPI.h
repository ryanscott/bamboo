#include "FacebookProxy.h"
#include "GraphObject.h"
#include "GraphDelegate.h"

@interface GraphAPI : NSObject 
{
	NSString* _accessToken;

	NSMutableArray* _connections;
	GraphDelegate* _asyncronousDelegate;
	
	NSData* _responseData;
	BOOL _isSynchronous;
}

@property (nonatomic, retain) NSString* _accessToken;
@property (nonatomic, retain) NSMutableArray* _connections;
@property (nonatomic, retain) GraphDelegate* _asyncronousDelegate;
@property (nonatomic, retain) NSData* _responseData;
@property (nonatomic, assign) BOOL _isSynchronous;

-(id)initWithAccessToken:(NSString*)access_token;

// pass YES for synchronous, NO for asynchronous.  YES (synchronous) is default
-(void)setSynchronousMode:(BOOL)isSynchronous;  

-(GraphObject*)getObject:(NSString*)obj_id;
-(GraphObject*)getObject:(NSString*)obj_id withArgs:(NSDictionary*)request_args;

-(UIImage*)getProfilePhotoForObject:(NSString*)obj_id;
-(UIImage*)getLargeProfilePhotoForObject:(NSString*)obj_id;

// returns an array of GraphObjects
-(NSArray*)getConnections:(NSString*)connection_name forObject:(NSString*)obj_id;

// this uses the introspection feature of the graph API, returns an array of possible connection types for this object
// (use with self.getConnections) 
//
// returns an array of NSStrings
-(NSArray*)getConnectionTypesForObject:(NSString*)obj_id;

// returns an array of GraphObjects
-(NSArray*)searchTerms:(NSString*)search_terms objectType:(NSString*)objType;

// This doesn't appear to be working right now
// returns an array of GraphObjects
-(NSArray*)searchNewsFeedForUser:(NSString*)user_id searchTerms:(NSString*)search_terms;

-(GraphObject*)putToObject:(NSString*)parent_obj_id connectionType:(NSString*)connection args:(NSDictionary*)request_args;
-(bool)deleteObject:(NSString*)obj_id;

// these 3 are just convenience methods that wrap putToObject, nothing special about them
-(GraphObject*)likeObject:(NSString*)obj_id;
-(GraphObject*)putCommentToObject:(NSString*)obj_id message:(NSString*)message;
-(GraphObject*)putWallPost:(NSString*)profile_id message:(NSString*)message attachment:(NSDictionary*)attachment_args;

@end

// Graph API Argument Keys
extern NSString* const kKeyArgumentMetadata;
extern NSString* const kKeyArgumentMessage;

// search method objectType parameter values
extern NSString* const kSearchPosts;
extern NSString* const kSearchUsers;
extern NSString* const kSearchPages;
extern NSString* const kSearchEvents;
extern NSString* const kSearchGroups;

// connection types
extern NSString* const kConnectionFriends;
extern NSString* const kConnectionNews;
extern NSString* const kConnectionWall;
extern NSString* const kConnectionFeed;
extern NSString* const kConnectionLikes;
extern NSString* const kConnectionMovies;
extern NSString* const kConnectionBooks;
extern NSString* const kConnectionNotes;
extern NSString* const kConnectionPhotos;
extern NSString* const kConnectionVideos;
extern NSString* const kConnectionEvents;
extern NSString* const kConnectionGroups;

extern NSString* const kConnectionComments;
extern NSString* const kConnectionLinks;
extern NSString* const kConnectionAttending;
extern NSString* const kConnectionMaybe;
extern NSString* const kConnectionDeclined;
extern NSString* const kConnectionAlbums;

