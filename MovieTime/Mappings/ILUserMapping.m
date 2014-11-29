//
//  ILUserMapping.m
//  Moneypool
//
//  Created by Patricio Beltran on 8/27/14.
//  Copyright (c) 2014 icalia labs. All rights reserved.
//

#import "ILUserMapping.h"
#import "ILUser.h"

@implementation ILUserMapping

+ (RKObjectMapping *)mapping
{
    static RKObjectMapping *_mapping = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[ILUser class]];
        [mapping addAttributeMappingsFromArray:@[@"name", @"email", @"uid"]];
        [mapping addAttributeMappingsFromDictionary:@{
                                                      @"id": @"userId",
                                                      @"auth_token": @"authToken"
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
    RKResponseDescriptor *logOutDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[self mappingWithRelationships]
                                                                                          method:RKRequestMethodDELETE
                                                                                     pathPattern:@"sessions"
                                                                                         keyPath:nil
                                                                                     statusCodes:[ILMappingManager statusCodeSet]];
    
    RKResponseDescriptor *showDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[self mappingWithRelationships]
                                                                                        method:RKRequestMethodGET
                                                                                   pathPattern:@"users/:userId"
                                                                                       keyPath:@"user"
                                                                                   statusCodes:[ILMappingManager statusCodeSet]];
    
    
    RKResponseDescriptor *loginDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[self mappingWithRelationships]
                                                                                           method:RKRequestMethodPOST
                                                                                      pathPattern:@"fbsessions"
                                                                                          keyPath:@"user"
                                                                                      statusCodes:[ILMappingManager statusCodeSet]];
    
    return @[logOutDescriptor, showDescriptor, loginDescriptor];
}

+ (NSArray *)requestDescriptors
{
    return @[];
}


@end
