//
//  CTArduinoService.h
//  CheckpointTerminal
//
//  Created by Evgeny Kubrakov on 08/04/16.
//  Copyright © 2016 Streetmage. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const CTArduinoServiceIRCodeReceivedEvent;
extern NSString *const CTArduinoServicePortOpened;
extern NSString *const CTArduinoServicePortClosed;

@interface CTArduinoService : NSObject

+ (instancetype)sharedService;

- (void)connect;
- (void)disconnect;

@end
