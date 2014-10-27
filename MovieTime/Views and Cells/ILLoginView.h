//
//  ILLoginView.h
//  Moneypool
//
//  Created by Patricio Beltran on 8/27/14.
//  Copyright (c) 2014 icalia labs. All rights reserved.
//

#import "FBLoginView.h"
#import <Facebook-iOS-SDK/FacebookSDK/FacebookSDK.h>

/**
 Specifies the type of the button. It should be
 a reference for the different uses of the FBLoginButton.
 */
typedef NS_ENUM(NSInteger, ILButtonType)  {
    ILButtonTypeNotSpecified = 0,
    ILButtonTypeLogin,
    ILButtonTypeConnect
};

/**
 View that manages the FBLogin View.
 */
@interface ILLoginView : FBLoginView

/**
 Button used to handle the login logic for FB.
 */
@property (weak, nonatomic) UIButton *loginButton;

/**
 Set to specify what behavoir should the button follow according to its type.
 */
@property (nonatomic, assign) ILButtonType buttonType;


/**
 Changes the default LoginButton from Facebook to show a button
 that goes with the Moneypool Brand.
 */
- (void)setLoginButtonImage;

@end
