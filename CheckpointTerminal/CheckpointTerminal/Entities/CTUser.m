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
    CTUser *user = [[CTUser alloc] init];
    user.phoneNumber = [json objectForKey:@"phone"];
    return user;
}

@end
