//
//  PBMovie.m
//  MovieTime
//
//  Created by Patricio Beltrán on 11/29/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import "PBMovie.h"

@implementation PBMovie

- (instancetype)initWithName:(NSString *)name
                        year:(NSNumber *)year
                       movId:(NSNumber *)movId
                      poster:(NSString *)poster
                     ratings:(NSNumber *)ratings
                 mpaaRatings:(NSString *)mpaaRating
                     runtime:(NSNumber *)runtime {
    self = [super init];
    if (self) {
        _name = name;
        _year = year;
        _movId = movId;
        _poster = poster;
        _ratings = ratings;
        _mpaaRatings = mpaaRating;
        _runtime = runtime;
    }
    return self;
}
@end
