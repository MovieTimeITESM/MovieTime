//
//  ListsDetailViewController.h
//  MovieTime
//
//  Created by Iliana García on 10/29/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListsDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *listLabel;

@end