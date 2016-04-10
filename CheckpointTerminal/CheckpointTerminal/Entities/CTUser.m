//
//  CTUser.m
//  CheckpointTerminal
//
//  Created by Evgeny Kubrakov on 09/04/16.
//  Copyright © 2016 Streetmage. All rights reserved.
//

#import "CTUser.h"

@implementation CTUser

+ (CTUser *)userWithJSON:(NSDictionary *)json {
    
    if (!json) {
        return nil;
    }
    
    CTUser *user = [[CTUser alloc] init];
    user.name = NilIfNull([json objectForKey:@"name"]);
    user.code = NilIfNull([json objectForKey:@"code"]);
    user.phone = NilIfNull([json objectForKey:@"phone"]);
    user.kills = NilIfNull([json objectForKey:@"frags"]);
    user.deaths = NilIfNull([json objectForKey:@"deaths"]);
    
    user.secondsCaptured = @(0);
    
    return user;
    
}

@end
