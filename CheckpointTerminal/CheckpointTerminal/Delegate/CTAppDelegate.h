//
//  CTAppDelegate.h
//  CheckpointTerminal
//
//  Created by Evgeny Kubrakov on 08/04/16.
//  Copyright © 2016 Streetmage. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class CTGame;

@interface CTAppDelegate : NSObject <NSApplicationDelegate>

@property NSWindowController *mainWindowController;

+ (CTAppDelegate *)sharedInstance;

- (void)openRegistrationScreen;
- (void)openStartGameScreen;
- (void)openGameStatusScreenWithGame:(CTGame *)game;

@end
