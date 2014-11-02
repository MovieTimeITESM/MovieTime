//
//  ViewController.m
//  MovieTime
//
//  Created by Patricio Beltrán on 10/20/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import "LoginViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "ILSession.h"

@interface LoginViewController ()<FBLoginViewDelegate>
@property (weak, nonatomic) IBOutlet ILLoginView *loginView;
@end

@implementation LoginViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.loginView.buttonType = ILButtonTypeLogin;
    self.loginView.delegate = self;
    self.loginView.hidden = NO;
    [self.loginView setLoginButtonImage];
    
    self.loginView.readPermissions = @[@"email",  @"user_birthday", @"user_location"];
    self.loginView.defaultAudience = FBSessionDefaultAudienceFriends;
}

#pragma mark - FBLoginViewDelegate

-(BOOL)isAccessTokenValidForSession:(FBSession *)fbSession
{
    NSDate *expirationDate = [[fbSession accessTokenData] expirationDate];
    NSDate *today = [NSDate date];
    return [today compare:expirationDate] == NSOrderedAscending;
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    
    // if access token is expired close session
    if (![self isAccessTokenValidForSession:[FBSession activeSession]]) {
        [[FBSession activeSession] closeAndClearTokenInformation];
        return;
    }
    
    NSString *accessToken = [FBSession activeSession].accessTokenData.accessToken;
    
    //Show progress spinner
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ILUser loginWithAccessToken:accessToken
                         success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                             
                             [[UIApplication sharedApplication] setStatusBarHidden:NO];
                             
                             ILUser *currentUser = mappingResult.array[0];
                             [ILSession newSessionForUser:currentUser];
                             
                             //Hide progress spinner
                             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                             
                             UIViewController *initialMainVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
                             [self presentViewController:initialMainVC animated:YES completion:nil];
                             
                         } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                             [[FBSession activeSession] closeAndClearTokenInformation];
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Server down"
                                                                             message:@"The server is currently down.\nPlease try to login again later"
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"OK"
                                                                   otherButtonTitles: nil];
                             [alert show];
                         }];
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error{
    NSLog(@"FBLogin Error - %@", error);
    ACAccountStore *accountStore;
    ACAccountType *accountTypeFB;
    
    if ((accountStore = [[ACAccountStore alloc] init]) &&
        (accountTypeFB = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook])){
        
        NSArray *fbAccounts = [accountStore accountsWithAccountType:accountTypeFB];
        id account;
        if (fbAccounts && [fbAccounts count] > 0 && (account = [fbAccounts objectAtIndex:0])){
            [accountStore renewCredentialsForAccount:account completion:^(ACAccountCredentialRenewResult renewResult, NSError *error) {
                //we don't actually need to inspect renewResult or error.
                if (error){ }
            }];
        }
    }
}


@end
