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

/*
 * Version: 1.1.0
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
#import "EZFormContinuousField.h"
#import "EZFormGenericField.h"
#import "EZFormRadioField.h"
#import "EZFormMultiRadioFormField.h"
#import "EZFormDateField.h"
#import "EZFormTextField.h"
#import "EZFormChildFormField.h"
#import "EZFormInputAccessoryViewProtocols.h"
#import "EZFormCommonValidators.h"
#import "EZFormRadioChoiceViewController.h"
#import "EZFormInputControl.h"
#import "EZFormValueTransformer.h"
#import "EZFormReversibleValueTransformer.h"


typedef NS_ENUM(NSInteger, EZFormInputAccessoryType) {
    EZFormInputAccessoryTypeNone = 0,
    EZFormInputAccessoryTypeStandard, //done button on the right
    EZFormInputAccessoryTypeStandardLeftAligned, //done button on the left
    EZFormInputAccessoryTypeDone, //done button on the right, no prev/next item
    EZFormInputAccessoryTypeDoneLeftAligned //done button on the left, no prev/next item
} ;

typedef NS_ENUM(NSInteger, EZFormInvalidIndicatorViewType) {
    EZFormInvalidIndicatorViewTypeTriangleExclamation = 1,
} ;

@protocol EZFormDelegate;
extern NSString * const EZFormChildFormPathSeparator;
extern NSString * const EZFormGroupedFieldsRegularExpression;


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
@property (nonatomic, weak) id<EZFormDelegate> delegate;

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

@property (nonatomic, strong) UIColor *inputAccessoryViewTintColor;
@property (nonatomic, strong) UIColor *inputAccessoryViewBarTintColor NS_AVAILABLE_IOS(7_0);
@property (nonatomic, assign) BOOL inputAccessoryViewTranslucent;   //defaults to YES

/** Padding around field user views when auto scrolling is enabled.
 *
 *  Ignored when auto scrolling a UITableView unless
 *  autoScrollForKeyboardInputVisibleRect is used.
 *
 *  Also see -autoScrollViewForKeyboardInput:
 */
@property (nonatomic, assign) CGSize autoScrollForKeyboardInputPaddingSize;

/** Area of auto scrolling view to ensure is always visible when keyboard present.
 *
 *  Also see -autoScrollViewForKeyboardInput:
 */
@property (nonatomic, assign) CGRect autoScrollForKeyboardInputVisibleRect;

/** Adds a field to the form.
 *
 *  @param formField The form field to add to the form.
 */
- (void)addFormField:(EZFormField *)formField;

/**
 * Inserts a field before another field.
 *
 * If the existing form field cannot be found the field will be added to the end.
 *
 * @param   formField       The form field to be inserted
 * @param   key             The key of the existing form field.
**/
- (void)insertFormField:(EZFormField *)formField beforeKey:(NSString *)key;

/**
 * Inserts a field after another field.
 *
 * If the existing form field cannot be found the field will be added to the end.
 *
 * @param   formField       The form field to be inserted.
 * @param   key             The key of the existing form field.
**/
- (void)insertFormField:(EZFormField *)formField afterKey:(NSString *)key;

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
@property (nonatomic, getter=isFormValid, readonly) BOOL formValid;

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
@property (nonatomic, readonly, copy) NSArray *invalidFieldKeys;

/** Returns the current value of the specified field.
 *
 *  @param key The key of the field whose value to return.
 *
 *  @returns The model value of the field. The type depends on the field.
 */
- (id)modelValueForKey:(NSString *)key;

/** A dictionary of all field key->value pairs, with child form fields in nested dictionaries.
 *
 * When setting the model values, only those values specified in the NSDictionary
 * will be updated. If using child forms, ensure that the nested dictionaries line up.
 *
 *  @returns A dictionary of all fields, keyed by field key.
 */
@property (nonatomic, copy) NSDictionary *modelValues;

/** Set the value of the specified field.
 *
 *  @param value The new value of the field.
 *
 *  @param key The key of the field as a string.
 */
- (void)setModelValue:(id)value forKey:(NSString *)key;

/**
 * Clears (nils) the values of all form fields.
**/
- (void)clearModelValues;

/** A NSValueTransformer that can be used to transform this form to an object of another type.
 *
 * For example, you can use this to transform the form's modelValues dictionary into your model object for
 * easy population. As per each field's -modelValueTransformer property, the forward transformation will
 * populate the form values, while the reverse transformation will export the form's values.
 *
 * The NSValueTransformer specified is expected to work in the following manner:
 *
 * Forward Transformation:
 *
 * The input value can be any object. It is expected that your transformer will return
 * an NSDictionary of formField key => values pairs that align with the fields in the form. Populating child
 * forms can be performed via nested dictionaries (i.e. dict[@"child"][@"field"]). If the transformed
 * value is nil the model values of the form will be cleared.
 *
 * Reverse Transformation:
 *
 * The input to the reverse transformer will be an NSDictionary of formField key => value mappings. Child
 * form values will be in nested dictionaries. The reverse transformer should return any object, such as your model objects.
 *
 * WARNING: Be careful when mixing -formValueTransformer and individual field's -valueTransformer. EZForm will always respect
 * the field's -valueTransformer, so expect that values might be transformed twice. For example, when importing to EZForm
 * (forward transforming), you should be returning a value your field's -valueTransformer can handle.
**/
@property (nonatomic, strong) NSValueTransformer *formValueTransformer;

/**
 * The transformed value of this form.
 *
 * This uses the -formValueTransformer property to convert the form's -modelValues dictionary into another object.
 * This is typically used for converting exporting or importing the entire form at once, such as when using child forms.
 *
 * If no -formValueTransformer is present, this property will be nil.
 *
 * WARNING: Be careful when mixing -formValueTransformer and individual field's -valueTransformer. EZForm will always respect
 * the field's -valueTransformer, so expect that values might be transformed twice. For example, when importing to EZForm
 * (forward transforming), you should be returning a value your field's -valueTransformer can handle.
**/
@property (nonatomic, weak) id transformedModelValue;

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
@property (nonatomic, readonly, strong) EZFormField *formFieldForFirstResponder;

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

/** Attempts to scroll the view so that the specified form field is visible.
 *
 *  Only valid if an auto scroll view is assigned with -autoScrollViewForKeyboardInput:.
 */
- (void)scrollFormFieldToVisible:(EZFormField *)formField;

/** @name Child Form Groups **/


/**
 * Returns the number of fields in the specified field group.
 *
 * Fields in the group are identified by the pattern key-<unique identifier>.
 *
 * @param   key         The key that identifies the form group.
 * @returns             The number of fields in the form that are in this group. Returns zero if the group is not found.
**/
- (NSInteger)numberOfFieldsForChildFormGroupWithKey:(NSString *)key;

/**
 * Removes the specified field from the form.
 *
 * @param   key         The key for a form field.
**/
- (void)removeFormFieldWithKey:(NSString *)key;

/**
 * Retrieves the form field from the form group at the specified index.
 *
 * Fields in the group are identified by the pattern key-<unique identifier>.
 *
 * @param   key         The key that identifies the form group.
 * @param   index       The index of a field within the group.
 * @returns             An EZFormField subclass (typically an EZFormChildFormField) for the field at that index, otherwise nil.
**/
- (id)formFieldInChildFormGroupWithKey:(NSString *)key atIndex:(NSUInteger)index;

/**
 * Retrieves an array of all of the form fields in the specified form group.
 *
 * Fields in the group are identified by the pattern key-<unique identifier>.
 *
 * @param   key         The key that identifies the form group.
 * @returns             An NSArray of all EZFormField objects (or subclasses thereof) in the specified group. Returns an empty array of the group is not found.
**/
- (NSArray *)formFieldsInGroupWithKey:(NSString *)key;

/**
 * Retrieves the EZForm subclass used for a particular child form group.
 *
 * This value is typically used to allow for easy additions of objects to the group. See -addObject:toGroupWithKey: for more.
 *
 * Fields in the group are identified by the pattern key-<unique identifier>.
 *
 * @param   key         The key that identifies the form group.
 * @returns             The Class of an EZForm subclass that has been associated with this form group.
**/
- (Class)formClassForChildFormGroupWithKey:(NSString *)key;

/**
 * Associates an EZFormSubclass with the specified form group.
 *
 * This is typically used to allow for easy additions of objects to form groups. See -addObject:toGroupWithKey: for more.
 *
 * @param   klass       An EZForm subclass.
 * @param   key         The key that identifies the form group.
**/
- (void)setFormClass:(Class)klass forChildFormGroupWithKey:(NSString *)key;

/**
 * Creates a new row/child form in the specified form group, populated with the specified object.
 *
 * This allows you to easy create a new row in the group, and using form transformers provide a initial value for the child
 * form.
 *
 * @param   object      An object to be used (via a -formValueTransformer on your subclass) as the initial value for the child form.
 * @param   key         The key that identifies the form group.
 * @returns             The field key that identifies this object. This is typically in the form groupKey:<unique identifier>.
**/
- (NSString *)addObject:(id)object toGroupWithKey:(NSString *)key;

@end


/** The EZFormDelegate protocol defines the messages sent to an EZForm delegate as part of form handling.
 *
 * All of the methods of this protocol are optional.
 */
@protocol EZFormDelegate <NSObject>

@optional

/** Tells the delegate that the Done button was touched and the keyboard is closing.
 *
 *  This method tells the delegate that the Done button was touched and
 *  the keyboard is closing.
 *
 *  @param form The form containing the field for which editing began.
 */
- (void)formInputAccessoryViewDone:(EZForm *)form;

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

/** Tells the delegate that editing ended for the specified field.
 *
 *  This method tells the delegate that the specified field resigned the first
 *  responder.
 *
 *  @param form The form containing the field for which editing ended.
 *
 *  @param formField The form field for which editing end.
 */
- (void)form:(EZForm *)form fieldDidEndEditing:(EZFormField *)formField;

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
- (NSIndexPath *)form:(EZForm *)form indexPathToAutoScrollCellForFieldKey:(NSString *)key;

/**
 * Maintained for backwards compatibility. Use -form:indexPathToAutoScrollCellForFieldKey: instead.
**/
- (NSIndexPath *)form:(EZForm *)form indexPathToAutoScrollTableForFieldKey:(NSString *)key;

@end
