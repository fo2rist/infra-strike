//
//  CTArduinoService.m
//  CheckpointTerminal
//
//  Created by Evgeny Kubrakov on 08/04/16.
//  Copyright © 2016 Streetmage. All rights reserved.
//

#import "CTArduinoService.h"

@interface CTArduinoService ()

@property (nonatomic, strong) NSMutableDictionary *observersForEvents;

@end

@implementation CTArduinoService

+ (instancetype)sharedService {
    static dispatch_once_t dispatchOnceToken;
    static CTArduinoService *sharedService;
    dispatch_once(&dispatchOnceToken, ^{
        sharedService = [[CTArduinoService alloc] init];
    });
    return sharedService;
}

#pragma mark - Acessors

- (NSMutableDictionary *)observersForEvents {
    if (!_observersForEvents) {
        _observersForEvents = [NSMutableDictionary dictionary];
    }
    return _observersForEvents;
}

#pragma mark - Public Methods

- (BOOL)connect {
    return YES;
}

- (BOOL)disconnect {
    return YES;
}

- (void)subscribeForEvent:(CTArduinoServiceEvent)event observer:(id)observer {
    //
}

@end
