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

#import "EZFormField.h"
#import "EZFormField+Private.h"
#import "EZFormFieldConcreteProtocol.h"
#import "EZForm+Private.h"

@interface EZFormField () {
    VALIDATOR validatorFn;
    NSMutableArray *validationBlocks;
}

@property (nonatomic, weak, readwrite) EZForm *form;
@end


@implementation EZFormField


- (id)fieldValue
{
    return [(id<EZFormFieldConcrete>)self actualFieldValue];
}

- (void)setFieldValue:(id)value
{
    [self setFieldValue:value canUpdateView:YES];
}

- (void)setFieldValue:(id)value canUpdateView:(BOOL)canUpdateView
{
    [(id<EZFormFieldConcrete>)self setActualFieldValue:value];
    
    if (canUpdateView && [(id<EZFormFieldConcrete>)self respondsToSelector:@selector(updateView)]) {
	[(id<EZFormFieldConcrete>)self updateView];
    }
    
    __strong EZForm *form = self.form;
    [form formFieldDidChangeValue:self];
}

- (void)becomeFirstResponder
{
    // No op in abstract base class
}

- (void)resignFirstResponder
{
    // No op in abstract base class
}

- (BOOL)canBecomeFirstResponder
{
    // Override in concrete subclasses, if relevant
    return NO;
}

- (BOOL)isFirstResponder
{
    // Override in concrete subclasses, if relevant
    return NO;
}

- (BOOL)acceptsInputAccessory
{
    // Override in concrete subclasses, if relevant
    return NO;
}

- (UIView *)userView
{
    // Override in concrete subclasses, if relevant
    return nil;
}

- (void)unwireUserViews
{
    // Override in concrete subclasses, if relevant
    return;
}

- (void)setValidationFunction:(VALIDATOR)validatorFunction
{
    validatorFn = validatorFunction;
}

- (void)addValidator:(BOOL (^)(id value))validator
{
    [validationBlocks addObject:[validator copy]];
}

- (BOOL)isValid
{
    BOOL result = YES;
    
    if (!_validationDisabled) {
	id value = [self fieldValue];
	
	for (unsigned i=0; result && i < [validationBlocks count]; i++) {
	    BOOL (^validator)(id value) = validationBlocks[i];
	    result = validator(value);
	}
	
	if (result && validatorFn) {
	    result = validatorFn(value);
	}
	
	if (result && [self respondsToSelector:@selector(typeSpecificValidation)]) {
	    result = [(id<EZFormFieldConcrete>)self typeSpecificValidation];
	}
    }
    
    return result;
}


#pragma mark - Custom property accessors

- (void)setInputAccessoryView:(UIView *)inputAccessoryView
{
    #pragma unused(inputAccessoryView)
    
    // No operation, by default
    // Override in concrete subclasses, if relevant
}

- (UIView *)inputAccessoryView
{
    // No operation, by default
    // Override in concrete subclasses, if relevant
    return nil;
}


#pragma mark - NSObject methods

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p key=\"%@\">", [self class], self, self.key];
}


#pragma mark - Object lifecycle

- (id)initWithKey:(NSString *)aKey
{
    if ((self = [super init])) {
	self.key = aKey;
	
	validationBlocks = [[NSMutableArray alloc] init];
    }
    
    return self;
}

@end
