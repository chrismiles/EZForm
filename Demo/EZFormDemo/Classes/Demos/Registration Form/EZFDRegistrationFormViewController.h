//
//  EZFDRegistrationFormViewController.h
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

#import <UIKit/UIKit.h>
#import <EZForm/EZForm.h>

@interface EZFDRegistrationFormViewController : UITableViewController <EZFormDelegate>

@property (strong, nonatomic) IBOutlet UITableViewCell *acceptTermsFieldTableViewCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *ageTableViewCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *bioTableViewCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *emailTableViewCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *firstNameTableViewCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *genderTableViewCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *lastnameTableViewCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *subscribeFieldTableViewCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *likesFieldTableViewCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *dateTableViewCell;

@property (strong, nonatomic) IBOutlet UITextField *ageTextField;
@property (strong, nonatomic) IBOutlet UITextView *bioTextView;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *firstnameTextField;
@property (strong, nonatomic) IBOutlet UILabel *genderFieldLabel;
@property (strong, nonatomic) IBOutlet UILabel *likesFieldLabel;
@property (strong, nonatomic) IBOutlet UITextField *dateTextField;

@property (strong, nonatomic) IBOutlet UITextField *lastnameTextField;
@property (strong, nonatomic) IBOutlet UIButton *registerButton;

@end
