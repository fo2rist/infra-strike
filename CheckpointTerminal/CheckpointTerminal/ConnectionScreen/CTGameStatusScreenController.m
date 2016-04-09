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

@property (nonatomic, weak) IBOutlet NSButton *gameStateChangeButton;

@end

@implementation CTGameStatusScreenController

- (void)viewWillAppear {
    [super viewWillAppear];
    [self startPolling];
}

- (void)viewWillDisappear {
    [super viewWillDisappear];
    [self stopPolling];
}

#pragma mark - Accessors

- (CTRepeatTimer *)repeatTimer {
    
    if (!_repeatTimer) {
        
        CTNetworkServiceCompletion completion = ^(BOOL success, CTGame *game, NSError *error) {
            if (success) {
                self.game = game;
            }
            else if (error) {
                if (error.code == -1011) {
                    [self stopPolling];
                }
                else {
                    NSAlert *alert = [NSAlert alertWithError:error];
                    [alert runModal];
                }
            }
        };
        
        _repeatTimer = [[CTRepeatTimer alloc] initWithRepeatInterval:10.0
                                                         tickHandler:^{
                                                             [[CTNetworkService sharedService] gameWithName:self.game.gameName
                                                                                                 completion:completion];
                                                             
                                                             [[CTNetworkService sharedService] shootWithGameName:self.game.gameName
                                                                                                            code:@"0xFFFFFF"
                                                                                                      completion:^(BOOL success, id data, NSError *error) {
                                                                                                          
                                                                                                      }];
                                                             
                                                         }];
        
    }
    
    return _repeatTimer;
}

- (void)setGame:(CTGame *)game {
    _game = game;
    [self reloadData];
    if ([game.state isEqualToString:CTStatePending]) {
        self.gameStateChangeButton.image = [NSImage imageNamed:@"PlayButtonBG"];
    }
    else if ([game.state isEqualToString:CTStateInProgress]) {
        self.gameStateChangeButton.image = [NSImage imageNamed:@"StopButtonBG"];
    }
    else {
        self.gameStateChangeButton.hidden = YES;
    }
}

#pragma mark - Private

- (void)reloadData {
    
}

- (void)startPolling {
    [self.repeatTimer setupTimer];
}

- (void)stopPolling {
    [self.repeatTimer invalidate];
}

#pragma mark - Actions

- (IBAction)onChangeGameStateButtonClick:(NSButton *)sender {
    NSString *state = self.game.state;
    if ([state isEqualToString:CTStatePending]) {
        [[CTNetworkService sharedService] startGameWithName:self.game.gameName
                                                 completion:^(BOOL success, CTGame *game, NSError *error) {
                                                     if (success) {
                                                         self.game = game;
                                                     }
                                                     else if (error) {
                                                         NSAlert *alert = [NSAlert alertWithError:error];
                                                         [alert runModal];
                                                     }
                                                 }];
    }
    else if ([state isEqualToString:CTStateInProgress]) {
        [[CTNetworkService sharedService] stopGameWithName:self.game.gameName
                                                completion:^(BOOL success, CTGame *game, NSError *error) {
                                                    if (success) {
                                                        self.game = game;
                                                        [self stopPolling];
                                                    }
                                                    else if (error) {
                                                        NSAlert *alert = [NSAlert alertWithError:error];
                                                        [alert runModal];
                                                    }
                                                }];
    }
}

@end
