#import "AppDelegate_Pad.h"
#import "MainController.h"

@implementation AppDelegate_Pad

@synthesize window;
@synthesize _mainController;

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{
	initRCLib();
	_mainController = [[MainController alloc] init];
	
	window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	window.backgroundColor = [UIColor greenColor];
	
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