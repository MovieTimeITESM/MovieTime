//
//  AddListViewController.m
//  MovieTime
//
//  Created by Iliana García on 11/5/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import "AddListViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <QuartzCore/QuartzCore.h>
#import <HexColors/HexColor.h>

@interface AddListViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UIButton *addAvatar;
@end

@implementation AddListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.continueButton.enabled = NO;
    self.name.delegate = self;
}

- (IBAction)hideKeyboard:(UITextField *)sender {
    [sender resignFirstResponder];
}
- (IBAction)unwindToLists:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (BOOL)shouldEnableContinueButtonWithTextField:(UITextField *)textField replacementString:(NSString *)string range:(NSRange)range {
    if (textField == self.name) {
        return self.avatar.image != nil && (range.location == 0  ? string.length > 0 : YES);
    }
    return self.avatar.image != nil && [self.name hasText];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    self.continueButton.enabled = [self shouldEnableContinueButtonWithTextField:textField replacementString:string range:range];
    return YES;
}
- (IBAction)createListDidClicked:(UIButton *)sender {
    NSLog(@"HEEY - ESAFNSF");
}

#pragma mark - Add Image

- (IBAction)addAvatarButtonPressed:(id)sender {
    UIActionSheet *imageSelection = [[UIActionSheet alloc] initWithTitle:nil
                                                                delegate:self
                                                       cancelButtonTitle:@"Cancel"
                                                  destructiveButtonTitle:nil
                                                       otherButtonTitles:@"Take Photo", @"Choose Existing Photo", nil];
    [imageSelection showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.mediaTypes = @[(NSString *) kUTTypeImage];
    switch (buttonIndex) {
        case 0:
        {
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePickerController animated:YES completion:nil];
            break;
        }
        case 1:
        {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePickerController animated:YES completion:nil];
            break;
        }
    }
}

- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToSave;
    
    // Handle a still image capture
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)
        == kCFCompareEqualTo) {
        
        editedImage = (UIImage *) [info objectForKey:
                                   UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:
                                     UIImagePickerControllerOriginalImage];
        
        if (editedImage) {
            imageToSave = editedImage;
        }
        else {
            imageToSave = originalImage;
        }
    }
    
    self.avatar.frame = CGRectMake(0.0f, 0.0f, 320.0f, 241.0f);
    self.avatar.clipsToBounds = YES;
    [self.avatar setContentMode:UIViewContentModeScaleAspectFill];
    self.avatar.image = imageToSave;
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
    NSRange a = {0,0};
    self.continueButton.enabled = [self shouldEnableContinueButtonWithTextField:nil replacementString:nil range:a];
}

@end
