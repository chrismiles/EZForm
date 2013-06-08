//
//  EZForm
//
//  Copyright 2013 Chris Miles. All rights reserved.
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

#import "EZFormInputControl.h"

@interface EZFormInputControl ()

@property (strong, nonatomic) UITapGestureRecognizer *tapToBecomeFirstResponderGestureRecognizer;
@property (strong, nonatomic) UIView *wrappedView;

@end


@implementation EZFormInputControl

@dynamic text;
@dynamic tapToBecomeFirstResponder;


- (id)initWithFrame:(CGRect)frame label:(UILabel *)label
{
    self = [super initWithFrame:frame];
    if (self) {
	self.wrappedView = label;
	self.userInteractionEnabled = YES;
	
	label.frame = self.bounds;
	label.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	[self addSubview:label];
    }
    return self;
}

- (void)awakeFromNib
{
    [self.subviews enumerateObjectsUsingBlock:^(id obj, __unused NSUInteger idx, BOOL *stop) {
	if ([obj isKindOfClass:[UILabel class]]) {
	    self.wrappedView = obj;
	    *stop = YES;
	}
    }];
    self.userInteractionEnabled = YES;
}


#pragma mark - First responder

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)becomeFirstResponder
{
    BOOL result = [super becomeFirstResponder];
    if (result) [self sendActionsForControlEvents:UIControlEventEditingDidBegin];
    return result;
}

- (BOOL)resignFirstResponder
{
    BOOL result = [super resignFirstResponder];
    if (result) [self sendActionsForControlEvents:UIControlEventEditingDidEnd];
    return result;
}


#pragma mark - Text property

- (void)setText:(NSString *)text
{
    [(id)self.wrappedView setText:text];
}

- (NSString *)text
{
    return [(id)self.wrappedView text];
}


#pragma mark - Tap to become first responder

- (void)setTapToBecomeFirstResponder:(BOOL)tapToBecomeFirstResponder
{
    if (tapToBecomeFirstResponder == YES && self.tapToBecomeFirstResponderGestureRecognizer == nil) {
	self.tapToBecomeFirstResponderGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToBecomeFirstResponderAction:)];
	[self addGestureRecognizer:self.tapToBecomeFirstResponderGestureRecognizer];
    }
    else if (tapToBecomeFirstResponder == NO && self.tapToBecomeFirstResponderGestureRecognizer) {
	[self removeGestureRecognizer:self.tapToBecomeFirstResponderGestureRecognizer];
	self.tapToBecomeFirstResponderGestureRecognizer = nil;
    }
}

- (BOOL)tapToBecomeFirstResponder
{
    return self.tapToBecomeFirstResponderGestureRecognizer != nil;
}

- (void)tapToBecomeFirstResponderAction:(__unused UITapGestureRecognizer *)tapGestureRecognizer
{
    [self becomeFirstResponder];
}

@end
