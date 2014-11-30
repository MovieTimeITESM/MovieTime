//
//  PBList.h
//  MovieTime
//
//  Created by Patricio Beltrán on 11/28/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import "ILMappingManager.h"

@interface PBList : NSObject

@property (strong, nonatomic) NSNumber *listId;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *avatar;
@property (strong, nonatomic) NSNumber *likes;
@property (copy, nonatomic) NSString *owner;
@property (assign, nonatomic) BOOL likedByUser;

/**
 Sends a POST request to server to the create list
 endpoint. It sends the given parameters inside a dictionary
 in the "list: " key, as requested from the server.
 **/
+ (void)createListWithParameters:(NSDictionary *)parameters
                         success:(RKSuccessBlock)success
                         failure:(RKFailureBlock)failure;

/**
 Sends a PUT request to server to vote for a list with
 the specified ID.
 **/
+ (void)voteForListWithId:(NSNumber *)listId
                  success:(RKSuccessBlock)success
                  failure:(RKFailureBlock)failure;

/**
 Sends a PUT request to server to make private a list with
 the specified ID.
 **/
+ (void)makePrivateForListWithId:(NSNumber *)listId
                         success:(RKSuccessBlock)success
                         failure:(RKFailureBlock)failure;

/**
 Sends a GET request to server to get a list of all the 
 lists.
 **/
+ (void)loadAllListsWithsuccess:(RKSuccessBlock)success
                        failure:(RKFailureBlock)failure;

/**
 Sends a GET request to server to get a list of a users the
 lists.
 **/
+ (void)loadlistsWithUserId:(NSNumber *)userId
                    success:(RKSuccessBlock)success
                    failure:(RKFailureBlock)failure;

/**
 Sends a DELETE request to server to delete a list with
 a given id.
 **/
+ (void)deleteListWithId:(NSNumber *)listId
                 success:(RKSuccessBlock)success
                 failure:(RKFailureBlock)failure;
@end
