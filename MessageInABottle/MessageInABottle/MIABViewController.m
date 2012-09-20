//
//  MIABViewController.m
//  MessageInABottle
//
//  Created by Karl Schmidt on 2012-09-19.
//  Copyright (c) 2012 Adrian Crook & Associates. All rights reserved.
//

#import "MIABViewController.h"
#import "MIABAppDelegate.h"

@interface MIABViewController ()

@end

@implementation MIABViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewDidAppear:(BOOL)animated
{
    // Check if we have already provided FB credentials, and will trigger
    // log-in flow if we already have them (will do nothing if we do not)
    MIABAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    [delegate openSessionWithAllowLoginUI:FALSE];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)loginTouched:(id)sender
{
    MIABAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    
    [delegate openSessionWithAllowLoginUI:TRUE];
}
@end
