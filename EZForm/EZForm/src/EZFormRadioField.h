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
#import "EZFormTextField.h"


/** A form field to handle selection from multiple choices.
 *
 *  EZFormRadioField is a subclass of EZFormTextField and so can
 *  accept input and display choices using any of the user views
 *  supported by EZFormTextField.
 *
 *  EZFormRadioField supports wiring up a UIPickerView to present
 *  the choices to the user, replacing a keyboard for input.
 *  Set the inputView property to a UIPickerView object, after
 *  wiring up a user view that supports becoming first responder
 *  (like a UITextField).
 *
 *  Alternatively, choices are commonly presented to the user in a table
 *  view.  EZForm provides EZFormRadioChoiceViewController as a
 *  convenience for presenting choices in a table view.
 *  The EZForm object and field key specifying the EZFormRadioField
 *  can be set on the EZFormRadioChoiceViewController object.
 *  It is up to the user to present the EZFormRadioChoiceViewController
 *  using whichever mechanism best fits the application (e.g.
 *  navigation push).
 */
@interface EZFormRadioField : EZFormTextField

/** Set choices as key->value pairs.
 *
 *  The key of a selected choice will be returned as the model value.
 *  The value of the choice is what is to be displayed to the user.
 */
@property (nonatomic, strong) NSDictionary *choices;

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

/** Wires up a view to use for input, replacing the keyboard.
 *
 *  Currently only the UIPickerView is supported as an EZFormRadioField
 *  inputView.  When set, a UIPickerView is used for selecting a choice,
 *  replacing the keyboard.
 *
 *  Setting an inputView is only valid after wiring up a user view that
 *  supports becoming first responder. It works well with a UITextField,
 *  for example.
 */
@property (nonatomic, strong) UIView *inputView;

/** Set choices from an array of values.
 *
 *  The order of choices in the array is maintained.
 *
 *  The key and value of each choice will be equivalent.
 *
 *  @param choices An array of values to use as choices.
 */
- (void)setChoicesFromArray:(NSArray *)choices;

/** set choices from an array of keys and values.
 *
 *  The order of choices is maintained
 * 
 *  An alternative to setChoicesFromArray: when you have a sorted list of 
 *  keys and values.
 */
- (void)setChoicesFromKeys:(NSArray *)keys values:(NSArray *)values;

/** Returns the keys of all choices.
 *
 */
- (NSArray *)choiceKeys;

/** Returns the current display value of the field
 *
 *  @return the value stored against the field's selected fieldValue key.
 */
- (NSString *)fieldDisplayValue;

@end
