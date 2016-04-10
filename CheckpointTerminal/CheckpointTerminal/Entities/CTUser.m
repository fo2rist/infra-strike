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
    user.name = [json objectForKey:@"name"];
    user.code = [json objectForKey:@"code"];
    user.phone = [json objectForKey:@"phone"];
    user.secondsCaptured = @(0);
    
    return user;
    
}

@end
