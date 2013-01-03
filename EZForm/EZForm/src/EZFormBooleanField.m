//
//  EZForm
//
//  Copyright 2011-2013 Chris Miles. All rights reserved.
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

#import "EZFormBooleanField.h"
#import "EZForm+Private.h"

typedef enum {
    EZFormBooleanFieldUserControlTypeNone = 0,
    EZFormBooleanFieldUserControlTypeButton = 1,
    EZFormBooleanFieldUserControlTypeSwitch = 2,
    EZFormBooleanFieldUserControlTypeTableViewCell = 3
} EZFormBooleanFieldUserControlType;


#pragma mark - EZFormBooleanField class extension

@interface EZFormBooleanField () {
    BOOL _internalValue;
}

@property (nonatomic, strong) UIView *userControl;
@property (nonatomic, assign) EZFormBooleanFieldUserControlType userControlType;

- (void)updateUI;
- (void)wireUpButton;
- (void)wireUpSwitch;
@end


#pragma mark - EZFormBooleanField implementation

@implementation EZFormBooleanField


#pragma mark - Public methods

- (void)toggleValue
{
    [self setFieldValue:[NSNumber numberWithBool:!_internalValue]];
}

- (void)useButton:(UIButton *)button
{
    self.userControl = button;
    self.userControlType = EZFormBooleanFieldUserControlTypeButton;
    [self updateUI];
    [self wireUpButton];
}

- (void)useSwitch:(UISwitch *)switchControl
{
    self.userControl = switchControl;
    self.userControlType = EZFormBooleanFieldUserControlTypeSwitch;
    [self updateUI];
    [self wireUpSwitch];
}

- (void)useTableViewCell:(UITableViewCell *)tableViewCell
{
    self.userControl = tableViewCell;
    self.userControlType = EZFormBooleanFieldUserControlTypeTableViewCell;
    [self updateUI];
}


#pragma mark - Private methods

- (void)wireUpButton
{
    [(UIControl *)self.userControl addTarget:self action:@selector(buttonTouchUpAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)unwireButton
{
    [(UIControl *)self.userControl removeTarget:self action:@selector(buttonTouchUpAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)wireUpSwitch
{
    [(UIControl *)self.userControl addTarget:self action:@selector(switchValueChangedAction:) forControlEvents:UIControlEventValueChanged];
}

- (void)unwireSwitch
{
    [(UIControl *)self.userControl removeTarget:self action:@selector(switchValueChangedAction:) forControlEvents:UIControlEventValueChanged];
}

- (void)unwireUserControl
{
    if (EZFormBooleanFieldUserControlTypeButton == self.userControlType) {
	[self unwireButton];
    }
    else if (EZFormBooleanFieldUserControlTypeSwitch == self.userControlType) {
	[self unwireSwitch];
    }
    
    self.userControl = nil;
    self.userControlType = EZFormBooleanFieldUserControlTypeNone;
}

- (void)buttonTouchUpAction:(UIButton *)button
{
    button.selected = !button.selected;
    [self setFieldValue:@(button.selected)];
}

- (void)switchValueChangedAction:(UISwitch *)switchControl
{
    [self setFieldValue:@(switchControl.on)];
}

- (void)updateUI
{
    if (EZFormBooleanFieldUserControlTypeButton == self.userControlType) {
	[(UIButton *)self.userControl setSelected:_internalValue];
    }
    else if (EZFormBooleanFieldUserControlTypeSwitch == self.userControlType) {
	[(UISwitch *)self.userControl setOn:_internalValue];
    }
    else if (EZFormBooleanFieldUserControlTypeTableViewCell == self.userControlType) {
	[(UITableViewCell *)self.userControl setAccessoryType:(_internalValue ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone)];
	
    }
}


#pragma mark - EZFormField methods

- (id)actualFieldValue
{
    return @(_internalValue);
}

- (void)setActualFieldValue:(id)value
{
    _internalValue = [value boolValue];
}

- (UIView *)userView
{
    return self.userControl;
}

- (void)unwireUserViews
{
    self.userControl = nil;
}


#pragma mark - EZFormFieldConcrete methods

- (BOOL)typeSpecificValidation
{
    BOOL result = YES;
    
    if (EZFormBooleanFieldStateOn == self.validationStates && _internalValue != YES) {
	result = NO;
    }
    else if (EZFormBooleanFieldStateOff == self.validationStates && _internalValue != NO) {
	result = NO;
    }
    
    return result;
}

- (void)updateView
{
    [self updateUI];
}

@end
