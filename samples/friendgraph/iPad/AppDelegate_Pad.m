#import "AppDelegate_Pad.h"
#import "PadRootController.h"
#import "FacebookProxy.h"

@implementation AppDelegate_Pad

@synthesize window;
@synthesize _mainController;

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{
	[FacebookProxy loadDefaults];
	_mainController = [[PadRootController alloc] init];
	
	window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	window.backgroundColor = [UIColor greenColor];
	
	[window addSubview:self._mainController.view];

	[window makeKeyAndVisible];
	
	return YES;
}

-(void)dealloc 
{
	[_mainController release];
	[window release];
	[super dealloc];
}


@end
