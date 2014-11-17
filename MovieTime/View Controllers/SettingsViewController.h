//
//  SettingsViewController.h
//  MovieTime
//
//  Created by Iliana García on 10/26/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *statusBarBg;
@property (strong, nonatomic) IBOutlet UINavigationBar *titleBar;
@property (strong, nonatomic) IBOutlet UIImageView *profilePic;
@property (strong, nonatomic) IBOutlet UILabel *likesLabel;
@property (strong, nonatomic) IBOutlet UILabel *listsLabel;
@property (strong, nonatomic) IBOutlet UILabel *starsLabel;
@property (strong, nonatomic) IBOutlet UIImageView *profileRound;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
- (IBAction)botonFacebook:(id)sender;
- (IBAction)botonTwitter:(id)sender;

@end
