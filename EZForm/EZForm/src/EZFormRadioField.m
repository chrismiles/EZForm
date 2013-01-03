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

#import "EZFormRadioField.h"
#import "EZForm+Private.h"


#pragma mark - EZFormRadioField class extension

@interface EZFormRadioField ()
@property (nonatomic, retain) id currentSelection;
@property (nonatomic, retain) NSArray *orderedKeys;
@property (nonatomic, retain) UILabel *userLabel;

- (void)updateUI;
@end


#pragma mark - EZFormRadioField implementation

@implementation EZFormRadioField

@synthesize choices=_choices;
@synthesize currentSelection;
@synthesize orderedKeys;
@synthesize unselected;
@synthesize userLabel;
@synthesize validationRequiresSelection;
@synthesize validationRestrictedToChoiceValues;


#pragma mark - Public methods

- (void)useLabel:(UILabel *)label
{
    self.userLabel = label;
    [self updateUI];
}

- (void)setChoicesFromArray:(NSArray *)choices
{
    self.choices = [NSDictionary dictionaryWithObjects:choices forKeys:choices];
    self.orderedKeys = choices;	    // preserve order specified by user
}

- (void)setChoices:(NSDictionary *)newChoices
{
    [newChoices retain];
    [_choices release];
    _choices = newChoices;
    
    self.orderedKeys = [newChoices allKeys];
}

- (NSArray *)choiceKeys
{
    return self.orderedKeys;
}


#pragma mark - Private methods

- (void)updateUI
{
    if (self.userLabel) {
	if (self.currentSelection) {
	    self.userLabel.text = [self.choices valueForKey:self.currentSelection];
	}
	else {
	    self.userLabel.text = self.unselected;
	}
    }
}


#pragma mark - EZFormField methods

- (id)actualFieldValue
{
    return self.currentSelection;
}

- (void)setActualFieldValue:(id)value
{
    self.currentSelection = value;
}

- (UIView *)userView
{
    return self.userLabel;
}

- (void)unwireUserViews
{
    self.userLabel = nil;
}


#pragma mark - EZFormFieldConcrete methods

- (BOOL)typeSpecificValidation
{
    BOOL result = YES;
    
    id value = [self fieldValue];
    
    if (validationRequiresSelection && nil == self.currentSelection) {
	result = NO;
    }
    else if (validationRestrictedToChoiceValues && ![[self.choices allKeys] containsObject:value]) {
	result = NO;
    }
    
    return result;
}

- (void)updateView
{
    [self updateUI];
}


#pragma mark - Memory management

- (void)dealloc
{
    [_choices release];
    [currentSelection release];
    [orderedKeys release];
    [unselected release];
    [userLabel release];
    
    [super dealloc];
}

@end
