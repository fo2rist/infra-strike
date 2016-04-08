//
//  CTArduinoService.h
//  CheckpointTerminal
//
//  Created by Evgeny Kubrakov on 08/04/16.
//  Copyright © 2016 Streetmage. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CTArduinoServiceEvent) {
    CTArduinoServiceIRCodeReceivedEvent
};

@interface CTArduinoService : NSObject

+ (instancetype)sharedService;

- (BOOL)connect;
- (BOOL)disconnect;

- (void)subscribeForEvent:(CTArduinoServiceEvent)event observer:(id)observer;

@end
