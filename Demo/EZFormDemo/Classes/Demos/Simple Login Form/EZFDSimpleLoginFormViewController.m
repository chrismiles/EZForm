//
//  EZFDSimpleLoginFormViewController.m
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

#import "EZFDSimpleLoginFormViewController.h"
#import <QuartzCore/QuartzCore.h>

#define kFormInvalidIndicatorViewSize 16.0f

static NSString * const EZFDLoginFormPasswordKey = @"password";
static NSString * const EZFDLoginFormUsernameKey = @"username";


@interface EZFDSimpleLoginFormViewController ()
@property (nonatomic, strong) EZForm *loginForm;
@end


@implementation EZFDSimpleLoginFormViewController


- (void)awakeFromNib
{
    [self initializeForm];
}

- (void)initializeForm
{
    /* Create EZForm instance to manage the form.
     */
    _loginForm = [[EZForm alloc] init];
    _loginForm.inputAccessoryType = EZFormInputAccessoryTypeDone;
    _loginForm.delegate = self;

    [_loginForm setInputAccessoryViewBarTintColor:[UIColor purpleColor]];
    [_loginForm setInputAccessoryViewTintColor:[UIColor yellowColor]];
    [_loginForm setInputAccessoryViewTranslucent:YES];

    /* Add an EZFormTextField instance to handle the username field.
     * Enables a validation rule of 1 character minimum.
     * Limits the input text field to 32 characters maximum (when hooked up to a control).
     */
    EZFormTextField *usernameField = [[EZFormTextField alloc] initWithKey:EZFDLoginFormUsernameKey];
    usernameField.validationMinCharacters = 1;
    usernameField.inputMaxCharacters = 32;
    usernameField.invalidIndicatorView = [EZForm formInvalidIndicatorViewForType:EZFormInvalidIndicatorViewTypeTriangleExclamation size:CGSizeMake(kFormInvalidIndicatorViewSize, kFormInvalidIndicatorViewSize)];
    [_loginForm addFormField:usernameField];
    
    /* Add an EZFormTextField instance to handle the password field.
     * Enables a validation rule of 3 character minimum.
     * Limits the input text field to 32 characters maximum (when hooked up to a control).
     */
    EZFormTextField *passwordField = [[EZFormTextField alloc] initWithKey:EZFDLoginFormPasswordKey];
    passwordField.validationMinCharacters = 4;
    passwordField.inputMaxCharacters = 32;
    passwordField.invalidIndicatorView = [EZForm formInvalidIndicatorViewForType:EZFormInvalidIndicatorViewTypeTriangleExclamation size:CGSizeMake(kFormInvalidIndicatorViewSize, kFormInvalidIndicatorViewSize)];
    [_loginForm addFormField:passwordField];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /* Wire up form fields to user interface elements.
     * This needs to be done after the views are loaded (e.g. in viewDidLoad).
     */
    EZFormTextField *usernameField = [self.loginForm formFieldForKey:EZFDLoginFormUsernameKey];
    [usernameField useTextField:self.usernameTextField];
    EZFormTextField *passwordField = [self.loginForm formFieldForKey:EZFDLoginFormPasswordKey];
    [passwordField useTextField:self.passwordTextField];
    
    /* Automatically scroll (or move) the given view if needed to
     * keep the active form field control visible.
     */
    [self.loginForm autoScrollViewForKeyboardInput:self.loginFormView];
    
    /* Add some padding around views that are auto scrolled for visibility.
     */
    self.loginForm.autoScrollForKeyboardInputPaddingSize = CGSizeMake(0.0f, 89.0f);
    
    
    /* Setup rest of the views to look nice (not form specific)
     */
    
    self.loginFormView.layer.cornerRadius = 10.0f;
    self.loginFormView.layer.shadowOffset = CGSizeMake(0.0f, 3.0f);
    self.loginFormView.layer.shadowOpacity = 0.7f;
    
    [self.invalidIndicatorKeyView addSubview:[EZForm formInvalidIndicatorViewForType:EZFormInvalidIndicatorViewTypeTriangleExclamation size:CGSizeMake(kFormInvalidIndicatorViewSize, kFormInvalidIndicatorViewSize)]];
    [self updateViewsForFormValidity];
}

- (void)viewDidUnload
{
    [self setLoginButton:nil];
    [self setPasswordTextField:nil];
    [self setUsernameTextField:nil];
    
    [self setLoginFormView:nil];
    [self setInvalidIndicatorKeyView:nil];
    [super viewDidUnload];
    
    /* Unwire (and release) all user views from the form fields.
     */
    [self.loginForm unwireUserViews];
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


#pragma mark - Login button status

- (void)updateViewsForFormValidity
{
    if ([self.loginForm isFormValid]) {
	self.loginButton.enabled = YES;
	self.loginButton.alpha = 1.0f;
	
	self.invalidIndicatorKeyView.hidden = YES;
    }
    else {
	self.loginButton.enabled = NO;
	self.loginButton.alpha = 0.4f;
	
	self.invalidIndicatorKeyView.hidden = NO;
    }
}


#pragma mark - EZFormDelegate methods

- (void)form:(EZForm *)form didUpdateValueForField:(EZFormField *)formField modelIsValid:(BOOL)isValid
{
    #pragma unused(form, formField, isValid)
    
    [self updateViewsForFormValidity];
}

- (void)formInputFinishedOnLastField:(EZForm *)form
{
    if ([form isFormValid]) {
	[self loginAction:nil];
    }
}


#pragma mark - Control actions

- (IBAction)loginAction:(id)sender
{
    #pragma unused(sender)
    
    [[[UIAlertView alloc] initWithTitle:@"Success" message:nil delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
}

@end
