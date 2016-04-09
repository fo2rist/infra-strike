//
//  CTUser.h
//  CheckpointTerminal
//
//  Created by Evgeny Kubrakov on 09/04/16.
//  Copyright © 2016 Streetmage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTUser : NSObject

@property (nonatomic, copy) NSString *phoneNumber;

+ (CTUser *)userWithJSON:(NSDictionary *)json;

@end
