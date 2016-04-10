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
@property (nonatomic, strong) NSMutableString *stringAccum;

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
    if (!self.serialPort.isOpen) {
        [self.serialPort open];
    }
}

- (void)disconnect {
    if (self.serialPort.isOpen) {
        [self.serialPort close];
    }
}

#pragma mark - ORSSerialPortDelegate Methods

- (void)serialPortWasRemovedFromSystem:(ORSSerialPort *)serialPort {
    NSLog(@"Port was removed");
}

- (void)serialPort:(ORSSerialPort *)serialPort didReceiveData:(NSData *)data {
    NSString *decodedString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if ([decodedString containsString:@"\r"]) {
        NSRange range = [decodedString rangeOfString:@"\r"];
        if (range.location > 0) {
            [self.stringAccum appendString:[decodedString substringToIndex:range.location]];
        }
    }
    else if (decodedString.length > 8) {
        return;
    }
    else if (decodedString.length < 8)  {
        if (!_stringAccum) {
            self.stringAccum = [NSMutableString stringWithString:decodedString];
            return;
        }
        else {
            [_stringAccum appendString:decodedString];
        }
    }
    else {
        _stringAccum = [decodedString mutableCopy];
    }
    
    if (self.stringAccum.length >= 8) {
        NSLog(@"%@", _stringAccum);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CTArduinoServiceIRCodeReceivedEvent
                                                        object:nil
                                                      userInfo:@{@"code" : NullIfNil(self.stringAccum)}];
    _stringAccum = nil;
}

- (void)serialPortWasOpened:(ORSSerialPort *)serialPort {
    NSLog(@"Port opened");
    [[NSNotificationCenter defaultCenter] postNotificationName:CTArduinoServicePortOpened object:nil];
}

- (void)serialPortWasClosed:(ORSSerialPort *)serialPort {
    NSLog(@"Port closed");
    [[NSNotificationCenter defaultCenter] postNotificationName:CTArduinoServicePortClosed object:nil];
}

@end
