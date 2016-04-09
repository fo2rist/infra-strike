//
//  CTGameStatusScreenController.m
//  CheckpointTerminal
//
//  Created by Evgeny Kubrakov on 09/04/16.
//  Copyright © 2016 Streetmage. All rights reserved.
//

#import "CTGameStatusScreenController.h"

#import "CTNetworkService.h"
#import "CTGame.h"

#import "CTRepeatTimer.h"

@interface CTGameStatusScreenController ()

@property (nonatomic, copy) NSArray *users;
@property (nonatomic, strong) CTRepeatTimer *repeatTimer;

@end

@implementation CTGameStatusScreenController

- (void)viewWillAppear {
    [super viewWillAppear];
    
}

- (void)viewWillDisappear {
    [super viewWillDisappear];
    
}

#pragma mark - Accessors

- (CTRepeatTimer *)repeatTimer {
    if (!_repeatTimer) {
        CTNetworkServiceCompletion completion = ^(BOOL success, id data, NSError *error) {
            if (success) {
                // TODO: populate users
            }
            else if (error) {
                NSAlert *alert = [NSAlert alertWithError:error];
                [alert runModal];
            }
        };
        _repeatTimer = [[CTRepeatTimer alloc] initWithRepeatInterval:10.0
                                                         tickHandler:^{
                                                             [[CTNetworkService sharedService] gameWithName:self.game.gameName
                                                                                                 completion:completion];
                                                         }];
    }
    return _repeatTimer;
}

#pragma mark - Private

- (void)startPolling {
    [self.repeatTimer setupTimer];
}

- (void)stopPolling {
    [self.repeatTimer invalidate];
}

@end
