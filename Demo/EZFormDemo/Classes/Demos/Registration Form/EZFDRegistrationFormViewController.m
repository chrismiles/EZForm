//
//  EZFDRegistrationFormViewController.m
//  EZFormDemo
//
//  Copyright 2012-2013 Chris Miles. All rights reserved.
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

#import "EZFDRegistrationFormViewController.h"
#import <EZForm/EZFormCommonValidators.h>

#define kFieldLabelTag 101


static NSString * const EZFDRegistrationFormFirstNameKey = @"firstname";
static NSString * const EZFDRegistrationFormLastNameKey = @"lastname";
static NSString * const EZFDRegistrationFormAgeKey = @"age";
static NSString * const EZFDRegistrationFormGenderKey = @"gender";
static NSString * const EZFDRegistrationFormEmailKey = @"email";
static NSString * const EZFDRegistrationFormSubscribeKey = @"subscribe";
static NSString * const EZFDRegistrationFormLikesKey = @"likes";
static NSString * const EZFDRegistrationFormDateKey = @"date";
static NSString * const EZFDRegistrationFormBioKey = @"bio";
static NSString * const EZFDRegistrationFormAcceptTermsKey = @"acceptterms";
static NSString * const EZFDRegistrationFormRatingKey = @"rating";


#pragma mark - UIView utility category interface -

@interface UIView (EZFDRegistrationFormUtility)
- (UIView *)findSubviewOfKind:(Class)kind;
@end


#pragma mark - EZFDRegistrationFormViewController private interface -

@interface EZFDRegistrationFormViewController ()
@property (nonatomic, strong) NSDictionary *formCells;
@property (nonatomic, strong) EZForm *registrationForm;
@end


#pragma mark - EZFDRegistrationFormViewController implementation -

@implementation EZFDRegistrationFormViewController


#pragma mark -

- (void)awakeFromNib
{
    [self initializeForm];
}

- (void)initializeForm
{
    /*
     * Create EZForm instance to manage the form.
     */
    _registrationForm = [[EZForm alloc] init];
    _registrationForm.inputAccessoryType = EZFormInputAccessoryTypeStandard;
    _registrationForm.delegate = self;
    
    /*
     * Add EZFormTextField instances to handle the first name & last name fields.
     * Enables a validation rule of 1 character minimum.
     * Limits the input text field to 32 characters maximum (when hooked up to a control).
     */
    EZFormTextField *firstnameField = [[EZFormTextField alloc] initWithKey:EZFDRegistrationFormFirstNameKey];
    firstnameField.validationMinCharacters = 1;
    firstnameField.inputMaxCharacters = 32;
    [_registrationForm addFormField:firstnameField];
    
    EZFormTextField *lastnameField = [[EZFormTextField alloc] initWithKey:EZFDRegistrationFormLastNameKey];
    lastnameField.validationMinCharacters = 1;
    lastnameField.inputMaxCharacters = 32;
    [_registrationForm addFormField:lastnameField];
    
    /*
     * Add an EZFormTextField instance to handle the age field.
     * Enables a validation rule of 1 character minimum.
     * Limits the input text field to 3 characters maximum (when hooked up to a control).
     * Restricts input to numeric characters only and numbers within a specified range.
     */
    EZFormTextField *ageField = [[EZFormTextField alloc] initWithKey:EZFDRegistrationFormAgeKey];
    ageField.validationMinCharacters = 1;
    ageField.inputMaxCharacters = 3;
    [ageField addInputFilter:^BOOL(id input) {
	return EZFormValidateNumericInputWithLimits(input, 1, 149);
    }];
    [_registrationForm addFormField:ageField];
    
    /*
     * Single-selection (radio) field
     */
    EZFormRadioField *genderField = [[EZFormRadioField alloc] initWithKey:EZFDRegistrationFormGenderKey];
    [genderField setChoicesFromArray:@[@"Female", @"Male", @"Not specified"]];
    genderField.validationRequiresSelection = YES;
    genderField.validationRestrictedToChoiceValues = YES;
    [_registrationForm addFormField:genderField];
    
    /*
     * Multi-selection field
     */
    EZFormMultiRadioFormField *likesField = [[EZFormMultiRadioFormField alloc] initWithKey:EZFDRegistrationFormLikesKey];
    likesField.choices = @{
                           @"everything" : @"Everything",
                           @"pizza" : @"Pizza",
                           @"pasta" : @"Pasta",
                           @"bacon" : @"Bacon",
                           @"salad" : @"Salad",
                           @"cheese" : @"Cheese",
                           @"tacos" : @"Tacos"
                           };
    likesField.mutuallyExclusiveChoice = @"everything";
    [likesField setFieldValue:@"everything"];
    [_registrationForm addFormField:likesField];
    
    /*
     * Add an EZFormDateField instance to handle the date field.
     * Enables a validation that requires date.  Correct date format set in inDateFormatter
     */
    EZFormDateField *dateField = [[EZFormDateField alloc] initWithKey:EZFDRegistrationFormDateKey];
    [dateField addValidator:^BOOL(id value) {
        return value != nil;
    }];
    [_registrationForm addFormField:dateField];
    
    /*
     * Add an EZFormTextField instance to handle the email address field.
     * Enables a validation rule that requires an email address format "x@y.z"
     * Limits the input text field to 128 characters maximum (when hooked up to a control).
     */
    EZFormTextField *emailField = [[EZFormTextField alloc] initWithKey:EZFDRegistrationFormEmailKey];
    emailField.inputMaxCharacters = 128;
    [emailField addValidator:EZFormEmailAddressValidator];
    [emailField addInputFilter:EZFormEmailAddressInputFilter];
    [_registrationForm addFormField:emailField];
    
    /*
     * Boolean field
     */
    EZFormBooleanField *subscribeField = [[EZFormBooleanField alloc] initWithKey:EZFDRegistrationFormSubscribeKey];
    [subscribeField setFieldValue:@YES];
    [_registrationForm addFormField:subscribeField];

    /*
     * Multi-line text field
     */
    EZFormTextField *bioField = [[EZFormTextField alloc] initWithKey:EZFDRegistrationFormBioKey];
    bioField.inputMaxCharacters = 200;
    [_registrationForm addFormField:bioField];
    
    /*
     * Boolean field
     */
    EZFormBooleanField *acceptTermsField = [[EZFormBooleanField alloc] initWithKey:EZFDRegistrationFormAcceptTermsKey];
    acceptTermsField.validationStates = EZFormBooleanFieldStateOn;
    [acceptTermsField setFieldValue:@NO];
    [_registrationForm addFormField:acceptTermsField];


    /*
     * Slider Field
     */
    EZFormContinuousField *ratingSliderField = [[EZFormContinuousField alloc] initWithKey:EZFDRegistrationFormRatingKey];
    ratingSliderField.maximumValue = 100;
    ratingSliderField.minimumValue = 0.0;
    [ratingSliderField setFieldValue:@50];
    [_registrationForm addFormField:ratingSliderField];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    /* Wire up form fields to user interface elements.
     * This needs to be done after the views are loaded (e.g. in viewDidLoad).
     */
    EZFormTextField *firstnameField = [self.registrationForm formFieldForKey:EZFDRegistrationFormFirstNameKey];
    [firstnameField useTextField:self.firstnameTextField];
    EZFormTextField *lastnameField = [self.registrationForm formFieldForKey:EZFDRegistrationFormLastNameKey];
    [lastnameField useTextField:self.lastnameTextField];
    EZFormTextField *ageField = [self.registrationForm formFieldForKey:EZFDRegistrationFormAgeKey];
    [ageField useTextField:self.ageTextField];
    EZFormRadioField *genderField = [self.registrationForm formFieldForKey:EZFDRegistrationFormGenderKey];
    [genderField useLabel:self.genderFieldLabel];
    EZFormDateField *dateField = [self.registrationForm formFieldForKey: EZFDRegistrationFormDateKey];
    [dateField useTextField:self.dateTextField];
    dateField.inputView = [UIDatePicker new];
    EZFormTextField *emailField = [self.registrationForm formFieldForKey:EZFDRegistrationFormEmailKey];
    [emailField useTextField:self.emailTextField];
    EZFormBooleanField *subscribeField = [self.registrationForm formFieldForKey:EZFDRegistrationFormSubscribeKey];
    [subscribeField useTableViewCell:self.subscribeFieldTableViewCell];
    EZFormTextField *bioField = [self.registrationForm formFieldForKey:EZFDRegistrationFormBioKey];
    [bioField useTextView:self.bioTextView];
    EZFormBooleanField *acceptTermsField = [self.registrationForm formFieldForKey:EZFDRegistrationFormAcceptTermsKey];
    [acceptTermsField useTableViewCell:self.acceptTermsFieldTableViewCell];
    EZFormMultiRadioFormField *likesField = [self.registrationForm formFieldForKey:EZFDRegistrationFormLikesKey];
    [likesField useLabel:self.likesFieldLabel];

    EZFormContinuousField *ratingField = [self.registrationForm formFieldForKey:EZFDRegistrationFormRatingKey];
    NSNumberFormatter *continouousFormatter = [[NSNumberFormatter alloc] init];
    continouousFormatter.minimumFractionDigits = 0;
    continouousFormatter.maximumFractionDigits = 1;
    ratingField.valueFormatter = continouousFormatter;

    [ratingField useSlider:self.ratingSlider];
    [ratingField useLabel:self.ratingSliderValue];

    /* Automatically scroll (or move) the given view if needed to
     * keep the active form field control visible.
     */
    [self.registrationForm autoScrollViewForKeyboardInput:self.tableView];
    
    /*
     * Record a mapping of form field keys to table view cells.
     * Will be used for showing field validity.
     */
    self.formCells = @{EZFDRegistrationFormFirstNameKey: self.firstNameTableViewCell,
		      EZFDRegistrationFormLastNameKey: self.lastnameTableViewCell,
		      EZFDRegistrationFormAgeKey: self.ageTableViewCell,
		      EZFDRegistrationFormGenderKey: self.genderTableViewCell,
              EZFDRegistrationFormDateKey: self.dateTableViewCell,
		      EZFDRegistrationFormEmailKey: self.emailTableViewCell,
		      EZFDRegistrationFormBioKey: self.bioTableViewCell,
		      EZFDRegistrationFormAcceptTermsKey: self.acceptTermsFieldTableViewCell,
                      EZFDRegistrationFormLikesKey: self.likesFieldTableViewCell,
                       EZFDRegistrationFormRatingKey : self.ratingTableViewCell};
    
    /*
     * Update validity indication for each field.
     */
    [self.formCells enumerateKeysAndObjectsUsingBlock:^(id key, __unused id obj, __unused BOOL *stop) {
	[self updateValidityIndicatorForField:[self.registrationForm formFieldForKey:key]];
    }];
    
    /* Configure other views.
     */
    [self updateRegisterButtonForFormValidity];
}

- (void)viewDidUnload
{
    [self setAcceptTermsFieldTableViewCell:nil];
    [self setAgeTextField:nil];
    [self setBioTextView:nil];
    [self setEmailTextField:nil];
    [self setFirstnameTextField:nil];
    [self setGenderFieldLabel:nil];
    [self setLastnameTextField:nil];
    [self setSubscribeFieldTableViewCell:nil];
    
    [self setRegisterButton:nil];
    [self setFirstNameTableViewCell:nil];
    [self setLastnameTableViewCell:nil];
    [self setAgeTableViewCell:nil];
    [self setGenderTableViewCell:nil];
    [self setEmailTableViewCell:nil];
    [self setBioTableViewCell:nil];
    [self setLikesFieldLabel:nil];
    [self setLikesFieldLabel:nil];
    [self setDateTableViewCell:nil];
    [self setDateTextField:nil];
    [self setRatingSlider:nil];
    [self setRatingTableViewCell:nil];

    [super viewDidUnload];
    
    [self.registrationForm unwireUserViews];
    self.formCells = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
	return YES;
    }
    else {
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == self.subscribeFieldTableViewCell) {
	EZFormBooleanField *subscribeField = [self.registrationForm formFieldForKey:EZFDRegistrationFormSubscribeKey];
	[subscribeField toggleValue];
    }
    else if (cell == self.acceptTermsFieldTableViewCell) {
	EZFormBooleanField *acceptTermsField = [self.registrationForm formFieldForKey:EZFDRegistrationFormAcceptTermsKey];
	[acceptTermsField toggleValue];
    }
    else {
	// If cell contains a UITextField or UITextView, make it first responder
	UIResponder *textField = [cell findSubviewOfKind:[UITextField class]];
	if (nil == textField) {
	    textField = [cell findSubviewOfKind:[UITextView class]];
	}
	if (textField) {
	    [textField becomeFirstResponder];
	}
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    #pragma unused(sender)
    
    if ([[segue identifier] isEqualToString:@"RegistrationFormGenderChoices"])
    {
        EZFormRadioChoiceViewController *viewController = [segue destinationViewController];
        viewController.form = self.registrationForm;
	viewController.radioFieldKey = EZFDRegistrationFormGenderKey;
    } else if ([[segue identifier] isEqualToString:@"RegistrationFormLikesChoices"])
    {
        EZFormRadioChoiceViewController *viewController = [segue destinationViewController];
        viewController.form = self.registrationForm;
	viewController.radioFieldKey = EZFDRegistrationFormLikesKey;
        viewController.allowsMultipleSelection = YES;
    }
}


#pragma mark - Form validity

- (void)updateRegisterButtonForFormValidity
{
    if ([self.registrationForm isFormValid]) {
	self.registerButton.enabled = YES;
	self.registerButton.alpha = 1.0f;
    }
    else {
	self.registerButton.enabled = NO;
	self.registerButton.alpha = 0.4f;
    }
}

- (void)updateValidityIndicatorForField:(EZFormField *)formField
{
    UITableViewCell *cell = [self.formCells valueForKey:[formField key]];
    UILabel *label = (UILabel *)[cell viewWithTag:kFieldLabelTag];
    if ([formField isValid]) {
	label.textColor = [UIColor blackColor];
	if ([label.text hasSuffix:@"*"]) {
	    label.text = [label.text substringToIndex:[label.text length]-1];
	}
    }
    else {
	label.textColor = [UIColor redColor];
	if (![label.text hasSuffix:@"*"]) {
	    label.text = [label.text stringByAppendingString:@"*"];
	}
    }
}


#pragma mark - EZFormDelegate methods

- (void)form:(EZForm *)form didUpdateValueForField:(EZFormField *)formField modelIsValid:(BOOL)isValid
{
    #pragma unused(form, isValid)
    
    [self updateValidityIndicatorForField:formField];
    [self updateRegisterButtonForFormValidity];
}

- (void)formInputFinishedOnLastField:(EZForm *)form
{
    if ([form isFormValid]) {
	[self registerAction:nil];
    }
}

- (void)form:(EZForm *)form fieldDidEndEditing:(EZFormField *)formField
{
    #pragma unused(form)

    NSLog(@"formField:%@ didEndEditing",formField);
}



#pragma mark - Control actions

- (IBAction)registerAction:(id)sender
{
    #pragma unused(sender)
    
    NSString *message = [NSString stringWithFormat:@"%@", [self.registrationForm modelValues]];
    [[[UIAlertView alloc] initWithTitle:@"Success" message:message delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
}

@end


#pragma mark - UIView utility category -

@implementation UIView (EZFDRegistrationFormUtility)

- (UIView *)findSubviewOfKind:(Class)kind
{
    // Breadth first search for subview
    for (UIView *view in self.subviews) {
	if ([view isKindOfClass:kind]) {
	    return view;
	}
    }
    for (UIView *view in self.subviews) {
	UIView *subview;
	if ((subview = [view findSubviewOfKind:kind])) {
	    return subview;
	}
    }
    return nil;
}

@end
