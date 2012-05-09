//
//  EZFDSimpleLoginFormViewController.h
//  EZFormDemo
//
//  Created by Chris Miles on 3/05/12.
//  Copyright (c) 2012 Chris Miles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZForm.h"

@interface EZFDSimpleLoginFormViewController : UIViewController <EZFormDelegate>

@property (retain, nonatomic) IBOutlet UITextField *passwordTextField;
@property (retain, nonatomic) IBOutlet UITextField *usernameTextField;

@property (retain, nonatomic) IBOutlet UIView *invalidIndicatorKeyView;
@property (retain, nonatomic) IBOutlet UIButton *loginButton;
@property (retain, nonatomic) IBOutlet UIView *loginFormView;

@end
