//
//  SendMessageViewController.m
//  MessageInABottle
//
//  Created by Karl Schmidt on 2012-09-20.
//  Copyright (c) 2012 Adrian Crook & Associates. All rights reserved.
//

#import "SendMessageViewController.h"

@interface SendMessageViewController ()

@end

@implementation SendMessageViewController
@synthesize imagePreview;
@synthesize messageTextView;

static NSString* k_TitleAS = @"Add Photo";
static NSString* k_CameraASEntry = @"Take photo";
static NSString* k_PhotoLibraryASEntry = @"Choose from Library";
static NSString* k_CancelASEntry = @"Cancel";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setMessageTextView:nil];
    [self setImagePreview:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)addPhotoTouched:(id)sender
{
    if( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] )
    {
        UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:k_CameraASEntry delegate:self cancelButtonTitle:k_CancelASEntry destructiveButtonTitle:nil
                                                        otherButtonTitles:k_CameraASEntry, k_PhotoLibraryASEntry, nil];
        [actionSheet showInView:self.view];
    }
    else
    {
        UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = TRUE;
        
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentModalViewController:imagePickerController animated:TRUE];
    }
}

- (IBAction)sendTouched:(id)sender
{
    // take message + photo, post as open graph object
    // send requests to all iOS friends
    // server-side - keep track of all requests, whomever receives first, keeps their request, delete all others from that bottle
    // allow them to 
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    const NSString* buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if( buttonTitle == k_PhotoLibraryASEntry )
    {
        UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = TRUE;
        
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentModalViewController:imagePickerController animated:TRUE];        
    }
    else if( buttonTitle == k_CameraASEntry )
    {
        UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = TRUE;
        
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentModalViewController:imagePickerController animated:TRUE];
    }
    else if( buttonTitle == k_CancelASEntry )
    {
        
    }
    else
    {
        NSLog( @"Unhandled buttonIndex: %d, %@", buttonIndex, buttonTitle );
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* chosenImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [imagePreview setImage:chosenImage];

    // keep image for upload
    
    [self dismissModalViewControllerAnimated:TRUE];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }

    return YES;
}


@end
