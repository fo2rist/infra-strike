//
//  CTArduinoService.h
//  CheckpointTerminal
//
//  Created by Evgeny Kubrakov on 08/04/16.
//  Copyright © 2016 Streetmage. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CTArduinoServiceEvent) {
    CTArduinoServiceIRCodeReceivedEvent,
    CTArduinoServicePortOpened,
    CTArduinoServicePortClosed
};

@class CTArduinoService;

@protocol CTArduinoServiceObserver <NSObject>

@required

- (void)arduinoService:(CTArduinoService *)arduinoService
          didSentEvent:(CTArduinoServiceEvent)event
                  data:(id)data;

@end

@interface CTArduinoService : NSObject

+ (instancetype)sharedService;

- (void)connect;
- (void)disconnect;

- (void)subscribeForEvent:(CTArduinoServiceEvent)event observer:(id <CTArduinoServiceObserver>)observer;
- (void)unsubscribeObserver:(id <CTArduinoServiceObserver>)observer forEvent:(CTArduinoServiceEvent)event;
- (void)unsubscribeObserversForEvent:(CTArduinoServiceEvent)event;

@end
