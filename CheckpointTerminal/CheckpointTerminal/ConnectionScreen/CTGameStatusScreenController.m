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
#import "CTUser.h"

#import "CTRepeatTimer.h"

#import "CTArduinoService.h"

@interface CTGameStatusScreenController () <NSTableViewDataSource, NSTableViewDelegate>

@property (nonatomic, copy) NSArray *users;
@property (nonatomic, strong) CTRepeatTimer *repeatTimer;
@property (nonatomic, strong) NSString *cachedGameName;

@property (nonatomic, weak) IBOutlet NSTextField *gameNameLabel;
@property (nonatomic, weak) IBOutlet NSTextField *gameOwnerName;
@property (nonatomic, weak) IBOutlet NSButton *gameStateChangeButton;
@property (nonatomic, weak) IBOutlet NSTableView *tableView;

@end

@implementation CTGameStatusScreenController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear {
    [super viewWillAppear];
    [self startPolling];
    
    self.gameNameLabel.stringValue = self.cachedGameName;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:CTArduinoServiceIRCodeReceivedEvent
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      [[CTNetworkService sharedService] shootWithGameName:self.cachedGameName
                                                                                                     code:note.userInfo[@"code"]
                                                                                               completion:^(BOOL success, id data, NSError *error) {
                                                                                                   
                                                                                               }];
                                                  }];
    
}

- (void)viewWillDisappear {
    [super viewWillDisappear];
    [self stopPolling];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark - Accessors

- (CTRepeatTimer *)repeatTimer {
    
    if (!_repeatTimer) {
        
        CTNetworkServiceCompletion completion = ^(BOOL success, CTGame *game, NSError *error) {
            if (success && game) {
                self.game = game;
            }
            else if (error) {
                if (error.code == -1011) {
                    [self stopPolling];
                }
                else {
//                    NSAlert *alert = [NSAlert alertWithError:error];
//                    [alert runModal];
                }
            }
        };
        
        _repeatTimer = [[CTRepeatTimer alloc] initWithRepeatInterval:10.0
                                                         tickHandler:^{
                                                             [[CTNetworkService sharedService] gameWithName:self.cachedGameName
                                                                                                 completion:completion];
                                                         }];
        
    }
    
    return _repeatTimer;
}

- (void)setGame:(CTGame *)game {
    _game = game;
    if (game.gameName.length > 0) {
        self.cachedGameName = game.gameName;
    }
    [self updateViews];
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

- (void)updateViews {
    [self.tableView reloadData];
    if (self.game.ownerName) {
        self.gameOwnerName.stringValue = self.game.ownerName;
    }
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
        [[CTNetworkService sharedService] startGameWithName:self.cachedGameName
                                                 completion:^(BOOL success, CTGame *game, NSError *error) {
                                                     if (success && game) {
                                                         self.game = game;
                                                         [[CTArduinoService sharedService] connect];
                                                     }
                                                     else if (error) {
                                                         NSAlert *alert = [NSAlert alertWithError:error];
                                                         [alert runModal];
                                                     }
                                                 }];
    }
    else if ([state isEqualToString:CTStateInProgress]) {
        [[CTNetworkService sharedService] stopGameWithName:self.cachedGameName
                                                completion:^(BOOL success, CTGame *game, NSError *error) {
                                                    if (success && game) {
                                                        self.game = game;
                                                        [self stopPolling];
                                                        [[CTArduinoService sharedService] disconnect];
                                                    }
                                                    else if (error) {
                                                        NSAlert *alert = [NSAlert alertWithError:error];
                                                        [alert runModal];
                                                    }
                                                }];
    }
}

#pragma mark - NSTableViewDataSource Methods

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.game.participants.count;
}

- (nullable id)tableView:(NSTableView *)tableView objectValueForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row {
    CTUser *user = [self.game.participants objectAtIndex:row];
    if (tableView.tableColumns[0] == tableColumn) {
        return user.name;
    }
    else if (tableView.tableColumns[1] == tableColumn) {
        return user.kills.stringValue ? user.kills.stringValue : @"0";
    }
    else if (tableView.tableColumns[2] == tableColumn){
        return user.deaths.stringValue ? user.deaths.stringValue : @"0";
    }
    return nil;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 100.0;
}

@end
