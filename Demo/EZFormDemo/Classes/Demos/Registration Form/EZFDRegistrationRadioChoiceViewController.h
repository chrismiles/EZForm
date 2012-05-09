//
//  EZFDRegistrationRadioChoiceViewController.h
//  EZFormDemo
//
//  Created by Chris Miles on 4/05/12.
//  Copyright (c) 2012 Chris Miles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZForm.h"

@interface EZFDRegistrationRadioChoiceViewController : UITableViewController

@property (nonatomic, retain) EZForm *form;
@property (nonatomic, copy) NSString *radioFieldKey;

@end
