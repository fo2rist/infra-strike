//
//  TRCountdownTimer.m
//  Tapture
//
//  Created by Artyom on 08/10/15.
//  Copyright © 2015 WeezLabs. All rights reserved.
//

#import "CTRepeatTimer.h"

@interface CTRepeatTimer ()

@property (nonatomic, readwrite) NSTimeInterval repeatInterval;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation CTRepeatTimer

- (instancetype)initWithRepeatInterval:(NSTimeInterval)repeatInterval
                           tickHandler:(CTTimerTickHandler)tickHandler {
    
    self = [super init];
    
    if (self) {
        self.repeatInterval = repeatInterval;
        self.tickHandler = tickHandler;
    }
    
    return self;
    
}

- (instancetype)init {
    self = [self initWithRepeatInterval:0.0 tickHandler:NULL];
    
    if (self) {
        
    }
    
    return self;
}

#pragma mark - Public Methods

- (void)setupTimer {
    if (self.timer) {
        [self invalidate];
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.repeatInterval
                                                  target:self
                                                selector:@selector(onTick:)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)invalidate {
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - Private Methods

- (void)onTick:(NSTimer *)timer {
    if (self.tickHandler) {
        self.tickHandler();
    }
}

@end
