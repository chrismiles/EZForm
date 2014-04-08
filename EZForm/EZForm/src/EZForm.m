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

#import "EZForm.h"
#import "EZForm+Private.h"
#import "EZFormField+Private.h"
#import "EZFormStandardInputAccessoryView.h"
#import "EZFormInvalidIndicatorTriangleExclamationView.h"
#import "UIView+EZFormUtility.h"

#pragma mark - EZForm class extension

@interface EZForm () {
    UIEdgeInsets _autoScrolledViewOriginalContentInset;
    CGRect _autoScrolledViewOriginalFrame;
    UIEdgeInsets _autoScrolledViewOriginalScrollIndicatorInsets;
    NSTimeInterval _keyboardAnimationDuration;
    BOOL _resigningFirstResponder;
    BOOL _scrollViewInsetsWereSaved;
    CGRect _visibleKeyboardFrame;
}

@property (nonatomic, strong)	NSMutableArray		*formFields;
@property (nonatomic, strong)	UIView			*inputAccessoryStandardView;
@property (nonatomic, strong)	UIView			*viewToAutoScroll;

- (void)configureInputAccessoryForFormField:(EZFormField *)formField;
- (void)updateInputAccessoryForEditingFormField:(EZFormField *)formField;

@end


#pragma mark - EZForm implementation

@implementation EZForm


#pragma mark - Public Methods

- (void)unwireUserViews
{
    for (EZFormField *formField in self.formFields) {
	[formField unwireUserViews];
    }
    
    [self autoScrollViewForKeyboardInput:nil];
}

- (void)addFormField:(EZFormField *)formField
{
    if (![self.formFields containsObject:formField]) {
	[self.formFields addObject:formField];
	formField.form = self;
	
	[self configureInputAccessoryForFormField:formField];
    }
}

- (id)formFieldForKey:(NSString *)key
{
    EZFormField *result = nil;
    for (EZFormField *formField in self.formFields) {
	if ([formField.key isEqualToString:key]) {
	    result = formField;
	    break;
	}
    }

    return result;
}

- (BOOL)isFormValid
{
    BOOL result = YES;
    for (EZFormField *formField in self.formFields) {
	if (![formField isValid]) {
	    result = NO;
	    break;
	}
    }
    return result;
}

- (BOOL)isFieldValid:(NSString *)key
{
    BOOL result = NO;
    
    for (EZFormField *formField in self.formFields) {
	if ([formField.key isEqualToString:key]) {
	    result = [formField isValid];
	    break;
	}
    }
    
    return result;
}

- (NSArray *)invalidFieldKeys
{
    NSMutableArray *keys = [NSMutableArray array];
    
    for (EZFormField *formField in self.formFields) {
	if (![formField isValid]) {
	    [keys addObject:[formField key]];
	}
    }
    
    return keys;
}

- (id)modelValueForKey:(NSString *)key
{
    EZFormField *formField = [self formFieldForKey:key];
    return [formField fieldValue];
}

- (void)setModelValue:(id)value forKey:(NSString *)key
{
    for (EZFormField *formField in self.formFields) {
	if ([formField.key isEqualToString:key]) {
	    [formField setFieldValue:value];
	    break;
	}
    }
}

- (NSDictionary *)modelValues
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    for (EZFormField *formField in self.formFields) {
	[result setValue:[formField fieldValue] forKey:[formField key]];
    }
    return result;
}

- (void)resignFirstResponder
{
    _resigningFirstResponder = YES;
    for (EZFormField *formField in self.formFields) {
	[formField resignFirstResponder];
    }
    _resigningFirstResponder = NO;
}

- (EZFormField *)formFieldForFirstResponder
{
    EZFormField *result = nil;
    for (EZFormField *formField in self.formFields) {
	if ([formField isFirstResponder]) {
	    result = formField;
	    break;
	}
    }
    return result;
}

- (void)autoScrollViewForKeyboardInput:(UIView *)view
{
    self.viewToAutoScroll = view;
}

+ (UIView *)formInvalidIndicatorViewForType:(EZFormInvalidIndicatorViewType)invalidIndicatorViewType size:(CGSize)size
{
    UIView *invalidIndicatorView = nil;
    
    if (EZFormInvalidIndicatorViewTypeTriangleExclamation == invalidIndicatorViewType) {
	invalidIndicatorView = [[EZFormInvalidIndicatorTriangleExclamationView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    }
    
    return invalidIndicatorView;
}


#pragma mark - Private Methods

- (void)formFieldDidChangeValue:(EZFormField *)formField
{
    __strong id<EZFormDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(form:didUpdateValueForField:modelIsValid:)]) {
	BOOL isValid = [self isFormValid];
	[delegate form:self didUpdateValueForField:formField modelIsValid:isValid];
    }
}

- (void)scrollFormFieldToVisible:(EZFormField *)formField
{
    if ([self.viewToAutoScroll isKindOfClass:[UITableView class]]) {
	/* Unless the table view cells are static, the delegate should tell us the index
	 * path for the field, as the field view may be off screen and so not in any
	 * table view cell.
	 */
	NSIndexPath *indexPath = nil;
	__strong id<EZFormDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(form:indexPathToAutoScrollCellForFieldKey:)]) {
        indexPath = [delegate form:self indexPathToAutoScrollCellForFieldKey:formField.key];
    }
    else if ([delegate respondsToSelector:@selector(form:indexPathToAutoScrollTableForFieldKey:)]) {
	    indexPath = [delegate form:self indexPathToAutoScrollTableForFieldKey:formField.key];
	}
	else {
	    /* Attempt to find the table view cell for the field user view, which will
	     * only work if the field view is visible or if the table view cells are static.
	     */
	    UITableViewCell *cell = (UITableViewCell *)[[formField userView] superviewOfKind:[UITableViewCell class]];
	    if (cell) {
		indexPath = [(UITableView *)self.viewToAutoScroll indexPathForCell:cell];
		if (nil == indexPath) {
		    indexPath = [(UITableView *)self.viewToAutoScroll indexPathForRowAtPoint:cell.frame.origin];
		}
	    }
	}
	
	if (indexPath) {
	    [(UITableView *)self.viewToAutoScroll scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
	}
    }
    else if ([self.viewToAutoScroll isKindOfClass:[UICollectionView class]]) {
        /* Unless the collection view cells are static, the delegate should tell us the index
         * path for the field, as the field view may be off screen and so not in any
         * table view cell.
         */
        NSIndexPath *indexPath = nil;
        __strong id<EZFormDelegate> delegate = self.delegate;
        if ([delegate respondsToSelector:@selector(form:indexPathToAutoScrollCellForFieldKey:)]) {
            indexPath = [delegate form:self indexPathToAutoScrollCellForFieldKey:formField.key];
        }
        else {
            /* Attempt to find the collection view cell for the field user view, which will
             * only work if the field view is visible.
             */
            UICollectionViewCell *cell = (UICollectionViewCell *)[[formField userView] superviewOfKind:[UICollectionViewCell class]];
            if (cell) {
                indexPath = [(UICollectionView *)self.viewToAutoScroll indexPathForCell:cell];
            }
        }
        
        if (indexPath) {
            [(UICollectionView *)self.viewToAutoScroll scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }
    }
    else if ([self.viewToAutoScroll isKindOfClass:[UIScrollView class]]) {
      UIScrollView *scrollViewToAutoScroll = (UIScrollView *)self.viewToAutoScroll;
      if (! CGRectIsEmpty(self.autoScrollForKeyboardInputVisibleRect)) {
        CGRect scrollRect = CGRectInset(self.autoScrollForKeyboardInputVisibleRect, -self.autoScrollForKeyboardInputPaddingSize.width, -self.autoScrollForKeyboardInputPaddingSize.height); // add some padding
        [scrollViewToAutoScroll scrollRectToVisible:scrollRect animated:YES];
      }
      else {
        UIView *formFieldView = [formField userView];
        if (formFieldView) {
          CGRect convertedFrame = [formFieldView.superview convertRect:formFieldView.frame toView:self.viewToAutoScroll];
          convertedFrame = CGRectInset(convertedFrame, -self.autoScrollForKeyboardInputPaddingSize.width, -self.autoScrollForKeyboardInputPaddingSize.height); // add some padding
          if ([scrollViewToAutoScroll isPagingEnabled]) {
            convertedFrame.origin.x = floorf(convertedFrame.origin.x / scrollViewToAutoScroll.bounds.size.width) * scrollViewToAutoScroll.bounds.size.width;
            convertedFrame.size.width = scrollViewToAutoScroll.bounds.size.width;
          }
          [scrollViewToAutoScroll scrollRectToVisible:convertedFrame animated:YES];
        }
      }
    }
    else if ([self.viewToAutoScroll isKindOfClass:[UIView class]]) {
	/* Scroll an arbitrary view by adjusting its frame enough to reveal the form field view
	 * from beneath the system keyboard.
	 */
	CGRect fieldViewFrame = CGRectNull;
	if (CGRectIsEmpty(self.autoScrollForKeyboardInputVisibleRect)) {
	    UIView *formFieldView = [formField userView];
	    if (formFieldView) fieldViewFrame = formFieldView.frame;
	}
	else {
	    fieldViewFrame = CGRectInset(self.autoScrollForKeyboardInputVisibleRect, -self.autoScrollForKeyboardInputPaddingSize.width, -self.autoScrollForKeyboardInputPaddingSize.height); // add some padding
	}
	
	if (! CGRectIsNull(fieldViewFrame)) {
	    fieldViewFrame = CGRectInset(fieldViewFrame, -self.autoScrollForKeyboardInputPaddingSize.width, -self.autoScrollForKeyboardInputPaddingSize.height); // add some padding

	    CGRect relativeKeyboardFrame = [self.viewToAutoScroll.window convertRect:_visibleKeyboardFrame toView:self.viewToAutoScroll];
	    
	    if (CGRectIntersectsRect(fieldViewFrame, relativeKeyboardFrame)) {
		CGRect newFrame = self.viewToAutoScroll.frame;
		CGFloat dy = CGRectGetMaxY(fieldViewFrame) - CGRectGetMinY(relativeKeyboardFrame);
		newFrame.origin.y -= dy;

		if (CGRectIsNull(_autoScrolledViewOriginalFrame)) {
		    _autoScrolledViewOriginalFrame = self.viewToAutoScroll.frame;
		}
		
		[UIView animateWithDuration:_keyboardAnimationDuration animations:^{
		    self.viewToAutoScroll.frame = newFrame;
		}];
	    }
	}
    }
}

- (void)adjustScrollViewForVisibleKeyboard
{
    UIScrollView *scrollView = (UIScrollView *)self.viewToAutoScroll;
    CGRect convertedKeyboardFrame = [[scrollView superview] convertRect:_visibleKeyboardFrame fromView:nil];
    CGRect intersectsRect = CGRectIntersection(scrollView.frame, convertedKeyboardFrame);
    if (intersectsRect.size.height > 0.0f) {
	UIEdgeInsets contentInset;
	UIEdgeInsets scrollIndicatorInsets;
	
	if (_scrollViewInsetsWereSaved) {
	    // Calculate insets from originally saved values
	    contentInset = _autoScrolledViewOriginalContentInset;
	    scrollIndicatorInsets = _autoScrolledViewOriginalScrollIndicatorInsets;
	}
	else {
	    contentInset = scrollView.contentInset;
	    scrollIndicatorInsets = scrollView.scrollIndicatorInsets;
	    
	    _autoScrolledViewOriginalContentInset = contentInset;
	    _autoScrolledViewOriginalScrollIndicatorInsets = scrollIndicatorInsets;
	    _scrollViewInsetsWereSaved = YES;
	}
	
	contentInset.bottom += intersectsRect.size.height;
	scrollIndicatorInsets.bottom += intersectsRect.size.height;
	
	if (! UIEdgeInsetsEqualToEdgeInsets(scrollView.contentInset, contentInset) || ! UIEdgeInsetsEqualToEdgeInsets(scrollView.scrollIndicatorInsets, scrollIndicatorInsets)) {
	    void (^insetChanges)(void) = ^{
		scrollView.contentInset = contentInset;
		scrollView.scrollIndicatorInsets = scrollIndicatorInsets;
	    };
	    
	    if (_keyboardAnimationDuration > 0.0) {
		[UIView animateWithDuration:_keyboardAnimationDuration animations:insetChanges];
	    }
	    else {
		insetChanges();
	    }
	}
    }
}

- (void)revertScrollViewInsetsAnimated:(BOOL)animated animationDuration:(NSTimeInterval)animationDuration
{
    if (_scrollViewInsetsWereSaved && [self.viewToAutoScroll isKindOfClass:[UIScrollView class]]) {
	UIScrollView *scrollView = (UIScrollView *)self.viewToAutoScroll;
	UIEdgeInsets autoScrolledViewOriginalContentInset = _autoScrolledViewOriginalContentInset;
	UIEdgeInsets autoScrolledViewOriginalScrollIndicatorInsets = _autoScrolledViewOriginalScrollIndicatorInsets;
	
	void (^changeInsets)(void) = ^{
	    if (! UIEdgeInsetsEqualToEdgeInsets(autoScrolledViewOriginalContentInset, scrollView.contentInset)) {
		[scrollView setContentInset:autoScrolledViewOriginalContentInset];
	    }
	    if (! UIEdgeInsetsEqualToEdgeInsets(autoScrolledViewOriginalScrollIndicatorInsets, scrollView.scrollIndicatorInsets)) {
		[scrollView setScrollIndicatorInsets:autoScrolledViewOriginalScrollIndicatorInsets];
	    }
	};
	
	if (animated) {
	    [UIView animateWithDuration:animationDuration animations:changeInsets];
	}
	else {
	    changeInsets();
	}
    }
    _autoScrolledViewOriginalContentInset = UIEdgeInsetsZero;
    _autoScrolledViewOriginalScrollIndicatorInsets = UIEdgeInsetsZero;
    _scrollViewInsetsWereSaved = NO;
}

- (void)revertAutoScrolledViewAnimationDuration:(NSTimeInterval)animationDuration
{
    if (! CGRectIsNull(_autoScrolledViewOriginalFrame)) {
	if (self.viewToAutoScroll) {
	    [UIView animateWithDuration:animationDuration animations:^{
		self.viewToAutoScroll.frame = self->_autoScrolledViewOriginalFrame;
	    }];
	}
	
	_autoScrolledViewOriginalFrame = CGRectNull;
    }
    
    [self revertScrollViewInsetsAnimated:(animationDuration > 0.0) animationDuration:animationDuration];
}

- (EZFormField *)firstResponderCapableFormFieldAfterField:(EZFormField *)formField searchForwards:(BOOL)searchForwards
{
    EZFormField *result = nil;
    
    NSUInteger fieldIndex = [self.formFields indexOfObject:formField];
    if (fieldIndex != NSNotFound) {
	NSInteger startIndex;
	NSInteger indexIncrement;
	if (searchForwards) {
	    startIndex = (NSInteger)fieldIndex+1;
	    indexIncrement = 1;
	}
	else {
	    startIndex = (NSInteger)fieldIndex-1;
	    indexIncrement = -1;
	}
	for (NSInteger index=startIndex; index >= 0 && index < (NSInteger)[self.formFields count]; index += indexIncrement) {
	    EZFormField *aFormField = (self.formFields)[(NSUInteger)index];
	    if ([aFormField canBecomeFirstResponder]) {
		result = aFormField;
		break;
	    }
	}
    }
    
    return result;
}

- (void)selectFormFieldForInput:(EZFormField *)formField
{
    [formField becomeFirstResponder];
    [self scrollFormFieldToVisible:formField];
}

- (void)formFieldInputFinished:(EZFormField *)formField
{
    EZFormField *nextFormField = nil;
    
    if (! _resigningFirstResponder) {
	// Find next form field that can become first responder
	nextFormField = [self firstResponderCapableFormFieldAfterField:formField searchForwards:YES];
    }
    
    if (nextFormField) {
	[self selectFormFieldForInput:nextFormField];
    }
    else {
	[formField resignFirstResponder];
	__strong id<EZFormDelegate> delegate = self.delegate;
	if ([delegate respondsToSelector:@selector(formInputFinishedOnLastField:)]) {
	    [delegate formInputFinishedOnLastField:self];
	}
    }
}

- (void)formFieldInputDidEnd:(EZFormField *)formField
{
    [self formFieldDidEndEditing:formField];
}

- (void)formFieldDidBeginEditing:(EZFormField *)formField
{
    [self updateInputAccessoryForEditingFormField:formField];
    
    __strong id<EZFormDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(form:fieldDidBeginEditing:)]) {
	[delegate form:self fieldDidBeginEditing:formField];
    }
}

- (void)formFieldDidEndEditing:(EZFormField *)formField
{
    __strong id<EZFormDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(form:fieldDidEndEditing:)]) {
        [delegate form:self fieldDidEndEditing:formField];
    }
}


#pragma mark - Input Accessories

- (UIView *)inputAccessoryViewForType:(EZFormInputAccessoryType)type
{
    UIView *inputAccessoryView = nil;
    if (EZFormInputAccessoryTypeStandard == type || EZFormInputAccessoryTypeStandardLeftAligned == type) {
	if (nil == self.inputAccessoryStandardView) {
	    // Create and cache it
	    // It will be resized automatically to match keyboard
	    EZFormStandardInputAccessoryView *accessoryView = [[EZFormStandardInputAccessoryView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
            if (self.inputAccessoryViewTintColor)
            {
                accessoryView.tintColor = self.inputAccessoryViewTintColor;
            }

            if ([accessoryView respondsToSelector:@selector(setBarTintColor:)] && self.inputAccessoryViewBarTintColor) {
                accessoryView.barTintColor = self.inputAccessoryViewBarTintColor;
            }

            accessoryView.translucent = self.inputAccessoryViewTranslucent;

            if (type == EZFormInputAccessoryTypeStandardLeftAligned) {
                accessoryView.doneButtonPosition = EZFormStandardInputAccessoryViewDoneButtonPositionLeft;
            }
	    accessoryView.inputAccessoryViewDelegate = self;
	    self.inputAccessoryStandardView = accessoryView;
	}
	inputAccessoryView = self.inputAccessoryStandardView;
    }
    
    return inputAccessoryView;
}

- (UIView *)inputAccessoryView
{
    return [self inputAccessoryViewForType:self.inputAccessoryType];
}

- (void)configureInputAccessoryForFormField:(EZFormField *)formField
{
    if ([formField acceptsInputAccessory]) {
	UIView *inputAccessoryView = [self inputAccessoryViewForType:self.inputAccessoryType];
	if (inputAccessoryView) {
	    formField.inputAccessoryView = inputAccessoryView;
	}
    }
}

- (void)updateInputAccessoryForEditingFormField:(EZFormField *)formField
{
    UIView<EZFormInputAccessoryViewProtocol> *inputAccessoryView = (UIView<EZFormInputAccessoryViewProtocol> *)[self inputAccessoryView];
    if (inputAccessoryView) {
	EZFormField *previousFormField = [self firstResponderCapableFormFieldAfterField:formField searchForwards:NO];
	EZFormField *nextFormField = [self firstResponderCapableFormFieldAfterField:formField searchForwards:YES];
	
	[inputAccessoryView setNextActionEnabled:(nextFormField != nil)];
	[inputAccessoryView setPreviousActionEnabled:(previousFormField != nil)];
    }
}


#pragma mark - EZFormInputAccessoryViewDelegate methods

- (void)inputAccessoryViewDone
{
    [self resignFirstResponder];

    __strong id<EZFormDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(formInputAccessoryViewDone:)]) {
	[delegate formInputAccessoryViewDone:self];
    }
}

- (void)inputAccessoryViewSelectedNextField
{
    EZFormField *currentFormField = [self formFieldForFirstResponder];
    if (currentFormField) {
	EZFormField *nextFormField = [self firstResponderCapableFormFieldAfterField:currentFormField searchForwards:YES];
	if (nextFormField) {
	    [self selectFormFieldForInput:nextFormField];
	}
    }
}

- (void)inputAccessoryViewSelectedPreviousField
{
    EZFormField *currentFormField = [self formFieldForFirstResponder];
    if (currentFormField) {
	EZFormField *nextFormField = [self firstResponderCapableFormFieldAfterField:currentFormField searchForwards:NO];
	if (nextFormField) {
	    [self selectFormFieldForInput:nextFormField];
	}
    }
}


#pragma mark - Keyboard Notifications

- (void)keyboardWillShowNotification:(NSNotification *)notification
{
    _visibleKeyboardFrame = [[notification userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _keyboardAnimationDuration = [[notification userInfo][UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    BOOL shouldAutoScroll = (self.viewToAutoScroll && (! [self.viewToAutoScroll isKindOfClass:[UITableView class]]));
    // Exception for table views: they will scroll automatically to reveal field holding first responder
    
    if (shouldAutoScroll) {
	
	if ([self.viewToAutoScroll isKindOfClass:[UIScrollView class]] && ! [self.viewToAutoScroll isKindOfClass:[UITableView class]]) {
	    [self adjustScrollViewForVisibleKeyboard];
	}
	
	EZFormField *formField = [self formFieldForFirstResponder];
	if (formField) {
	    [self scrollFormFieldToVisible:formField];
	}
    }
}

- (void)keyboardWillHideNotification:(NSNotification *)notification
{
    _visibleKeyboardFrame = CGRectZero;
    
    if (self.viewToAutoScroll) {
	NSTimeInterval animationDuration = [[notification userInfo][UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        [self revertAutoScrolledViewAnimationDuration:animationDuration];
    }
}

- (void)keyboardWillChangeFrameNotification:(NSNotification *)notification
{
    _visibleKeyboardFrame = [[notification userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _keyboardAnimationDuration = [[notification userInfo][UIKeyboardAnimationDurationUserInfoKey] doubleValue];
}


#pragma mark - Memory Management

- (id)init
{
    if ((self = [super init])) {
	self.formFields = [NSMutableArray array];
	
	_autoScrolledViewOriginalContentInset = UIEdgeInsetsZero;
	_autoScrolledViewOriginalFrame = CGRectNull;
	_autoScrolledViewOriginalScrollIndicatorInsets = UIEdgeInsetsZero;
	_autoScrollForKeyboardInputPaddingSize = CGSizeMake(0.0f, 10.0f);
	_autoScrollForKeyboardInputVisibleRect = CGRectZero;
	_scrollViewInsetsWereSaved = NO;
        _inputAccessoryViewTranslucent = YES;
	
	// Subscribe to keyboard visible notifications
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
	if (&UIKeyboardWillChangeFrameNotification != nil) {
	    // iOS 5+
	    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
	}
    }
    return self;
}

- (void)dealloc
{
    for (EZFormField *formField in _formFields) {
	formField.form = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    
}

@end
