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

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface EZFormStandardInputAccessoryView ()
@property (nonatomic, strong) UISegmentedControl *previousNextControl;
@property (nonatomic, strong) id prevNextItem;
@property (nonatomic, strong) id doneItem;
@property (nonatomic, strong) id flexibleSpaceItem;
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

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.barStyle = UIBarStyleBlackTranslucent;

        NSString *nextString = NSLocalizedString(@"Next", @"EZForm Standard Input Accessory view - Next");
        NSString *prevString = NSLocalizedString(@"Previous", @"EZForm Standard Input Accessory view - Previous");

        NSArray *segmentTitles = @[prevString, nextString];

        _previousNextControl = [[UISegmentedControl alloc] initWithItems:segmentTitles];
        _previousNextControl.momentary = YES;
        [_previousNextControl addTarget:self action:@selector(previousNextAction:) forControlEvents:UIControlEventValueChanged];

        if (!SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            //this is deprecated in iOS 7
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            _previousNextControl.segmentedControlStyle = UISegmentedControlStyleBar;
#pragma clang diagnostic pop
        }

        self.doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
        self.flexibleSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        self.prevNextItem = [[UIBarButtonItem alloc] initWithCustomView:self.previousNextControl];
        self.doneButtonPosition = EZFormStandardInputAccessoryViewDoneButtonPositionRight;
    }
    return self;
}

- (void)setHidesPrevNextItem:(BOOL)hidesPrevNextItem
{
    _hidesPrevNextItem = hidesPrevNextItem;
    [self layoutSubviews];
}

- (void)setDoneButtonPosition:(EZFormStandardInputAccessoryViewDoneButtonPosition)doneButtonPosition
{
    _doneButtonPosition = doneButtonPosition;
    [self layoutSubviews];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    switch (self.doneButtonPosition) {
        case EZFormStandardInputAccessoryViewDoneButtonPositionLeft: {
            [self setItems:@[self.doneItem, self.flexibleSpaceItem, self.prevNextItem]];
            break;
        }
        case EZFormStandardInputAccessoryViewDoneButtonPositionRight: {
            [self setItems:@[self.prevNextItem, self.flexibleSpaceItem, self.doneItem]];
            break;
        }
    }

    if (self.hidesPrevNextItem) {
        NSMutableArray * itemsCopy = [self.items mutableCopy];
        [itemsCopy removeObject:self.prevNextItem];
        self.items = [itemsCopy copy];
    }
}

@end
