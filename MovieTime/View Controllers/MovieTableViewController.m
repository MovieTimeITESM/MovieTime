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

@interface MovieTableViewController ()
{
    NSMutableArray *movies;
    NSDictionary *movie;
}

@end

@implementation MovieTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *stringColor = @"#22c064";
    NSUInteger red, green, blue;
    sscanf([stringColor UTF8String], "#%02X%02X%02X", &red, &green, &blue);
    
    UIColor *color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
    self.navigationController.navigationBar.barTintColor = color;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    /*
    UIViewController *initialMainVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
    [self presentViewController:initialMainVC animated:YES completion:nil];
    */
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/



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
