//
//  MovieTableViewController.h
//  MovieTime
//
//  Created by Iliana García on 10/29/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCollectionViewController : UICollectionViewController
- (void)setIsFromSearch:(BOOL)isFromSearch;
- (void)setMovies:(NSMutableArray *)movies;
@end
