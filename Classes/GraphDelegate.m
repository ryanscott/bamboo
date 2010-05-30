#import "GraphDelegate.h"

@implementation GraphDelegate

@synthesize _responseData;

#pragma mark Initialization

-(id)initWithAccessToken:(NSString*)access_token
{
	if ( self = [super init] )
	{
		self._responseData = [[NSMutableData alloc] initWithLength:0];

	}
	return self;	
}

-(void)dealloc
{
	[_responseData release];
	[super dealloc];	
}


#pragma mark NSURLConnection delegate methods


-(void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response
{
	[self._responseData setLength:0];
}


-(void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
	[self._responseData appendData:data];
}


-(void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
	[self._responseData setLength:0];
	[connection release];
}

-(NSCachedURLResponse*)connection:(NSURLConnection*)connection 
									 willCacheResponse:(NSCachedURLResponse*)cachedResponse
{
	// returning nil means do not cache response.  it's not clear that the response matters at all anyway...
	return nil;
}


-(void)connectionDidFinishLoading:(NSURLConnection*)connection
{
//	NSString* responseString = [[NSString alloc] initWithData:self._responseData encoding:NSUTF8StringEncoding];	
//	
//	[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationConnectionDidFinish object:nil];
}



//-(void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response
//{
	// this is from MGTwitterEngine, still deciding on how I want to handle this
	
//	// This method is called when the server has determined that it has enough information to create the NSURLResponse.
//	// it can be called multiple times, for example in the case of a redirect, so each time we reset the data.
//	[connection resetDataLength];
//	
//	// Get response code.
//	NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
//	NSInteger statusCode = [resp statusCode];
//	
//	if (statusCode >= 400) {
//		// Assume failure, and report to delegate.
//		NSError *error = [NSError errorWithDomain:@"HTTP" code:statusCode userInfo:nil];
//		if ([self _isValidDelegateForSelector:@selector(requestFailed:withError:)])
//			[_delegate requestFailed:[connection identifier] withError:error];
//		
//		// Destroy the connection.
//		[connection cancel];
//		NSString *connectionIdentifier = [connection identifier];
//		[_connections removeObjectForKey:connectionIdentifier];
//		if ([self _isValidDelegateForSelector:@selector(connectionFinished:)])
//			[_delegate connectionFinished:connectionIdentifier];
//		
//	} else if (statusCode == 304 || [connection responseType] == MGTwitterGeneric) {
//		// Not modified, or generic success.
//		if ([self _isValidDelegateForSelector:@selector(requestSucceeded:)])
//			[_delegate requestSucceeded:[connection identifier]];
//		if (statusCode == 304) {
//			[self parsingSucceededForRequest:[connection identifier] 
//												ofResponseType:[connection responseType] 
//										 withParsedObjects:[NSArray array]];
//		}
//		
//		// Destroy the connection.
//		[connection cancel];
//		NSString *connectionIdentifier = [connection identifier];
//		[_connections removeObjectForKey:connectionIdentifier];
//		if ([self _isValidDelegateForSelector:@selector(connectionFinished:)])
//			[_delegate connectionFinished:connectionIdentifier];
//	}
	
//#if DEBUG
//	if (NO) {
//		// Display headers for debugging.
//		NSHTTPURLResponse *respDebug = (NSHTTPURLResponse *)response;
//		NSLog(@"MGTwitterEngine: (%d) [%@]:\r%@", 
//					[resp statusCode], 
//					[NSHTTPURLResponse localizedStringForStatusCode:[respDebug statusCode]], 
//					[respDebug allHeaderFields]);
//	}
//#endif
//}


@end



// http://github.com/mattgemmell/MGTwitterEngine/blob/master/MGTwitterEngine.m


//- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
//{
//	if (_username && _password && [challenge previousFailureCount] == 0 && ![challenge proposedCredential]) {
//		NSURLCredential *credential = [NSURLCredential credentialWithUser:_username password:_password 
//																													persistence:NSURLCredentialPersistenceForSession];
//		[[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
//	} else {
//		[[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
//	}
//}



//- (void)connection:(MGTwitterHTTPURLConnection *)connection didFailWithError:(NSError *)error
//{
//	NSString *connectionIdentifier = [connection identifier];
//	
//	// Inform delegate.
//	if ([self _isValidDelegateForSelector:@selector(requestFailed:withError:)]){
//		[_delegate requestFailed:connectionIdentifier
//									 withError:error];
//	}
//	
//	// Release the connection.
//	[_connections removeObjectForKey:connectionIdentifier];
//	if ([self _isValidDelegateForSelector:@selector(connectionFinished:)])
//		[_delegate connectionFinished:connectionIdentifier];
//}

//
//- (void)connectionDidFinishLoading:(MGTwitterHTTPURLConnection *)connection
//{
//	NSString *connID = nil;
//	MGTwitterResponseType responseType = 0;
//	connID = [connection identifier];
//	responseType = [connection responseType];
//	
//	// Inform delegate.
//	if ([self _isValidDelegateForSelector:@selector(requestSucceeded:)])
//		[_delegate requestSucceeded:connID];
//	
//	NSData *receivedData = [connection data];
//	if (receivedData) {
//#if DEBUG
//		if (NO) {
//			// Dump data as string for debugging.
//			NSString *dataString = [NSString stringWithUTF8String:[receivedData bytes]];
//			NSLog(@"MGTwitterEngine: Succeeded! Received %d bytes of data:\r\r%@", [receivedData length], dataString);
//		}
//		
//		if (NO) {
//			// Dump XML to file for debugging.
//			NSString *dataString = [NSString stringWithUTF8String:[receivedData bytes]];
//			[dataString writeToFile:[[NSString stringWithFormat:@"~/Desktop/twitter_messages.%@", API_FORMAT] stringByExpandingTildeInPath] 
//									 atomically:NO encoding:NSUnicodeStringEncoding error:NULL];
//		}
//#endif
//		
//		if (responseType == MGTwitterImage) {
//			// Create image from data.
//#if TARGET_OS_IPHONE
//			UIImage *image = [[[UIImage alloc] initWithData:[connection data]] autorelease];
//#else
//			NSImage *image = [[[NSImage alloc] initWithData:[connection data]] autorelease];
//#endif
//			
//			// Inform delegate.
//			if ([self _isValidDelegateForSelector:@selector(imageReceived:forRequest:)])
//				[_delegate imageReceived:image forRequest:[connection identifier]];
//		} else {
//			// Parse data from the connection (either XML or JSON.)
//			[self _parseDataForConnection:connection];
//		}
//	}
//	
//	// Release the connection.
//	[_connections removeObjectForKey:connID];
//	if ([self _isValidDelegateForSelector:@selector(connectionFinished:)])
//		[_delegate connectionFinished:connID];
//}
