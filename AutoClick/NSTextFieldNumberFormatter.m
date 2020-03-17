//
//  NSTextFieldNumberFormatter.m
//  AutoClick
//
//  Created by Primax on 2019/7/9.
//  Copyright © 2019 Primax. All rights reserved.
//

#import "NSTextFieldNumberFormatter.h"

@implementation NSTextFieldNumberFormatter

-(BOOL)isPartialStringValid:(NSString *)partialString newEditingString:(NSString **)newString errorDescription:(NSString **) error {
    // Make sure we clear newString and error to ensure old values aren't being used
    if (newString)
    {
        *newString = nil;
    }
    if (error)
    {
        *error = nil;
    }

    static NSCharacterSet *nonDecimalCharacters = nil;
    if (nonDecimalCharacters == nil) {
        nonDecimalCharacters = [[NSCharacterSet decimalDigitCharacterSet] invertedSet] ;
    }
    
    if ([partialString length] == 0) {
        return YES; // The empty string is okay (the user might just be deleting everything and starting over)
    } else if ([partialString rangeOfCharacterFromSet:nonDecimalCharacters].location != NSNotFound) {
        return NO; // Non-decimal characters aren't cool!
    }

    return YES;
}

@end
