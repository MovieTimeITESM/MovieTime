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
#import "UIImageView+LBBlurredImage.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DBManager.h"

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
    BOOL _appendToList;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.allLists = [[NSMutableArray alloc] init];
    self.myLists = [[NSMutableArray alloc] init];
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
    _appendToList = NO;
    [self loadPublicLists];
    [self loadPrivateLists];
}

- (void)loadPrivateLists {
    if ([self.listTab selectedSegmentIndex] == 1) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        if (_appendToList) {
            [self.myLists addObjectsFromArray:[[DBManager getSharedInstance] findAllLists]];
        }
        else {
            self.myLists = [NSMutableArray arrayWithArray:[[DBManager getSharedInstance] findAllLists]];
            _appendToList = YES;
        }
        [self.listsTableView reloadData];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }
}

- (void)loadPublicLists {
    if ([self.listTab selectedSegmentIndex] == 0) {
        [PBList loadAllListsWithsuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            if (_appendToList) {
                [self.allLists addObjectsFromArray:mappingResult.array];
            }
            else {
                self.allLists = [NSMutableArray arrayWithArray:mappingResult.array];
                _appendToList = YES;
            }
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
                                if (_appendToList) {
                                    [self.myLists addObjectsFromArray:mappingResult.array];
                                }
                                else {
                                    self.myLists = [NSMutableArray arrayWithArray:mappingResult.array];
                                    _appendToList = YES;
                                }
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
    if ([self.listTab selectedSegmentIndex] == 1 && !self.myLists) {
        [self startRefreshControl];
    }
    [self loadLists];
}


#pragma mark - Table view data source

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    if ([self.listTab selectedSegmentIndex] == 0) {
        return [((PBList *)self.allLists[indexPath.row]).owner isEqualToString:[activeSession currentUser].name];
    }
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
    
    PBList *object = ([self.listTab selectedSegmentIndex] == 0) ? self.allLists[indexPath.row] : self.myLists[indexPath.row];
    cell.nameLabel.text = object.name;
    cell.authorLabel.text = object.owner;
    if (object.likedByUser) {
        [cell.likeButton setImage:[UIImage imageNamed:@"lists-dashboard-liked"] forState:UIControlStateNormal];
    } else {
       [cell.likeButton setImage:[UIImage imageNamed:@"lists-dashboard-like"] forState:UIControlStateNormal];
    }
    cell.likeButton.enabled = !object.likedByUser;
    cell.likesCount.text = object.likes.stringValue;
    cell.delegate = self;
    cell.likeButton.tag = object.listId.integerValue;
    cell.backgroundView = [[UIImageView alloc] init];
    [(UIImageView *)cell.backgroundView sd_setImageWithURL:[NSURL URLWithString:object.avatar]
                                          placeholderImage:[UIImage imageNamed:@""]
                                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                     [self setBackgroundBluredForCell:cell];
                                                 }];
    
    return cell;
}

- (void)setBackgroundBluredForCell:(ListsTableViewCell *)cell {
    ((UIImageView *)cell.backgroundView).contentMode = UIViewContentModeScaleAspectFill;
    ((UIImageView *)cell.backgroundView).clipsToBounds = YES;
    [((UIImageView *)cell.backgroundView) setImageToBlur:((UIImageView *)cell.backgroundView).image
                         blurRadius:2.5f
                    completionBlock:nil];
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
