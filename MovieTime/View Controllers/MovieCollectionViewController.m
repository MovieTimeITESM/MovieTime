//
//  MovieTableViewController.m
//  MovieTime
//
//  Created by Iliana García on 10/29/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import "MovieCollectionViewController.h"
#import "MovieCollectionViewCell.h"
#import "MovieDetailViewController.h"
#import <HexColors/HexColor.h>
#import "PBMovie.h"
#import "UIImageView+LBBlurredImage.h"

@interface MovieCollectionViewController ()  <UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) NSMutableArray *movies;
@property (nonatomic) BOOL isFromSearch;
@end

@implementation MovieCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#22c064"];
    self.navigationController.navigationBar.translucent = NO;
    
    if(self.isFromSearch){
        [self.collectionView reloadData];
    }
    else{
      //Load showtime movies
    }
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)setMovies:(NSMutableArray *)movies {
    NSMutableArray *tempMappingArray = [[NSMutableArray alloc] init];
    for (NSDictionary *movie in movies) {
        PBMovie *movieObject = [[PBMovie alloc] initWithName:movie[@"title"]
                                                        year:movie[@"year"]
                                                       movId:movie[@"id"]
                                                      poster:[movie[@"posters"][@"original"] stringByReplacingOccurrencesOfString:@"_tmb" withString:@"_det" ]
                                                     ratings:movie[@"ratings"][@"audience_score"]
                                                 mpaaRatings:movie[@"mpaa_rating"]
                                                     runtime:movie[@"runtime"]];
        [tempMappingArray addObject:movieObject];
    }
    _movies = tempMappingArray;
}

- (void)setIsFromSearch:(BOOL)isFromSearch {
    _isFromSearch = isFromSearch;
}

#pragma mark - Collection view data source

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MovieCollectionViewCell* cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCell"
                                                                                   forIndexPath:indexPath];
    cell.mpaaRating.text = ((PBMovie *)self.movies[indexPath.row]).mpaaRatings;
    cell.rating.text = ((PBMovie *)self.movies[indexPath.row]).ratings.stringValue;
    cell.name.text = ((PBMovie *)self.movies[indexPath.row]).name;
    cell.runtime.text = ((PBMovie *)self.movies[indexPath.row]).runtime.stringValue;
    cell.year.text = ((PBMovie *)self.movies[indexPath.row]).year.stringValue;
    
    [cell.coverImage setImageToBlur:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:((PBMovie *)self.movies[indexPath.row]).poster]]]
                         blurRadius:0.5f
                    completionBlock:nil];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.movies count];
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"ShowDetailMovie"]) {
        NSArray *indexPaths = [self.collectionView indexPathsForSelectedItems];
        NSIndexPath *index = [indexPaths objectAtIndex:0];
        [[segue destinationViewController] setDetailItem:self.movies[index.row]];
    }
}


@end
