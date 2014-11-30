//
//  MovieTrailerViewController.m
//  MovieTime
//
//  Created by Iliana García on 10/28/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import "MovieTrailerViewController.h"

@interface MovieTrailerViewController ()
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation MovieTrailerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configureView];
}

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    
    if (self.detailItem) {
        self.titleLabel.text = self.detailItem.name;
    }
}

@end
