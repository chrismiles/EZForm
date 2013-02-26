//
//  EZFormDateField.h
//  EZForm
//
//  Created by Muhammad Y on 2/26/13.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

#import "EZFormTextField.h"

/** A form field to handle date input.
 *  EZFormDateField is a subclass of EZFormTextField and so can
 *  accept input and display choices using any of the user views
 *  supported by EZFormTextField.
 *
 *  EZFormDateField supports wiring up a UIDatePicker to present
 *  the choices to the user, replacing a keyboard for input.
 *  Set the inputView property to a UIDatePicker object, after
 *  wiring up a user view that supports becoming first responder
 *  (like a UITextField).
 */
@interface EZFormDateField : EZFormTextField

/** Used for formatting internal date to visible text.
 */
@property (strong, nonatomic) NSDateFormatter *outDateFormatter;

/** Used for parsing input text to internal date. 
 *  Used only if inputView is not set to UIDatePicker
 */
@property (strong, nonatomic) NSDateFormatter *inDateFormatter;

/** Wires up a view to use for input, replacing the keyboard.
 *
 *  Currently only the UIDatePicker is supported as an EZFormDateField
 *  inputView.  When set, a UIDatePicker is used for selecting a date,
 *  replacing the keyboard.
 *
 *  Setting an inputView is only valid after wiring up a user view that
 *  supports becoming first responder. It works well with a UITextField,
 *  for example.
 */
@property (nonatomic, strong) UIView *inputView;

@end
