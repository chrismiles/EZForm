//
//  EZFDCaptchaFormController.m
//  EZFormDemo
//
//  Created by Sash Zats on 1/31/15.
//  Copyright (c) 2015 Chris Miles. All rights reserved.
//

#import "EZFDCaptchaFormController.h"

#import <EZForm/EZForm.h>

@interface EZFDCaptchaFormController () <EZFormDelegate>

@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, weak) IBOutlet UILabel *label;

@property (nonatomic, assign) NSInteger randomNumber;
@property (nonatomic, strong) EZForm *captchaForm;

@end

@implementation EZFDCaptchaFormController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _initializeForm];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self _resetForm];
    
}

#pragma mark - Actions

- (IBAction)_newCaptureButtonAction:(__unused id)sender
{
    [self _resetForm];
}

#pragma mark - Private

- (void)_initializeForm
{
    EZFormTextField *captchaField = [[EZFormTextField alloc] initWithKey:@"captcha"];
    [captchaField useTextField:self.textField];
    captchaField.invalidIndicatorView = [EZForm formInvalidIndicatorViewForType:EZFormInvalidIndicatorViewTypeTriangleExclamation
                                                                           size:CGSizeMake(20, 20)];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.locale = [NSLocale currentLocale];
    numberFormatter.numberStyle = NSNumberFormatterSpellOutStyle;
    captchaField.valueTransformer = [EZFormReversibleValueTransformer reversibleValueTransformerWithForwardBlock:^id(NSNumber *value) {
        return [numberFormatter stringFromNumber:value];
    } reverseBlock:^id(id value) {
        return [numberFormatter numberFromString:[value lowercaseString]];
    }];
    __weak id weak_self = self;
    [captchaField addValidator:^BOOL(id value) {
        __strong EZFDCaptchaFormController *strong_self = weak_self;
        return strong_self.randomNumber == [value integerValue];
    }];

    self.captchaForm = [[EZForm alloc] init];
    self.captchaForm.delegate = self;
    [self.captchaForm addFormField:captchaField];
}

- (void)_resetForm
{
    UITextField *tetField = self.textField;
    tetField.text = nil;
    
    self.randomNumber = (NSInteger)arc4random_uniform(100);
    UILabel *label = self.label;
    label.text = [NSString stringWithFormat:@"%td", self.randomNumber];
}

@end
