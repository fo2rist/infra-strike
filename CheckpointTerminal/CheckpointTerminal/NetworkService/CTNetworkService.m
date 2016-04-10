//
//  CTNetworkService.m
//  CheckpointTerminal
//
//  Created by Evgeny Kubrakov on 09/04/16.
//  Copyright © 2016 Streetmage. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

#import "CTNetworkService.h"
#import "CTSession.h"

#import "CTUser.h"
#import "CTGame.h"

static NSString *const CTAPIBaseUrl = @"http://10.10.43.17:5000";

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
                completion:^(BOOL success, id data, NSError *error) {
                    if (success && data) {
                        [CTSession sharedSession].userId = [data objectForKey:@"uid"];
                    }
                    if (completion) {
                        completion(success, nil, error);
                    }
                }];
}

- (void)createNewGameWithName:(NSString *)gameName
                  creatorName:(NSString *)creatorName
                         mode:(NSString *)mode
                         code:(NSString *)code
                   completion:(CTNetworkServiceCompletion)completion {
    NSDictionary *parameters = @{
                                 @"name" : NullIfNil(gameName),
                                 @"creatorName" : NullIfNil(creatorName),
                                 @"mode" : NullIfNil(mode),
                                 @"code" : NullIfNil(code),
                                 @"respawnSeconds" : @(20)
                                 };
    [CTNetworkService POST:@"/games"
                parameters:parameters
                completion:^(BOOL success, id data, NSError *error) {
                    CTGame *game = nil;
                    if (success && data) {
                        game = [CTGame gameWithJSON:data];
                    }
                    if (completion) {
                        completion(success, game, error);
                    }
                }];
}

- (void)gameWithName:(NSString *)gameName
          completion:(CTNetworkServiceCompletion)completion {
    [CTNetworkService GET:[NSString stringWithFormat:@"/games/%@", gameName]
               parameters:nil
               completion:^(BOOL success, id data, NSError *error) {
                   CTGame *game = nil;
                   if (success && data) {
                       game = [CTGame gameWithJSON:data];
                   }
                   if (completion) {
                       completion(success, game, error);
                   }
               }];
}

- (void)shootWithGameName:(NSString *)gameName
                     code:(NSString *)code
               completion:(CTNetworkServiceCompletion)completion {
    NSDictionary *parameters = @{
                                 @"code" : NullIfNil(code)
                                 };
    [CTNetworkService POST:[NSString stringWithFormat:@"games/%@/shots", gameName]
                parameters:parameters
                completion:completion];
}

- (void)startGameWithName:(NSString *)gameName
               completion:(CTNetworkServiceCompletion)completion {
    NSDictionary *parameters = @{
                                 @"state" : CTStateInProgress
                                 };
    [CTNetworkService PUT:[NSString stringWithFormat:@"/games/%@", gameName]
               parameters:parameters
               completion:^(BOOL success, id data, NSError *error) {
                   CTGame *game = nil;
                   if (success && data) {
                       game = [CTGame gameWithJSON:data];
                   }
                   if (completion) {
                       completion(success, game, error);
                   }
               }];
}

- (void)stopGameWithName:(NSString *)gameName
              completion:(CTNetworkServiceCompletion)completion {
    [CTNetworkService DELETE:[NSString stringWithFormat:@"/games/%@", gameName]
                  parameters:nil
                  completion:^(BOOL success, id data, NSError *error) {
                      CTGame *game = nil;
                      if (success && data) {
                          game = [CTGame gameWithJSON:data];
                      }
                      if (completion) {
                          completion(success, game, error);
                      }
                  }];
}

#pragma mark - Private Methods

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
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    if ([CTSession sharedSession].isLogged) {
        [requestSerializer setValue:[CTSession sharedSession].userId forHTTPHeaderField:@"uid"];
    }
    
    NSURL *requestUrl = [NSURL URLWithString:path
                               relativeToURL:[NSURL URLWithString:CTAPIBaseUrl]];
    
    NSMutableURLRequest *request = nil;
    request = [requestSerializer requestWithMethod:method
                                         URLString:requestUrl.absoluteString
                                        parameters:parameters
                                             error:nil];
    request.timeoutInterval = 20;
    
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
