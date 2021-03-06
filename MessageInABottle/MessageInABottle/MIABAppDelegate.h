//
//  MIABAppDelegate.h
//  MessageInABottle
//
//  Created by Karl Schmidt on 2012-09-19.
//  Copyright (c) 2012 Adrian Crook & Associates. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Facebook;

extern NSString *const MIABSessionStateChangedNotification;

@interface MIABAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) Facebook *facebook;

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;

@end
