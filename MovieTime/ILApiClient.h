//
//  ILApiClient.h
//
//  Created by Adrian Gzz on 17/10/13.
//  Copyright (c) 2013 Icalia Labs. All rights reserved.
//

#import <AFNetworking/AFHTTPClient.h>

static NSString * const ILBaseURLString = @"http://localhost:3000/api";

@interface ILApiClient : AFHTTPClient

typedef void(^ AFSuccessBlock)(AFHTTPRequestOperation *operation, NSDictionary *responseObject);
typedef void(^ AFFailureBlock)(AFHTTPRequestOperation *operation, NSError *error);

+ (instancetype)sharedClient;
+ (void)setAuthorizationToken:(NSString *)accessToken;
+ (void)clearAuthorizationToken;


@end
