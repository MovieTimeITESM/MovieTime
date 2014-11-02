//
//  SettingsViewController.m
//  MovieTime
//
//  Created by Iliana García on 10/26/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import "SettingsViewController.h"
#import "ILSession.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)logoutButtonDidClicked:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^(){
        ILUser *user = [[ILUser alloc] init];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        [user logOutWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            [activeSession clearSessionAndToken];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
                        failure:^(RKObjectRequestOperation *operation, NSError *error) {
                            NSLog(@"Error - Could not logout user");
                        }];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
