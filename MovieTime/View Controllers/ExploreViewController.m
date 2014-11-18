//
//  ExploreViewController.m
//  MovieTime
//
//  Created by Iliana García on 10/26/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import "ExploreViewController.h"
#import <HexColors/HexColor.h>

@interface ExploreViewController ()
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@end

@implementation ExploreViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.searchTextField.delegate = self;
    self.searchView.layer.cornerRadius = 15;
    self.topView.backgroundColor = [UIColor colorWithHexString:@"#22c064"];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.searchTextField) {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
