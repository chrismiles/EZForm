//
//  EZForm
//
//  Copyright 2011-2013 Chris Miles. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "EZFormCommonValidators.h"


#pragma mark - Input Validation Blocks

EZFormFieldValidator EZFormEmailAddressValidator = ^(id value)
{
    return EZFormValidateEmailFormat(value);
};

BOOL (^EZFormEmailAddressInputFilter)(id) = ^(id input)
{
    return EZFormFilterInputForEmailAddressFormat(input);
};


#pragma mark - Input Validation functions

BOOL
EZFormValidateNumericInputWithLimits(id input, NSInteger min, NSInteger max)
{
    // Restrict to only numeric characters
    NSCharacterSet *nonNumericCharset = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSRange nonNumericRange = [(NSString *)input rangeOfCharacterFromSet:nonNumericCharset];
    if (nonNumericRange.location != NSNotFound) {
	return NO;
    }
    
    if ([(NSString *)input length] > 0) {
	// Restrict to specified range of numbers
	NSInteger value = [input integerValue];
	if ((min != NSNotFound && value < min) || (max != NSNotFound && value > max)) {
	    return NO;
	}
    }
    
    return YES;
}

BOOL
EZFormValidateNumericInput(id input)
{
    return EZFormValidateNumericInputWithLimits(input, NSNotFound, NSNotFound);
}

BOOL
EZFormValidateEmailFormat(NSString *value)
{
    /* Checks for minimum of "x@y.z"
     * Does not allow more than one "@" character.
     * Does not allow consecutive "." characters.
     */
    
    if ([value length] < 5) {
	return NO;
    }
    
    // Check for "@" char within string, but not at either end
    NSRange range = [value rangeOfString:@"@"];
    if (range.location == NSNotFound || range.location < 1 || range.location >= [value length]-1) {
	return NO;
    }
    
    // Check for multiple "@" chars
    NSRange range2 = [value rangeOfString:@"@" options:NSBackwardsSearch];
    if (range2.location != range.location) {
	return NO;
    }
    
    NSString *domain = [value componentsSeparatedByString:@"@"][1];
    
    if ([domain length] < 3) {
	return NO;
    }
    
    // Check for "." char within domain, but not the first character
    range = [domain rangeOfString:@"."];
    if (range.location == NSNotFound || range.location < 1) {
	return NO;
    }
    
    // Check for ".." char within domain
    range = [domain rangeOfString:@".."];
    if (range.location != NSNotFound) {
	return NO;
    }
    
    return YES;
}


#pragma mark - Text field input filter functions

BOOL
EZFormFilterInputForEmailAddressFormat(NSString *input)
{
    /* For use as an EZFormTextField input filter for email address input.
     *
     * Prevents multiple "@" characters.
     * Prevents consecutive "." characters in domain part.
     */
    
    NSRange range = [input rangeOfString:@"@"];
    if (range.location != NSNotFound) {
	
	// Check for multiple "@" chars
	NSRange range2 = [input rangeOfString:@"@" options:NSBackwardsSearch];
	if (range2.location != range.location) {
	    return NO;
	}
	
	NSString *domain = [input componentsSeparatedByString:@"@"][1];
	
	range = [domain rangeOfString:@"."];
	if (range.location != NSNotFound) {
	    
	    // Check for ".." char within domain
	    range = [domain rangeOfString:@".."];
	    if (range.location != NSNotFound) {
		return NO;
	    }
	}
    }
    
    return YES;
}
