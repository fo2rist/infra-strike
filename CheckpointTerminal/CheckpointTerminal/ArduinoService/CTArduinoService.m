//
//  CTArduinoService.m
//  CheckpointTerminal
//
//  Created by Evgeny Kubrakov on 08/04/16.
//  Copyright © 2016 Streetmage. All rights reserved.
//

#import <ORSSerialPort/ORSSerialPort.h>

#import "CTArduinoService.h"

@interface CTArduinoService () <ORSSerialPortDelegate>

@property (nonatomic, strong) ORSSerialPort *serialPort;
@property (nonatomic, strong) NSMutableDictionary <NSNumber *, NSMutableArray *> *observersForEvents;

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

- (ORSSerialPort *)serialPort {
    if (!_serialPort) {
        _serialPort = [ORSSerialPort serialPortWithPath:@"/dev/cu.usbserial-A603RPPP"];
        _serialPort.baudRate = @(9600);
        _serialPort.delegate = self;
    }
    return _serialPort;
}

- (NSMutableDictionary *)observersForEvents {
    if (!_observersForEvents) {
        _observersForEvents = [NSMutableDictionary dictionary];
    }
    return _observersForEvents;
}

#pragma mark - Public Methods

- (void)connect {
    [self.serialPort open];
}

- (void)disconnect {
    [self.serialPort close];
}

- (void)subscribeForEvent:(CTArduinoServiceEvent)event observer:(id)observer {
    NSMutableArray *observers = [self.observersForEvents objectForKey:@(event)];
    if (!observers) {
        observers = [NSMutableArray array];
    }
    [observers addObject:observer];
    [self.observersForEvents setObject:observers forKey:@(event)];
}

- (void)unsubscribeObserver:(id)observer forEvent:(CTArduinoServiceEvent)event {
    NSMutableArray *observers = [self.observersForEvents objectForKey:@(event)];
    if (!observers) {
        [observers removeObject:observer];
    }
}

- (void)unsubscribeObserversForEvent:(CTArduinoServiceEvent)event {
    [self.observersForEvents removeObjectForKey:@(event)];
}

#pragma mark - Private Methods

- (void)sentEvent:(CTArduinoServiceEvent)event data:(id)data {
    NSMutableArray *observers = [self.observersForEvents objectForKey:@(event)];
    for (id <CTArduinoServiceObserver> observer in observers) {
        [observer arduinoService:self didSentEvent:event data:data];
    }
}

#pragma mark - ORSSerialPortDelegate Methods

- (void)serialPortWasRemovedFromSystem:(ORSSerialPort *)serialPort {
    NSLog(@"Port was removed");
}

- (void)serialPort:(ORSSerialPort *)serialPort didReceiveData:(NSData *)data {
    NSString *decodedString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    NSLog(@"%@", decodedString);
//    NSLog(@"%@", data);
    [self sentEvent:CTArduinoServiceIRCodeReceivedEvent data:decodedString];
}

- (void)serialPortWasOpened:(ORSSerialPort *)serialPort {
    NSLog(@"Port opened");
    [self sentEvent:CTArduinoServicePortOpened data:nil];
}

- (void)serialPortWasClosed:(ORSSerialPort *)serialPort {
    NSLog(@"Port closed");
    [self sentEvent:CTArduinoServicePortClosed data:nil];
}

@end
