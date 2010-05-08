#import "FacebookProxy.h"
#import "Constants.h"
//#import "FBConnect/FBConnect.h"
#import "AppDelegate_Phone.h"
#import "MainController.h"

@implementation FacebookProxy

@synthesize _session;
@synthesize _uid;

#pragma mark Singleton Methods

static FacebookProxy* gFacebookProxy = NULL;

+(FacebookProxy*)instance
{
	@synchronized(self)
	{
    if (gFacebookProxy == NULL)
		{
			gFacebookProxy = [[FacebookProxy alloc] init];
		}
	}
	return gFacebookProxy;
}

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

-(void)getSession
{
	if ( ![self._session resume] )
	{
		RCLog( @"Starting new session" );
		self._session = [FBSession sessionForApplication:kFBAPIKey secret:kFBAppSecret delegate:self];
	}
	else 
	{
		RCLog( @"Session resumed!" );
	}
}

-(id)init
{
	if ( self = [super init] )
	{
		self._uid = 0;
		[self getSession];
//		[self initControls];
	}
	return self;
}

//- (void)loadView 
//{
//	CGRect content_frame = [[UIScreen mainScreen] applicationFrame];
//	UIView *content_view = [[UIView alloc] initWithFrame:content_frame];
//	//	UIView *content_view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 45.0f)];
//	content_view.backgroundColor = [UIColor blackColor];
//	self.view = content_view;
//	[content_view release];
//}

//-(void)initEvents
//{
//	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notify:) name:@"Event" object:notificationSender];	
//}

//-(void)stopEvents
//{
//	//[[NSNotificationCenter defaultCenter] removeObserver:self @"Event" object:notificationSender];
//}

//-(void)addSubviews
//{
//	//	[self.view addSubview:self._someview];
//}

//-(void)viewDidLoad 
//{
//	//	[self initEvents];
//	
////	[self addSubviews];
//	[super viewDidLoad];
//}

- (void)dealloc 
{
	//	[self stopEvents];
	if ( self._session != nil )
		[self._session.delegates removeObject: self];	
	[super dealloc];
}

#pragma mark Instance Methods

-(bool)isLoggedin
{
	return self._uid != 0;
}

-(void)login
{
	if ( self._session )
	{
		FBLoginDialog* dialog = [[[FBLoginDialog alloc] initWithSession:self._session] autorelease];
		dialog.delegate = self;
		[dialog show];
	}
}

//-(void)postAttachment 
//{ 
////	NSString *statusString = @"test status";
////	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: statusString, @"status", 
////																																		 @"true", @"status_includes_verb", 
////																																		 nil]; 
////	
//
////	NSString* attachment = [NSString stringWithFormat:@"{\"name\":\"Facebook Connect for iPhone\"," 
////													"\"description\":\"%@\"}", kShareText];
//	
//	NSString* attachment = [NSString stringWithFormat:@"{\"name\":\"%@\"," 
//													"\"description\":\"%@\"}", kShareEmailSubject, kShareText];
//	
//	NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
//															self._session.apiKey,      @"api_key",
//															self._session.sessionKey,  @"session_key",
//															@"true",                 @"auto_publish",
//															attachment,          @"attachment",
////															_actionLinks,         @"action_links",
//															nil];
//	
//	[[FBRequest requestWithDelegate:self] call:@"facebook.stream.publish" params:params]; 
//	
//	//	dialog.attachment = @"{\"name\":\"Facebook Connect for iPhone\"," 
//	//	"\"href\":\"http://developers.facebook.com/connect.php?tab=iphone\"," 
//	
////http://www.facebook.com/uscensusbureau
//}

-(void)postAttachment
{
	[((AppDelegate_Phone *)[[UIApplication sharedApplication] delegate])._mainController doneLoggingIn];
}	

-(void)postSampleMessage
{
	[self postAttachment];
	
//	FBStreamDialog* dialog = [[[FBStreamDialog alloc] init] autorelease]; 
////	dialog.delegate = inDelegate; 
//	dialog.userMessagePrompt = @"Example prompt"; 
//	dialog.attachment = @"{\"name\":\"Facebook Connect for iPhone\"," 
//	"\"href\":\"http://developers.facebook.com/connect.php?tab=iphone\"," 
//	"\"caption\":\"Caption\",\"description\":\"Description\"," 
//	"\"media\":[{\"type\":\"image\"," 
//	"\"src\":\"http://img40.yfrog.com/img40/5914/iphoneconnectbtn.jpg\"," 
//	"\"href\":\"http://developers.facebook.com/connect.php?tab=iphone/\"}]," 
//	"\"properties\":{\"another link\":{\"text\":\"Facebook home page\",\"href\":\"http://www.facebook.com\"}}}"; 
//	// replace this with a friend's UID 
//	// dialog.targetId = @"999999"; 
//	[dialog show];	
}

-(void)postMessageToWall:(NSString*)message delegate:(id<FBDialogDelegate>)inDelegate
{
	if ( [self isLoggedin] )
	{
		[self postSampleMessage];
//		FBStreamDialog* dialog = [[[FBStreamDialog alloc] init] autorelease]; 
//		dialog.delegate = inDelegate; 
//		dialog.userMessagePrompt = @"Example prompt"; 
//		dialog.attachment = @"{\"name\":\"Facebook Connect for iPhone\"," 
//													"\"href\":\"http://developers.facebook.com/connect.php?tab=iphone\"," 
//													"\"caption\":\"Caption\",\"description\":\"Description\"," 
//													"\"media\":[{\"type\":\"image\"," 
//																	"\"src\":\"http://img40.yfrog.com/img40/5914/iphoneconnectbtn.jpg\"," 
//																	"\"href\":\"http://developers.facebook.com/connect.php?tab=iphone/\"}]," 
//													"\"properties\":{\"another link\":{\"text\":\"Facebook home page\",\"href\":\"http://www.facebook.com\"}}}"; 
//		// replace this with a friend's UID 
//		// dialog.targetId = @"999999"; 
//		[dialog show];
	}
	else 
	{
		[self login];
	}
}

#pragma mark FBSessionDelegate Methods

- (void)session:(FBSession*)session didLogin:(FBUID)uid 
{
	self._uid = uid;
	NSLog(@"User with id %lld logged in.", self._uid);
}

#pragma mark FBRequestDelegate Methods

- (void)request:(FBRequest*)request didLoad:(id)result
{
	RCLog( @"stream.publish didLoad" );
	[Util simpleAlertWithTitle:@"Facebook Update Posted" message:@"Your Facebook update has been posted successfully"];
}

- (void)request:(FBRequest*)request didFailWithError:(NSError*)error
{
	RCLog( @"stream.publish didFailWithError: %@", error );
	
	FBPermissionDialog* dialog = [[[FBPermissionDialog alloc] init] autorelease]; 
	dialog.delegate = self; 
//	dialog.permission = @"status_update"; 
	dialog.permission = @"publish_stream"; 
	[dialog show];
}

- (void)requestWasCancelled:(FBRequest*)request;
{
	RCLog( @"stream.publish wasCancelled" );
}

#pragma mark FBDialogDelegate Methods

- (void)dialogDidSucceed:(FBDialog*)dialog
{
//	[self setUsersStatus];
	[self postSampleMessage];
}

#pragma mark Event Handlers
#pragma mark Button Handlers

@end
