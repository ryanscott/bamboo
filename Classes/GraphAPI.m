#import "GraphAPI.h"
#import "JSON.h"

NSString* const kGraphAPIServer = @"http://graph.facebook.com/";

// Graph API Argument Keys
NSString* const kAPIKeyAccessToken = @"access_token";

// other dictionary keys
NSString* const kKeySearchQuery = @"q";
NSString* const kKeySearchObjectType = @"type";

// other things...
NSString* const kRequestVerbGet = @"get";
NSString* const kRequestVerbPost = @"post";

NSString* const kPostStringBoundary = @"3i2ndDfv2rTHiSisAbouNdArYfORhtTPEefj3q2f";

#pragma mark Public Constants

// search method objectType parameter values
NSString* const kSearchPosts = @"post";
NSString* const kSearchUsers = @"user";
NSString* const kSearchPages = @"page";
NSString* const kSearchEvents = @"event";
NSString* const kSearchGroups = @"group";


@interface GraphAPI (_PrivateMethods)

-(NSData*)api:(NSString*)obj_id args:(NSMutableDictionary*)request_args;
-(NSData*)api:(NSString*)obj_id args:(NSMutableDictionary*)request_args verb:(NSString*)verb;
-(NSData*)makeSynchronousRequest:(NSString*)path args:(NSDictionary*)request_args verb:(NSString*)verb;

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
	NSString* path = obj_id;

	NSData* response = [self api:path args:nil];
	NSString* r_string = [[[NSString alloc] initWithData:response encoding:NSASCIIStringEncoding] autorelease];
	return r_string;
}

// example url:
// http://graph.facebook.com/ryan.stubblefield/picture

-(UIImage*)getProfilePhotoForObject:(NSString*)obj_id
{
	NSString* path = [NSString stringWithFormat:@"%@/picture", obj_id];

	NSData* response = [self api:path args:nil];
	UIImage* r_image = [[[UIImage alloc] initWithData:response] autorelease];
	return r_image;
}

-(NSString*)getConnections:(NSString*)connection_name forObject:(NSString*)obj_id
{
	NSString* path = [NSString stringWithFormat:@"%@/%@", obj_id, connection_name];

	NSData* response = [self api:path args:nil];
	NSString* r_string = [[[NSString alloc] initWithData:response encoding:NSASCIIStringEncoding] autorelease];
	return r_string;
}

-(NSString*)searchTerms:(NSString*)search_terms objectType:(NSString*)objType
{
	NSMutableDictionary* args = [NSMutableDictionary dictionaryWithObjectsAndKeys:search_terms, kKeySearchQuery,
																																				 objType, kKeySearchObjectType, nil];

	NSString* path = @"search";
	NSData* response = [self api:path args:args];
	NSString* r_string = [[[NSString alloc] initWithData:response encoding:NSASCIIStringEncoding] autorelease];
	return r_string;
}

// This doesn't appear to be working right now
-(NSString*)searchNewsFeedForUser:(NSString*)user_id searchTerms:(NSString*)search_terms
{
	NSMutableDictionary* args = [NSMutableDictionary dictionaryWithObjectsAndKeys:search_terms, kKeySearchQuery, nil];
	
	NSString* path = [NSString stringWithFormat:@"%@/home", user_id];
	NSData* response = [self api:path args:args];
	NSString* r_string = [[[NSString alloc] initWithData:response encoding:NSASCIIStringEncoding] autorelease];
	return r_string;	
}

-(bool)putToObject:(NSString*)parent_obj_id connectionType:(NSString*)connection args:(NSDictionary*)request_args
{
	// [ryan:5-10-10] this will not work until we implement extended permissions
	NSMutableDictionary* mutableArgs = [NSMutableDictionary dictionaryWithDictionary:request_args];
	
	NSString* path = [NSString stringWithFormat:@"%@/%@", parent_obj_id, connection];
	NSData* responseData	= [self api:path args:mutableArgs verb:kRequestVerbPost];
	NSString* r_string = [[[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding] autorelease];
	bool response = true;
	r_string = nil;
	
	NSDictionary* jsonDict = [r_string JSONValue];

	NSLog( @"response NSString: %@", r_string );
	NSLog( @"response JSON Dictionary: %@", jsonDict );

	return response;		
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
		if ( nil != request_args )
		{
			[request_args setObject:self._accessToken forKey:kAPIKeyAccessToken];
		}
		else
		{
			request_args = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self._accessToken, 
																																				 kAPIKeyAccessToken, nil];
		}
	}

	// will probably want to generally use async calls, but building this with sync first is easiest
//	NSString* response = [self makeSynchronousRequest:obj_id args:request_args verb:kRequestVerbGet];
	NSData* response = [self makeSynchronousRequest:obj_id args:request_args verb:verb];
	
	// todo
	// 1. parse JSON response (and handle true/false responses)
	// 2. check for errors
	
	return response;
}

-(NSData*)makeSynchronousRequest:(NSString*)path args:(NSDictionary*)request_args verb:(NSString*)verb
{
	// todo - this
	//# if the verb isn't get or post, send it as a post argument
	//args.merge!({:method => verb}) && verb = "post" if verb != "get" && verb != "post"
	
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
	// synchronous call
	self._responseData = [NSURLConnection sendSynchronousRequest:r_url returningResponse:&response error:&error];
	// async
	//		self._connection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	
	if ( [verb isEqualToString:kRequestVerbPost] )
	{
		NSLog( @"Post response:" );
		NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;

		NSLog( @"status: %d, %@", [httpResponse statusCode], [NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]] );	
		NSLog( @"headers: %@", [httpResponse allHeaderFields] );
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
