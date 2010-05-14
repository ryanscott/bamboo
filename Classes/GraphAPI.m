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

NSString* const kKeyAttachmentMessage = @"message";

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
NSString* const kConnectionLikes = @"likes";
NSString* const kConnectionMovies = @"movies";
NSString* const kConnectionBooks = @"books";
NSString* const kConnectionNotes = @"notes";
NSString* const kConnectionPhotos = @"photos";
NSString* const kConnectionVideos = @"videos";
NSString* const kConnectionEvents = @"events";
NSString* const kConnectionGroups = @"groups";

@interface GraphAPI (_PrivateMethods)

-(NSData*)api:(NSString*)obj_id args:(NSMutableDictionary*)request_args;
-(NSData*)api:(NSString*)obj_id args:(NSMutableDictionary*)request_args verb:(NSString*)verb;
-(NSData*)makeSynchronousRequest:(NSString*)path args:(NSMutableDictionary*)request_args verb:(NSString*)verb;

-(NSString*)encodeParams:(NSDictionary*)request_args;
-(NSData*)generatePostBody:(NSDictionary*)request_args;

@end

@implementation GraphAPI

@synthesize _accessToken;
@synthesize _connection;
@synthesize _responseData;

#pragma mark Initialization

-(id)initWithAccessToken:(NSString*)access_token
{
	if ( self = [super init] )
	{
		self._accessToken = access_token;
		self._connection = nil;
		self._responseData = nil;
	}
	return self;	
}

#pragma mark Public API

-(NSString*)getObject:(NSString*)obj_id;
{
	return [self getObject:obj_id withArgs:nil];
//	NSString* path = obj_id;
//
//	NSData* response = [self api:path args:nil];
//	NSString* r_string = [[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding] autorelease];
//	return r_string;
}

-(NSString*)getObject:(NSString*)obj_id withArgs:(NSDictionary*)request_args
{
	NSString* path = obj_id;
	NSMutableDictionary* mutableArgs = [NSMutableDictionary dictionaryWithDictionary:request_args];
	
	NSData* response = [self api:path args:mutableArgs];
	NSString* r_string = [[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding] autorelease];
	return r_string;
}

// example url:
// https://graph.facebook.com/ryan.stubblefield/picture

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
//	NSString* path = [NSString stringWithFormat:@"%@/picture", obj_id];
//
//	NSData* response = [self api:path args:nil];
//	UIImage* r_image = [[[UIImage alloc] initWithData:response] autorelease];
//	return r_image;
}

-(UIImage*)getLargeProfilePhotoForObject:(NSString*)obj_id
{
	NSDictionary* args = [NSDictionary dictionaryWithObject:@"large" forKey:@"type"];
	return [self getProfilePhotoForObject:obj_id withArgs:args];
}


-(NSString*)getConnections:(NSString*)connection_name forObject:(NSString*)obj_id
{
	NSString* path = [NSString stringWithFormat:@"%@/%@", obj_id, connection_name];

	NSData* response = [self api:path args:nil];
	NSString* r_string = [[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding] autorelease];
	return r_string;
}

-(NSArray*)getConnectionTypesForObject:(NSString*)obj_id
{
	NSMutableDictionary* args = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1", kKeyArgumentMetadata, nil];
	
	NSString* responseString = [self getObject:obj_id withArgs:args];
	
	NSDictionary* jsonDict = [responseString JSONValue];
	
	NSArray* connections = nil;
	
	if ( nil != jsonDict )
		connections = [[[jsonDict objectForKey:@"metadata"] objectForKey:@"connections"] allKeys];
	
	return connections;
}


-(NSString*)searchTerms:(NSString*)search_terms objectType:(NSString*)objType
{
	NSMutableDictionary* args = [NSMutableDictionary dictionaryWithObjectsAndKeys:search_terms, kKeySearchQuery,
																																				 objType, kKeySearchObjectType, nil];

	NSString* path = @"search";
	NSData* response = [self api:path args:args];
	NSString* r_string = [[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding] autorelease];
	return r_string;
}

// This doesn't appear to be working right now
-(NSString*)searchNewsFeedForUser:(NSString*)user_id searchTerms:(NSString*)search_terms
{
	NSMutableDictionary* args = [NSMutableDictionary dictionaryWithObjectsAndKeys:search_terms, kKeySearchQuery, nil];
	
	NSString* path = [NSString stringWithFormat:@"%@/home", user_id];
	NSData* response = [self api:path args:args];
	NSString* r_string = [[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding] autorelease];
	return r_string;	
}

-(bool)putToObject:(NSString*)parent_obj_id connectionType:(NSString*)connection args:(NSDictionary*)request_args
{
	NSMutableDictionary* mutableArgs = [NSMutableDictionary dictionaryWithDictionary:request_args];
	
	NSString* path = [NSString stringWithFormat:@"%@/%@", parent_obj_id, connection];
	NSData* responseData	= [self api:path args:mutableArgs verb:kRequestVerbPost];
	NSString* r_string = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
	NSLog( @"response NSString: %@", r_string );

	bool response = true;
	
	NSDictionary* jsonDict = [r_string JSONValue];

	if ( nil == jsonDict )
		response = false;
	
	NSLog( @"response JSON Dictionary: %@", jsonDict );

	return response;		
}

//# attachment adds a structured attachment to the status message being
//# posted to the Wall. It should be a dictionary of the form:
//# 
//#     {"name": "Link name"
//#      "link": "http://www.example.com/",
//#      "caption": "{*actor*} posted a new review",
//#      "description": "This is a longer description of the attachment",
//#      "picture": "http://www.example.com/thumbnail.jpg"}

-(bool)putWallPost:(NSString*)profile_id message:(NSString*)message attachment:(NSDictionary*)attachment_args
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
	[mutableArgs setObject:message forKey:kKeyAttachmentMessage];

	bool successResponse = [self putToObject:profile_id connectionType:kConnectionWall args:mutableArgs];
	
	return successResponse;
}

-(bool)deleteObject:(NSString*)obj_id
{
	NSString* path = obj_id;	
	NSData* responseData = [self api:path args:nil verb:kRequestVerbDelete];
	responseData;
//	NSString* r_string = [[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding] autorelease];

	// [ryan:5-13-10] todo - I'm not sure what to check for here, 
	// will have to test the responses to DELETE in koala maybe
	
	// this should return true/false, as per Alex.
	
	// ruby, wrap in array, take :0
	// or special case
	
	bool successResponse = true;
	
	return successResponse;
}

// stuff from Koala, left to do.  convenience posting methods
//
//def put_comment(object_id, message)
//# Writes the given comment on the given post.
//self.put_object(object_id, "comments", {:message => message})
//end
//
//def put_like(object_id)
//# Likes the given post.
//self.put_object(object_id, "likes")
//end



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
//		[request_args setObject:@"119908831367602|674667c45691cbca6a03d480-1394987957|dRiaWMp7ZoqrRy_jHDEutHC5AP0." forKey:kArgumentKeyAccessToken];
		
	}
								 
	// will probably want to generally use async calls, but building this with sync first is easiest
//	NSString* response = [self makeSynchronousRequest:obj_id args:request_args verb:kRequestVerbGet];
	NSData* response = [self makeSynchronousRequest:obj_id args:request_args verb:verb];
	
	// todo
	// 1. parse JSON response (and handle true/false responses)
	// 2. check for errors
	
	return response;
}

-(NSData*)makeSynchronousRequest:(NSString*)path args:(NSMutableDictionary*)request_args verb:(NSString*)verb
{
	//# if the verb isn't get or post, send it as a post argument
	if ( kRequestVerbGet != verb && kRequestVerbPost != verb )
	{
		[request_args setObject:verb forKey:kArgumentKeyMethod];
		verb = kRequestVerbPost;
	}

//	NSString* responseString = nil;
	self._responseData = nil;
	NSString* urlString;
	NSMutableURLRequest* r_url;
	
	// handle get first, add post support next
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
//		urlString = [NSString stringWithFormat:@"%@", @"http://www.allforyoga.com"];
		
		r_url = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
														 cachePolicy:NSURLRequestUseProtocolCachePolicy
												 timeoutInterval:60.0];
		
		NSData* postBody = [self generatePostBody:request_args];
		NSString* contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", kPostStringBoundary];

		[r_url setHTTPMethod:kRequestVerbPost];
		[r_url setValue:contentType forHTTPHeaderField:@"Content-Type"];
		[r_url setHTTPBody:postBody];			
//		[r_url setHTTPBody:[@"message=bambootesting" dataUsingEncoding:NSISOLatin1StringEncoding]];
	}
	
	NSURLResponse* response;
	NSError* error;
	
	NSLog( @"fetching url:\n%@", urlString );
	
	NSLog( @"request headers: %@", [r_url allHTTPHeaderFields] );

	// synchronous call
	self._responseData = [NSURLConnection sendSynchronousRequest:r_url returningResponse:&response error:&error];
	// async
	//		self._connection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	
//	if ( [verb isEqualToString:kRequestVerbPost] )
	{
		NSLog( @"Post response:" );
		NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;

		NSLog( @"status: %d, %@", [httpResponse statusCode], [NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]] );	
		NSLog( @"response headers: %@", [httpResponse allHeaderFields] );
		NSLog( @"response: %@", self._responseData );
	}
	
	if ( nil == self._responseData )
	{
		NSLog(@"Connection failed!\n URL = %@\n Error - %@ %@",
					urlString,
					[error localizedDescription],						
					[[error userInfo] objectForKey:@"NSUnderlyingError"]);
//			[[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
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
	
  NSLog(@"post body sending\n%s", [body bytes]);
  return body;
}



@end
