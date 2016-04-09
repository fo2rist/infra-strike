//
//  CTConnectionScreenController.m
//  CheckpointTerminal
//
//  Created by Evgeny Kubrakov on 08/04/16.
//  Copyright © 2016 Streetmage. All rights reserved.
//

#import <libPhoneNumber-iOS/NBPhoneNumber.h>
#import <libPhoneNumber-iOS/NBPhoneNumberUtil.h>

#import "CTConnectionScreenController.h"
#import "CTNetworkService.h"

@interface CTConnectionScreenController () <NSTextFieldDelegate>

@property (nonatomic, weak) IBOutlet NSTextField *phoneNumberTextField;

@end

@implementation CTConnectionScreenController

#pragma mark - Private Methods

- (void)registerWithPhoneNumber:(NSString *)phoneNumber {
    
    NBPhoneNumberUtil *phoneNumberUtil = [[NBPhoneNumberUtil alloc] init];
    NSError *error = nil;
    NSString *countryCode = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
    NBPhoneNumber *parsedPhoneNumber = [phoneNumberUtil parse:phoneNumber
                                                defaultRegion:countryCode
                                                        error:&error];
    
    if (!error) {
        BOOL phoneNumberIsValid =  [phoneNumberUtil isValidNumber:parsedPhoneNumber];
        if (phoneNumberIsValid) {
            NSString *phonenNumberInE164Format = [phoneNumberUtil  format:parsedPhoneNumber
                                                             numberFormat:NBEPhoneNumberFormatE164
                                                                    error:&error];
            NSLog(@"TODO: send phone number for registration %@", phonenNumberInE164Format);
            [self performSegueWithIdentifier:@"ToStartGameScreen" sender:self];
        }
    }
    
    if (error) {
        NSAlert *alert = [NSAlert alertWithError:error];
        [alert runModal];
    }
    
}


#pragma mark - Actions

- (IBAction)onRegisterButtonClick:(NSButton *)sender {
    [self registerWithPhoneNumber:self.phoneNumberTextField.stringValue];
}

@end
