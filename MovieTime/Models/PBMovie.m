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
                       movId:(NSString *)movId
                      poster:(NSString *)poster
                     ratings:(NSNumber *)ratings
                 mpaaRatings:(NSString *)mpaaRating
                     runtime:(NSNumber *)runtime {
    self = [super init];
    if (self) {
        _name = name;
        _year = year;
        _rottenId = movId;
        _poster = poster;
        _ratings = ratings;
        _mpaaRatings = mpaaRating;
        _runtime = runtime;
    }
    return self;
}

+ (void)createMovieWithListId:(NSNumber *)listId
                   parameters:(NSDictionary *)parameters
                  Withsuccess:(RKSuccessBlock)success
                        failure:(RKFailureBlock)failure {
    
    [[RKObjectManager sharedManager] postObject:[[PBMovie alloc] init]
                                          path:[NSString stringWithFormat:@"lists/%@/movies", listId]
                                     parameters:@{ @"list_id" : listId.stringValue,
                                                   @"movie" : parameters
                                                   }
                                       success:success
                                       failure:failure];
}

+ (void)loadMoviesWithListId:(NSNumber *)listId
                 Withsuccess:(RKSuccessBlock)success
                        failure:(RKFailureBlock)failure {
    
    [[RKObjectManager sharedManager] getObject:[[PBMovie alloc] init]
                                          path:[NSString stringWithFormat:@"lists/%@/movies", listId]
                                    parameters:nil
                                       success:success
                                       failure:failure];
}

+ (void)deleteMovieWithListId:(NSNumber *)listId
                      movieId:(NSNumber *)movieId
                 success:(RKSuccessBlock)success
                 failure:(RKFailureBlock)failure {
    
    [[RKObjectManager sharedManager] deleteObject:[[PBMovie alloc] init]
                                             path:[NSString stringWithFormat:@"lists/%@/movies/%@", listId, movieId]
                                       parameters:nil
                                          success:success
                                          failure:failure];
}

@end
