#import "MainController.h"
#import "FacebookProxy.h"
#import "GraphAPI.h"
#import "JSON.h"

@implementation MainController

@synthesize _graph;

@synthesize _authButton;
@synthesize _postButton;
@synthesize _statusInfo;
@synthesize _profileImage;

@synthesize _fullText;

#pragma mark Initialization

-(void)initControls
{
	self._statusInfo = nil;
	self._profileImage = nil;
	self._graph = nil;
	
	CGFloat h_buf = 10.0f;

	CGFloat x = 10.0f;
	CGFloat y = 120.0f;
	CGFloat width = 300.0f;
	CGFloat height = 25.0f;
	
	CGRect l_frame = CGRectMake(x, y, width, height);
	
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

	self._authButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	self._authButton.frame = CGRectMake(10, 10, 80, 30);
	[self._authButton addTarget:self action:@selector(doAuth) forControlEvents:UIControlEventTouchUpInside];
	[self._authButton setTitle:@"Auth FB" forState:UIControlStateNormal];
	
	self._postButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	self._postButton.frame = CGRectMake(10, 50, 80, 30);
	[self._postButton addTarget:self action:@selector(doPost) forControlEvents:UIControlEventTouchUpInside];
	[self._postButton setTitle:@"Post" forState:UIControlStateNormal];
	
	width = 50.0f;
	height = 50.0f;
#ifdef __IPHONE_3_2 && IS_IPAD
//	if ( IS_IPAD )
//	{
		width = 200.0f;
		height = 200.0f;
#endif
	x = kApplicationFrame.size.width - h_buf - width;
	y = h_buf;
	
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
	[self.view addSubview:self._statusInfo];
	[self.view addSubview:self._fullText];

	//	[self.view addSubview:self._profileImage];
}

-(void)viewDidLoad 
{
	//	[self initEvents];
	
	[self addSubviews];
	
	// [rya:5-9-10] kinda weird place to do this, but works for now
	[FacebookProxy loadDefaults];
	
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
	
	[super dealloc];
}

#pragma mark Singleton Methods

#pragma mark Instance Methods


#pragma mark Event Handlers

#pragma mark FacebookProxy Callback

-(void)doneAuthorizing
{
	self._statusInfo.text = [FacebookProxy instance]._oAuthAccessToken;
	
	if ( nil == self._graph )
		self._graph = [[FacebookProxy instance] newGraph];
	
	NSString* me = [self._graph getObject:@"me"];
	
	NSDictionary* jsonDict = [me JSONValue];

	RCLog( @"json dictionary: %@", jsonDict );
	
	NSString* name = [NSString stringWithFormat:@"%@, %@ (%@)", [jsonDict objectForKey:@"last_name"], [jsonDict objectForKey:@"first_name"], [jsonDict objectForKey:@"gender"]];
	
	NSArray* metadata = [self._graph getConnectionTypesForObject:@"me"];
	
	RCLog( @"connection types = %@", metadata );

	self._fullText.text = me;

	NSString* likesText = [self._graph getConnections:@"likes" forObject:@"me"];
//	NSString* searchText = [self._graph searchTerms:@"context" objectType:kSearchUsers];

	// this doesn't seem to work at all
	//	NSString* searchNewsText = [self._graph searchNewsFeedForUser:@"me" searchTerms:@"mother"];
	
	self._fullText.text = [NSString stringWithFormat:@"%@ Likes\n%@\n\nObject\n%@", name, likesText, self._fullText.text];
//	self._fullText.text = [NSString stringWithFormat:@"%@ Likes\n%@\n\nObject\n%@\n\nSearch\n%@", name, likesText, self._fullText.text, searchText];
//	self._fullText.text = [NSString stringWithFormat:@"Likes\n%@\n\nObject\n%@\n\nSearch\n%@\n\nNews for mother\n%@", likesText, self._fullText.text, searchText, searchNewsText];
	
	
#ifdef __IPHONE_3_2 && IS_IPAD
//	if ( IS_IPAD )
//		self._profileImage.image = [self._graph getLargeProfilePhotoForObject:@"me"];	
//	else
//	self._profileImage.image = [self._graph getProfilePhotoForObject:@"me"];	

	self._profileImage.image = [self._graph getLargeProfilePhotoForObject:@"me"];	
#else
	self._profileImage.image = [self._graph getProfilePhotoForObject:@"me"];	
#endif
	
	if ( nil == self._profileImage.superview )
		[self.view addSubview:self._profileImage];
}

#pragma mark Button Handlers

-(void)doAuth
{
	self._statusInfo.text = @"authorizing...";
	[[FacebookProxy instance] loginAndAuthorizeWithTarget:self callback:@selector(doneAuthorizing)];
}

-(void)doPost
{
	// if we have a saved access_token, but no graph...make one
	// but if not, we don't try to login, just do nothing
	if ( nil == self._graph && nil != [FacebookProxy instance]._oAuthAccessToken )
	{
		self._graph = [[FacebookProxy instance] newGraph];
	}
	
	if ( nil != self._graph )
	{
		//post something 
		// 	graph.put_object("me", "feed", :message => "Hello, world")
		
		NSDictionary* args = [NSDictionary dictionaryWithObjectsAndKeys:@"bamboo test", @"message", nil];
		[self._graph putToObject:@"me" connectionType:@"feed" args:args];
		
//		1394987957_115365565169546

//		NSDictionary* args = [NSDictionary dictionaryWithObjectsAndKeys:@"Bamboo comment test", @"message", nil];
//		if ( [self._graph putToObject:@"1394987957_115365565169546" connectionType:@"comments" args:args] )
//		{
//			self._statusInfo.text = @"Post success!";
//		}
//		else
//		{
//			self._statusInfo.text = @"Post failure, probably auth";
//		}

	}
}

@end

