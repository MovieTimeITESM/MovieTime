//
//  ILApiClient.m
//
//  Created by Adrian Gzz on 17/10/13.
//  Copyright (c) 2013 Icalia Labs. All rights reserved.
//

#import "ILApiClient.h"
#import <AFNetworking/AFJSONRequestOperation.h>

static NSString * const ILApiVersion = @"1";

@implementation ILApiClient

+ (instancetype)sharedClient {
    static ILApiClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedClient = [[ILApiClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/", ILBaseURLString]]];
    });
    
    return _sharedClient;
    
}

+ (void)setAuthorizationToken:(NSString *)accessToken
{
    [self.sharedClient setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"Token token=%@", accessToken]];
}

+ (void)clearAuthorizationToken
{
    [self.sharedClient setDefaultHeader:@"Authorization" value:nil];
}


- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        
        [self setDefaultHeader:@"Accept" value:[NSString stringWithFormat:@"application/vnd.movieTime.dev+json; version=%@", ILApiVersion]];
    }
    
    return self;
}

@end
