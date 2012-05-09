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

#import "EZFormGenericField.h"

typedef enum {
    EZFormGenericFieldUserControlTypeNone = 0,
    EZFormGenericFieldUserControlTypeLabel = 1,
} EZFormGenericFieldUserControlType;


#pragma mark - EZFormGenericField class extension

@interface EZFormGenericField ()

@property (nonatomic, retain) id internalValue;
@property (nonatomic, retain) UIView *userControl;
@property (nonatomic, assign) EZFormGenericFieldUserControlType userControlType;

- (void)updateUI;
- (void)unwireUserControl;
@end


#pragma mark - EZFormGenericField implementation

@implementation EZFormGenericField

@synthesize internalValue=_internalValue;
@synthesize userControl;
@synthesize userControlType;
@synthesize validationNotNil;


#pragma mark - Public methods

- (void)useLabel:(UIView *)label
{
    [self unwireUserControl];
    
    self.userControl = label;
    self.userControlType = EZFormGenericFieldUserControlTypeLabel;
    [self updateUI];
}


#pragma mark - Private methods

- (void)unwireUserControl
{
    self.userControlType = EZFormGenericFieldUserControlTypeLabel;
}

- (void)updateUIWithValue:(id)value
{
    if (EZFormGenericFieldUserControlTypeLabel == self.userControlType) {
	NSString *string = nil;
	if (value) {
	    string = [NSString stringWithFormat:@"%@", value];
	}
	[(UILabel *)self.userControl setText:string];
    }
}

- (void)updateUI
{
    [self updateUIWithValue:[self fieldValue]];
}


#pragma mark - EZFormFieldConcrete methods

- (BOOL)typeSpecificValidation
{
    BOOL result = YES;
    
    id value = [self fieldValue];
    
    if (self.validationNotNil && nil == value) {
	result = NO;
    }
    
    return result;
}

- (void)updateView
{
    [self updateUI];
}


#pragma mark - EZFormField methods

- (id)actualFieldValue
{
    return self.internalValue;
}

- (void)setActualFieldValue:(id)value
{
    self.internalValue = value;
}

- (void)becomeFirstResponder
{
    [self.userControl becomeFirstResponder];
}

- (void)resignFirstResponder
{
    [self.userControl resignFirstResponder];
}

- (BOOL)canBecomeFirstResponder
{
    return [self.userControl canBecomeFirstResponder];
}

- (BOOL)isFirstResponder
{
    return [self.userControl isFirstResponder];
}

- (UIView *)userView
{
    return self.userControl;
}

- (void)unwireUserViews
{
    [self unwireUserControl];
}

- (BOOL)acceptsKeyboardAccessory
{
    return NO;
}


#pragma mark - Memory Management

- (id)initWithKey:(NSString *)aKey
{
    if ((self = [super initWithKey:aKey])) {

    }
    
    return self;
}

- (void)dealloc
{
    [self unwireUserControl];
    
    [_internalValue release];
    [userControl release];
    
    [super dealloc];
}

@end
