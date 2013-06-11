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

#import <Foundation/Foundation.h>
#import "EZFormField.h"


/** Validation and input filter blocks.
 *
 *  For use with -[EZFormField addValidator:] and -[EZFormTextField addInputFilter:].
 */

/** A block-based email address validator.
 *
 *  A block wrapper around EZFormValidateEmailFormat().
 */
extern EZFormFieldValidator EZFormEmailAddressValidator;

/** A block-based email address input filter.
 *
 *  A block wrapper around EZFormFilterInputForEmailAddressFormat().
 */
extern BOOL (^EZFormEmailAddressInputFilter)(id);



/** Validation and input filter functions
 *
 *  For use with -[EZFormField setValidationFunction:] and -[EZFormTextField setInputFilterFunction:].
 */

/** Validates input is all numeric characters.
 */
BOOL
EZFormValidateNumericInput(id input);

/** Validates input is a number within specified limits.
 *
 *  Specify NSNotFound for either min or max for unbounded limit.
 */
BOOL
EZFormValidateNumericInputWithLimits(id input, NSInteger min, NSInteger max);

/** An email address validation function.
 *
 *  Checks for minimum of "x[at]y.z"
 *  Does not allow more than one "@" character.
 *  Does not allow consecutive "." characters.
 */
BOOL
EZFormValidateEmailFormat(NSString *value);

/** Filter input to assist email address entry.
 */
BOOL
EZFormFilterInputForEmailAddressFormat(NSString *input);
