//
//  CTSession.m
//  CheckpointTerminal
//
//  Created by Evgeny Kubrakov on 09/04/16.
//  Copyright © 2016 Streetmage. All rights reserved.
//

#import "CTSession.h"

static NSString *const CTUserIdStorageKey = @"UserIdStorageKey";

@implementation CTSession

+ (instancetype)sharedSession {
    static dispatch_once_t dispatchOnceToken;
    static CTSession *sharedSession;
    dispatch_once(&dispatchOnceToken, ^{
        sharedSession = [[CTSession alloc] init];
    });
    return sharedSession;
}

#pragma mark - Accessors

- (void)setUserId:(NSString *)userId {
    [[NSUserDefaults standardUserDefaults] setObject:userId
                                              forKey:CTUserIdStorageKey];
}

- (NSString *)userId {
    return [[NSUserDefaults standardUserDefaults] objectForKey:CTUserIdStorageKey];
}

@end
