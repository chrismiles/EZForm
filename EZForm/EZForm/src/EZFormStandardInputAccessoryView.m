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

#import "EZFormStandardInputAccessoryView.h"

@interface EZFormStandardInputAccessoryView ()
@property (nonatomic, strong) UISegmentedControl *previousNextControl;
@end


@implementation EZFormStandardInputAccessoryView


- (void)previousNextAction:(id)sender
{
    UISegmentedControl *control = (UISegmentedControl *)sender;
    __strong id<EZFormInputAccessoryViewDelegate> inputAccessoryViewDelegate = self.inputAccessoryViewDelegate;
    
    if (0 == control.selectedSegmentIndex) {
	[inputAccessoryViewDelegate inputAccessoryViewSelectedPreviousField];
    }
    else {
	[inputAccessoryViewDelegate inputAccessoryViewSelectedNextField];
    }
}

- (void)doneAction:(id)sender
{
    #pragma unused(sender)

    __strong id<EZFormInputAccessoryViewDelegate> inputAccessoryViewDelegate = self.inputAccessoryViewDelegate;
    [inputAccessoryViewDelegate inputAccessoryViewDone];
}


#pragma mark - EZFormInputAccessoryViewProtocol methods

- (void)setNextActionEnabled:(BOOL)enabled
{
    [self.previousNextControl setEnabled:enabled forSegmentAtIndex:1];
}

- (void)setPreviousActionEnabled:(BOOL)enabled
{
    [self.previousNextControl setEnabled:enabled forSegmentAtIndex:0];
}


#pragma mark - Object lifecycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
	self.barStyle = UIBarStyleBlackTranslucent;
	_previousNextControl = [[UISegmentedControl alloc] initWithItems:@[
                            NSLocalizedString(@"Previous", @"EZForm Standard Input Accessory view - Previous"),
                            NSLocalizedString(@"Next", @"EZForm Standard Input Accessory view - Next")]];
	_previousNextControl.segmentedControlStyle = UISegmentedControlStyleBar;
	_previousNextControl.momentary = YES;
	[_previousNextControl addTarget:self action:@selector(previousNextAction:) forControlEvents:UIControlEventValueChanged];
	UIBarButtonItem *previousNextItem = [[UIBarButtonItem alloc] initWithCustomView:self.previousNextControl];
	UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem* doneItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", @"EZForm Standard Input Accessory view - Done") style:UIBarButtonItemStyleDone target:self action:@selector(doneAction:)];
	[self setItems:@[previousNextItem, flexibleItem, doneItem]];
    }
    return self;
}


@end
