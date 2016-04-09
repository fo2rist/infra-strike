//
//  CTNetworkService.h
//  CheckpointTerminal
//
//  Created by Evgeny Kubrakov on 09/04/16.
//  Copyright © 2016 Streetmage. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CTNetworkServiceCompletion)(BOOL success, id data, NSError *error);

@interface CTNetworkService : NSObject

+ (instancetype)sharedService;

- (void)registerWithPhoneNumber:(NSString *)phoneNumber completion:(CTNetworkServiceCompletion)completion;
- (void)startNewGameWithUserId:(NSString *)userId completion:(CTNetworkServiceCompletion)completion;

@end
