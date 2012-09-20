//
//  SendMessageViewController.h
//  MessageInABottle
//
//  Created by Karl Schmidt on 2012-09-20.
//  Copyright (c) 2012 Adrian Crook & Associates. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendMessageViewController : UIViewController <UIImagePickerControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate,
                                                         UINavigationControllerDelegate, UITextViewDelegate>

- (IBAction)addPhotoTouched:(id)sender;
- (IBAction)sendTouched:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *imagePreview;
@property (strong, nonatomic) IBOutlet UITextView *messageTextView;
@end
