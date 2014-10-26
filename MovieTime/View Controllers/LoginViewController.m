//
//  ViewController.m
//  MovieTime
//
//  Created by Patricio Beltrán on 10/20/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (IBAction)goToTest {
    UIStoryboard *testStoryboard = [UIStoryboard storyboardWithName:@"Test" bundle:nil];
    UIViewController *initialTestVC = [testStoryboard instantiateInitialViewController];
    initialTestVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:initialTestVC animated:YES completion:nil];
}

-(IBAction)goToMain {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *initialMainVC = [mainStoryboard instantiateInitialViewController];
    initialMainVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:initialMainVC animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
