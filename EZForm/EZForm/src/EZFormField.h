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

#import <UIKit/UIKit.h>


typedef BOOL (*VALIDATOR)(id);			    // function validator
typedef BOOL (^EZFormFieldValidator)(id value);	    // block validator

@class EZForm;


/** Abstract base class for form fields.
 *
 *  This class is not designed to be used on its own. Instead, choose one of
 *  the subclasses: EZFormBooleanField, EZFormGenericField, EZFormRadioField,
 *  or EZFormTextField.
 */
@interface EZFormField : NSObject

@property (nonatomic, assign) BOOL validationDisabled;
@property (nonatomic, weak, readonly) EZForm *form;
@property (nonatomic, strong) UIView *inputAccessoryView;
@property (nonatomic, copy) NSString *key;


/** Initialises an allocated EZFormField object with the specified key.
 *
 *  @param aKey The key of the form field.
 *
 *  @returns Initialised EZFormField object.
 */
- (id)initWithKey:(NSString *)aKey;

/** Returns the current value of the field.
 */
- (id)fieldValue;

/** Updates the value of the field.
 *
 *  Any wired user view is updated with the new value.
 *
 *  Also see setFieldValue:canUpdateView:.
 *
 *  @param value The new value to set.
 */
- (void)setFieldValue:(id)value;

/** Updates the value of the field and optionally updates a wired user view.
 *
 *  Any wired user view is only updated if canUpdateView is YES.
 *
 *  @param value The new value to set.
 *
 *  @param canUpdateView Whether to update a wired user view.
 */
- (void)setFieldValue:(id)value canUpdateView:(BOOL)canUpdateView;

/** Set a user-defined validator function.
 *
 *  The function will be called to validate the field value and
 *  should return YES if the value is valid, NO otherwise.
 *
 *  Any validation blocks added with addValidator: will be
 *  called first. The validation function will only be called
 *  if all the validation blocks return YES.
 *
 *  @param validatorFunction A function that accepts a single
 *  object argument and returns a boolean.
 */
- (void)setValidationFunction:(VALIDATOR)validatorFunction;

/** Adds a user-defined validator.
 *
 *  User-defined validators will be called, in order, to validate
 *  the field value and should return YES if the value is valid,
 *  NO otherwise.
 *
 *  Validators are called until one of them returns NO.
 *
 *  @param validator A block object containing the validation logic.
 */
- (void)addValidator:(BOOL (^)(id value))validator;

/** Returns a boolean indicating whether the field value is valid.
 */
- (BOOL)isValid;

/** Requests the wired user control to become first responder.
 */
- (void)becomeFirstResponder;

/** Requests the wired user control to resign first responder.
 */
- (void)resignFirstResponder;

/** Returns whether the wired user control can become first responder.
 */
- (BOOL)canBecomeFirstResponder;

/** Returns whether the wired user control is currently holding
 *  first responder status.
 */
- (BOOL)isFirstResponder;

/** Returns the wired user view or control.
 */
- (UIView *)userView;

/** Returns a boolean indicating whether the wired user control
 *  accepts an input accessory.
 */
- (BOOL)acceptsInputAccessory;

/** Unwire and release any user-specified views that were attached to the form field.
 *
 *  Causes form field to detach and release any user-specified views or controls
 *  that were added by, for example -[EZFormTextField useTextField:].
 */
- (void)unwireUserViews;

@end
