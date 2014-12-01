//
//  MovieDetailViewController.m
//  MovieTime
//
//  Created by Iliana García on 10/28/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "PBAddToListViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MovieDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *runtimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *mpaaRatingLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *yearLabel;
@property (strong, nonatomic) IBOutlet UIImageView *moviePoster;
@end

@implementation MovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
}

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        [self configureView];
    }
}

- (void)configureView
{
    if (self.detailItem) {
        self.titleLabel.text = self.detailItem.name;
        self.yearLabel.text = self.detailItem.year.stringValue;
        self.runtimeLabel.text = self.detailItem.runtime.stringValue;
        self.mpaaRatingLabel.text = self.detailItem.mpaaRatings;
        self.ratingLabel.text = self.detailItem.ratings.stringValue;
        [self.moviePoster sd_setImageWithURL:[NSURL URLWithString:self.detailItem.poster]
                                              placeholderImage:[UIImage imageNamed:@""]];
        self.moviePoster.clipsToBounds = YES;
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ShowTrailerMovie"]) {
        [[segue destinationViewController] setDetailItem:self.detailItem];
    }
    else if ([[segue identifier] isEqualToString:@"addToList"]) {
        [((PBAddToListViewController *)[segue destinationViewController]) setMovie:self.detailItem];
    }
}

@end
