//
//  MainController.h
//  friendgraph
//
//  Created by Ryan Stubblefield on 5/7/10.
//  Copyright 2010 Context Optional Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MainController : UIViewController
{
	NSMutableData* _responseText;
}

-(void)doneLoggingIn;

@end
