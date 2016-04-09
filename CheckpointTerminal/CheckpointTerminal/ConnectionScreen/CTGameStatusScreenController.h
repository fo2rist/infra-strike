//
//  CTGameStatusScreenController.h
//  CheckpointTerminal
//
//  Created by Evgeny Kubrakov on 09/04/16.
//  Copyright © 2016 Streetmage. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class CTGame;

@interface CTGameStatusScreenController : NSViewController

@property (nonatomic, strong) CTGame *game;

@end
