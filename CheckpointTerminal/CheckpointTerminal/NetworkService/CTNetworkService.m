//
//  CTNetworkService.m
//  CheckpointTerminal
//
//  Created by Evgeny Kubrakov on 09/04/16.
//  Copyright © 2016 Streetmage. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

#import "CTNetworkService.h"

#define NullIfNil(obj) obj != nil ? obj : [NSNull null]

static NSString *const CTAPIBaseUrl = @"http://10.10.42.42:5000";

@implementation CTNetworkService

+ (instancetype)sharedService {
    static dispatch_once_t dispatchOnceToken;
    static CTNetworkService *sharedService;
    dispatch_once(&dispatchOnceToken, ^{
        sharedService = [[CTNetworkService alloc] init];
    });
    return sharedService;
}

- (void)registerWithPhoneNumber:(NSString *)phoneNumber completion:(CTNetworkServiceCompletion)completion {
    NSDictionary *parameters = @{
                                 @"phone" : NullIfNil(phoneNumber),
                                 @"isBase" : @(1)
                                 };
    [CTNetworkService POST:@"/users"
                parameters:parameters
                completion:completion];
}

- (void)startNewGameWithName:(NSString *)gameName
                 creatorName:(NSString *)creatorName
                        mode:(NSString *)mode
                        code:(NSString *)code
                  completion:(CTNetworkServiceCompletion)completion {
    NSDictionary *parameters = @{
                                 @"name" : NullIfNil(gameName),
                                 @"creatorName" : NullIfNil(creatorName),
                                 @"mode" : NullIfNil(mode),
                                 @"code" : NullIfNil(code)
                                 };
    [CTNetworkService POST:@"/games"
                parameters:parameters
                completion:completion];
}

+ (NSURLSessionDataTask *)GET:(NSString *)path
                   parameters:(id)parameters
                   completion:(CTNetworkServiceCompletion)completion {
    return [self runRequest:path
                     method:@"GET"
                 parameters:parameters
          requestSerializer:[AFHTTPRequestSerializer serializer]
         responseSerializer:[AFJSONResponseSerializer serializer]
                 completion:completion];
}

+ (NSURLSessionDataTask *)POST:(NSString *)path
                    parameters:(id)parameters
                    completion:(CTNetworkServiceCompletion)completion {
    return [self runRequest:path
                     method:@"POST"
                 parameters:parameters
          requestSerializer:[AFJSONRequestSerializer serializer]
         responseSerializer:[AFJSONResponseSerializer serializer]
                 completion:completion];
}

+ (NSURLSessionDataTask *)PUT:(NSString *)path
                   parameters:(id)parameters
                   completion:(CTNetworkServiceCompletion)completion {
    return [self runRequest:path
                     method:@"PUT"
                 parameters:parameters
          requestSerializer:[AFJSONRequestSerializer serializer]
         responseSerializer:[AFJSONResponseSerializer serializer]
                 completion:completion];
}

+ (NSURLSessionDataTask *)DELETE:(NSString *)path
                      parameters:(id)parameters
                      completion:(CTNetworkServiceCompletion)completion {
    return [self runRequest:path
                     method:@"DELETE"
                 parameters:parameters
          requestSerializer:[AFJSONRequestSerializer serializer]
         responseSerializer:[AFJSONResponseSerializer serializer]
                 completion:completion];
}

#pragma mark - Private

+ (NSURLSessionDataTask *)runRequest:(NSString *)path
                              method:(NSString *)method
                          parameters:(id)parameters
                   requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                  responseSerializer:(AFHTTPResponseSerializer *)responseSerializer
                          completion:(CTNetworkServiceCompletion)completion {
    
    requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", nil];
    
    NSURL *requestUrl = [NSURL URLWithString:path
                               relativeToURL:[NSURL URLWithString:CTAPIBaseUrl]];
    
    NSMutableURLRequest *request = nil;
    request = [requestSerializer requestWithMethod:method
                                         URLString:requestUrl.absoluteString
                                        parameters:parameters
                                             error:nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager setResponseSerializer:responseSerializer];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (completion) {
            completion(!error, responseObject, error);
        }
    }];
    
    [dataTask resume];
    return dataTask;
}



@end
