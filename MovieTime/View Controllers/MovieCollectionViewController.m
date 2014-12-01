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
#import <MBProgressHUD/MBProgressHUD.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface MovieCollectionViewController ()  <UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) NSMutableArray *movies;
@property (nonatomic) BOOL isFromSearch;
@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) NSMutableData *responseData;
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
        NSURL *url = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?page_limit=15&page=1&country=us&apikey=aecvqpq4d9px7b87gj97psn6"];
        
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
        self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        self.responseData = [[NSMutableData alloc] init];
        self.isFromSearch = false;
    }
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    NSInteger statusCode = [httpResponse statusCode];
    NSLog(@"Rotten Tomatoes Search - Status %li", (long)statusCode);
    
    [self.responseData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error;
    
    NSDictionary *datos = [NSJSONSerialization JSONObjectWithData:self.responseData options:kNilOptions error:&error];
    
    [self setMovies:(NSMutableArray *)[datos objectForKey:@"movies"]];
    
    if(self.movies.count == 0){
        NSLog(@"No hay movies");
    }else{
        [self.collectionView reloadData];
        NSLog(@"title: %@, movies: %lu",((PBMovie *)self.movies[0]).name, (unsigned long)self.movies.count);
    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.responseData = nil;
    self.connection = nil;
    
    NSLog(@"Error en la conexion");
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
                                                     runtime:([movie[@"runtime"] isEqual:@""]) ? nil : movie[@"runtime"]
                                                alternateLink:movie[@"links"][@"alternate"]];
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
    cell.name.text = ((PBMovie *)self.movies[indexPath.row]).name;
    if (((PBMovie *)self.movies[indexPath.row]).runtime != nil) {
        cell.runtime.text = ((PBMovie *)self.movies[indexPath.row]).runtime.stringValue;
    }
    cell.year.text = ((PBMovie *)self.movies[indexPath.row]).year.stringValue;
    cell.rating.text = ((PBMovie *)self.movies[indexPath.row]).ratings.stringValue;
    
    
    [cell.coverImage sd_setImageWithURL:[NSURL URLWithString:((PBMovie *)self.movies[indexPath.row]).poster]
                       placeholderImage:[UIImage imageNamed:@""]
                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                  [self setBackgroundBluredForCell:cell];
                              }];
    return cell;
}

- (void)setBackgroundBluredForCell:(MovieCollectionViewCell *)cell {
    [cell.coverImage setImageToBlur:cell.coverImage.image
                         blurRadius:0.5f
                    completionBlock:nil];
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
