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
#import "EZFormFieldConcreteProtocol.h"

typedef enum : NSInteger {
    EZFormTextFieldInvalidIndicatorPositionRight = 0,
    EZFormTextFieldInvalidIndicatorPositionLeft,
} EZFormTextFieldInvalidIndicatorPosition;


typedef BOOL (*TEXTFIELDFILTER)(id);

/** A form field to handle text input.
 *
 *  EZFormTextField instances can be optionally wired up to views of type:
 *  UITextField, UITextView or UILabel (or any UIView with a `text' property).
 *
 *  If wired up to a UITextField or UITextView the form field will validate
 *  input as it is entered by the user.  Input can be restricted using
 *  setInputFilterFunction:.
 *
 *  If wired up to a UILabel or conformant UIView, the view will be used to display the
 *  field value only. i.e. a read-only field.
 */
@interface EZFormTextField : EZFormField <EZFormFieldConcrete, UITextFieldDelegate, UITextViewDelegate>

/** Wire up a UILabel to the form field.
 *
 *  The UILabel (or any UIView with a setText: method) is used to display the
 *  value of the form field. The view is automatically updated when the
 *  value changes.
 *
 *  Only one view/control can be wired up at any one time.
 *
 *  Also see useTextField: and useTextView:.
 *
 *  @param label A UILabel (or any UIView with a setText: method).
 */
- (void)useLabel:(UIView *)label;

/** Wire up a UITextField to the form field.
 *
 *  The UITextField is used for input and display of the form field
 *  value. If any validators are set, the form field will validate
 *  input from the UITextField. If inputMaxCharacters or a text
 *  filter is enabled, the input to the UITextField will be restricted.
 *
 *  Only one view/control can be wired up at any one time.
 *
 *  Also see setInputFilterFunction:, inputMaxCharacters, useTextView:
 *  and useLabel:.
 *
 *  @param textField A UITextField to use.
 */
- (void)useTextField:(UITextField *)textField;

/** Wire up a UITextView to the form field.
 *
 *  The UITextView is used for input and display of the form field
 *  value. If any validators are set, the form field will validate
 *  input from the UITextView. If inputMaxCharacters or a text
 *  filter is enabled, the input to the UITextView will be restricted.
 *
 *  Only one view/control can be wired up at any one time.
 *
 *  Also see setInputFilterFunction:, inputMaxCharacters, useTextField:
 *  and useLabel:.
 *
 *  @param textView A UITextView to use.
 */
- (void)useTextView:(UITextView *)textView;

/** Add an input text filter.
 *
 *  When the form field is wired to a UITextField or UITextView,
 *  user inputs are passed to any text filters, which can return YES
 *  to allow the input, or NO to disallow it.
 *
 *  For example, an input text filter could be used to restrict text
 *  input to numeric characters only.
 *
 *  Any number of block text filters can be added and are
 *  called in the order they were added. The first to return NO
 *  will indicate the input is not allowed and no more text filters
 *  will be called.
 *
 *  Block text filters are called before any function
 *  text filter set by setInputFilterFunction:.
 *
 *  Also see removeInputFilters and setInputFilterFunction:.
 *
 *  @param inputFilter A block that takes an id as argument and
 *  returns a BOOL.
 */
- (void)addInputFilter:(BOOL(^)(id input))inputFilter;

/** Removes all block text filters
 *
 *  All block text filters added by addInputFilter: will be
 *  removed.
 *
 *  This method does not effect any function text filter
 *  added by setInputFilterFunction:.
 *
 *  Also see addInputFilter:.
 */
- (void)removeInputFilters;

/** Specifies a function to be called for input text filtering.
 *
 *  When the form field is wired to a UITextField or UITextView,
 *  user inputs are passed to any text filters, which can return YES
 *  to allow the input, or NO to disallow it.
 *
 *  For example, an input text filter could be used to restrict text
 *  input to numeric characters only.
 *
 *  A function text filter is called only after all block text filters
 *  (added by addInputFilter:) have been called and all returned YES.
 *
 *  Only one function text filter can be set.
 *
 *  Also see addInputFilter:.
 *
 *  @param filterFn Pointer to a function that accepts one argument
 *  of type id and returns a BOOL.
 */
- (void)setInputFilterFunction:(TEXTFIELDFILTER)filterFn;

/** Limits the maximum number of text input characters allowed.
 *
 *  This settings only has an effect if the field is wired up to a
 *  UITextField or UITextView. It limits the length of the input
 *  string that can be typed in to these controls.
 *
 *  This setting does not effect form value validation.
 */
@property (nonatomic, assign) NSUInteger inputMaxCharacters;

/** Set a field validation rule requiring a minimum number of characters.
 *
 *  Set to 0 to disable.
 *
 *  Default is 0 (disabled).
 */
@property (nonatomic, assign) NSUInteger validationMinCharacters;

/** Whether to trim whitespace (including newlines) off both ends of the
 *  input string.
 *
 *  Default is YES.
 */
@property (nonatomic, assign) BOOL trimWhitespace;

/** A view to show when the form field value has not passed validation.
 *
 *  Only has an effect when a UITextField is wired up. The view will be
 *  shown as the `rightView` or `leftView` of the UITextField. The position
 *  is controlled by the invalidIndicatorPosition property.
 *
 *  Any view can be used as an invalid indicator view.
 *
 *  For convenience, EZForm provides built-in invalid indicator views
 *  that can be created using +[EZForm formInvalidIndicatorViewForType:size:].
 *
 *  Default is nil (no invalid indicator view).
 *
 *  Also see invalidIndicatorPosition.
 */
@property (nonatomic, strong) UIView *invalidIndicatorView;

/** Where to position the invalid indicator view.
 *
 *  Controls whether the invalid indicator view is added to a UITextField
 *  `rightView` (default) or `leftView`.
 *
 *  Defaults to EZFormTextFieldInvalidIndicatorPositionRight.
 *
 *  Also see invalidIndicatorView.
 */
@property (nonatomic, assign) EZFormTextFieldInvalidIndicatorPosition invalidIndicatorPosition;

@end
