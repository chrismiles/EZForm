//
//  EZFDRegistrationFormViewController.m
//  EZFormDemo
//
//  Copyright 2012 Chris Miles. All rights reserved.
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
//#import "EZFormCommonValidators.h"
#import <EZForm/EZFormCommonValidators.h>

#define kFieldLabelTag 101


static NSString * const EZFDRegistrationFormFirstNameKey = @"firstname";
static NSString * const EZFDRegistrationFormLastNameKey = @"lastname";
static NSString * const EZFDRegistrationFormAgeKey = @"age";
static NSString * const EZFDRegistrationFormGenderKey = @"gender";
static NSString * const EZFDRegistrationFormEmailKey = @"email";
static NSString * const EZFDRegistrationFormSubscribeKey = @"subscribe";
static NSString * const EZFDRegistrationFormBioKey = @"bio";
static NSString * const EZFDRegistrationFormAcceptTermsKey = @"acceptterms";


#pragma mark - UIView utility category interface -

@interface UIView (EZFDRegistrationFormUtility)
- (UIView *)findSubviewOfKind:(Class)kind;
@end


#pragma mark - EZFDRegistrationFormViewController private interface -

@interface EZFDRegistrationFormViewController ()
@property (nonatomic, retain) NSDictionary *formCells;
@property (nonatomic, retain) EZForm *registrationForm;
@end


#pragma mark - EZFDRegistrationFormViewController implementation -

@implementation EZFDRegistrationFormViewController

@synthesize ageTextField = _ageTextField;
@synthesize ageTableViewCell = _ageTableViewCell;
@synthesize bioTableViewCell = _bioTableViewCell;
@synthesize acceptTermsFieldTableViewCell = _acceptTermsFieldTableViewCell;
@synthesize bioTextView = _bioTextView;
@synthesize emailTableViewCell = _emailTableViewCell;
@synthesize emailTextField = _emailTextField;
@synthesize firstnameTextField = _firstnameTextField;
@synthesize firstNameTableViewCell = _firstNameTableViewCell;
@synthesize genderTableViewCell = _genderTableViewCell;
@synthesize formCells = _formCells;
@synthesize genderFieldLabel = _genderFieldLabel;
@synthesize lastnameTableViewCell = _lastnameTableViewCell;
@synthesize lastnameTextField = _lastnameTextField;
@synthesize registerButton = _registerButton;
@synthesize registrationForm = _registrationForm;
@synthesize subscribeFieldTableViewCell = _subscribeFieldTableViewCell;


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
    EZFormTextField *firstnameField = [[[EZFormTextField alloc] initWithKey:EZFDRegistrationFormFirstNameKey] autorelease];
    firstnameField.validationMinCharacters = 1;
    firstnameField.inputMaxCharacters = 32;
    [_registrationForm addFormField:firstnameField];
    
    EZFormTextField *lastnameField = [[[EZFormTextField alloc] initWithKey:EZFDRegistrationFormLastNameKey] autorelease];
    lastnameField.validationMinCharacters = 1;
    lastnameField.inputMaxCharacters = 32;
    [_registrationForm addFormField:lastnameField];
    
    /*
     * Add an EZFormTextField instance to handle the age field.
     * Enables a validation rule of 1 character minimum.
     * Limits the input text field to 3 characters maximum (when hooked up to a control).
     * Restricts input to numeric characters only and numbers within a specified range.
     */
    EZFormTextField *ageField = [[[EZFormTextField alloc] initWithKey:EZFDRegistrationFormAgeKey] autorelease];
    ageField.validationMinCharacters = 1;
    ageField.inputMaxCharacters = 3;
    [ageField addInputFilter:^BOOL(id input) {
	return EZFormValidateNumericInputWithLimits(input, 1, 149);
    }];
    [_registrationForm addFormField:ageField];
    
    /*
     *
     */
    EZFormRadioField *genderField = [[[EZFormRadioField alloc] initWithKey:EZFDRegistrationFormGenderKey] autorelease];
    [genderField setChoicesFromArray:[NSArray arrayWithObjects:@"Female", @"Male", @"Not specified", nil]];
    genderField.validationRequiresSelection = YES;
    genderField.validationRestrictedToChoiceValues = YES;
    [_registrationForm addFormField:genderField];
    
    /*
     * Add an EZFormTextField instance to handle the email address field.
     * Enables a validation rule that requires an email address format "x@y.z"
     * Limits the input text field to 128 characters maximum (when hooked up to a control).
     */
    EZFormTextField *emailField = [[[EZFormTextField alloc] initWithKey:EZFDRegistrationFormEmailKey] autorelease];
    emailField.inputMaxCharacters = 128;
    [emailField addValidator:EZFormEmailAddressValidator];
    [emailField addInputFilter:EZFormEmailAddressInputFilter];
    [_registrationForm addFormField:emailField];
    
    /*
     *
     */
    EZFormBooleanField *subscribeField = [[[EZFormBooleanField alloc] initWithKey:EZFDRegistrationFormSubscribeKey] autorelease];
    [subscribeField setFieldValue:[NSNumber numberWithBool:YES]];
    [_registrationForm addFormField:subscribeField];
    
    /*
     *
     */
    EZFormTextField *bioField = [[[EZFormTextField alloc] initWithKey:EZFDRegistrationFormBioKey] autorelease];
    bioField.inputMaxCharacters = 200;
    [_registrationForm addFormField:bioField];
    
    /*
     *
     */
    EZFormBooleanField *acceptTermsField = [[[EZFormBooleanField alloc] initWithKey:EZFDRegistrationFormAcceptTermsKey] autorelease];
    acceptTermsField.validationStates = EZFormBooleanFieldStateOn;
    [acceptTermsField setFieldValue:[NSNumber numberWithBool:NO]];
    [_registrationForm addFormField:acceptTermsField];
}

- (void)dealloc
{
    [_registrationForm release];
    [_firstnameTextField release];
    [_formCells release];
    [_lastnameTextField release];
    [_ageTextField release];
    [_genderFieldLabel release];
    [_emailTextField release];
    [_subscribeFieldTableViewCell release];
    [_bioTextView release];
    [_acceptTermsFieldTableViewCell release];
    [_registerButton release];
    [_firstNameTableViewCell release];
    [_lastnameTableViewCell release];
    [_ageTableViewCell release];
    [_genderTableViewCell release];
    [_emailTableViewCell release];
    [_bioTableViewCell release];
    [super dealloc];
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
    EZFormTextField *genderField = [self.registrationForm formFieldForKey:EZFDRegistrationFormGenderKey];
    [genderField useLabel:self.genderFieldLabel];
    EZFormTextField *emailField = [self.registrationForm formFieldForKey:EZFDRegistrationFormEmailKey];
    [emailField useTextField:self.emailTextField];
    EZFormBooleanField *subscribeField = [self.registrationForm formFieldForKey:EZFDRegistrationFormSubscribeKey];
    [subscribeField useTableViewCell:self.subscribeFieldTableViewCell];
    EZFormTextField *bioField = [self.registrationForm formFieldForKey:EZFDRegistrationFormBioKey];
    [bioField useTextView:self.bioTextView];
    EZFormBooleanField *acceptTermsField = [self.registrationForm formFieldForKey:EZFDRegistrationFormAcceptTermsKey];
    [acceptTermsField useTableViewCell:self.acceptTermsFieldTableViewCell];
    
    /* Automatically scroll (or move) the given view if needed to
     * keep the active form field control visible.
     */
    [self.registrationForm autoScrollViewForKeyboardInput:self.tableView];
    
    /*
     * Record a mapping of form field keys to table view cells.
     * Will be used for showing field validity.
     */
    self.formCells = [NSDictionary dictionaryWithObjectsAndKeys:
		      self.firstNameTableViewCell, EZFDRegistrationFormFirstNameKey,
		      self.lastnameTableViewCell, EZFDRegistrationFormLastNameKey,
		      self.ageTableViewCell, EZFDRegistrationFormAgeKey,
		      self.genderTableViewCell, EZFDRegistrationFormGenderKey,
		      self.emailTableViewCell, EZFDRegistrationFormEmailKey,
		      self.bioTableViewCell, EZFDRegistrationFormBioKey,
		      self.acceptTermsFieldTableViewCell, EZFDRegistrationFormAcceptTermsKey,
		      nil];
    
    /*
     * Update validity indication for each field.
     */
    [self.formCells enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
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
    [super viewDidUnload];
    
    [self.registrationForm unwireUserViews];
    self.formCells = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
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
    if ([[segue identifier] isEqualToString:@"RegistrationFormGenderChoices"])
    {
        EZFormRadioChoiceViewController *viewController = [segue destinationViewController];
        viewController.form = self.registrationForm;
	viewController.radioFieldKey = EZFDRegistrationFormGenderKey;
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
    [self updateValidityIndicatorForField:formField];
    [self updateRegisterButtonForFormValidity];
}

- (void)formInputFinishedOnLastField:(EZForm *)form
{
    if ([form isFormValid]) {
	[self registerAction:nil];
    }
}


#pragma mark - Control actions

- (IBAction)registerAction:(id)sender
{
    NSString *message = [NSString stringWithFormat:@"%@", [self.registrationForm modelValues]];
    [[[[UIAlertView alloc] initWithTitle:@"Success" message:message delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] autorelease] show];
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