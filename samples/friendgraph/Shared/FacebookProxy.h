#import <Foundation/Foundation.h>
#import "FBConnect/FBConnect.h"

@interface FacebookProxy : NSObject <FBSessionDelegate, FBDialogDelegate, FBRequestDelegate>
{
	FBSession* _session;
	FBUID _uid;
}

@property (nonatomic, retain) FBSession* _session;
@property (nonatomic, assign) FBUID _uid;

+(FacebookProxy*)instance;

-(void)postMessageToWall:(NSString*)message delegate:(id<FBDialogDelegate>)inDelegate;

@end
