//
//  ListsDetailViewController.m
//  MovieTime
//
//  Created by Iliana García on 10/29/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import "ListsDetailViewController.h"
#import "ILSession.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "PBMovie.h"
#import "PBListMovieTableViewCell.h"
#import "UIImageView+LBBlurredImage.h"

@interface ListsDetailViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *coverPhoto;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *authorLabel;
@property (strong, nonatomic) NSMutableArray *movies;
@property (weak, nonatomic) IBOutlet UITableView *moviesTableView;
@end

@implementation ListsDetailViewController {
    PBMovie *_editingPBMovie;
    NSIndexPath *_editingMovieIndexPath;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.moviesTableView.delegate = self;
    self.moviesTableView.dataSource = self;
    [self configureView];
    [self loadMovies];
}

- (void)setDetailItem:(PBList *)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.coverPhoto.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.detailItem.avatar]]];
        self.nameLabel.text = self.detailItem.name;
        self.authorLabel.text = self.detailItem.owner;
        self.likesLabel.text = self.detailItem.likes.stringValue;
    }
}

- (void)loadMovies {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [PBMovie loadMoviesWithListId:self.detailItem.listId
                      Withsuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                          self.movies = [NSMutableArray arrayWithArray:mappingResult.array];
                          [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                              [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                              [self.moviesTableView reloadData];
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
                              NSLog(@"ERROR - Could not load movies successfully.");
                          }];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"FromListToMovie"]) {
        [[segue destinationViewController] setDetailItem:self.movies[[self.moviesTableView indexPathForSelectedRow].row]];
    }
}

#pragma mark - TableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PBListMovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listMovieIdent"];
    
    if (cell == nil) {
        cell = [[PBListMovieTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"listMovieIdent"];
    }
    
    
    cell.nameLabel.text = ((PBMovie *)self.movies[indexPath.row]).name;
    cell.ratingNumber.text =((PBMovie *)self.movies[indexPath.row]).ratings.stringValue;
    [cell.movieImage setImageToBlur:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:((PBMovie *)self.movies[indexPath.row]).poster]]]
                         blurRadius:5.0f
                    completionBlock:nil];
    cell.movieImage.clipsToBounds = YES;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        _editingPBMovie = self.movies[indexPath.row];
        _editingMovieIndexPath = indexPath;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm"
                                                        message:@"Are you sure you want to delete this movie?"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Yes", nil];
        alert.tag = 104;
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 104) {
        if (buttonIndex == 0) {
            NSLog(@"Delete movie confirmation user clicked on cancel");
        }
        else {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [PBMovie deleteMovieWithListId:self.detailItem.listId
                                   movieId:_editingPBMovie.movieId
                             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                 [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                     [self.movies removeObjectAtIndex:_editingMovieIndexPath.row];
                                     [self.moviesTableView deleteRowsAtIndexPaths:@[_editingMovieIndexPath]
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.movies count];
}

- (IBAction)saveListLocally:(id)sender {
    NSLog(@"List should be saved on a database");
}


@end
