//
//  ListsTableViewCell.h
//  MovieTime
//
//  Created by Iliana García on 10/29/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PBListCellDelegate <NSObject>

- (void)shouldReloadTable;

@end

@interface ListsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *likesCount;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UILabel *authorLabel;
@property (strong, nonatomic) id<PBListCellDelegate> delegate;
@end
