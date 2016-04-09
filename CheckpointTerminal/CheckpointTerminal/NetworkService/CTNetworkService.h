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

- (void)registerWithPhoneNumber:(NSString *)phoneNumber
                     completion:(CTNetworkServiceCompletion)completion;

- (void)createNewGameWithName:(NSString *)gameName
                  creatorName:(NSString *)creatorName
                         mode:(NSString *)mode
                         code:(NSString *)code
                   completion:(CTNetworkServiceCompletion)completion;

- (void)gameWithName:(NSString *)gameName
          completion:(CTNetworkServiceCompletion)completion;

- (void)shootWithGameName:(NSString *)gameName
                     code:(NSString *)code
               completion:(CTNetworkServiceCompletion)completion;

- (void)startGameWithName:(NSString *)gameName
               completion:(CTNetworkServiceCompletion)completion;

- (void)stopGameWithName:(NSString *)gameName
              completion:(CTNetworkServiceCompletion)completion;

@end

