//
//  PBList.m
//  MovieTime
//
//  Created by Patricio Beltrán on 11/28/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import "PBList.h"
#import <UIImage+ImageCompress.h>

@implementation PBList

+ (void)createListWithParameters:(NSDictionary *)parameters
                         success:(RKSuccessBlock)success
                         failure:(RKFailureBlock)failure {
    NSMutableURLRequest *request = [[RKObjectManager sharedManager] multipartFormRequestWithObject:[[PBList alloc] init]
                                                                                            method:RKRequestMethodPOST
                                                                                              path:@"lists"
                                                                                        parameters:@{
                                                                                                     @"list" : parameters
                                                                                                     }
                                                                         constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                                             if (parameters[@"avatar"]) {
                                                                                 UIImage *compressedImage = [UIImage compressImage:parameters[@"avatar"] compressRatio:0.9f];
                                                                                 NSData *imageData = UIImageJPEGRepresentation(compressedImage, 1.0f);
                                                                                 [formData appendPartWithFileData:imageData
                                                                                                             name:@"list[avatar]"
                                                                                                         fileName:[NSString stringWithFormat:@"%@ListAvatarImage.jpeg", [parameters[@"name"] stringByReplacingOccurrencesOfString:@" " withString:@""]]
                                                                                                         mimeType:@"image/jpeg"];
                                                                             }
                                                                         }];
    RKObjectRequestOperation *operation = [[RKObjectManager sharedManager]
                                           objectRequestOperationWithRequest:request
                                           success:success
                                           failure:failure];
    
    [[RKObjectManager sharedManager] enqueueObjectRequestOperation:operation]; // NOTE: Must be enqueued rather than started
}

+ (void)voteForListWithId:(NSNumber *)listId
                  success:(RKSuccessBlock)success
                  failure:(RKFailureBlock)failure {
    
    [[RKObjectManager sharedManager] putObject:[[PBList alloc] init]
                                          path:[NSString stringWithFormat:@"lists/%@/vote", listId]
                                    parameters:nil
                                       success:success
                                       failure:failure];
}

+ (void)makePrivateForListWithId:(NSNumber *)listId
                         success:(RKSuccessBlock)success
                         failure:(RKFailureBlock)failure {
    
    [[RKObjectManager sharedManager] putObject:[[PBList alloc] init]
                                          path:[NSString stringWithFormat:@"lists/%@/make_private", listId]
                                    parameters:nil
                                       success:success
                                       failure:failure];
}

+ (void)loadAllListsWithsuccess:(RKSuccessBlock)success
                        failure:(RKFailureBlock)failure {
    
    [[RKObjectManager sharedManager] getObject:[[PBList alloc] init]
                                          path:@"lists"
                                    parameters:nil
                                       success:success
                                       failure:failure];
}

+ (void)loadlistsWithUserId:(NSNumber *)userId
                    success:(RKSuccessBlock)success
                    failure:(RKFailureBlock)failure {
    
    [[RKObjectManager sharedManager] getObject:[[PBList alloc] init]
                                          path:[NSString stringWithFormat:@"users/%@/lists", userId]
                                    parameters:nil
                                       success:success
                                       failure:failure];
}

+ (void)deleteListWithId:(NSNumber *)listId
                 success:(RKSuccessBlock)success
                 failure:(RKFailureBlock)failure {
    
    [[RKObjectManager sharedManager] deleteObject:[[PBList alloc] init]
                                             path:[NSString stringWithFormat:@"lists/%@", listId]
                                       parameters:nil
                                          success:success
                                          failure:failure];
}

@end
