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

//  EZFormMultiRadioFormField by Jesse Collis <jesse@jcmultimedia.com.au>

#import "EZFormMultiRadioFormField.h"
#import "EZForm+Private.h"

@interface EZFormTextField (EZFormMultiRadioFieldPrivateAccess)
- (void)updateUIWithValue:(NSString *)value;
- (void)updateValidityIndicators;
@end

@interface EZFormRadioField (EZFormMultiRadioFormFieldPrivateAccess)
- (NSArray *)orderedKeys;
- (id)choiceValueForKey:(NSString *)key;
@end

@interface EZFormMultiRadioFormField ()
@property (nonatomic, strong) NSMutableArray *selectedChoiceKeys;
@end

@implementation EZFormMultiRadioFormField

#pragma mark - Public methods

- (NSString *)fieldValuesJoinedByString:(NSString *)separator
{
    NSMutableArray *fieldValues = [NSMutableArray array];
    [self.selectedChoiceKeys enumerateObjectsUsingBlock:^(id obj, __unused NSUInteger idx, __unused BOOL *stop) {
        id keyValue = [self choiceValueForKey:obj];
        if (keyValue) {
            [fieldValues addObject:keyValue];
        }
    }];

    return [fieldValues componentsJoinedByString:separator];
}

- (void)unsetFieldValue:(id)value
{
    [self unsetFieldValue:value canUpdateView:YES];
}

- (void)unsetAllFieldValues
{
    [self.selectedChoiceKeys removeAllObjects];
}

- (void)unsetFieldValue:(id)value canUpdateView:(BOOL)canUpdateView
{
    [self unsetActualFieldValue:value];

    if (self.mutuallyExclusiveChoice && [self.selectedChoiceKeys count] == 0 && ![value isEqual:self.mutuallyExclusiveChoice]) {
        self.fieldValue = self.mutuallyExclusiveChoice;
    }

    if (canUpdateView && [(id<EZFormFieldConcrete>)self respondsToSelector:@selector(updateView)]) {
        [(id<EZFormFieldConcrete>)self updateView];
    }

    __strong EZForm *form = self.form;
    [form formFieldDidChangeValue:self];
}

- (void)unsetActualFieldValue:(id)value
{
    BOOL containedValue = [self.selectedChoiceKeys containsObject:value];
    if (containedValue) {
        [self.selectedChoiceKeys removeObject:value];
    }
}

#pragma mark - EZFormField

- (id)fieldValue
{
    return self.selectedChoiceKeys;
}

- (void)setActualFieldValue:(id)value {
    if (value) {
        if (self.mutuallyExclusiveChoice != nil && [value isEqual:self.mutuallyExclusiveChoice]) {
            [self unsetAllFieldValues];
        }
        else if ([self.selectedChoiceKeys containsObject:self.mutuallyExclusiveChoice]) {
            [self unsetFieldValue:self.mutuallyExclusiveChoice canUpdateView:NO];
        }
        if (![self.selectedChoiceKeys containsObject:value]) {
            [self.selectedChoiceKeys addObject:value];
        }
    }
    else {
        [self unsetAllFieldValues];
    }
}


#pragma mark - Values

- (void)setModelValue:(id)modelValue canUpdateView:(BOOL)canUpdateView
{
    if (self.valueTransformer != nil) {
        modelValue = [self.valueTransformer transformedValue:modelValue];
    }
    
    if ([modelValue isKindOfClass:[NSArray class]]) {
        for (id key in ((NSArray *)modelValue)) {
            [self setFieldValue:key canUpdateView:canUpdateView];
        }
    
    } else if ([modelValue isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *dictionaryModelValue = (NSDictionary *)modelValue;
        
        // compile new choices array
        NSMutableArray *keys = [NSMutableArray array];
        NSMutableArray *values = [NSMutableArray array];
        
        // save existing keys and values
        [keys addObjectsFromArray:self.choices.allKeys];
        for (id key in self.orderedKeys) {
            [values addObject:[self.choices objectForKey:key]];
        }
        
        // now add in the new one
        for (id key in dictionaryModelValue) {
            [keys addObject:key];
            [values addObject:[dictionaryModelValue objectForKey:key]];
        }
        
        // now update those keys
        [self setChoicesFromKeys:keys values:values];
        
        // and update the value
        for (id key in [dictionaryModelValue allKeys]) {
            [self setFieldValue:key canUpdateView:canUpdateView];
        }
        
    } else {
        [self setFieldValue:modelValue canUpdateView:canUpdateView];
    }
}

#pragma mark - EZFormFieldConcrete

- (void)updateView
{
    NSString *fieldValue = [self fieldValuesJoinedByString:@", "];
    [self updateUIWithValue:fieldValue];
}

//TODO: jessedc implement this method correctly
//- (BOOL)typeSpecificValidation
//{
//}


#pragma mark - InputView

- (void)setInputView:(UIView *)inputView
{
    if (inputView) {
        @throw [NSException exceptionWithName:@"Form field does not support an InputView" reason:@"EZFormMultiRadioFormField does not support inputView" userInfo:nil];
    }
}

#pragma mark - Object lifecycle

- (instancetype)initWithKey:(NSString *)aKey
{
    if ((self = [super initWithKey:aKey])) {
        self.selectedChoiceKeys = [NSMutableArray array];
    }

    return self;
}

@end
