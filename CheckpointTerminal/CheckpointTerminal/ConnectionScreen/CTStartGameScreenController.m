//
//  CTStartGameScreenController.m
//  CheckpointTerminal
//
//  Created by Evgeny Kubrakov on 09/04/16.
//  Copyright © 2016 Streetmage. All rights reserved.
//

#import "CTStartGameScreenController.h"

#import "CTAppDelegate.h"
#import "CTSession.h"
#import "CTNetworkService.h"

#import "CTArduinoService.h"

@interface CTStartGameScreenController ()

@property (nonatomic, weak) IBOutlet NSTextField *userNameTextField;
@property (nonatomic, weak) IBOutlet NSTextField *gameNameTextField;

@end

@implementation CTStartGameScreenController

#pragma mark - Actions

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)onPlayButtonClick:(NSButton *)sender {
    if (self.userNameTextField.stringValue &&
        self.gameNameTextField.stringValue) {
        [[CTNetworkService sharedService] createNewGameWithName:self.gameNameTextField.stringValue
                                                    creatorName:self.userNameTextField.stringValue
                                                           mode:@"check point"
                                                           code:@"00000000"
                                                     completion:^(BOOL success, CTGame *game, NSError *error) {
                                                         if (success) {
                                                             [[CTAppDelegate sharedInstance] openGameStatusScreenWithGame:game];
                                                         }
                                                     }];
    }
}

@end
