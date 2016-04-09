//
//  CTGame.m
//  CheckpointTerminal
//
//  Created by Evgeny Kubrakov on 09/04/16.
//  Copyright © 2016 Streetmage. All rights reserved.
//

#import "CTGame.h"

@implementation CTGame

+ (CTGame *)gameWithJSON:(NSDictionary *)json {
    CTGame *game = [[CTGame alloc] init];
    game.gameName = NilIfNull( [json objectForKey:@"name"]);
    game.mode = NilIfNull([json objectForKey:@"mode"]);
    game.creatorName = NilIfNull([json objectForKey:@"creatorName"]);
    game.code = NilIfNull([json objectForKey:@"code"]);
    return game;
}

@end
