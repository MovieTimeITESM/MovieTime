//
//  MovieTableViewController.m
//  MovieTime
//
//  Created by Iliana García on 10/29/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import "MovieTableViewController.h"
#import "MovieTableViewCell.h"
#import "MovieDetailViewController.h"
#import <HexColors/HexColor.h>

@interface MovieTableViewController ()  <UITableViewDelegate, UITableViewDataSource>
@end

@implementation MovieTableViewController {
    NSMutableArray *movies;
    NSDictionary *movie;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#22c064"];
    
    NSArray *titles = [[NSArray alloc] initWithObjects: @"Toy Story",
                                                        @"Monsters, Inc.",
                                                        @"Finding Nemo",
                                                        nil];
    
    NSArray *years = [[NSArray alloc] initWithObjects:  @"1995",
                                                        @"2001",
                                                        @"2003",
                                                        nil];
    
    if(!movies){
        movies = [[NSMutableArray alloc] init];
    }
    
    for(int i=0; i < [titles count]; i++)
    {
        movie = [[NSDictionary alloc] initWithObjectsAndKeys:
                 [titles objectAtIndex:i], @"title",
                 [years objectAtIndex:i], @"year",
                 nil];
        
        [movies addObject:movie];
    }
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [movies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"
                                                               forIndexPath:indexPath];
    
    NSDictionary *object = movies[indexPath.row];
    
    cell.titleLabel.text = [object objectForKey:@"title"];
    cell.yearLabel.text = [object objectForKey:@"year"];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *movieTitle = [movies[indexPath.row] objectForKey:@"title"];
    
    NSLog(@"%@", movieTitle);
    
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"ShowDetailMovie"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *object = movies[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}


@end
