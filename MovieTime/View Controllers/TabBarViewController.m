//
//  TabBarViewController.m
//  MovieTime
//
//  Created by Juan Lorenzo Gonzalez on 11/16/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import "TabBarViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0f],
                                                        NSForegroundColorAttributeName : [UIColor whiteColor]
                                                        } forState:UIControlStateNormal];
    
    UITabBar *tabBar = self.tabBar;
    // repeat for every tab, but increment the index each time
    UITabBarItem *firstTab = [tabBar.items objectAtIndex:0];
    
    // also repeat for every tab
    firstTab.image = [[UIImage imageNamed:@"tab-bar-explore"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    
    UITabBarItem *secondTab = [tabBar.items objectAtIndex:1];
    
    // also repeat for every tab
    secondTab.image = [[UIImage imageNamed:@"tab-bar-lists"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    
    UITabBarItem *thirdTab = [tabBar.items objectAtIndex:2];
    
    // also repeat for every tab
    thirdTab.image = [[UIImage imageNamed:@"tab-bar-showtime"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    
    UITabBarItem *fourthTab = [tabBar.items objectAtIndex:3];
    
    // also repeat for every tab
    fourthTab.image = [[UIImage imageNamed:@"tab-bar-profile"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    
    NSString *stringColor = @"#22c064";
    NSUInteger red, green, blue;
    sscanf([stringColor UTF8String], "#%02X%02X%02X", &red, &green, &blue);
    
    UIColor *color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
    
    [[UITabBar appearance] setBarTintColor:color /*#22c064*/];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

@end
