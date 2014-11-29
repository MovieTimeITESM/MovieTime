//
//  ListsTableViewCell.m
//  MovieTime
//
//  Created by Iliana García on 10/29/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import "ListsTableViewCell.h"
#import "PBList.h"
#import <MBProgressHUD/MBProgressHUD.h>

@implementation ListsTableViewCell

- (IBAction)likesButton:(UIButton *)sender {
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    [PBList voteForListWithId:[NSNumber numberWithInteger:sender.tag]
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                          [MBProgressHUD hideAllHUDsForView:self animated:YES];
                          [self.delegate shouldReloadTable];
                      }
                      failure:^(RKObjectRequestOperation *operation, NSError *error) {
                          [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                              [MBProgressHUD hideAllHUDsForView:self animated:YES];
                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Server is down."
                                                                              message:@"The server is having some troubles.\nPlease try again later."
                                                                             delegate:nil
                                                                    cancelButtonTitle:@"Ok"
                                                                    otherButtonTitles: nil];
                              [alert show];
                          }];
                          NSLog(@"ERROR - Could not vote for list successfully.");
                      }];
}

@end
