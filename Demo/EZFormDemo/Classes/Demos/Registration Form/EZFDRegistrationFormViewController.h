//
//  EZFDRegistrationFormViewController.h
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
