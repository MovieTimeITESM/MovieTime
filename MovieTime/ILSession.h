//
//  ILSession.h
//  Moneypool
//
//  Created by Patricio Beltran on 8/27/14.
//  Copyright (c) 2014 icalia labs. All rights reserved.
//

#import "ILUser.h"

@interface ILSession : NSObject

/**
 Specifies the user that is currently loged in.
 */
@property (nonatomic, strong) ILUser *currentUser;

/**
 Returns the active session or creates a new one if there is none.
 @param currentUser ILUser that represent the user that is logged in.
 */
+ (instancetype)newSessionForUser:(ILUser *)currentUser;

/**
 Clears the current session
 */
- (void)clearSessionAndToken;

/**
 Makes the request to reload the current user data
 */
- (void)reloadUserData;

/**
 Makes a request to reload the current user data and then yields the block
 depending if it succeed or failed
 @param success Block yield if the request succeed
 @param failure Block yield if the request failed
 */
- (void)reloadUserDataWithSuccess:(void (^)())sucess failure:(void (^)())failure;

extern ILSession *activeSession;

@end
