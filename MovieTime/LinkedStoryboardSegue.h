//
//  LinkedStoryboardSegue.h
//  MovieTime
//
//  Created by Iliana García on 10/23/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LinkedStoryboardSegue : UIStoryboardSegue

+ (UIViewController *)sceneNamed:(NSString *)identifier;

@end