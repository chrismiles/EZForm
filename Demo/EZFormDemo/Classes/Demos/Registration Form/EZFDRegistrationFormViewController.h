//
//  EZFDRegistrationFormViewController.h
//  EZFormDemo
//
//  Created by Chris Miles on 4/05/12.
//  Copyright (c) 2012 Chris Miles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZForm.h"

@interface EZFDRegistrationFormViewController : UITableViewController <EZFormDelegate>

@property (retain, nonatomic) IBOutlet UITableViewCell *acceptTermsFieldTableViewCell;
@property (retain, nonatomic) IBOutlet UITableViewCell *ageTableViewCell;
@property (retain, nonatomic) IBOutlet UITableViewCell *bioTableViewCell;
@property (retain, nonatomic) IBOutlet UITableViewCell *emailTableViewCell;
@property (retain, nonatomic) IBOutlet UITableViewCell *firstNameTableViewCell;
@property (retain, nonatomic) IBOutlet UITableViewCell *genderTableViewCell;
@property (retain, nonatomic) IBOutlet UITableViewCell *lastnameTableViewCell;
@property (retain, nonatomic) IBOutlet UITableViewCell *subscribeFieldTableViewCell;

@property (retain, nonatomic) IBOutlet UITextField *ageTextField;
@property (retain, nonatomic) IBOutlet UITextView *bioTextView;
@property (retain, nonatomic) IBOutlet UITextField *emailTextField;
@property (retain, nonatomic) IBOutlet UITextField *firstnameTextField;
@property (retain, nonatomic) IBOutlet UILabel *genderFieldLabel;
@property (retain, nonatomic) IBOutlet UITextField *lastnameTextField;
@property (retain, nonatomic) IBOutlet UIButton *registerButton;

@end
