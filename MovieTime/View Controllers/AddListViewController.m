//
//  AddListViewController.m
//  MovieTime
//
//  Created by Iliana García on 11/5/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import "AddListViewController.h"

@interface AddListViewController ()

@end

@implementation AddListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)hideKeyboard:(UITextField *)sender {
    [sender resignFirstResponder];
}
- (IBAction)unwindToLists:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

@end
