//
//  CTConnectionScreenController.m
//  CheckpointTerminal
//
//  Created by Evgeny Kubrakov on 08/04/16.
//  Copyright © 2016 Streetmage. All rights reserved.
//

#import "CTConnectionScreenController.h"

#import "CTArduinoService.h"

@interface CTConnectionScreenController () <CTArduinoServiceObserver>

@property (nonatomic) IBOutlet NSTextView *textView;

@end

@implementation CTConnectionScreenController

- (void)viewWillAppear {
    [super viewWillAppear];
    [[CTArduinoService sharedService] connect];
    [[CTArduinoService sharedService] subscribeForEvent:CTArduinoServiceIRCodeReceivedEvent
                                               observer:self];
}

- (void)viewWillDisappear {
    [super viewWillDisappear];
    [[CTArduinoService sharedService] disconnect];
    [[CTArduinoService sharedService] unsubscribeObserver:self
                                                 forEvent:CTArduinoServiceIRCodeReceivedEvent];
}

#pragma mark - CTArduinoServiceObserver Methods

- (void)arduinoService:(CTArduinoService *)arduinoService
          didSentEvent:(CTArduinoServiceEvent)event
                  data:(id)data {
    if ([data isKindOfClass:[NSString class]]) {
        self.textView.string = data;
    }
}

@end
