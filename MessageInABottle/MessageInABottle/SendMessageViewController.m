//
//  SendMessageViewController.m
//  MessageInABottle
//
//  Created by Karl Schmidt on 2012-09-20.
//  Copyright (c) 2012 Adrian Crook & Associates. All rights reserved.
//

#import "SendMessageViewController.h"
#import "MIABProtocols.h"

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
    
    if( self.imagePreview.image != nil )
    {
        [self postPhotoThenOpenGraphAction];
    }
    else
    {
        [self postOpenGraphActionWithPhotoURL: nil];
    }
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

static NSString* k_ServerURL = @"https://intense-fjord-7538.herokuapp.com/bottle.php";
static NSString* k_AppID = @"283702078409452";
//static NSString* k_ImageURL = @"http://www.karlschmidt.net/AC%26A/PlayRank/testOGImage.png";

- (id<MIABOGBottle>)bottleObjectForMessage:(NSString*)message
{
    id<MIABOGBottle> result = (id<MIABOGBottle>)[FBGraphObject graphObject];

    static NSString* format =
    @"%@?"
    @"fb:app_id=%@&og:type=%@&"
    @"og:title=%@&og:description=%%22%@%%22&"
    @"og:image=%@&"
    @"worldhackbottleapp:messages=%@&"
    @"body=%@";
    
    static NSString* athlete = @"227877630672470";
    
    result.url = [NSString stringWithFormat:format,
                  k_ServerURL, k_AppID, @"worldhackbottleapp:bottle", @"Bottle", @"Bottle Description",
                  @"https://s-static.ak.fbcdn.net/images/devsite/attachment_blank.png", message, @"Bottle"];
    
    return result;
}

- (void)postOpenGraphActionWithPhotoURL:(NSString *)photoURL
{
    // First create the Open Graph meal object for the meal we ate.
    id<MIABOGBottle> bottleObject = [self bottleObjectForMessage:messageTextView.text];
    
    // Now create an Open Graph eat action with the meal, our location, and the people we were with.
    id<MIABOGThrowBottleAction> action = (id<MIABOGThrowBottleAction>)[FBGraphObject graphObject];
    action.bottle = bottleObject;

    if (photoURL)
    {
        NSMutableDictionary *image = [[NSMutableDictionary alloc] init];
        [image setObject:photoURL forKey:@"url"];
        
        NSMutableArray *images = [[NSMutableArray alloc] init];
        [images addObject:image];
        
        action.image = images;
    }
    
    // Create the request and post the action to the "me/fb_sample_scrumps:eat" path.
    [FBRequestConnection startForPostWithGraphPath:@"me/worldhackbottleapp:throw"
                                       graphObject:action
                                 completionHandler:^(FBRequestConnection *connection,
                                                     id result,
                                                     NSError *error) {
                                     //[self.activityIndicator stopAnimating];
                                     //[self.view setUserInteractionEnabled:YES];
                                     
                                     NSString *alertText;
                                     if (!error)
                                     {
                                         alertText = [NSString stringWithFormat:@"Posted Open Graph action, id: %@",
                                                      [result objectForKey:@"id"]];
                                         
                                         // start over
                                         [self.navigationController popViewControllerAnimated:TRUE];
                                     }
                                     else
                                     {
                                         alertText = [NSString stringWithFormat:@"error: domain = %@, code = %d",
                                                      error.domain, error.code];
                                     }
                                     [[[UIAlertView alloc] initWithTitle:@"Result"
                                                                 message:alertText
                                                                delegate:nil
                                                       cancelButtonTitle:@"Thanks!"
                                                       otherButtonTitles:nil]
                                      show];
                                 }];
}

// FBSample logic
// Creates an Open Graph Action using the user-specified properties, optionally first
// uploading a photo to Facebook and attaching it to the action.
- (void)postPhotoThenOpenGraphAction
{
    FBRequestConnection *connection = [[FBRequestConnection alloc] init];
    
    // First request uploads the photo.
    FBRequest *request1 = [FBRequest requestForUploadPhoto:self.imagePreview.image];
    [connection addRequest:request1
         completionHandler:
     ^(FBRequestConnection *connection, id result, NSError *error)
    {
         if (!error) {
         }
     }
            batchEntryName:@"photopost"
     ];
    
    // Second request retrieves photo information for just-created photo so we can grab its source.
    FBRequest *request2 = [FBRequest requestForGraphPath:@"{result=photopost:$.id}"];
    [connection addRequest:request2
         completionHandler:
     ^(FBRequestConnection *connection, id result, NSError *error) {
         if (!error &&
             result) {
             NSString *source = [result objectForKey:@"source"];
             [self postOpenGraphActionWithPhotoURL:source];
         }
     }
     ];
    
    [connection start];
}

@end
