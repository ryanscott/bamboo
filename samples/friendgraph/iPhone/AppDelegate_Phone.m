#import "AppDelegate_Phone.h"
#import "MainController.h"
#import "FacebookProxy.h"

@implementation AppDelegate_Phone

@synthesize window;
@synthesize _mainController;

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{
	initRCLib();
	[FacebookProxy loadDefaults];
	_mainController = [[MainController alloc] init];
	
	window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];	
	window.backgroundColor = [UIColor blueColor];
	
	[window addSubview:self._mainController.view];
	
	[window makeKeyAndVisible];
	
	return YES;
}

-(void)dealloc 
{
	terminateRCLib();
	[_mainController release];
	[window release];
	[super dealloc];
}


@end
