//
//  PBMovie.h
//  MovieTime
//
//  Created by Patricio Beltrán on 11/29/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PBMovie : NSObject
@property (nonatomic, strong) NSNumber *movieId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *year;
@property (nonatomic, copy) NSString *rottenId;
@property (nonatomic, copy) NSString *poster;
@property (nonatomic, strong) NSNumber *ratings;
@property (nonatomic, copy) NSString *mpaaRatings;
@property (nonatomic, strong) NSNumber *runtime;

- (instancetype)initWithName:(NSString *)name
                        year:(NSNumber *)year
                       movId:(NSString *)movId
                      poster:(NSString *)poster
                     ratings:(NSNumber *)ratings
                 mpaaRatings:(NSString *)mpaaRating
                     runtime:(NSNumber *)runtime;
@end
