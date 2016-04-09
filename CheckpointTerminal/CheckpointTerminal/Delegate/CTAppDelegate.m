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

@interface CTAppDelegate ()

@end

@implementation CTAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    if (![CTSession sharedSession].isLogged) {
        [[CTAppDelegate sharedInstance] openRegistrationScreen];
    }
}

#pragma mark - Accessors

+ (CTAppDelegate *)sharedInstance {
    return [NSApplication sharedApplication].delegate;
}

#pragma mark - Public Methods

- (void)openRegistrationScreen {
    CTConnectionScreenController *connectionScreenController = [[NSStoryboard storyboardWithName:@"Main" bundle:nil]instantiateControllerWithIdentifier:@"CTConnectionScreenController"];
    [NSApplication sharedApplication].windows.firstObject.windowController.contentViewController = connectionScreenController;
}

- (void)openStartGameScreen {
    CTStartGameScreenController *startGameScreenController = [[NSStoryboard storyboardWithName:@"Main" bundle:nil] instantiateControllerWithIdentifier:@"CTStartGameScreenController"];
    [NSApplication sharedApplication].windows.firstObject.windowController.contentViewController = startGameScreenController;
}

@end
