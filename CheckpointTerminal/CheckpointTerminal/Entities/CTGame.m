//
//  CTGame.m
//  CheckpointTerminal
//
//  Created by Evgeny Kubrakov on 09/04/16.
//  Copyright © 2016 Streetmage. All rights reserved.
//

#import "CTGame.h"
#import "CTUser.h"

NSString *const CTStatePending = @"pending";
NSString *const CTStateInProgress = @"in progress";
NSString *const CTStateFinished = @"finished";

@implementation CTGame

+ (CTGame *)gameWithJSON:(NSDictionary *)json {
    
    if (!json) {
        return nil;
    }
    
    CTGame *game = [[CTGame alloc] init];
    game.gameName = NilIfNull( [json objectForKey:@"name"]);
    game.mode = NilIfNull([json objectForKey:@"mode"]);
    game.state = NilIfNull([json objectForKey:@"state"]);
    game.ownerPhoneNumber = NilIfNull([json objectForKey:@""]);
    
    NSArray *participantsJSON = NilIfNull([json objectForKey:@"participants"]);
    NSMutableArray *participants = [NSMutableArray array];
    for (NSDictionary *participantJSON in participantsJSON) {
        CTUser *user = [CTUser userWithJSON:participantJSON];
        [participants addObject:user];
    }
    game.participants = [NSArray arrayWithArray:participants];
    
    return game;
    
}

@end
