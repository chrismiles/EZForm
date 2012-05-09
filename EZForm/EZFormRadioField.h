//
//  EZForm
//
//  Copyright 2011-2012 Chris Miles. All rights reserved.
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
#import "EZFormFieldConcreteProtocol.h"


/** A form field to handle selection from multiple choices.
 *
 *  The value of the selection can be displayed with a label.
 *
 *  The choices are typically presented to the user in a table
 *  view.
 */
@interface EZFormRadioField : EZFormField <EZFormFieldConcrete>

/** Set choices as key->value pairs.
 *
 *  The key of a selected choice will be returned as the model value.
 *  The value of the choice is what is to be displayed to the user.
 */
@property (nonatomic, retain) NSDictionary *choices;

/** Set a value to display when no choice has been selected.
 *
 */
@property (nonatomic, copy) NSString *unselected;

/** Sets whether validation requires a choice to be selected.
 */
@property (nonatomic, assign) BOOL validationRequiresSelection;

/** Sets whether validation requires one of the defined choices to be
 *  selected.
 *
 *  If NO, the field value does not need to be set to one of the
 *  defined choices to pass validation.
 */
@property (nonatomic, assign) BOOL validationRestrictedToChoiceValues;

/** Wire up a UILabel to the form field.
 *
 *  The UILabel is used to display the value of the form field. The
 *  view is automatically updated when the value changes.
 *
 *  Only one view/control can be wired up at any one time.
 *
 *  @param label A UILabel.
 */
- (void)useLabel:(UILabel *)label;

/** Set choices from an array of values.
 *
 *  The order of choices in the array is maintained.
 *
 *  The key and value of each choice will be equivalent.
 *
 *  @param choices An array of values to use as choices.
 */
- (void)setChoicesFromArray:(NSArray *)choices;

/** Returns the keys of all choices.
 */
- (NSArray *)choiceKeys;

@end
