//
//  EZFDScrollViewFormViewController.m
//  EZFormDemo
//
//  Created by Chris Miles on 9/01/13.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

#import "EZFDScrollViewFormViewController.h"
#import <EZForm/EZForm.h>


@interface EZFDScrollViewFormViewController ()

@property (strong, nonatomic) EZForm *form;

@property (weak, nonatomic) IBOutlet UITextField *address1TextField;
@property (weak, nonatomic) IBOutlet UITextField *address2TextField;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITextField *stateTextField;
@property (weak, nonatomic) IBOutlet UITextField *postcodeTextField;

@property (weak, nonatomic) IBOutlet UIView *formView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end


@implementation EZFDScrollViewFormViewController

- (void)awakeFromNib
{
    _form = [[EZForm alloc] init];
    _form.inputAccessoryType = EZFormInputAccessoryTypeStandard;
    
    EZFormTextField *address1Field = [[EZFormTextField alloc] initWithKey:@"address1"];
    EZFormTextField *address2Field = [[EZFormTextField alloc] initWithKey:@"address2"];
    EZFormTextField *cityField = [[EZFormTextField alloc] initWithKey:@"city"];
    EZFormTextField *stateField = [[EZFormTextField alloc] initWithKey:@"state"];
    EZFormTextField *postcodeField = [[EZFormTextField alloc] initWithKey:@"postcode"];
    
    [_form addFormField:address1Field];
    [_form addFormField:address2Field];
    [_form addFormField:cityField];
    [_form addFormField:stateField];
    [_form addFormField:postcodeField];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView.contentSize = self.formView.bounds.size;
    
    [[self.form formFieldForKey:@"address1"] useTextField:self.address1TextField];
    [[self.form formFieldForKey:@"address2"] useTextField:self.address2TextField];
    [[self.form formFieldForKey:@"city"] useTextField:self.cityTextField];
    [[self.form formFieldForKey:@"state"] useTextField:self.stateTextField];
    [[self.form formFieldForKey:@"postcode"] useTextField:self.postcodeTextField];
    
    [self.form autoScrollViewForKeyboardInput:self.scrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
