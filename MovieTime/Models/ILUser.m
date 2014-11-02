//
//  ILUser.m
//  Moneypool
//
//  Created by Patricio Beltran on 8/27/14.
//  Copyright (c) 2014 icalia labs. All rights reserved.
//

#import "ILUser.h"

@implementation ILUser

+ (void)loginWithAccessToken:(NSString *)token
                     success:(RKSuccessBlock)success
                     failure:(RKFailureBlock)failure
{
    [[RKObjectManager sharedManager] postObject:[[ILUser alloc] init]
                                           path:@"fbsessions"
                                     parameters:@{@"user" : @{@"oauth_token" : token }}
                                        success:success
                                        failure:failure];
}

- (void)logOutWithSuccess:(RKSuccessBlock)success
                  failure:(RKFailureBlock)failure {
    
    [[RKObjectManager sharedManager] deleteObject:self
                                             path:@"sessions"
                                       parameters:nil
                                          success:success
                                          failure:failure];
}

+ (void)loadUserWithId:(NSNumber *)userId
               success:(RKSuccessBlock)success
               failure:(RKFailureBlock)failure {

    [[RKObjectManager sharedManager] getObject:[[ILUser alloc] init]
                                          path:[NSString stringWithFormat:@"users/%@", userId]
                                    parameters:nil
                                       success:success
                                       failure:failure];
}

@end
