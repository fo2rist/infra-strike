//
//  CTAppDelegate.m
//  CheckpointTerminal
//
//  Created by Evgeny Kubrakov on 08/04/16.
//  Copyright © 2016 Streetmage. All rights reserved.
//

#import "CTAppDelegate.h"

#import "CTArduinoService.h"
#import "CTSession.h"

#import "CTConnectionScreenController.h"
#import "CTStartGameScreenController.h"
#import "CTGameStatusScreenController.h"

@interface CTAppDelegate ()

@property (nonatomic, readonly) NSStoryboard *mainStoryBoard;

@end

@implementation CTAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    if (![CTSession sharedSession].isLogged) {
        [[CTAppDelegate sharedInstance] openRegistrationScreen];
    }
    [CTSession sharedSession].userId = nil;
}

#pragma mark - Accessors

+ (CTAppDelegate *)sharedInstance {
    return [NSApplication sharedApplication].delegate;
}

#pragma mark - Public Methods

- (void)openRegistrationScreen {
    CTConnectionScreenController *connectionScreenController = [self.mainStoryBoard instantiateControllerWithIdentifier:@"CTConnectionScreenController"];
    [self setupContentController:connectionScreenController];
}

- (void)openStartGameScreen {
    CTStartGameScreenController *startGameScreenController = [self.mainStoryBoard instantiateControllerWithIdentifier:@"CTStartGameScreenController"];
    [self setupContentController:startGameScreenController];
}

- (void)openGameStatusScreenWithGame:(CTGame *)game {
    CTGameStatusScreenController *gameStatusScreenController = [self.mainStoryBoard instantiateControllerWithIdentifier:@"CTGameStatusScreenController"];
    gameStatusScreenController.game = game;
    [self setupContentController:gameStatusScreenController];
}

#pragma mark - Private Methods

- (NSStoryboard *)mainStoryBoard {
    return [NSStoryboard storyboardWithName:@"Main" bundle:nil];
}

- (void)setupContentController:(NSViewController *)contentController {
    [NSApplication sharedApplication].windows.firstObject.windowController.contentViewController = contentController;
}

@end
