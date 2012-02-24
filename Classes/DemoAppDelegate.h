//
//  DemoAppDelegate.h
//  Demo
//
//  Created by chenjianshe on 12-2-22.
//  Copyright 2012 NetDragon WebSoft Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DemoViewController;

@interface DemoAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    DemoViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet DemoViewController *viewController;

@end

