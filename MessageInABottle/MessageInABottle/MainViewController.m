//
//  MainViewController.m
//  MessageInABottle
//
//  Created by Karl Schmidt on 2012-09-20.
//  Copyright (c) 2012 Adrian Crook & Associates. All rights reserved.
//

#import "MainViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface MainViewController ()

@end

@implementation MainViewController
@synthesize welcomeLbl;
@synthesize checkButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    if (FBSession.activeSession.isOpen)
    {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error)
        {
             if (!error)
             {
                 self.welcomeLbl.text = [NSString stringWithFormat:@"Welcome, %@!", user.first_name];
//                 self.userProfileImage.profileID = [user objectForKey:@"id"];
             }
         }];
        
        [self refreshTouched:nil];
    }

    [self.checkButton setEnabled:FALSE];
}

- (void)viewDidUnload
{
    [self setWelcomeLbl:nil];
    [self setCheckButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)checkTouched:(id)sender
{
    
}

- (IBAction)logoutTouched:(id)sender
{
    [FBSession.activeSession closeAndClearTokenInformation];
}

- (IBAction)refreshTouched:(id)sender
{
    if (FBSession.activeSession.isOpen)
    {
        [[FBRequest requestForGraphPath:@"me/apprequests"] startWithCompletionHandler:
         ^(FBRequestConnection* connection, id result, NSError* error )
         {
             if( !error )
             {
                 //NSLog(@"%@", result );
                 NSArray* requests = [result objectForKey:@"data"];
                 /*if( requests != nil )
                 {
                     NSLog(@"Requests: %@", requests);
                 }*/

                 if( [requests count] > 0 )
                 {
                     NSDictionary* applicationInfo = [[requests objectAtIndex:0] objectForKey:@"application"];
                     
                     if( [[applicationInfo objectForKey:@"id"] isEqualToString: @"283702078409452"] )
                     {
                         [self.checkButton setEnabled:TRUE];
                     }
                 }
             }
         }];
    }
}

@end
