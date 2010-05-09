#import "GraphAPI.h"

NSString* const kGraphAPIServer = @"http://graph.facebook.com/";

// Graph API Argument Keys
NSString* const kAPIKeyAccessToken = @"access_token";

NSString* const kRequestVerbGet = @"get";

@interface GraphAPI (_PrivateMethods)

-(NSString*)api:(NSString*)obj_id args:(NSMutableDictionary*)request_args;
-(NSString*)makeSynchronousRequest:(NSString*)path args:(NSDictionary*)request_args verb:(NSString*)verb;

-(NSString*)encodeParams:(NSDictionary*)request_args;

@end

@implementation GraphAPI

@synthesize _accessToken;
@synthesize _connection;
@synthesize _responseData;

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

-(NSString*)getObject:(NSString*)obj_id;
{
	return [self api:obj_id args:nil];
}

-(NSString*)api:(NSString*)obj_id args:(NSMutableDictionary*)request_args
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
	NSString* response = [self makeSynchronousRequest:obj_id args:request_args verb:kRequestVerbGet];
	
	// todo
	// 1. parse JSON response (and handle true/false responses)
	// 2. check for errors
	
	return response;
}

-(NSString*)makeSynchronousRequest:(NSString*)path args:(NSDictionary*)request_args verb:(NSString*)verb
{
	// todo - this
	//# if the verb isn't get or post, send it as a post argument
	//args.merge!({:method => verb}) && verb = "post" if verb != "get" && verb != "post"
	
	NSString* responseString = nil;
	
	// handle get first, add post support next
	if ( [verb isEqualToString:kRequestVerbGet] )
	{
		NSString* argString = [self encodeParams:request_args];
		
		NSString* urlString = [NSString stringWithFormat:@"%@%@?%@", kGraphAPIServer, path, argString];
		
		NSURLRequest* r_url = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]
																								cachePolicy:NSURLRequestUseProtocolCachePolicy
																						timeoutInterval:60.0];
		// create the connection with the request
		// and start loading the data
//		self._connection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];

		NSURLResponse* response;
		NSError* error;
		
		// synchronous call
		NSData* responseData = [NSURLConnection sendSynchronousRequest:r_url returningResponse:&response error:&error];
		
		if ( nil != responseData )
		{
			responseString = [[[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding] autorelease];
		} 
		else 
		{
			RCLog(@"Connection failed!\n URL = %@\n Error - %@ %@",
						urlString,
						[error localizedDescription],						
						[[error userInfo] objectForKey:@"NSUnderlyingError"]);
//			[[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
		}
	}
	return responseString;
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


//def self.make_request(path, args, verb)
//# We translate args to a valid query string. If post is specified,
//# we send a POST request to the given path with the given arguments.
//
//# if the verb isn't get or post, send it as a post argument
//args.merge!({:method => verb}) && verb = "post" if verb != "get" && verb != "post"
//
//http = Net::HTTP.new(Facebook::GRAPH_SERVER, 443)
//http.use_ssl = true
//# we turn off certificate validation to avoid the 
//# "warning: peer certificate won't be verified in this SSL session" warning
//# not sure if this is the right way to handle it
//# see http://redcorundum.blogspot.com/2008/03/ssl-certificates-and-nethttps.html
//http.verify_mode = OpenSSL::SSL::VERIFY_NONE
//
//result = http.start { |http|
//response, body = (verb == "post" ? http.post(path, encode_params(args)) : http.get("#{path}?#{encode_params(args)}")) 
//body
//}
//end

//def self.encode_params(param_hash)
//# TODO investigating whether a built-in method handles this
//# if no hash (e.g. no auth token) return empty string
//((param_hash || {}).collect do |key_and_value| 
// key_and_value[1] = key_and_value[1].to_json if key_and_value[1].class != String
// "#{key_and_value[0].to_s}=#{CGI.escape key_and_value[1]}"
// end).join("&")
//end



//def get_object(id, args = {})
//# Fetchs the given object from the graph.
//api(id, args)
//end

//def api(path, args = {}, verb = "get")
//# Fetches the given path in the Graph API.
//args["access_token"] = @access_token if @access_token
//
//# make the request via the provided service
//result = Koala.make_request(path, args, verb)
//
//# Facebook sometimes sends results like "true" and "false", which aren't strictly object
//# and cause JSON.parse to fail
//# so we account for that
//response = JSON.parse("[#{result}]")[0]
//
//# check for errors
//if response.is_a?(Hash) && error_details = response["error"]
//raise GraphAPIError.new(error_details)
//end
//
//response
//end



@end
