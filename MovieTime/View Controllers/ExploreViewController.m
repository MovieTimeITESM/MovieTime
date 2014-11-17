//
//  ExploreViewController.m
//  MovieTime
//
//  Created by Iliana García on 10/26/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import "ExploreViewController.h"

@interface ExploreViewController ()

@end

@implementation ExploreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *stringColor = @"#22c064";
    NSUInteger red, green, blue;
    sscanf([stringColor UTF8String], "#%02X%02X%02X", &red, &green, &blue);
    
    UIColor *color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
    
    self.titleBar.translucent = NO;
    self.titleBar.barTintColor = color;
    
    self.searchTextField.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.searchTextField) {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
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
