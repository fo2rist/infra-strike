//
//  CTSession.h
//  CheckpointTerminal
//
//  Created by Evgeny Kubrakov on 09/04/16.
//  Copyright © 2016 Streetmage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTSession : NSObject

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, readonly, getter = isLogged) BOOL logged;

+ (instancetype)sharedSession;

@end
