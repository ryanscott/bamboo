#import "AppDelegate_Pad.h"

@implementation AppDelegate_Pad

@synthesize window;

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{
	window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	window.backgroundColor = [UIColor greenColor];
	[window makeKeyAndVisible];
	
	return YES;
}

-(void)dealloc 
{
	[window release];
	[super dealloc];
}


@end
