//
//  ILSession.m
//  Moneypool
//
//  Created by Patricio Beltran on 8/27/14.
//  Copyright (c) 2014 icalia labs. All rights reserved.
//

#import "ILSession.h"
#import "ILApiClient.h"
#import <Facebook-iOS-SDK/FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"

@implementation ILSession

ILSession *activeSession = nil;

+ (instancetype)newSessionForUser:(ILUser *)currentUser
{
    if (activeSession)
        return activeSession;
    
    activeSession = [[self alloc] initWithCurrentUser:currentUser];
    return activeSession;
}

- (instancetype)initWithCurrentUser:(ILUser *)currentUser
{
    self = [super init];
    if (self) {
        self.currentUser = currentUser;
        [ILApiClient setAuthorizationToken:currentUser.authToken];
    }
    return self;
}

- (void)reloadUserData
{
    [ILUser loadUserWithId:self.currentUser.userId
                   success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                       self.currentUser = mappingResult.array[0];
                   }
                   failure:^(RKObjectRequestOperation *operation, NSError *error) {
                   }];
}

- (void)reloadUserDataWithSuccess:(void (^)())sucess failure:(void (^)())failure
{
    [ILUser loadUserWithId:self.currentUser.userId
                   success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                       self.currentUser =mappingResult.array[0];
                       if (sucess) {
                           sucess();
                       }
                   }
                   failure:^(RKObjectRequestOperation *operation, NSError *error) {
                       if (failure) {
                           failure();
                       }
                   }];
}

- (void) clearSessionAndToken
{
    [ILApiClient clearAuthorizationToken];
    [[FBSession activeSession] closeAndClearTokenInformation];
    activeSession = nil;
}

@end
