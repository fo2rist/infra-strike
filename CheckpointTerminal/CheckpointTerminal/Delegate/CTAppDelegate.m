//
//  CTAppDelegate.m
//  CheckpointTerminal
//
//  Created by Evgeny Kubrakov on 08/04/16.
//  Copyright © 2016 Streetmage. All rights reserved.
//

#import "CTAppDelegate.h"

@implementation CTAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    NSStoryboard *mainStoryboard = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    self.mainWindowController = [mainStoryboard instantiateControllerWithIdentifier:@"MainWindowController"];
    [self.mainWindowController showWindow:self];
}

@end
