//
//  EZForm
//
//  Copyright 2013 Chris Miles. All rights reserved.
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

#import "EZFDScrollViewFormViewController.h"
#import <EZForm/EZForm.h>

@interface EZFDScrollViewFormViewController () <EZFormDelegate>

@property (strong, nonatomic) EZForm *form;

@property (weak, nonatomic) IBOutlet UITextField *address1TextField;
@property (weak, nonatomic) IBOutlet UITextField *address2TextField;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITextField *stateTextField;
@property (weak, nonatomic) IBOutlet EZFormInputControl *stateInputControl;
@property (weak, nonatomic) IBOutlet UITextField *postcodeTextField;

@property (weak, nonatomic) IBOutlet UIView *formView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end


@implementation EZFDScrollViewFormViewController

- (void)awakeFromNib
{
    _form = [[EZForm alloc] init];
    _form.inputAccessoryType = EZFormInputAccessoryTypeStandard;
    _form.delegate = self;
    
    EZFormTextField *address1Field = [[EZFormTextField alloc] initWithKey:@"address1"];
    EZFormTextField *address2Field = [[EZFormTextField alloc] initWithKey:@"address2"];
    EZFormTextField *cityField = [[EZFormTextField alloc] initWithKey:@"city"];
    EZFormRadioField *stateField = [[EZFormRadioField alloc] initWithKey:@"state"];
    EZFormTextField *postcodeField = [[EZFormTextField alloc] initWithKey:@"postcode"];
    
    [stateField setChoicesFromArray:@[@"ACT", @"NSW", @"NT", @"QLD", @"SA", @"Vic", @"WA"]];
    stateField.validationRequiresSelection = YES;
    stateField.validationRestrictedToChoiceValues = YES;
    stateField.unselected = @"Select your state";

    [_form addFormField:address1Field];
    [_form addFormField:address2Field];
    [_form addFormField:cityField];
    [_form addFormField:stateField];
    [_form addFormField:postcodeField];
    
    //[self.form setModelValue:@"Vic" forKey:@"state"]; // TEST
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    __strong UIScrollView *scrollView = self.scrollView;
    __strong UIView *formView = self.formView;
    scrollView.contentSize = formView.bounds.size;
    
    [[self.form formFieldForKey:@"address1"] useTextField:self.address1TextField];
    [[self.form formFieldForKey:@"address2"] useTextField:self.address2TextField];
    [[self.form formFieldForKey:@"city"] useTextField:self.cityTextField];
    [[self.form formFieldForKey:@"state"] useLabel:self.stateInputControl];
    [[self.form formFieldForKey:@"postcode"] useTextField:self.postcodeTextField];
    
    EZFormRadioField *stateField = [self.form formFieldForKey:@"state"];
    stateField.inputView = [[UIPickerView alloc] initWithFrame:CGRectZero];
    
    __strong EZFormInputControl *stateInputControl = self.stateInputControl;
    stateInputControl.tapToBecomeFirstResponder = YES;
    
    [self.form autoScrollViewForKeyboardInput:scrollView];
}


#pragma mark - EZFormDelegate

- (void)form:(EZForm *)form didUpdateValueForField:(EZFormField *)formField modelIsValid:(BOOL)isValid
{
    #pragma unused(form)
    DLog(@"formField: %@ isValid: %@", formField, (isValid?@"YES":@"NO"));
}

- (void)formInputFinishedOnLastField:(EZForm *)form
{
    BOOL isValid = [form isFormValid];
    DLog(@"Form isValid: %@", (isValid ? @"YES":@"NO"));
}

@end
