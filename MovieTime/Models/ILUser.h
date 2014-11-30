//
//  ILUser.h
//  Moneypool
//
//  Created by Patricio Beltran on 8/27/14.
//  Copyright (c) 2014 icalia labs. All rights reserved.
//

#import "ILMappingManager.h"

@interface ILUser : NSObject

@property (strong, nonatomic) NSNumber *userId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *authToken;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSNumber *likes;
@property (strong, nonatomic) NSNumber *lists;
@property (strong, nonatomic) NSNumber *likesToUser;

/**
 Sends a request to login to the app given a access token.
 */
+ (void)loginWithAccessToken:(NSString *)token
                     success:(RKSuccessBlock)success
                     failure:(RKFailureBlock)failure;

/**
 Sends a request to logout from the app
 */
- (void)logOutWithSuccess:(RKSuccessBlock)success
                  failure:(RKFailureBlock)failure;

/**
 Sends a request to load the user by the userId
 */
+ (void)loadUserWithId:(NSNumber *)userId
               success:(RKSuccessBlock)success
               failure:(RKFailureBlock)failure;

@end
