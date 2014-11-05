//
//  ListsTableViewController.m
//  MovieTime
//
//  Created by Iliana García on 10/29/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import "ListsTableViewController.h"
#import "ListsTableViewCell.h"
#import "ListsDetailViewController.h"

@interface ListsTableViewController ()
{
    NSMutableArray *lists;
    NSDictionary *list;
}

@end

@implementation ListsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *names = [[NSMutableArray alloc] initWithObjects:   @"Ana's Wishlist",
                                                                @"Xmas Movies",
                                                                @"Movies 4 Kids",
                                                                nil];
    
    NSArray *authors = [[NSMutableArray alloc] initWithObjects: @"Ana Garza",
                                                                @"Juan Perez",
                                                                @"Gabriel Santos",
                                                                nil];
    
    if(!lists){
        lists = [[NSMutableArray alloc] init];
    }
    
    for(int i=0; i < [names count]; i++)
    {
        list = [[NSDictionary alloc] initWithObjectsAndKeys:
                 [names objectAtIndex:i], @"name",
                 [authors objectAtIndex:i], @"author",
                 nil];
        
        [lists addObject:list];
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
    return [lists count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ListsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListCell"
                                                               forIndexPath:indexPath];
    
    NSDictionary *object = lists[indexPath.row];
    
    cell.nameLabel.text = [object objectForKey:@"name"];
    cell.authorLabel.text = [object objectForKey:@"author"];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *listName = [lists[indexPath.row] objectForKey:@"name"];
    
    NSLog(@"%@", listName);
    
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"ShowDetailList"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *object = lists[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

@end
