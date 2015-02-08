//
//  EZFormChildFormField.m
//  EZForm
//
//  Created by Rob Amos on 28/03/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "EZFormChildFormField.h"
#import "EZForm.h"
#import "EZFormField+Private.h"
#import "EZForm+Private.h"

@interface EZFormChildFormField () <EZFormDelegate>

@end

@implementation EZFormChildFormField

#pragma mark - Object lifecycle

- (id)initWithKey:(NSString *)aKey childForm:(EZForm *)aForm
{
    if ((self = [self initWithKey:aKey])) {
        self.childForm = aForm;
        
        if (aForm.delegate == nil)
            aForm.delegate = self;
    }
    return self;
}

#pragma mark - EZFormFieldConcrete Methods

- (id)actualFieldValue
{
    if (self.childForm == nil)
        return nil;
    
    return [self.childForm modelValues];
}

- (void)setActualFieldValue:(id)value
{
    NSParameterAssert(value != nil);
    NSAssert([value isKindOfClass:[NSDictionary class]], @"Setting the field value for a child form must be a NSDictionary.");
    NSAssert(self.childForm != nil, @"The child form must be created before you can set field values.");

    NSDictionary *modelValues = (NSDictionary *)value;
    for (NSString *key in modelValues)
        [self.childForm setModelValue:[modelValues objectForKey:key] forKey:key];
}

#pragma mark - Overrides to support child forms

- (BOOL)isValid
{
    NSAssert(self.childForm != nil, @"The child form must be created before you can interact with the field.");
    return [self.childForm isFormValid];
}

- (BOOL)isFirstResponder
{
    // we can never directly be the first responder
    return NO;
}

- (void)resignFirstResponder
{
    NSAssert(self.childForm != nil, @"The child form must be created before you can interact with the field.");
    [self.childForm resignFirstResponder];
}

#pragma mark - EZFormDelegate Method Forwarding

- (void)form:(EZForm *)form didUpdateValueForField:(EZFormField *)formField modelIsValid:(BOOL)isValid
{
    EZForm *parentForm = self.form;
    if (parentForm != nil) {
        id<EZFormDelegate> delegate = parentForm.delegate;
        if (delegate != nil && [delegate respondsToSelector:@selector(form:didUpdateValueForField:modelIsValid:)]) {
            [delegate form:form didUpdateValueForField:formField modelIsValid:isValid];
        }
    }
}

- (void)form:(EZForm *)form fieldDidBeginEditing:(EZFormField *)formField
{
    EZForm *parentForm = self.form;
    if (parentForm != nil) {
        id<EZFormDelegate> delegate = parentForm.delegate;
        if (delegate != nil && [delegate respondsToSelector:@selector(form:fieldDidBeginEditing:)]) {
            [delegate form:form fieldDidBeginEditing:formField];
        }
    }
}

- (void)form:(EZForm *)form fieldDidEndEditing:(EZFormField *)formField
{
    EZForm *parentForm = self.form;
    if (parentForm != nil) {
        id<EZFormDelegate> delegate = parentForm.delegate;
        if (delegate != nil && [delegate respondsToSelector:@selector(form:fieldDidEndEditing:)]) {
            [delegate form:form fieldDidEndEditing:formField];
        }
    }
}

- (NSIndexPath *)form:(EZForm *)form indexPathToAutoScrollCellForFieldKey:(NSString *)key
{
    EZForm *parentForm = self.form;
    if (parentForm != nil) {
        id<EZFormDelegate> delegate = parentForm.delegate;
        if (delegate != nil && [delegate respondsToSelector:@selector(form:indexPathToAutoScrollCellForFieldKey:)]) {
            return [delegate form:form indexPathToAutoScrollCellForFieldKey:key];
        }
    }
    return nil;
}

- (void)formInputAccessoryViewDone:(EZForm *)form
{
    EZForm *parentForm = self.form;
    if (parentForm != nil) {
        id<EZFormDelegate> delegate = parentForm.delegate;
        if (delegate != nil && [delegate respondsToSelector:@selector(formInputAccessoryViewDone:)]) {
            [delegate formInputAccessoryViewDone:form];
        }
    }
}

- (void)formInputFinishedOnLastField:(EZForm *)form
{
    EZForm *parentForm = self.form;
    if (parentForm != nil) {
        id<EZFormDelegate> delegate = parentForm.delegate;
        if (delegate != nil && [delegate respondsToSelector:@selector(formInputFinishedOnLastField:)]) {
            [delegate formInputFinishedOnLastField:form];
        }
    }
}

@end
