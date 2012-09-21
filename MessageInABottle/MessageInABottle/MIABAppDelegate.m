//
//  MIABAppDelegate.m
//  MessageInABottle
//
//  Created by Karl Schmidt on 2012-09-19.
//  Copyright (c) 2012 Adrian Crook & Associates. All rights reserved.
//

#import "MIABAppDelegate.h"
#import "Facebook.h"

NSString *const MIABSessionStateChangedNotification = @"com.facebook.worldhackbottleapp:MIABSessionStateChangedNotification";

@implementation MIABAppDelegate

@synthesize facebook = _facebook;

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState)state
                      error:(NSError *)error
{
    // FBSample logic
    // Any time the session is closed, we want to display the login controller (the user
    // cannot use the application unless they are logged in to Facebook). When the session
    // is opened successfully, hide the login controller and show the main UI.
    switch (state)
    {
        case FBSessionStateOpen:
        {
            NSLog( @"User has logged in, sending them to the main screen." );
            
            // Initiate a Facebook instance
            self.facebook = [[Facebook alloc]
                             initWithAppId:FBSession.activeSession.appID
                             andDelegate:nil];
            
            // Store the Facebook session information
            self.facebook.accessToken = FBSession.activeSession.accessToken;
            self.facebook.expirationDate = FBSession.activeSession.expirationDate;

            [self.window.rootViewController performSegueWithIdentifier:@"FBLogin" sender:self.window.rootViewController];
        }
        break;
        
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
        {
            NSLog( @"User has logged out, sending them to the login screen." );
            
            [self.window.rootViewController dismissModalViewControllerAnimated:TRUE];

            [FBSession.activeSession closeAndClearTokenInformation];

            // Clear out the Facebook instance
            self.facebook = nil;
        }
        break;
            
        default:
        break;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MIABSessionStateChangedNotification
                                                        object:session];
    
    if (error)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:error.localizedDescription
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI
{
    NSArray *permissions = [NSArray arrayWithObjects:@"publish_actions", nil];
    return [FBSession openActiveSessionWithPermissions:permissions
                                          allowLoginUI:allowLoginUI
                                     completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                         [self sessionStateChanged:session state:state error:error];
                                     }];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    // FBSample logic
    // We need to handle URLs by passing them to FBSession in order for SSO authentication
    // to work.
    return [FBSession.activeSession handleOpenURL:url];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    // this means the user switched back to this app without completing a login in Safari/Facebook App
    if (FBSession.activeSession.state == FBSessionStateCreatedOpening)
    {
        // BUG: for the iOS 6 preview we comment this line out to compensate for a race-condition in our
        // state transition handling for integrated Facebook Login; production code should close a
        // session in the opening state on transition back to the application; this line will again be
        // active in the next production rev
        //[FBSession.activeSession close]; // so we close our session and start over
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [FBSession.activeSession close];
}

@end
