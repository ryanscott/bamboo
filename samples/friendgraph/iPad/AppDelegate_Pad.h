@class MainController;

@interface AppDelegate_Pad : NSObject <UIApplicationDelegate> 
{
	UIWindow *window;
	MainController* _mainController;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) MainController* _mainController;

@end

