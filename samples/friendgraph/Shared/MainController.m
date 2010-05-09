#import "MainController.h"
#import "FacebookProxy.h"
#import "GraphAPI.h"

@implementation MainController

@synthesize _graph;

@synthesize _authButton;
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

	self._authButton = [UIButton buttonWithType:UIButtonTypeCustom];
	self._authButton.frame = CGRectMake(10, 10, 80, 30);
	[self._authButton addTarget:self action:@selector(doAuth) forControlEvents:UIControlEventTouchUpInside];
	[self._authButton setTitle:@"Auth FB" forState:UIControlStateNormal];
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
	
	self._fullText.text = [self._graph getObject:@"me"];
}

#pragma mark Button Handlers

-(void)doAuth
{
	self._statusInfo.text = @"authorizing...";
	[[FacebookProxy instance] loginAndAuthorizeWithTarget:self callback:@selector(doneAuthorizing)];
}

@end

