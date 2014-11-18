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
#import <HexColors/HexColor.h>

@interface ListsTableViewController ()  <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *listsTableView;

@end

@implementation ListsTableViewController {
    NSMutableArray *lists;
    NSDictionary *list;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#22c064"];
    
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
    
    self.listsTableView.delegate = self;
    self.listsTableView.dataSource = self;
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
    cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"lists-dashboard-bg"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile]];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *listName = [lists[indexPath.row] objectForKey:@"name"];
    NSLog(@"%@", listName);
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"ShowDetailList"]) {
        NSIndexPath *indexPath = [self.listsTableView indexPathForSelectedRow];
        NSDictionary *object = lists[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

@end
