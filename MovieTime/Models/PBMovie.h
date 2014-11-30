//
//  PBMovie.h
//  MovieTime
//
//  Created by Patricio Beltrán on 11/29/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import "ILMappingManager.h"

@interface PBMovie : NSObject
@property (nonatomic, strong) NSNumber *movieId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *year;
@property (nonatomic, copy) NSString *rottenId;
@property (nonatomic, copy) NSString *poster;
@property (nonatomic, strong) NSNumber *ratings;
@property (nonatomic, copy) NSString *mpaaRatings;
@property (nonatomic, strong) NSNumber *runtime;

/**
 Designated Initailizer for PBMovie
 **/
- (instancetype)initWithName:(NSString *)name
                        year:(NSNumber *)year
                       movId:(NSString *)movId
                      poster:(NSString *)poster
                     ratings:(NSNumber *)ratings
                 mpaaRatings:(NSString *)mpaaRating
                     runtime:(NSNumber *)runtime;

/**
 Sends a POST request to server to create a movie within a given
 list with some parameters.
 **/
+ (void)createMovieWithListId:(NSNumber *)listId
                   parameters:(NSDictionary *)parameters
                  Withsuccess:(RKSuccessBlock)success
                      failure:(RKFailureBlock)failure;

/**
 Sends a GET request to server to retrive all the movies 
 for a certain list with a given id.
 */
+ (void)loadMoviesWithListId:(NSNumber *)listId
                 Withsuccess:(RKSuccessBlock)success
                     failure:(RKFailureBlock)failure;

/**
 Sends a DELETE request to server to delete a movie with a given
 id on a given list.
 **/
+ (void)deleteMovieWithListId:(NSNumber *)listId
                      movieId:(NSNumber *)movieId
                      success:(RKSuccessBlock)success
                      failure:(RKFailureBlock)failure;
@end
