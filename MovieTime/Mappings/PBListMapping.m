//
//  PBListMapping.m
//  MovieTime
//
//  Created by Patricio Beltrán on 11/28/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import "PBListMapping.h"
#import "PBList.h"

@implementation PBListMapping

+ (RKObjectMapping *)mapping
{
    static RKObjectMapping *_mapping = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[PBList class]];
        [mapping addAttributeMappingsFromArray:@[@"name", @"likes", @"owner"]];
        [mapping addAttributeMappingsFromDictionary:@{
                                                      @"id": @"listId",
                                                      @"avatar_url" : @"avatar",
                                                      @"liked_by_current_user" : @"likedByUser"
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
    RKResponseDescriptor *createListDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[self mappingWithRelationships]
                                                                                              method:RKRequestMethodPOST
                                                                                         pathPattern:@"lists"
                                                                                             keyPath:@"list"
                                                                                         statusCodes:[ILMappingManager statusCodeSet]];
    
    RKResponseDescriptor *likeListDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[self mappingWithRelationships]
                                                                                              method:RKRequestMethodPUT
                                                                                         pathPattern:@"lists/:listId/vote"
                                                                                             keyPath:@"list"
                                                                                         statusCodes:[ILMappingManager statusCodeSet]];
    
    RKResponseDescriptor *listsDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[self mappingWithRelationships]
                                                                                         method:RKRequestMethodGET
                                                                                    pathPattern:@"lists"
                                                                                        keyPath:@"lists"
                                                                                    statusCodes:[ILMappingManager statusCodeSet]];
    
    RKResponseDescriptor *userListsDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[self mappingWithRelationships]
                                                                                             method:RKRequestMethodGET
                                                                                        pathPattern:@"users/:userId/lists"
                                                                                            keyPath:@"users"
                                                                                        statusCodes:[ILMappingManager statusCodeSet]];
    
    RKResponseDescriptor *deleteListDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[self mappingWithRelationships]
                                                                                             method:RKRequestMethodDELETE
                                                                                        pathPattern:@"lists/:listId"
                                                                                            keyPath:@"list"
                                                                                        statusCodes:[ILMappingManager statusCodeSet]];
    
    return @[createListDescriptor, likeListDescriptor, listsDescriptor, userListsDescriptor, deleteListDescriptor];
}

+ (NSArray *)requestDescriptors
{
    return @[];
}

@end
