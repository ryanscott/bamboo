#import "AppDelegate_Phone.h"
#import "MainController.h"

@implementation AppDelegate_Phone

@synthesize window;
@synthesize _mainController;

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{
	_mainController = [[MainController alloc] init];
	
	window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];	
	window.backgroundColor = [UIColor blueColor];
	
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
