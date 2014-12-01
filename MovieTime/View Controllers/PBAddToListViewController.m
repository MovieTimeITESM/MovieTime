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
#import "DBManager.h"

@interface PBAddToListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UITableView *userLists;
@property (strong, nonatomic) NSMutableArray *lists;
@property (strong, nonatomic) NSIndexPath *selectedCellIndexPath;
@end

@implementation PBAddToListViewController {
    BOOL _appendToList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lists = [[NSMutableArray alloc] init];
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
    [PBMovie createMovieWithListId:((PBList *)self.lists[self.selectedCellIndexPath.row]).listId
                        parameters:@{
                                     @"name" : self.movie.name,
                                     @"year" : self.movie.year.stringValue,
                                     @"rotten_id" : self.movie.rottenId,
                                     @"poster" : self.movie.poster,
                                     @"ratings" : self.movie.ratings.stringValue,
                                     @"mpaa_ratings" : self.movie.mpaaRatings,
                                     @"runtime" : self.movie.runtime.stringValue,
                                     }
                       Withsuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                           [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                               [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                               [self dismissViewControllerAnimated:YES completion:nil];
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
                               NSLog(@"ERROR - Could not create movie successfully.");
                           }];
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
    _appendToList = NO;
    [self loadPublicLists];
    [self loadPrivateLists];
}

- (void)loadPublicLists {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [PBList loadlistsWithUserId:[activeSession currentUser].userId
                        success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                            if (_appendToList) {
                                [self.lists addObjectsFromArray:mappingResult.array];
                            }
                            else {
                                self.lists = [NSMutableArray arrayWithArray:mappingResult.array];
                                _appendToList = YES;
                            }
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

- (void)loadPrivateLists {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (_appendToList) {
        [self.lists addObjectsFromArray:[[DBManager getSharedInstance] findAllLists]];
    }
    else {
        self.lists = [NSMutableArray arrayWithArray:[[DBManager getSharedInstance] findAllLists]];
        _appendToList = YES;
    }
    [self.userLists reloadData];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
