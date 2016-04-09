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

    }
    return _progressIndicator;
}

#pragma mark - Public Methods

- (void)showActivityIndicator {
    
}

- (void)hideActivityIndicator {
    
}

@end
