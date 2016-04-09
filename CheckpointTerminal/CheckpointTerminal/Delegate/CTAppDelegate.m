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

@property (nonatomic, strong) NSStoryboard *mainStoryboard;

@end

@implementation CTAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    NSStoryboard *mainStoryboard = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    self.mainWindowController = [mainStoryboard instantiateControllerWithIdentifier:@"MainWindowController"];
    if ([CTSession sharedSession])
    [self.mainWindowController showWindow:self];
}

- (void)applicationWillTerminate:(NSNotification *)notification {
    [[CTArduinoService sharedService] disconnect];
}

#pragma mark - Accessors

+ (CTAppDelegate *)sharedInstance {
    return [NSApplication sharedApplication].delegate;
}

#pragma mark - Public Methods

- (void)openRegistrationScreen {
    CTConnectionScreenController *connectionScreenController = [self.mainStoryboard instantiateControllerWithIdentifier:@"CTConnectionScreenController"];
    self.mainWindowController.contentViewController = connectionScreenController;
}

- (void)openStartGameScreen {
    CTStartGameScreenController *startGameScreenController = [self.mainStoryboard instantiateControllerWithIdentifier:@"CTStartGameScreenController"];
    self.mainWindowController.contentViewController = startGameScreenController;
}

@end
