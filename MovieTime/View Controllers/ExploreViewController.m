//
//  ExploreViewController.m
//  MovieTime
//
//  Created by Iliana García on 10/26/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import "ExploreViewController.h"
#import "MovieCollectionViewController.h"
#import <HexColors/HexColor.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface ExploreViewController ()
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (strong, nonatomic) NSArray *movies;
@property BOOL searchMovie;
@end

@implementation ExploreViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.searchTextField.delegate = self;
    self.searchView.layer.cornerRadius = 15;
    self.topView.backgroundColor = [UIColor colorWithHexString:@"#22c064"];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#22c064"];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSURL *url = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?limit=30&country=us&apikey=aecvqpq4d9px7b87gj97psn6"];
        
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
        self.searchMovie = NO;
        self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        self.responseData = [[NSMutableData alloc] init];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.searchTextField) {
        [textField resignFirstResponder];
        NSString *searchTerm = [self.searchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/movies.json?q=%@&page_limit=10&page=1&apikey=aecvqpq4d9px7b87gj97psn6",searchTerm]];
        
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
        self.searchMovie = YES;
        self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        self.responseData = [[NSMutableData alloc] init];
        
        return NO;
    }
    return YES;
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
    self.movies = [datos objectForKey:@"movies"];
    
    if(self.movies.count == 0){
        NSLog(@"No hay movies");
    }else{
        //NSLog(@"title: %@, movies: %i",[self.movies[0] objectForKey:@"title"], self.movies.count);
    }
    if(self.searchMovie){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self performSegueWithIdentifier:@"search" sender:self];
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        int randNum = arc4random() % (29 - 0) + 0;
        NSLog(@"%@",self.movies[randNum][@"title"]);
        self.exploreImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.movies[randNum][@"posters"][@"original"] stringByReplacingOccurrencesOfString:@"_tmb" withString:@"_det" ]]]];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.responseData = nil;
    self.connection = nil;
    
    NSLog(@"Error en la conexion");
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"search"])
    {
        MovieCollectionViewController *movieVC = [segue destinationViewController];
        [movieVC setIsFromSearch:YES];
        [movieVC setMovies:(NSMutableArray*)self.movies];
    }
}

@end
