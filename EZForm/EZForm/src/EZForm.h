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

/*
 * Version: 1.0.1
 */

/*
 *  Documentation can be generated and installed for reading within Xcode using
 *  appledoc from https://github.com/tomaz/appledoc
 *
 *  $ appledoc --project-name EZForm --project-company "Chris Miles" --company-id info.chrismiles EZForm
 */


#import <Foundation/Foundation.h>
#import "EZFormField.h"
#import "EZFormBooleanField.h"
#import "EZFormGenericField.h"
#import "EZFormRadioField.h"
#import "EZFormTextField.h"
#import "EZFormInputAccessoryViewProtocols.h"
#import "EZFormCommonValidators.h"
#import "EZFormRadioChoiceViewController.h"


typedef enum {
    EZFormInputAccessoryTypeNone = 0,
    EZFormInputAccessoryTypeStandard,
} EZFormInputAccessoryType;

typedef enum {
    EZFormInvalidIndicatorViewTypeTriangleExclamation = 1,
} EZFormInvalidIndicatorViewType;


@protocol EZFormDelegate;


/** EZForm is a form handling and validation library.
 *
 *  EZForm manages the form field types, model values and validation.
 *  EZForm is decoupled from the user interface layout. EZForm gives you
 *  full freedom to lay out your user interface however you like.
 *  However, EZForm knows how to work with common user interface elements
 *  and can be wired up to your controls and views to simplify the form
 *  user interface logic.
 */
@interface EZForm : NSObject <EZFormInputAccessoryViewDelegate>

/** The receiver’s delegate.
 *
 *  You can use the delegate to receive messages from EZForm
 *  such as when a field value changes.
 */
@property (nonatomic, assign) id<EZFormDelegate> delegate;

/** Select an input accessory to use for text input fields.
 *
 *  If an input accessory type is selected then EZForm will
 *  automatically add it to any text field controls.
 *
 *  Choose EZFormInputAccessoryTypeStandard to get the common
 *  input accessory added to the virtual keyboard with "Next",
 *  "Previous" and "Done" buttons (similar to Mobile Safari's input
 *  accessory). The "Next" and "Previous" buttons will be
 *  automatically wired up to select the next and previous text
 *  input fields.
 *
 *  By default, no input accessory is used.
 */
@property (nonatomic, assign) EZFormInputAccessoryType inputAccessoryType;

/** Padding around field user views when auto scrolling is enabled.
 */
@property (nonatomic, assign) CGSize autoScrollForKeyboardInputPaddingSize;

/** Adds a field to the form.
 *
 *  @param formField The form field to add to the form.
 */
- (void)addFormField:(EZFormField *)formField;

/** Returns the form field object for the key specified.
 *
 *  @param key The key of the form field to return.
 *
 *  @returns A form field object (subclass of EZFormField) for the specified key.
 *	Or nil of no form field object exists for the specified key.
 */
- (id)formFieldForKey:(NSString *)key;

/** Returns a boolean value indicating whether the form values are currently all valid.
 *
 *  Only returns YES if all form field values pass their validation rules.
 *  Otherwise, returns NO.
 *
 *  @returns A boolean indicating whether all field values of the form are valid.
 */
- (BOOL)isFormValid;

/** Returns a boolean value indicating whether the specified field holds a valid value.
 *
 *  Only returns YES if the value of the specified field passes all
 *  validation rules defined for it.
 *
 *  @param key The key of the form field to return validation state for.
 *
 *  @returns A boolean indicating whether the field value is valid.
 */
- (BOOL)isFieldValid:(NSString *)key;

/** Returns an array of keys for all fields that do not pass validation rules.
 *
 *  @returns An array of keys as strings.
 */
- (NSArray *)invalidFieldKeys;

/** Returns the current value of the specified field.
 *
 *  @param key The key of the field whose value to return.
 *
 *  @returns The model value of the field. The type depends on the field.
 */
- (id)modelValueForKey:(NSString *)key;

/** Returns a dictionary of all field key->value pairs.
 *
 *  @returns A dictionary of all fields, keyed by field key.
 */
- (NSDictionary *)modelValues;

/** Set the value of the specified field.
 *
 *  @param value The new value of the field.
 *
 *  @param key The key of the field as a string.
 */
- (void)setModelValue:(id)value forKey:(NSString *)key;

/** Notifies the receiver to request all of its field controls to resign first responder.
 *
 *  All wired up user interface controls will be notified to resign first
 *  responder status.
 */
- (void)resignFirstResponder;

/** Returns the form field wired to a control currently holding first responder status.
 *
 *  If any field is wired to a user interface control that is currently holding
 *  first responder status then it will be returned.
 *
 *  @returns A form field.
 */
- (EZFormField *)formFieldForFirstResponder;

/** Supply a view that can be scrolled to keep the active form field visible when a keyboard is present.
 *
 *  The view to scroll must contain the form field user views somewhere in its
 *  own view hierarchy.
 *
 *  The view to scroll can be a UITableView, a UIScrollView or a UIView.  A table
 *  view or scroll view will be scrolled to reveal the form field user view.  A
 *  normal view will have its frame origin adjusted.
 *
 *  The property autoScrollForKeyboardInputPaddingSize controls how much padding
 *  to add around the form field user view when calculating visibility.
 *
 *  No views are scrolled if the form field user view is already visible.
 *
 *  By default no views are scrolled or moved when the keyboard is revealed.
 *
 *  @param view The view to scroll or reposition.
 */
- (void)autoScrollViewForKeyboardInput:(UIView *)view;

/** Unwire and release any user-specified views that were attached to the form.
 *
 *  Causes all form fields to detach from any user-specified views or controls
 *  that were added by, for example -[EZFormTextField useTextField:].
 *  Also detaches and releases any view added by
 *  -[EZForm autoScrollViewForKeyboardInput:].
 */
- (void)unwireUserViews;

/** Returns a new instance of a view that can be used to indicate an invalid field.
 *
 *  The type specifies which style of view to create.
 *
 *  @param invalidIndicatorViewType The type of invalid indicator view to return.
 *
 *  @param size The size of the view to return.
 *
 *  @returns A view of the specified type and size.
 */
+ (UIView *)formInvalidIndicatorViewForType:(EZFormInvalidIndicatorViewType)invalidIndicatorViewType size:(CGSize)size;

@end


/** The EZFormDelegate protocol defines the messages sent to an EZForm delegate as part of form handling.
 *
 * All of the methods of this protocol are optional.
 */
@protocol EZFormDelegate <NSObject>

@optional

/** Tells the delegate that a form field value was updated.
 *
 *  @param form The form for which a field value was updated.
 *
 *  @param formField The form field for which the value was updated.
 *
 *  @param isValid Whether the form model is valid or not.
 */
- (void)form:(EZForm *)form didUpdateValueForField:(EZFormField *)formField modelIsValid:(BOOL)isValid;

/** Tells the delegate that the user finished form input on the last field.
 *
 *  This is normally called when the user hits the return key on the last
 *  text field of a form.
 *
 *  @param form The form for which input has finished on the last field.
 */
- (void)formInputFinishedOnLastField:(EZForm *)form;

/** Tells the delegate that editing began for the specified field.
 *
 *  This method tells the delegate that the specified field became the first
 *  responder.
 *
 *  @param form The form containing the field for which editing began.
 *
 *  @param formField The form field for which editing began.
 */
- (void)form:(EZForm *)form fieldDidBeginEditing:(EZFormField *)formField;

/** Asks the delegate for the index path to the row containing the user view
 *  for the specified field.
 *
 *  This should only be needed for forms presented using dynamic table views.
 *  EZForm won't be able to determine where in the table the field's view
 *  is located as it may be off screen and so not part of a table view cell.
 *
 *  If the delegate does not implement this method or returns nil then
 *  the form will attempt to determine the location of the field view, if
 *  possible.
 *
 *  @param form The form requesting the index path.
 *
 *  @param key The key of the field wired to a user view whose index path is
 *  requested.
 *
 *  @returns The indexPath of the cell containing the user view for the field.
 */
- (NSIndexPath *)form:(EZForm *)form indexPathToAutoScrollTableForFieldKey:(NSString *)key;

@end
