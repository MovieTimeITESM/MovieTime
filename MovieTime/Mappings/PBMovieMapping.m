//
//  PBMovieMapping.m
//  MovieTime
//
//  Created by Patricio Beltrán on 11/30/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import "PBMovieMapping.h"
#import "PBMovie.h"

@implementation PBMovieMapping

+ (RKObjectMapping *)mapping
{
    static RKObjectMapping *_mapping = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[PBMovie class]];
        [mapping addAttributeMappingsFromArray:@[@"name", @"year", @"poster", @"ratings", @"runtime"]];
        [mapping addAttributeMappingsFromDictionary:@{
                                                      @"id": @"movieId",
                                                      @"rotten_id" : @"rottenId",
                                                      @"mpaa_ratings" : @"mpaaRatings"
                                                      }];
        _mapping = mapping;
    });
    return _mapping;
}

+ (RKObjectMapping *)mappingWithRelationships
{
    static RKObjectMapping *_mapping = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _mapping = [[self mapping] copy];
    });
    return _mapping;
}

+ (void)addRelationships
{
}

+ (NSArray *)responseDescriptors
{
    RKResponseDescriptor *createMovieDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[self mappingWithRelationships]
                                                                                              method:RKRequestMethodPOST
                                                                                         pathPattern:@"lists/:listId/movies"
                                                                                             keyPath:@"movie"
                                                                                         statusCodes:[ILMappingManager statusCodeSet]];
    
    
    RKResponseDescriptor *moviesDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[self mappingWithRelationships]
                                                                                         method:RKRequestMethodGET
                                                                                    pathPattern:@"lists/:listId/movies"
                                                                                        keyPath:@"movies"
                                                                                    statusCodes:[ILMappingManager statusCodeSet]];
    
    
    RKResponseDescriptor *deleteMovieDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[self mappingWithRelationships]
                                                                                              method:RKRequestMethodDELETE
                                                                                         pathPattern:@"lists/:listId/movies/:movieId"
                                                                                             keyPath:@"movie"
                                                                                         statusCodes:[ILMappingManager statusCodeSet]];
    
    return @[createMovieDescriptor, moviesDescriptor, deleteMovieDescriptor];
}

+ (NSArray *)requestDescriptors
{
    return @[];
}

@end
