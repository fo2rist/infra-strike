//
//  TRCountdownTimer.h
//  Tapture
//
//  Created by Artyom on 08/10/15.
//  Copyright © 2015 WeezLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CTTimerTickHandler)(void);

@interface CTRepeatTimer : NSObject

@property (nonatomic, readonly) NSTimeInterval repeatInterval;
@property (nonatomic, copy) CTTimerTickHandler tickHandler;

- (instancetype)initWithRepeatInterval:(NSTimeInterval)repeatInterval
                           tickHandler:(CTTimerTickHandler)tickHandler NS_DESIGNATED_INITIALIZER;

- (void)setupTimer;
- (void)invalidate;

@end

