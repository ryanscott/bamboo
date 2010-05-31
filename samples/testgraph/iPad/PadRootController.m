#import "PadRootController.h"
#import "FacebookProxy.h"
#import "GraphAPI.h"
#import "GraphObject.h"
#import "JSON.h"

@interface PadRootController (_PrivateMethods)

-(bool)haveGraph;

@end


@implementation PadRootController

@synthesize _graph;

@synthesize _authButton;
@synthesize _postButton;
@synthesize _testButton;
@synthesize _walkButton;

@synthesize _statusInfo;
@synthesize _profileImage;

@synthesize _fullText;

#pragma mark Initialization

-(UIButton*)buttonWithFrame:(CGRect)l_frame title:(NSString*)title action:(SEL)action
{
	UIButton* newButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	newButton.frame = l_frame;
	[newButton setTitle:title forState:UIControlStateNormal];
	[newButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
	
	return newButton;
}

-(void)initControls
{
	self._statusInfo = nil;
	self._profileImage = nil;
	self._graph = nil;

	CGFloat h_buf = 10.0f;
	CGFloat v_buf = h_buf;
	
	CGFloat x = h_buf;
	CGFloat y = v_buf;
	CGFloat width = 80.0f;
	CGFloat height = 30.0f;
	
	CGRect l_frame = CGRectMake(x, y, width, height);
	
	self._authButton = [self buttonWithFrame:l_frame title:@"Login" action:@selector(doAuth)];
	
	y += height + v_buf;
	l_frame = CGRectMake(x, y, width, height);
	
	self._testButton = [self buttonWithFrame:l_frame title:@"Test" action:@selector(doTest)];
	
	y += height + v_buf;
	l_frame = CGRectMake(x, y, width, height);

	self._postButton = [self buttonWithFrame:l_frame title:@"Post" action:@selector(doPost)];
	
	y += height + v_buf;
	l_frame = CGRectMake(x, y, width, height);
	
//	self._walkButton = [self buttonWithFrame:l_frame title:@"Walk" action:@selector(doWalk)];
	self._walkButton = [self buttonWithFrame:l_frame title:@"Search" action:@selector(doWalk)];
	
	y = 220.0f;
	width = 300.0f - x;
	height = 25.0f;
	
	l_frame = CGRectMake(x, y, width, height);
	
	self._statusInfo = [[UILabel alloc] initWithFrame:l_frame];
	self._statusInfo.backgroundColor = [UIColor blueColor];
	self._statusInfo.textColor = [UIColor whiteColor];
	self._statusInfo.text = @"waiting on API";	
	
	y += height + h_buf;
	height = ([UIScreen mainScreen].applicationFrame.size.height - h_buf) - y;
	
	l_frame = CGRectMake(x, y, width, height);
	self._fullText = [[UITextView alloc] initWithFrame:l_frame];
	self._fullText.text = @"";
	self._fullText.backgroundColor = [UIColor blueColor];
	self._fullText.textColor = [UIColor whiteColor];
	self._fullText.editable = NO;
	self._fullText.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	
	width = 200.0f;
	height = 200.0f;
	x = self._authButton.frame.size.width + (h_buf * 2);
	y = v_buf;
	
	l_frame = CGRectMake(x, y, width, height);
	
	self._profileImage = [[UIImageView alloc] initWithFrame:l_frame];
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
	[self.view addSubview:self._authButton];
	[self.view addSubview:self._postButton];
	[self.view addSubview:self._testButton];
	[self.view addSubview:self._walkButton];
	[self.view addSubview:self._statusInfo];
	[self.view addSubview:self._fullText];
	
	//	[self.view addSubview:self._profileImage];
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
	[_statusInfo release];
	[_profileImage release];
	[_graph release];
	[_fullText release];
	[_authButton release];
	[_postButton release];
	[_testButton release];
	[_walkButton release];
	
	[super dealloc];
}

#pragma mark Rotation support

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
//	BOOL shouldRotate = (( interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown ) || (interfaceOrientation ==  UIInterfaceOrientationPortrait));
//
//	return shouldRotate;// && !self._disableRotation;
	return YES;
}

//-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
//{
////	[UIScreen mainScreen].applicationFrame;
////
//	CGFloat h_buf = 10.0f;
//	CGFloat width = 200.0f;
//	CGFloat height = 200.0f;
//	CGFloat x = kApplicationFrame.size.width - h_buf - width;
//
//	// it's rediculous that UIScreen.applicationFrame is not rotation aware
//	if ( UIInterfaceOrientationIsLandscape( self.interfaceOrientation ) )
//	{
//		x = kApplicationFrame.size.height - h_buf - width;
//	}
//
//	CGFloat y = h_buf;
//	
//	CGRect l_frame = CGRectMake(x, y, width, height);
//	
//	self._profileImage.frame = l_frame;
//}
//
#pragma mark Singleton Methods

#pragma mark Instance Methods


#pragma mark Event Handlers

#pragma mark FacebookProxy Callback

-(void)doneAuthorizing
{
	// FacebookProxy is useful as a way to have users login to Facebook, and a convenient way to get an access_token
	// you are welcome to use it, or provide your own facebook login mechanism
	
	if ( nil != [FacebookProxy instance]._oAuthAccessToken )
	{
		// either way, the GraphAPI object is what you want.  this method creates a new GraphAPI object using the FacebookProxy's access_token		
		if ( nil == self._graph )
			self._graph = [[FacebookProxy instance] newGraph];	

		self._statusInfo.text = [FacebookProxy instance]._oAuthAccessToken;

		GraphObject* me = [self._graph getObject:@"me"];
		self._profileImage.image = [me largePicture];

		// this one call is more efficient than the above code, which makes two calls to the graph.
		// but the code above tests the picture accessors of GraphObject
		//[self._graph getLargeProfilePhotoForObject:@"me"];	
		
		if ( nil == self._profileImage.superview )
			[self.view addSubview:self._profileImage];
	}
}

#pragma mark Private Methods

-(bool)haveGraph
{
	if ( nil == self._graph && nil != [FacebookProxy instance]._oAuthAccessToken )
	{
		self._graph = [[FacebookProxy instance] newGraph];
	}
	
	return (nil != self._graph);
}

#pragma mark Button Handlers

-(void)doAuth
{
	self._statusInfo.text = @"authorizing...";

	// this method will invoke all the necessary network calls that by the time your callback is called,
	// FacebookProxy should have a valid access_token which you can use to access the GraphAPI
	[[FacebookProxy instance] loginAndAuthorizeWithTarget:self callback:@selector(doneAuthorizing)];
}

-(void)doTest
{
	if ( [self haveGraph] )
	{
		self._statusInfo.text = [FacebookProxy instance]._oAuthAccessToken;
		
		self._profileImage.image = [self._graph getLargeProfilePhotoForObject:@"me"];	
		
		if ( nil == self._profileImage.superview )
			[self.view addSubview:self._profileImage];

		GraphObject* me = [self._graph getObject:@"me"];
		NSString* name = [me name];
		
		NSArray* metadata = [self._graph getConnectionTypesForObject:@"me"];
		
		NSLog( @"connection types = %@", metadata );
		
		NSArray* likes = [self._graph getConnections:@"likes" forObject:me.objectID];
		
		if ( [likes count] > 0)
		{
			NSString* likesText = [[likes objectAtIndex:0] name];
		
			self._fullText.text = [NSString stringWithFormat:@"%@ Likes\n%@", name, likesText];
		}
		else 
		{
			self._fullText.text = name;
		}
	}
}

-(void)doPost
{
	if ( [self haveGraph] )
	{
		// POST test #1
		// post something 
		
//		NSDictionary* args = [NSDictionary dictionaryWithObjectsAndKeys:@"bamboo test", @"message", nil];
//		[self._graph putToObject:@"me" connectionType:@"feed" args:args];
		
		
		// POST test #2
		// a test comment, something we can more freely POST to that wont pollute our status message

		// change this to switch between valid / invalid comment test
		NSString* test_comment_id = @"dkjfghsudfhgluerg";
//		test_comment_id = @"744407303_123977144285804";
		
		NSDictionary* args = [NSDictionary dictionaryWithObjectsAndKeys:@"Bamboo comment test", @"message", nil];
		GraphObject* post_result = [self._graph putToObject:test_comment_id connectionType:@"comments" args:args];
		if ( nil != post_result.objectID )
		{		
			NSLog( @"post_result = %@", post_result.objectID );
			self._statusInfo.text = [NSString stringWithFormat:@"Post success!\ncomment id = %@", post_result.objectID];

			// DELETE test
			// now clean up after yourself
			if ( [self._graph deleteObject:test_comment_id] )
			{
				NSLog( @"DELETE success" );
			}
			else
			{
				NSLog( @"DELETE failure" );
			}
		}
		else
		{
			NSLog( @"post_result = %@", post_result.error );
			self._statusInfo.text = @"Post failure";
			
//			GraphObject* errorObj = [[GraphObject alloc] initWithString:post_result.error];
			GraphObject* errorObj = [[GraphObject alloc] initWithDict:post_result.error];
			NSString* errorMessage = [errorObj propertyWithKey:@"message"];
			if ( nil != errorMessage)
			{
				self._fullText.text = [NSString stringWithFormat:@"%@", errorMessage];
			}
			else
			{
				self._fullText.text = [NSString stringWithFormat:@"%@", post_result.error];
			}
		}
	}
}

-(void)doWalk
{
	if ( [self haveGraph] )
	{
		// this search doesn't seem to work at all		
//		NSString* searchNewsText = [self._graph searchNewsFeedForUser:@"me" searchTerms:@"mother"];
//		self._fullText.text = searchNewsText;
		
		// this search does work
		NSArray* searchResults = [self._graph searchTerms:@"context" objectType:kSearchUsers];
		
		if ( [searchResults count] > 1)
		{
			NSString* searchText = [[searchResults objectAtIndex:1] name];
			NSLog( @"searchText = %@", searchText );
			
			self._fullText.text = searchText;
		}
	}
}

@end

