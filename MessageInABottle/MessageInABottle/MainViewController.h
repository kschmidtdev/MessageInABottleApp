//
//  MainViewController.h
//  MessageInABottle
//
//  Created by Karl Schmidt on 2012-09-20.
//  Copyright (c) 2012 Adrian Crook & Associates. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *welcomeLbl;
@property (strong, nonatomic) IBOutlet UIButton *checkButton;
- (IBAction)checkTouched:(id)sender;
@end
