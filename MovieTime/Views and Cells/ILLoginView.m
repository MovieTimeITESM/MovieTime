//
//  ILLoginView.m
//  Moneypool
//
//  Created by Patricio Beltran on 8/27/14.
//  Copyright (c) 2014 icalia labs. All rights reserved.
//

#import "ILLoginView.h"

@implementation ILLoginView

- (void)setLoginButtonImage
{
    for (id obj in self.subviews)
    {
        if ([obj isKindOfClass: [UIButton class]])
        {
            UIButton *loginButton = obj;
            UIImage *loginImage;
            if (self.buttonType == ILButtonTypeLogin)
            {
                loginImage = [UIImage imageNamed:@"fb-login-btn"];
            }
            else if (self.buttonType == ILButtonTypeConnect)
            {
                loginImage = [UIImage imageNamed:@"fb-connect-btn"];
            }
            [loginButton setBackgroundImage:loginImage forState:UIControlStateNormal];
            [loginButton setBackgroundImage:nil forState:UIControlStateSelected];
            [loginButton setBackgroundImage:nil forState:UIControlStateHighlighted];
            [loginButton sizeToFit];
            self.loginButton = loginButton;
        }
        if ([obj isKindOfClass:[UILabel class]])
        {
            UILabel * loginLabel =  obj;
            loginLabel.text = @"";
            loginLabel.textColor = [UIColor clearColor];
            loginLabel.textAlignment = NSTextAlignmentCenter;
            loginLabel.frame = CGRectMake(0, 0, 0, 0);
        }
    }
}

@end
