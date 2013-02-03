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

//  EZFormMultiRadioFormField by Jesse Collis <jesse@jcmultimedia.com.au>

#import "EZFormRadioField.h"


/** A form field to handle multiple selection from multiple choices.
 *
 * TODO: Documentation for EZFormMultiRadioFormField
 */

@interface EZFormMultiRadioFormField : EZFormRadioField

/** Designates one option to be mutually exclusive 
 * 
 *  Setting this property will cause the value to be toggled off
 *  if additional values are selected, and it will toggle all
 *  other selected values off when it is reselected.
 */
@property (nonatomic, strong) NSString *mutuallyExclusiveChoice;

/** Currently selected keys. 
 *
 *  Returns an NSArray of selected keys and nil if no keys are selected.
 */
- (id)fieldValue;

/** Joins all the field values with a given string
 *
 *  A convenience method to return the selected field values
 *  joined by an NSString. Uses NSString componentsJoinedByString:
 *  underneath.
 */
- (NSString *)fieldValuesJoinedByString:(NSString *)separator;

/** Unsets a set field value
 *
 *  The equivalent to passing YES to unsetFieldValue:canUpdateView:
 */
- (void)unsetFieldValue:(id)value;

/** Unsets all previously set field values
 *  
 *  Note: passing nil to setFieldValue: causes this method to be invoked.
 */
- (void)unsetAllFieldValues;

/** Unsets a specific field value if it's set
 *
 *  This method acts the same as EZFormField setFieldValue: canUpdateView:
 */
- (void)unsetFieldValue:(id)value canUpdateView:(BOOL)canUpdateView;



@end
