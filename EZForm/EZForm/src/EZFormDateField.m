//
//  EZFormDateField.m
//  EZForm
//
//  Created by Muhammad Y on 2/26/13.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

#import "EZFormDateField.h"
#import "EZForm+Private.h"


#pragma mark - External Class Categories

@interface UIView (EZFormDateFieldExtension)
@property (readwrite, retain) UIView *inputView;
@end

@interface EZFormTextField(EZFormDateFieldPrivateAccess)
- (void)updateUIWithValue:(NSString *)value;
@end


@interface EZFormDateField()
@property (strong, nonatomic) NSDate *internalValue;

@end


#pragma mark - EZFormDateField implementation

@implementation EZFormDateField

@dynamic inputView;


#pragma mark - EZFormFieldConcrete methods

- (void)updateView
{
    NSDate *date = [self fieldValue];
    NSString *value = [self.outDateFormatter stringFromDate: date];
    [self updateUIWithValue:value];
    [self updateInputViewAnimated:YES];
}

#pragma mark - Unwire views

- (void)unwireUserViews
{
    [self unwireInputView];
    [super unwireUserViews];
}

- (void)unwireInputView
{
    if ([self.userView.inputView isKindOfClass:[UIDatePicker class]]) {
        UIDatePicker *picker = (UIDatePicker *)self.userView.inputView;
        [picker removeTarget: self action: @selector(onValueChanged:) forControlEvents: UIControlEventValueChanged];
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
        NSException *exception = [NSException exceptionWithName:@"setInputView invalid" reason:@"EZFormDateField user view does not accept an input view" userInfo:nil];
        @throw exception;
    }
    
    if ([inputView isKindOfClass:[UIDatePicker class]]) {
        UIDatePicker *picker = (UIDatePicker *)inputView;
        
        // TODO: User can elect to handle dataSource or delegate for picker, otherwise we do it automatically
        [picker addTarget: self action: @selector(onValueChanged:) forControlEvents: UIControlEventValueChanged];
    }
    else {
        NSException *exception = [NSException exceptionWithName:@"Unsupported inputView" reason:@"EZFormDateField only supports wiring up inputViews of type UIDatePicker" userInfo:nil];
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
    if ([self.userView.inputView isKindOfClass:[UIDatePicker class]]) {
        UIDatePicker *picker = (UIDatePicker *)self.userView.inputView;
        if (self.fieldValue) {
            [picker setDate: self.fieldValue animated: animated];
        }
    }
}

#pragma mark - EZFormField methods

- (id)actualFieldValue
{
    return self.internalValue;
}

- (void)setActualFieldValue:(id)value
{
    if ([value isKindOfClass: [NSDate class]]) {
        self.internalValue = value;
    }
    else if ([value isKindOfClass: [NSString class]]) {
        self.internalValue = [self.inDateFormatter dateFromString: value];
    }
    else {
        self.internalValue = nil;
    }
}

#pragma mark - Object lifecycle

- (id)initWithKey:(NSString *)aKey {
    self = [super initWithKey: aKey];
    if (self) {
        // Default date formatters        
        self.inDateFormatter = [NSDateFormatter new];
        [self.inDateFormatter setDateFormat: @"yyyy-MM-dd hh:mm a"];
        self.outDateFormatter = [NSDateFormatter new];
        [self.outDateFormatter setDateFormat: @"yyyy-MM-dd hh:mm a"];
    }
    return self;
}

#pragma mark - UIDatePicker

- (void)onValueChanged:(UIDatePicker *)sender {
    NSDate *date = sender.date;
    [self setFieldValue: date canUpdateView: YES];
}

@end
