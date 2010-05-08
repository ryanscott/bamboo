#import "Constants.h"


// Facebook API
NSString* const kFBAPIKey = @"25e1cec0df2b3bfa781da3ed78da3a1e";
NSString* const kFBAppSecret = @"e45e55a333eec232d4206d2703de1307";

// Sharing text
NSString* const kShareEmailSubject = @"Check out my awesome iPhone application";
NSString* const kShareText = @"This is a test, of my awesome iPhone application";
NSString* const kTwitterShareText = @"This is a tweet, from my awesome iPhone application";


//
//// Title dimensions
//const CGFloat kTitleHeight = 16.0f;
//const CGFloat kTitleWidth = 160.0f;
//
//// Main View control sizes
////const CGFloat kTopBarHeight = 38.0f;
//const CGFloat kTopBarHeight = 44.0f;
//
//const CGFloat kTopBarButtonWidth = 68.0f;
//const CGFloat kTopBarButtonHeight = 24.0f;
//
//const CGFloat kShortButtonWidth = 30.0f;
//const CGFloat kShortButtonHeight = 30.0f;
//
//const CGFloat kMediumButtonWidth = 84.0f;
//const CGFloat kMediumButtonHeight = 30.0f;
//
//const CGFloat kLongButtonWidth = 120.0f;
//const CGFloat kLongButtonHeight = 30.0f;
//
//CGRect kScreenFrame;
//
//// Custom Controls
//const CGFloat kColorGridWidth = 294.0f;
//const CGFloat kColorGridHeight = 288.0f;
//
//const int kGridMenuMaxCapacity = 9;
//
//const CGFloat kGridMenuSlideDuration = 0.85f;
//
//const CGFloat kGridMenuVMargin = 20.0f; 
//const CGFloat kGridMenuHMargin = 21.0f;
//const CGFloat kGridMenuVBuffer = 20.0f;
//const CGFloat kGridMenuHBuffer = 21.0f;
//
//// (kGridMenuVBuffer / 2) - (kGridMenuItemTitleHeight / 2), roughly
//const CGFloat kGridMenuItemTitleVOffset = 3.0f;
//// kGridMenuItemFontSize, at least
//const CGFloat kGridMenuItemTitleHeight = 12.0f;
//
//const CGFloat kGridMenuIconWidth = 80.0f;
//const CGFloat kGridMenuIconHeight = 80.0f;
//
//const CGFloat kGridMenuIconCornerRadius = 5.0f;
//
//const CGFloat kGridMenuBarHeight = 31.0f;
//
//const CGFloat kCalculatorFieldWidth = 120.0f;
//const CGFloat kCalculatorFieldHeight = 30.0f;
//
//const CGFloat kCalculatorSwitchHeight = 27.0f;
//
//// Fonts
//NSString *const kAppTitleFont = @"HelveticaNeue-Bold";
//const CGFloat kAppTitleFontSize = 16.0f;
//
//UIFont* kTitleFont;
//
//NSString *const kGridMenuItemFontName = @"HelveticaNeue";
//const CGFloat kGridMenuItemFontSize = 11.0f;
//
//UIFont* kGridMenuItemFont;
//
//NSString *const kDefaultLabelFontName = @"HelveticaNeue";
//const CGFloat kDefaultLabelFontSize = 14.0f;
//
//UIFont* kDefaultLabelFont;
//
//NSString *const kDefaultFontName = @"HelveticaNeue";
//const CGFloat kDefaultFontSize = 12.0f;
//
//UIFont* kDefaultFont;
//
//
//// Colors
//UIColor* kBackgroundGray;
//UIColor* kDefaultTextColor;
//
//// Paint & Database 
//
//const int kPremiumPaintCount = 1752;
//const int kUltraPaintCount = 386;
//const int kTotalPaintCount = 2138;
//const int kGuessUserPaintCount = 50;
//
//// Palette
//
//const NSUInteger kPaletteColorCount = 3;
//
//const NSUInteger kPaletteTypePrimaryMono = 0;
//const NSUInteger kPaletteTypePrimaryComp = 1;
//const NSUInteger kPaletteTypePrimaryWarm = 2;
//const NSUInteger kPaletteTypePrimaryCool = 3;
//const NSUInteger kPaletteTypeAltMono = 4;
//const NSUInteger kPaletteTypeAltComp = 5;
//const NSUInteger kPaletteTypeAltWarm = 6;
//const NSUInteger kPaletteTypeAltCool = 7;
//const NSUInteger kPaletteTypeCount = 8;
//
//// Global Objects
//
//@implementation Globals
//
//static UIBarButtonItem* __backBarButton = nil;
//
//+(UIBarButtonItem*)backBarButton
//{
//	if ( nil == __backBarButton )
//	{
//		__backBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
//	}
//	return __backBarButton;
//}
//+(UILabel*)allocLabelWithFrame:(CGRect)l_frame
//{
//	return [Globals allocLabelWithFrame:l_frame andTitle:nil];
//}
//
//+(UILabel*)allocLabelWithFrame:(CGRect)l_frame andTitle:(NSString*)l_title
//{
//	UILabel* newLabel = [[UILabel alloc] initWithFrame:l_frame];
//	newLabel.backgroundColor = [UIColor clearColor];
//	newLabel.textColor = kDefaultTextColor;
//
//	if ( nil != l_title )
//		newLabel.text = l_title;
//	
//	return newLabel;
//}
//
//#pragma mark Logging
//
//+(void)logPaint:(Paint*)l_paint
//{
//	if ( nil != l_paint )
//		RCLog( @"Paint info: %@:%@ (%d : %d, %d, %d )\n", l_paint._colorID, l_paint._colorName, l_paint._colorRGB, rcRED(l_paint._colorRGB), rcGREEN(l_paint._colorRGB), rcBLUE(l_paint._colorRGB) );
//}
//
//#pragma mark Memory Management
//
//+(void)freeMemory
//{
//	[__backBarButton release];
//	__backBarButton = nil;
//}
//
//@end
//
//
