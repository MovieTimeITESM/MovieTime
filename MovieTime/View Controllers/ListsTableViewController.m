//
//  ListsTableViewController.m
//  MovieTime
//
//  Created by Iliana García on 10/29/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import "ListsTableViewController.h"
#import "ListsTableViewCell.h"
#import "ListsDetailViewController.h"
#import <HexColors/HexColor.h>
#import "PBList.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "ILSession.h"

@interface ListsTableViewController ()  <UITableViewDelegate, UITableViewDataSource, PBListCellDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *listTab;
@property (weak, nonatomic) IBOutlet UITableView *listsTableView;
@property (strong, nonatomic) NSMutableArray *allLists;
@property (strong, nonatomic) NSMutableArray *myLists;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation ListsTableViewController {
    PBList *_editingPBList;
    NSIndexPath *_editingListIndexPath;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadLists];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#22c064"];
    
    self.listsTableView.delegate = self;
    self.listsTableView.dataSource = self;
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor colorWithHexString:@"#22c064"];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.listsTableView addSubview:self.refreshControl];
    
    [self.refreshControl addTarget:self
                            action:@selector(loadLists)
                  forControlEvents:UIControlEventValueChanged];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self startRefreshControl];
}

- (void)loadLists {
    if ([self.listTab selectedSegmentIndex] == 0) {
        [PBList loadAllListsWithsuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            self.allLists = [NSMutableArray arrayWithArray:mappingResult.array];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.listsTableView reloadData];
                [self.refreshControl endRefreshing];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }];
        }
                                failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                        [self.refreshControl endRefreshing];
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
    else {
        [PBList loadlistsWithUserId:[activeSession currentUser].userId
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                self.myLists = [NSMutableArray arrayWithArray:mappingResult.array];
                                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                    [self.listsTableView reloadData];
                                    [self.refreshControl endRefreshing];
                                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                }];
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                    [self.refreshControl endRefreshing];
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
    // End the refreshing
    if (self.refreshControl) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"d MMM, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last Update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
    }
}

- (void)startRefreshControl {
    [self.refreshControl beginRefreshing];
    [self loadLists];
}

- (IBAction)listTabsValueDidChanged:(UISegmentedControl *)sender
{
    if (!self.allLists || !self.myLists) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self startRefreshControl];
    }
}

#pragma mark - Table view data source

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        _editingPBList = ([self.listTab selectedSegmentIndex] == 0) ? self.allLists[indexPath.row] : self.myLists[indexPath.row];
        _editingListIndexPath = indexPath;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm"
                                                        message:@"Are you sure you want to delete this list?"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Yes", nil];
        alert.tag = 103;
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 103) {
        if (buttonIndex == 0) {
            NSLog(@"Delete list confirmation user clicked on cancel");
        }
        else {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [PBList deleteListWithId:_editingPBList.listId
                             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                 [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                     if ([self.listTab selectedSegmentIndex] == 0) {
                                         [self.allLists removeObjectAtIndex:_editingListIndexPath.row];
                                     }
                                     else {
                                         [self.myLists removeObjectAtIndex:_editingListIndexPath.row];
                                     }
                                     [self.listsTableView deleteRowsAtIndexPaths:@[_editingListIndexPath]
                                                                withRowAnimation:UITableViewRowAnimationFade];
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
                                 NSLog(@"ERROR - Failed to delete list");
                             }];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if ([self.listTab selectedSegmentIndex] == 0) {
        return [self.allLists count];
    }
    return [self.myLists count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ListsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListCell"
                                                               forIndexPath:indexPath];
    
    PBList *object = self.allLists[indexPath.row];
    cell.nameLabel.text = object.name;
    cell.authorLabel.text = object.owner;
    cell.likeButton.enabled = !object.likedByUser;
    cell.likesCount.text = object.likes.stringValue;
    cell.delegate = self;
    if ([self.listTab selectedSegmentIndex] == 0) {
        cell.likeButton.tag = ((PBList* )self.allLists[indexPath.row]).listId.integerValue;
    }
    else {
        cell.likeButton.tag = ((PBList* )self.myLists[indexPath.row]).listId.integerValue;
    }
    cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:object.avatar]]] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile]];
    
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ShowDetailList"]) {
        PBList *object;
        NSIndexPath *indexPath = [self.listsTableView indexPathForSelectedRow];
        if ([self.listTab selectedSegmentIndex] == 0) {
            object = self.allLists[indexPath.row];
        }
        else {
            object = self.myLists[indexPath.row];
        }
        [[segue destinationViewController] setDetailItem:object];
    }
}

-(void)shouldReloadTable {
    [self loadLists];
}

@end
