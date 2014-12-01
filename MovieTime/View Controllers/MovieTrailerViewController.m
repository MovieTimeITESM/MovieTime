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
@property (strong, nonatomic) NSDictionary *trailer;
@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) NSMutableData *responseData;
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
    
    self.trailer = [[[[[datos objectForKey:@"feed"] objectForKey:@"entry"] objectAtIndex:0] objectForKey:@"link"] objectAtIndex:0];
    
    
    if(!self.trailer){
        NSLog(@"No hay Trailer");
    }else{
        NSURL *url = [NSURL URLWithString:[self.trailer objectForKey:@"href"]];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        NSLog(@"%@", [self.trailer objectForKey:@"href"]);
        
        [self.trailerWebView loadRequest:requestObj];
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.responseData = nil;
    self.connection = nil;
    
    NSLog(@"Error en la conexion");
}

- (void)configureView {
    // Update the user interface for the detail item.
    
    if (self.detailItem) {
        self.titleLabel.text = self.detailItem.name;
        
        NSString *searchTerm = [self.detailItem.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://gdata.youtube.com/feeds/api/videos?v=2&alt=json&max-results=1&q=allintitle:%@&format=5&prettyprint=true", searchTerm]];
        
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
        self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        self.responseData = [[NSMutableData alloc] init];

    }
}

@end
