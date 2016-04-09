//
//  CTArduinoService.m
//  CheckpointTerminal
//
//  Created by Evgeny Kubrakov on 08/04/16.
//  Copyright © 2016 Streetmage. All rights reserved.
//

#import <ORSSerialPort/ORSSerialPort.h>

#import "CTArduinoService.h"

NSString *const CTArduinoServiceIRCodeReceivedEvent = @"ArduinoServiceIRCodeReceivedEvent";
NSString *const CTArduinoServicePortOpened = @"ArduinoServicePortOpened";
NSString *const CTArduinoServicePortClosed = @"ArduinoServicePortClosed";

@interface CTArduinoService () <ORSSerialPortDelegate>

@property (nonatomic, strong) ORSSerialPort *serialPort;

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

#pragma mark - Public Methods

- (void)connect {
    [self.serialPort open];
}

- (void)disconnect {
    [self.serialPort close];
}

#pragma mark - ORSSerialPortDelegate Methods

- (void)serialPortWasRemovedFromSystem:(ORSSerialPort *)serialPort {
    NSLog(@"Port was removed");
}

- (void)serialPort:(ORSSerialPort *)serialPort didReceiveData:(NSData *)data {
    NSString *decodedString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    NSLog(@"%@", decodedString);
    
}

- (void)serialPortWasOpened:(ORSSerialPort *)serialPort {
    NSLog(@"Port opened");
}

- (void)serialPortWasClosed:(ORSSerialPort *)serialPort {
    NSLog(@"Port closed");
}

@end
