//
//  MovieDetailViewController.m
//  MovieTime
//
//  Created by Iliana García on 10/28/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import "MovieDetailViewController.h"

@interface MovieDetailViewController ()

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
        self.titleLabel.text = [self.detailItem objectForKey:@"title"];
        self.yearLabel.text = [NSString stringWithFormat:@"%@",[self.detailItem objectForKey:@"year"]];
        id posters = [self.detailItem objectForKey:@"posters"];
        self.moviePoster.image  = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[posters objectForKey:@"profile"]]]];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"ShowTrailerMovie"]) {
        [[segue destinationViewController] setDetailItem:self.titleLabel.text];
    }
    
}


@end
