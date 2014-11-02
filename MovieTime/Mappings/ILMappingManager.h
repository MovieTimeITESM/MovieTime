//
//  ILMappingManager.h
//
//  Created by Adrian Gonzalez on 9/18/13.
//  Copyright (c) 2013 Icalia Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

typedef void (^ RKSuccessBlock)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult);
typedef void (^ RKFailureBlock)(RKObjectRequestOperation *operation, NSError *error);

@interface ILMappingManager : NSObject

+ (void)setup;
+ (NSIndexSet *)statusCodeSet;

@end

@protocol ILMapper <NSObject>

+ (RKObjectMapping *)mapping;
+ (RKObjectMapping *)mappingWithRelationships;
+ (NSArray *)responseDescriptors;
+ (NSArray *)requestDescriptors;
+ (void)addRelationships;

@end