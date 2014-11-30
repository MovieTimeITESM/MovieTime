//
//  MovieDetailViewController.m
//  MovieTime
//
//  Created by Iliana García on 10/28/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import "MovieDetailViewController.h"

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
    // Do any additional setup after loading the view.
    
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDetailItem:(id)newDetailItem
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
        self.titleLabel.text = self.detailItem.name;
        self.yearLabel.text = self.detailItem.year.stringValue;
        self.runtimeLabel.text = self.detailItem.runtime.stringValue;
        self.mpaaRatingLabel.text = self.detailItem.mpaaRatings;
        self.ratingLabel.text = self.detailItem.ratings.stringValue;
        self.moviePoster.image  = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.detailItem.poster]]];
        self.moviePoster.clipsToBounds = YES;
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"ShowTrailerMovie"]) {
        [[segue destinationViewController] setDetailItem:self.detailItem];
    }
    else if ([[segue identifier] isEqualToString:@"addToList"]) {
        //Pass PBMovie to view controller
    }
}

@end
