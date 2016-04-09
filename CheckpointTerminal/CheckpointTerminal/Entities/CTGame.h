//
//  CTGame.h
//  CheckpointTerminal
//
//  Created by Evgeny Kubrakov on 09/04/16.
//  Copyright © 2016 Streetmage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTGame : NSObject

@property (nonatomic, copy) NSString *gameName;
@property (nonatomic, copy) NSString *mode;
@property (nonatomic, copy) NSString *creatorName;
@property (nonatomic, copy) NSString *code;

+ (CTGame *)gameWithJSON:(NSDictionary *)json;

@end
