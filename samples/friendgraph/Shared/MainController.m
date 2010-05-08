    //
//  MainController.m
//  friendgraph
//
//  Created by Ryan Stubblefield on 5/7/10.
//  Copyright 2010 Context Optional Inc. All rights reserved.
//

#import "MainController.h"
#import "FacebookProxy.h"


@implementation MainController

#pragma mark Initialization

-(void)initControls
{
	//	CGFloat h_buf = 10.0f;
	//	CGFloat inset = 10.0f;
	//	
	//	CGFloat x = inset;
	//	CGFloat y = inset;
	//	CGFloat width = 0.0f;
	//	CGFloat height = 0.0f;
	//	
	//	CGRect l_frame = CGRectMake(x, y, width, height);
}

-(id)init
{
	if ( self = [super init] )
	{
		[self initControls];
	}
	return self;
}

- (void)loadView 
{
	CGRect content_frame = [[UIScreen mainScreen] applicationFrame];
	UIView *content_view = [[UIView alloc] initWithFrame:content_frame];
	//	UIView *content_view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 45.0f)];
	content_view.backgroundColor = [UIColor blackColor];
	self.view = content_view;
	[content_view release];
}

//-(void)initEvents
//{
//	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notify:) name:@"Event" object:notificationSender];	
//}

//-(void)stopEvents
//{
//	//[[NSNotificationCenter defaultCenter] removeObserver:self @"Event" object:notificationSender];
//}

-(void)addSubviews
{
	//	[self.view addSubview:self._someview];
	
	UIButton* authButton = [UIButton buttonWithType:UIButtonTypeCustom];
	authButton.frame = CGRectMake(10, 10, 80, 30);
	[authButton addTarget:self action:@selector(doAuth) forControlEvents:UIControlEventTouchUpInside];
	[authButton setTitle:@"Auth FB" forState:UIControlStateNormal];
	
	[self.view addSubview:authButton];
	//[authButton release];
}

-(void)viewDidLoad 
{
	//	[self initEvents];
	
	[self addSubviews];
	[super viewDidLoad];
}

#pragma mark Memory Management

- (void)didReceiveMemoryWarning 
{
	[super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
}

- (void)dealloc 
{
	//	[self stopEvents];
	[super dealloc];
}

#pragma mark Singleton Methods

#pragma mark Instance Methods


#pragma mark Event Handlers
#pragma mark Button Handlers

-(void)doAuth
{
	[[FacebookProxy instance] postMessageToWall:@"test message" delegate:nil];
}

#pragma mark login Callback

-(void)doneLoggingIn
{
	NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://graph.facebook.com/oauth/authorize?client_id=119908831367602&redirect_uri=http://oauth.twoalex.com/"]
																						cachePolicy:NSURLRequestUseProtocolCachePolicy
																				timeoutInterval:60.0];
	// create the connection with the request
	// and start loading the data
	NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if (theConnection) 
	{
    // Create the NSMutableData to hold the received data.
    // receivedData is an instance variable declared elsewhere.
    _responseText = [[NSMutableData data] retain];
	} 
	else 
	{
		RCLog( @"NSURLConnection fail" );
    // Inform the user that the connection failed.
	}
}

#pragma mark NSURLConnectionDelegate

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response 
{
	RCLog( @"didReceiveResponse" );
  _responseText = [[NSMutableData alloc] init];
	
  NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
	
	RCLog( @"status: %@", [NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]] );

	RCLog( @"headers: %@", [httpResponse allHeaderFields] );
	RCLog( @"header keys: %@", [[httpResponse allHeaderFields] allKeys] );
	RCLog( @"header values: %@", [[httpResponse allHeaderFields] allValues]);
	
//	httpResponse = nil;
	
//  if ([_delegate respondsToSelector:@selector(request:didReceiveResponse:)]) {    
//    [_delegate request:self didReceiveResponse:httpResponse];
//  }
}

-(void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data 
{
	RCLog( @"didReceiveData" );
  [_responseText appendData:data];
}

//- (NSCachedURLResponse*)connection:(NSURLConnection*)connection
//								 willCacheResponse:(NSCachedURLResponse*)cachedResponse {
//  return nil;
//}

- (void)handleResponseData:(NSData*)data 
{
  RCLog(@"DATA: %s", data.bytes);
	
	NSString* responseBody = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
	RCLog( @"response: %@", responseBody );
	responseBody = nil;
	
//  NSError* error = nil;
//  id result = [self parseXMLResponse:data error:&error];
//  if (error) {
//    [self failWithError:error];
//  } else if ([_delegate respondsToSelector:@selector(request:didLoad:)]) {
//    [_delegate request:self didLoad:result];
//  }
}

-(void)connectionDidFinishLoading:(NSURLConnection*)connection 
{
	RCLog( @"connectionDidFinishLoading" );
	[self handleResponseData:_responseText];
}

//- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error {  
//  [self failWithError:error];
//	
//  [_responseText release];
//  _responseText = nil;
//  [_connection release];
//  _connection = nil;
//}


@end