//
//  CTGame.h
//  CheckpointTerminal
//
//  Created by Evgeny Kubrakov on 09/04/16.
//  Copyright © 2016 Streetmage. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const CTStatePending;
extern NSString *const CTStateInProgress;
extern NSString *const CTStateFinished;

@interface CTGame : NSObject

@property (nonatomic, copy) NSString *gameName;
@property (nonatomic, copy) NSString *mode;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *ownerPhoneNumber;

@property (nonatomic, copy) NSArray *participants;

+ (CTGame *)gameWithJSON:(NSDictionary *)json;

@end
