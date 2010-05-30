#import "GraphAPI.h"
#import "JSON.h"

NSString* const kGraphAPIServer = @"https://graph.facebook.com/";

// Graph API Argument Keys
NSString* const kArgumentKeyAccessToken = @"access_token";
NSString* const kArgumentKeyMethod = @"method";

// other dictionary keys
NSString* const kKeySearchQuery = @"q";
NSString* const kKeySearchObjectType = @"type";

// other things...
NSString* const kRequestVerbGet = @"GET";
NSString* const kRequestVerbPost = @"POST";
NSString* const kRequestVerbDelete = @"DELETE";

NSString* const kPostStringBoundary = @"3i2ndDfv2rTHiSisAbouNdArYfORhtTPEefj3q2f";

#pragma mark Public Constants

// Graph API Argument Keys
NSString* const kKeyArgumentMetadata = @"metadata";
NSString* const kKeyArgumentMessage = @"message";

// search method objectType parameter values
NSString* const kSearchPosts = @"post";
NSString* const kSearchUsers = @"user";
NSString* const kSearchPages = @"page";
NSString* const kSearchEvents = @"event";
NSString* const kSearchGroups = @"group";

// connection types
NSString* const kConnectionFriends = @"friends";
NSString* const kConnectionNews = @"home";
NSString* const kConnectionWall = @"feed";
NSString* const kConnectionFeed = @"feed";
NSString* const kConnectionLikes = @"likes";
NSString* const kConnectionMovies = @"movies";
NSString* const kConnectionBooks = @"books";
NSString* const kConnectionNotes = @"notes";
NSString* const kConnectionPhotos = @"photos";
NSString* const kConnectionVideos = @"videos";
NSString* const kConnectionEvents = @"events";
NSString* const kConnectionGroups = @"groups";

// more connection types, these ones are used for publishing to facebook (among other things)
// http://developers.facebook.com/docs/api#publishing

NSString* const kConnectionComments = @"comments";
NSString* const kConnectionLinks = @"links";
NSString* const kConnectionAttending = @"attending";
NSString* const kConnectionMaybe = @"maybe";
NSString* const kConnectionDeclined = @"declined";
NSString* const kConnectionAlbums = @"albums";

@interface GraphAPI (_PrivateMethods)

-(NSData*)api:(NSString*)obj_id args:(NSMutableDictionary*)request_args;
-(NSData*)api:(NSString*)obj_id args:(NSMutableDictionary*)request_args verb:(NSString*)verb;
-(NSData*)makeSynchronousRequest:(NSString*)path args:(NSMutableDictionary*)request_args verb:(NSString*)verb;
-(NSData*)makeAsynchronousRequest:(NSString*)path args:(NSMutableDictionary*)request_args verb:(NSString*)verb;

-(NSString*)encodeParams:(NSDictionary*)request_args;
-(NSData*)generatePostBody:(NSDictionary*)request_args;
-(NSArray*)graphObjectArrayFromJSON:(NSString*)jsonString;

@end

@implementation GraphAPI

@synthesize _accessToken;
@synthesize _connections;
@synthesize _asyncronousDelegate;
@synthesize _responseData;
@synthesize _isSynchronous;

#pragma mark Initialization

-(id)initWithAccessToken:(NSString*)access_token
{
	if ( self = [super init] )
	{
		self._accessToken = access_token;
		self._connections = nil;
		self._asyncronousDelegate = nil;
		self._responseData = nil;
		self._isSynchronous = YES;
	}
	return self;	
}

-(void)setSynchronousMode:(BOOL)isSynchronous
{
	if ( self._isSynchronous != isSynchronous )
	{
		// something else will probably happen here too
		self._isSynchronous = isSynchronous;
	}
}

-(void)dealloc
{
	[_accessToken release];
	[_connections release];
	[_asyncronousDelegate release];
	[_responseData release];
	[super dealloc];	
}

#pragma mark Public API

-(GraphObject*)getObject:(NSString*)obj_id;
{
	return [self getObject:obj_id withArgs:nil];
}

-(GraphObject*)getObject:(NSString*)obj_id withArgs:(NSDictionary*)request_args
{
	NSString* path = obj_id;
	NSMutableDictionary* mutableArgs = [NSMutableDictionary dictionaryWithDictionary:request_args];
	
	NSData* response = [self api:path args:mutableArgs];
	NSString* r_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
	GraphObject* r_obj = [[[GraphObject alloc] initWithString:r_string] autorelease];
	[r_string release];
	return r_obj;
}

-(UIImage*)getProfilePhotoForObject:(NSString*)obj_id withArgs:(NSDictionary*)request_args
{
	NSMutableDictionary* mutableArgs = [NSMutableDictionary dictionaryWithDictionary:request_args];
	NSString* path = [NSString stringWithFormat:@"%@/picture", obj_id];
	
	NSData* response = [self api:path args:mutableArgs];
	UIImage* r_image = [[[UIImage alloc] initWithData:response] autorelease];
	return r_image;	
}

-(UIImage*)getProfilePhotoForObject:(NSString*)obj_id
{
	return [self getProfilePhotoForObject:obj_id withArgs:nil];
}

-(UIImage*)getLargeProfilePhotoForObject:(NSString*)obj_id
{
	NSDictionary* args = [NSDictionary dictionaryWithObject:@"large" forKey:@"type"];
	return [self getProfilePhotoForObject:obj_id withArgs:args];
}

-(NSArray*)getConnections:(NSString*)connection_name forObject:(NSString*)obj_id
{
	NSString* path = [NSString stringWithFormat:@"%@/%@", obj_id, connection_name];

	NSData* response = [self api:path args:nil];
	NSString* r_string =[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
	
	NSArray* connections = [self graphObjectArrayFromJSON:r_string];
	[r_string release];
	return connections;
}

-(NSArray*)getConnectionTypesForObject:(NSString*)obj_id
{
	NSMutableDictionary* args = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1", kKeyArgumentMetadata, nil];
	
	GraphObject* responseObj = [self getObject:obj_id withArgs:args];
	
	NSArray* connections = nil;
	
	@try
	{
		if ( nil != responseObj && nil != responseObj._properties )
			connections = [[[responseObj._properties objectForKey:kKeyArgumentMetadata] objectForKey:@"connections"] allKeys];
	}
	@catch (id exception) 
	{
	}
	
	return connections;
}

-(NSArray*)searchTerms:(NSString*)search_terms objectType:(NSString*)objType
{
	NSMutableDictionary* args = [NSMutableDictionary dictionaryWithObjectsAndKeys:search_terms, kKeySearchQuery,
																																				 objType, kKeySearchObjectType, nil];

	NSString* path = @"search";
	NSData* response = [self api:path args:args];
	NSString* r_string =[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
	
	NSArray* connections = [self graphObjectArrayFromJSON:r_string];
	[r_string release];
	return connections;
}

// This doesn't appear to be working right now
-(NSArray*)searchNewsFeedForUser:(NSString*)user_id searchTerms:(NSString*)search_terms
{
	NSMutableDictionary* args = [NSMutableDictionary dictionaryWithObjectsAndKeys:search_terms, kKeySearchQuery, nil];
	
	NSString* path = [NSString stringWithFormat:@"%@/home", user_id];
	NSData* response = [self api:path args:args];
	NSString* r_string =[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
	
	NSArray* connections = [self graphObjectArrayFromJSON:r_string];
	[r_string release];
	return connections;
}

-(GraphObject*)putToObject:(NSString*)parent_obj_id connectionType:(NSString*)connection args:(NSDictionary*)request_args
{
	NSMutableDictionary* mutableArgs = [NSMutableDictionary dictionaryWithDictionary:request_args];
	
	NSString* path = [NSString stringWithFormat:@"%@/%@", parent_obj_id, connection];
	NSData* responseData	= [self api:path args:mutableArgs verb:kRequestVerbPost];
	NSString* r_string = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	GraphObject* r_obj = [[[GraphObject alloc] initWithString:r_string] autorelease];
	[r_string release];
	return r_obj;
}

//# attachment adds a structured attachment to the status message being
//# posted to the Wall. It should be a dictionary of the form:
//# 
//#     {"name": "Link name"
//#      "link": "http://www.example.com/",
//#      "caption": "{*actor*} posted a new review",
//#      "description": "This is a longer description of the attachment",
//#      "picture": "http://www.example.com/thumbnail.jpg"}

-(GraphObject*)putWallPost:(NSString*)profile_id message:(NSString*)message attachment:(NSDictionary*)attachment_args
{
	NSMutableDictionary* mutableArgs = nil;

	if ( nil != attachment_args )
	{
		mutableArgs = [NSMutableDictionary dictionaryWithDictionary:attachment_args];
	}
	else
	{
		mutableArgs = [NSMutableDictionary dictionaryWithCapacity:2];
	}
	[mutableArgs setObject:message forKey:kKeyArgumentMessage];

	return [self putToObject:profile_id connectionType:kConnectionWall args:mutableArgs];
}

-(GraphObject*)likeObject:(NSString*)obj_id
{
	return [self putToObject:obj_id connectionType:kConnectionLikes args:nil];
}

-(GraphObject*)putCommentToObject:(NSString*)obj_id message:(NSString*)message
{
	NSMutableDictionary* args = [NSMutableDictionary dictionaryWithObjectsAndKeys:message, kKeyArgumentMessage, nil];
	return [self putToObject:obj_id connectionType:kConnectionComments args:args];
}

-(bool)deleteObject:(NSString*)obj_id
{
	NSString* path = obj_id;	
	NSData* responseData = [self api:path args:nil verb:kRequestVerbDelete];
	NSString* r_string = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
	
	// for this api, and I think only this api, facebook does not return proper JSON, just true/false
	bool successResponse = [r_string boolValue];
	
	return successResponse;
}

#pragma mark Private Implementation Methods

-(NSData*)api:(NSString*)obj_id args:(NSMutableDictionary*)request_args
{
	return [self api:obj_id args:request_args verb:kRequestVerbGet];
}

-(NSData*)api:(NSString*)obj_id args:(NSMutableDictionary*)request_args verb:(NSString*)verb
{
	if ( nil != self._accessToken )
	{
		if ( nil == request_args )
		{
			request_args = [NSMutableDictionary dictionaryWithCapacity:1];
		}
		[request_args setObject:self._accessToken forKey:kArgumentKeyAccessToken];
	}
								 
	NSData* response = nil;

	// will probably want to generally use async calls, but building this with sync first is easiest
	if (self._isSynchronous)
		response = [self makeSynchronousRequest:obj_id args:request_args verb:verb];
	else
		response = [self makeAsynchronousRequest:obj_id args:request_args verb:verb];
	
	return response;
}

-(NSData*)makeAsynchronousRequest:(NSString*)path args:(NSMutableDictionary*)request_args verb:(NSString*)verb
{
	// if the verb isn't get or post, send it as a post argument
	if ( kRequestVerbGet != verb && kRequestVerbPost != verb )
	{
		[request_args setObject:verb forKey:kArgumentKeyMethod];
		verb = kRequestVerbPost;
	}
	
	//	NSString* responseString = nil;
	self._responseData = nil;
	NSString* urlString;
	NSMutableURLRequest* r_url;
	
	if ( [verb isEqualToString:kRequestVerbGet] )
	{
		NSString* argString = [self encodeParams:request_args];
		
		urlString = [NSString stringWithFormat:@"%@%@?%@", kGraphAPIServer, path, argString];
		
		r_url = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]
														 cachePolicy:NSURLRequestUseProtocolCachePolicy
												 timeoutInterval:60.0];
	}
	else
	{
		urlString = [NSString stringWithFormat:@"%@%@", kGraphAPIServer, path];
		
		r_url = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
																		cachePolicy:NSURLRequestUseProtocolCachePolicy
																timeoutInterval:60.0];
		
		NSData* postBody = [self generatePostBody:request_args];
		NSString* contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", kPostStringBoundary];
		
		[r_url setHTTPMethod:kRequestVerbPost];
		[r_url setValue:contentType forHTTPHeaderField:@"Content-Type"];
		[r_url setHTTPBody:postBody];			
	}
	
	//	NSLog( @"fetching url:\n%@", urlString );	
	//	NSLog( @"request headers: %@", [r_url allHTTPHeaderFields] );
	
//	NSURLResponse* response;
	NSError* error;
	
	if ( nil == self._asyncronousDelegate )
		self._asyncronousDelegate = [[GraphDelegate alloc] init];
	
	// async call
	NSURLConnection* newConnection = [[NSURLConnection alloc] initWithRequest:r_url delegate:self._asyncronousDelegate];
	
	if ( nil != newConnection )
	{
		[self._connections addObject:newConnection];
	}
	else
	{
		NSLog(@"Connection failed!\n URL = %@\n Error - %@ %@",
					urlString,
					[error localizedDescription],						
					[[error userInfo] objectForKey:@"NSUnderlyingError"]);
	}
	
	return nil;
}

-(NSData*)makeSynchronousRequest:(NSString*)path args:(NSMutableDictionary*)request_args verb:(NSString*)verb
{
	// if the verb isn't get or post, send it as a post argument
	if ( kRequestVerbGet != verb && kRequestVerbPost != verb )
	{
		[request_args setObject:verb forKey:kArgumentKeyMethod];
		verb = kRequestVerbPost;
	}

//	NSString* responseString = nil;
	self._responseData = nil;
	NSString* urlString;
	NSMutableURLRequest* r_url;
	
	if ( [verb isEqualToString:kRequestVerbGet] )
	{
		NSString* argString = [self encodeParams:request_args];
		
		urlString = [NSString stringWithFormat:@"%@%@?%@", kGraphAPIServer, path, argString];
	
		r_url = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]
														 cachePolicy:NSURLRequestUseProtocolCachePolicy
												 timeoutInterval:60.0];
	}
	else
	{
		urlString = [NSString stringWithFormat:@"%@%@", kGraphAPIServer, path];
		
		r_url = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
														 cachePolicy:NSURLRequestUseProtocolCachePolicy
												 timeoutInterval:60.0];
		
		NSData* postBody = [self generatePostBody:request_args];
		NSString* contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", kPostStringBoundary];

		[r_url setHTTPMethod:kRequestVerbPost];
		[r_url setValue:contentType forHTTPHeaderField:@"Content-Type"];
		[r_url setHTTPBody:postBody];			
	}
	
	//	NSLog( @"fetching url:\n%@", urlString );	
	//	NSLog( @"request headers: %@", [r_url allHTTPHeaderFields] );
	
	NSURLResponse* response;
	NSError* error;
	
	// synchronous call
	self._responseData = [NSURLConnection sendSynchronousRequest:r_url returningResponse:&response error:&error];

	// async
	// self._connection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
		
//	if ( [verb isEqualToString:kRequestVerbPost] )
//	{
//		NSLog( @"Post response:" );
//		NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
//
//		NSLog( @"status: %d, %@", [httpResponse statusCode], [NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]] );	
//		NSLog( @"response headers: %@", [httpResponse allHeaderFields] );
//		NSLog( @"response: %@", self._responseData );
//	}
	
	
	if ( nil == self._responseData )
	{
		NSLog(@"Connection failed!\n URL = %@\n Error - %@ %@",
					urlString,
					[error localizedDescription],						
					[[error userInfo] objectForKey:@"NSUnderlyingError"]);
	}

	return self._responseData;
}

-(NSString*)encodeParams:(NSDictionary*)request_args
{
	NSMutableString* argString = [NSMutableString stringWithString:@""];
	NSUInteger arg_count = [request_args count];
	uint i = 0;
	
	for ( NSString* i_key in request_args ) 
	{
		i++;
		[argString appendFormat:@"%@=%@", i_key, [request_args objectForKey:i_key]];
		if ( i < arg_count )
			[argString appendString:@"&"];
	}
	return [argString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
}

-(NSData*)generatePostBody:(NSDictionary*)request_args
{
  NSMutableData *body = [NSMutableData data];
  NSString *beginLine = [NSString stringWithFormat:@"\r\n--%@\r\n", kPostStringBoundary];
	
  [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kPostStringBoundary]
										dataUsingEncoding:NSUTF8StringEncoding]];
  
  for (id key in [request_args keyEnumerator])
	{
    NSString* value = [request_args valueForKey:key];
    if (![value isKindOfClass:[UIImage class]]) 
		{
      [body appendData:[beginLine dataUsingEncoding:NSUTF8StringEncoding]];        
      [body appendData:[[NSString
												 stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key]
												dataUsingEncoding:NSUTF8StringEncoding]];
      [body appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
    }
  }
	
  for (id key in [request_args keyEnumerator]) 
	{
    if ([[request_args objectForKey:key] isKindOfClass:[UIImage class]]) 
		{
      UIImage* image = [request_args objectForKey:key];
      CGFloat quality =  0.75;
      NSData* data = UIImageJPEGRepresentation(image, quality);
      
      [body appendData:[beginLine dataUsingEncoding:NSUTF8StringEncoding]];
      [body appendData:[[NSString stringWithFormat:
												 @"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n",
												 key]
												dataUsingEncoding:NSUTF8StringEncoding]];
      [body appendData:[[NSString
												 stringWithFormat:@"Content-Length: %d\r\n", data.length]
												dataUsingEncoding:NSUTF8StringEncoding]];  
      [body appendData:[[NSString
												 stringWithString:@"Content-Type: image/jpeg\r\n\r\n"]
												dataUsingEncoding:NSUTF8StringEncoding]];  
      [body appendData:data];
    }
  }
  	
  [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", kPostStringBoundary]
										dataUsingEncoding:NSUTF8StringEncoding]];
	
//  NSLog(@"post body sending\n%s", [body bytes]);
  return body;
}

-(NSArray*)graphObjectArrayFromJSON:(NSString*)jsonString
{
	GraphObject* r_obj = [[GraphObject alloc] initWithString:jsonString];
	NSMutableArray* connections = nil;
	
	@try
	{
		if ( nil != r_obj && nil != r_obj._properties )
		{
			// this should be an array of dictionaries, we turn it into an array of GraphObjects
			NSArray* jsonConnections = [r_obj._properties objectForKey:@"data"];
			connections = [NSMutableArray arrayWithCapacity:[jsonConnections count]];
			for ( NSDictionary* i_like in jsonConnections )
			{
				GraphObject* i_obj = [[GraphObject alloc] initWithDict:i_like];
				[connections addObject:i_obj];
				[i_obj release];				
			}
		}
	}
	@catch (id exception) 
	{
	}
	
	[r_obj release];
	return connections;	
}

@end
