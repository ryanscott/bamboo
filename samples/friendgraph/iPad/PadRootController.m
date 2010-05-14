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
	CGFloat width = kDefaultButtonWidth;
	CGFloat height = kDefaultButtonHeight;
	
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
	
	self._walkButton = [self buttonWithFrame:l_frame title:@"Walk" action:@selector(doWalk)];
	
	y = 220.0f;
	width = 300.0f - x;
	height = 25.0f;
	
	l_frame = CGRectMake(x, y, width, height);
	
	self._statusInfo = [[UILabel alloc] initWithFrame:l_frame];
	self._statusInfo.backgroundColor = [UIColor blueColor];
	self._statusInfo.textColor = [UIColor whiteColor];
	self._statusInfo.text = @"waiting on API";	
	
	y += height + h_buf;
	height = (kApplicationFrame.size.height - h_buf) - y;
	
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
	RCLibFreeMemory();
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
	if ( nil != [FacebookProxy instance]._oAuthAccessToken )
	{
		if ( nil == self._graph )
			self._graph = [[FacebookProxy instance] newGraph];	

		self._statusInfo.text = [FacebookProxy instance]._oAuthAccessToken;
		
		self._profileImage.image = [self._graph getLargeProfilePhotoForObject:@"me"];	
		
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

		NSString* me_s = [self._graph getObject:@"me"];
		
		NSDictionary* jsonDict = [me_s JSONValue];
		
		RCLog( @"json dictionary: %@", jsonDict );
		
		GraphObject* me = [[GraphObject alloc] initWithString:me_s];
		
		NSString* name = [NSString stringWithFormat:@"%@, %@ (%@)", [jsonDict objectForKey:@"last_name"], [jsonDict objectForKey:@"first_name"], [jsonDict objectForKey:@"gender"]];
		
		// alternatively, using the Graph Object, it would be
		name = [me name];
		
		NSArray* metadata = [self._graph getConnectionTypesForObject:@"me"];
		
		RCLog( @"connection types = %@", metadata );
		
		self._fullText.text = me_s;
		
		NSString* likesText = [self._graph getConnections:@"likes" forObject:@"me"];
		//	NSString* searchText = [self._graph searchTerms:@"context" objectType:kSearchUsers];
		
		// this doesn't seem to work at all
		//	NSString* searchNewsText = [self._graph searchNewsFeedForUser:@"me" searchTerms:@"mother"];
		
		self._fullText.text = [NSString stringWithFormat:@"%@ Likes\n%@\n\nObject\n%@", name, likesText, self._fullText.text];
		//	self._fullText.text = [NSString stringWithFormat:@"%@ Likes\n%@\n\nObject\n%@\n\nSearch\n%@", name, likesText, self._fullText.text, searchText];
		//	self._fullText.text = [NSString stringWithFormat:@"Likes\n%@\n\nObject\n%@\n\nSearch\n%@\n\nNews for mother\n%@", likesText, self._fullText.text, searchText, searchNewsText];
	}
}

-(void)doPost
{
	if ( [self haveGraph] )
	{
		//post something 
		// 	graph.put_object("me", "feed", :message => "Hello, world")
		
		NSDictionary* args = [NSDictionary dictionaryWithObjectsAndKeys:@"bamboo test", @"message", nil];
		[self._graph putToObject:@"me" connectionType:@"feed" args:args];
		
		// a test comment, something we can more freely POST to that wont pollute our status message
		// 1394987957_115365565169546
		
		//		NSDictionary* args = [NSDictionary dictionaryWithObjectsAndKeys:@"Bamboo comment test", @"message", nil];
		//		if ( [self._graph putToObject:@"1394987957_115365565169546" connectionType:@"comments" args:args] )
		//		{
		//			self._statusInfo.text = @"Post success!";
		//		}
		//		else
		//		{
		//			self._statusInfo.text = @"Post failure, probably auth";
		//		}


		// now clean up after yourself
		//		[self._graph deleteObject:@"1394987957_121775964514199"];
		

	}
}

-(void)doWalk
{
	
}

@end

