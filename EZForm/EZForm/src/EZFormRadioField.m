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

#import "EZFormRadioField.h"
#import "EZForm+Private.h"


#pragma mark - External Class Categories

@interface UIView (EZFormRadioFieldExtension)
@property (readwrite, retain) UIView *inputView;
@end

@interface EZFormTextField (EZFormRadioFieldPrivateAccess)
- (void)updateUIWithValue:(NSString *)value;
- (void)updateValidityIndicators;
@end


#pragma mark - EZFormRadioField class extension

@interface EZFormRadioField () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) NSArray *orderedKeys;
@property (nonatomic, strong) NSString *selectedChoiceKey;

@end


#pragma mark - EZFormRadioField implementation

@implementation EZFormRadioField

@dynamic inputView;


#pragma mark - Public methods

- (void)setChoicesFromArray:(NSArray *)choices
{
    [self setChoicesFromKeys:choices values:choices];
}

- (void)setChoicesFromKeys:(NSArray *)keys values:(NSArray *)values
{
    _choices = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    self.orderedKeys = keys; // preserve order specified by user
}

- (void)setChoices:(NSDictionary *)newChoices
{
    _choices = newChoices;
    
    self.orderedKeys = [newChoices allKeys];
}

- (NSArray *)choiceKeys
{
    return self.orderedKeys;
}


#pragma mark - EZFormFieldConcrete methods

- (BOOL)typeSpecificValidation
{
    BOOL result = YES;
    
    id value = [self fieldValue];
    
    if (self.validationRequiresSelection && nil == self.fieldValue) {
	result = NO;
    }
    else if (self.validationRestrictedToChoiceValues && ![[self.choices allKeys] containsObject:value]) {
	result = NO;
    }
    
    if (result) {
	result = [super typeSpecificValidation];
    }
    
    return result;
}

- (void)updateView
{
    NSString *value = [self fieldDisplayValue];
    [self updateUIWithValue:value];
    [self updateInputViewAnimated:YES];
}

- (NSString *)fieldDisplayValue
{
    return [self choiceValueForKey:[self actualFieldValue]];
}

#pragma mark - Unwire views

- (void)unwireUserViews
{
    [self unwireInputView];
    [super unwireUserViews];
}

- (void)unwireInputView
{
    if ([self.userView.inputView isKindOfClass:[UIPickerView class]]) {
	UIPickerView *pickerView = (UIPickerView *)self.userView.inputView;
	if (pickerView.dataSource == self) pickerView.dataSource = nil;
	if (pickerView.delegate == self) pickerView.delegate = nil;
    }
    
    self.userView.inputView = nil;
}


#pragma mark - inputView

- (void)setInputView:(UIView *)inputView
{
    if (self.userView == nil) {
	NSException *exception = [NSException exceptionWithName:@"Attempt to set inputView with no userView" reason:@"A user view must be set before calling setInputView" userInfo:nil];
	@throw exception;
    }
    if (! [self.userView respondsToSelector:@selector(setInputView:)]) {
	NSException *exception = [NSException exceptionWithName:@"setInputView invalid" reason:@"EZFormRadioField user view does not accept an input view" userInfo:nil];
	@throw exception;
    }
    
    if ([inputView isKindOfClass:[UIPickerView class]]) {
	UIPickerView *pickerView = (UIPickerView *)inputView;
	
	pickerView.showsSelectionIndicator = YES;
	
	// User can elect to handle dataSource or delegate for picker, otherwise we do it automatically
	if (pickerView.dataSource == nil) pickerView.dataSource = self;
	if (pickerView.delegate == nil) pickerView.delegate = self;
    }
    else {
	NSException *exception = [NSException exceptionWithName:@"Unsupported inputView" reason:@"EZFormRadioField only supports wiring up inputViews of type UIPickerView" userInfo:nil];
	@throw exception;
    }
    
    self.userView.inputView = inputView;
    [self updateInputViewAnimated:NO];
}

- (UIView *)inputView
{
    return self.userView.inputView;
}

- (void)updateInputViewAnimated:(BOOL)animated
{
    if ([self.userView.inputView isKindOfClass:[UIPickerView class]]) {
	UIPickerView *pickerView = (UIPickerView *)self.userView.inputView;
	if (self.fieldValue) {
	    NSUInteger index = [self.orderedKeys indexOfObject:self.fieldValue];
	    if (index != NSNotFound) {
		if (self.unselected) index++;
		if (index != (NSUInteger)[pickerView selectedRowInComponent:0]) {
		    [pickerView selectRow:(NSInteger)index inComponent:0 animated:animated];
		}
	    }
	}
    }
}


#pragma mark - Choice Values

- (NSString *)valueOrUnselectedAtIndex:(NSUInteger)index
{
    NSString *value = nil;
    if (self.unselected) {
	if (index == 0) {
	    value = self.unselected;
	}
	else {
	    NSString *key = [self.orderedKeys objectAtIndex:index - 1];
	    value = [self.choices valueForKey:key];
	}
    }
    else {
	NSString *key = [self.orderedKeys objectAtIndex:index];
	value = [self.choices valueForKey:key];
    }
    return value;
}

- (NSString *)choiceKeyAtIndex:(NSUInteger)index
{
    NSString *key = nil;
    if (self.unselected) {
	if (index == 0) {
	    key = nil;
	}
	else {
	    key = [self.orderedKeys objectAtIndex:index - 1];
	}
    }
    else {
	key = [self.orderedKeys objectAtIndex:index];
    }
    return key;
}

- (id)choiceValueForKey:(NSString *)key
{
    id value;
    if (key) {
	value = self.choices[key];
    }
    else {
	value = self.unselected;
    }
    return value;
}


#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(__unused UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(__unused UIPickerView *)pickerView numberOfRowsInComponent:(__unused NSInteger)component
{
    NSInteger rows = (NSInteger)[self.choices count];
    if (self.unselected) rows += 1;
    return rows;
}


#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(__unused UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(__unused NSInteger)component
{
    return [self valueOrUnselectedAtIndex:(NSUInteger)row];
}

- (void)pickerView:(__unused UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(__unused NSInteger)component
{
    NSString *key = [self choiceKeyAtIndex:(NSUInteger)row];
    [self setFieldValue:key canUpdateView:YES];
    [self updateValidityIndicators];
}

@end
