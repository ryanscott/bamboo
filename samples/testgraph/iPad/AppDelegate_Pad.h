@class PadRootController;

@interface AppDelegate_Pad : NSObject <UIApplicationDelegate> 
{
	UIWindow *window;
	PadRootController* _mainController;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) PadRootController* _mainController;

@end

