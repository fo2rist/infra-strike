//
//  CTNetworkService.m
//  CheckpointTerminal
//
//  Created by Evgeny Kubrakov on 09/04/16.
//  Copyright © 2016 Streetmage. All rights reserved.
//

#import "CTNetworkService.h"

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
    
}

- (void)startNewGameWithUserId:(NSString *)userId completion:(CTNetworkServiceCompletion)completion {

}


@end
