//
//  SettingsViewController.m
//  MovieTime
//
//  Created by Iliana García on 10/26/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import "SettingsViewController.h"
#import "ILSession.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+LBBlurredImage.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *starsNumber;
@property (weak, nonatomic) IBOutlet UILabel *listsNumber;
@property (weak, nonatomic) IBOutlet UILabel *likesNumber;
@property (strong, nonatomic) IBOutlet UIImageView *profilePic;
@property (strong, nonatomic) IBOutlet UIImageView *profileRound;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.profileRound.layer.cornerRadius = 50;
    self.profileRound.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profileRound.layer.borderWidth = 3;
    self.profileRound.clipsToBounds = YES;
    self.profilePic.clipsToBounds = YES;
    self.starsNumber.text = [activeSession currentUser].likesToUser.stringValue;
    self.likesNumber.text = [activeSession currentUser].likes.stringValue;
    self.listsNumber.text = [activeSession currentUser].lists.stringValue;
    self.userName.text = [activeSession currentUser].name;
    self.emailLabel.text = [activeSession currentUser].email;
    [self loadProfilePicture];
}

- (void)loadProfilePicture {
    NSString *profilePicURL = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", [activeSession currentUser].uid];
    
    [self.profilePic setImageToBlur:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:profilePicURL]]]
                         blurRadius:2.5f
                    completionBlock:nil];
    self.profileRound.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:profilePicURL]]];
}

- (IBAction)logoutButtonDidClicked:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^(){
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        ILUser *user = [[ILUser alloc] init];
        [user logOutWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            [activeSession clearSessionAndToken];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
                        failure:^(RKObjectRequestOperation *operation, NSError *error) {
                            NSLog(@"Error - Could not logout user");
                        }];
    }];
}

@end
