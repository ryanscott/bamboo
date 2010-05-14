@class MainController;

@interface AppDelegate_Phone : NSObject <UIApplicationDelegate> 
{
	UIWindow *window;
	MainController* _mainController;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) MainController* _mainController;

@end

