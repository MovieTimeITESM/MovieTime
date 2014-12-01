//
//  ExploreViewController.h
//  MovieTime
//
//  Created by Iliana García on 10/26/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExploreViewController : UIViewController <UITextFieldDelegate, NSURLConnectionDataDelegate, NSURLConnectionDelegate, UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) IBOutlet UIImageView *exploreImageView;

@end
