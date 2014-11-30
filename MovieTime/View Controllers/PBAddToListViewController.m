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
@property (strong, nonatomic) NSIndexPath *selectedCellIndexPath;
@end

@implementation PBAddToListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lists = [[NSArray alloc] init];
    [self loadData];
    self.continueButton.enabled = NO;
    self.userLists.delegate = self;
    self.userLists.dataSource = self;
}

- (IBAction)exitButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addButtonClicked:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //Call to PBList's add movie method with movie params
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
    
    if ([self.selectedCellIndexPath isEqual:indexPath]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = ((PBList *)self.lists[indexPath.row]).name;
    return cell;
}

#pragma mark - Helper methods

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

- (void)tableView:(UITableView *)tableView toogleChoosenCardOnIndexPathForPayment:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selectedCellIndexPath == indexPath) {
        self.selectedCellIndexPath = nil;
        self.continueButton.enabled = NO;
    }
    else {
        self.selectedCellIndexPath = indexPath;
        self.continueButton.enabled = YES;
    }
    [tableView reloadData];
}

@end
