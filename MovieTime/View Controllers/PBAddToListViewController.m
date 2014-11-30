//
//  PBAddToListViewController.m
//  MovieTime
//
//  Created by Patricio Beltrán on 11/29/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import "PBAddToListViewController.h"
#import "PBList.h"
#import "ILSession.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface PBAddToListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UITableView *userLists;
@property (strong, nonatomic) NSArray *lists;
@end

@implementation PBAddToListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //load lists
    [self loadData];
    self.lists = [[NSArray alloc] init];
    self.continueButton.enabled = NO;
    self.userLists.delegate = self;
    self.userLists.dataSource = self;
}

- (IBAction)exitButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addButtonClicked:(id)sender {
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self tableView:tableView toogleChoosenCardOnIndexPathForPayment:indexPath];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.lists count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addListCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addListCell"];
    }
    
    cell.textLabel.text = ((PBList *)self.lists[indexPath.row]).name;
    return cell;
}

- (void)loadData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [PBList loadlistsWithUserId:[activeSession currentUser].userId
                        success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                            self.lists = [NSMutableArray arrayWithArray:mappingResult.array];
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                [self.userLists reloadData];
                                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                            }];
                        }
                        failure:^(RKObjectRequestOperation *operation, NSError *error) {
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Server is down."
                                                                                message:@"The server is having some troubles.\nPlease try again later."
                                                                               delegate:nil
                                                                      cancelButtonTitle:@"Ok"
                                                                      otherButtonTitles: nil];
                                [alert show];
                            }];
                            NSLog(@"ERROR - Could not load lists successfully.");
                        }];
}

@end
