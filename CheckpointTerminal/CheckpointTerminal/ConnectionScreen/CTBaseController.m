//
//  CTBaseController.m
//  CheckpointTerminal
//
//  Created by Evgeny Kubrakov on 09/04/16.
//  Copyright © 2016 Streetmage. All rights reserved.
//

#import "CTBaseController.h"

@interface CTBaseController ()

@property (nonatomic, strong) NSProgressIndicator *progressIndicator;

@end

@implementation CTBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

#pragma mark - Accessors

- (NSProgressIndicator *)progressIndicator {
    if (!_progressIndicator) {
        _progressIndicator = [[NSProgressIndicator alloc] initWithFrame:NSMakeRect(0.0, 0.0, 30.0, 30.0)];
        _progressIndicator.style = NSProgressIndicatorSpinningStyle;
    }
    return _progressIndicator;
}

#pragma mark - Public Methods

- (void)showActivityIndicator {
    
}

- (void)hideActivityIndicator {
    
}

@end
