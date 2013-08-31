//
//  EZForm
//
//  Copyright 2011-2013 Chris Miles. All rights reserved.
//  Copyright 2013 Jesse Collis. All rights reserved.
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

#import "EZFormContinuousField.h"

@interface EZFormGenericField (EZFormContinuousFieldAccess)

@property (nonatomic, strong) id internalValue;
- (void)updateUIWithValue:(id)value;
- (void)unwireUserViews;

@end

@interface EZFormContinuousField()
@property (nonatomic, strong) UISlider *slider;
@end

@implementation EZFormContinuousField

- (id)initWithKey:(NSString *)aKey
{
    if ((self = [super initWithKey:aKey]))
    {
        self.continuous = YES;
    }
    return self;
}

#pragma mark - EZFormGenericField

- (void)unwireUserViews
{
    [super unwireUserViews];
    
    [self unwireSlider];
}

// EZFormGenericField updateView -> updateUI -> updateUIWithValue:
- (void)updateUIWithValue:(id)value
{
    if (self.valueFormatter)
    {
        value = [self.valueFormatter stringFromNumber:value];
    }

    [super updateUIWithValue:value];
}

#pragma mark EZFormContinousField

- (void)useSlider:(UISlider *)slider
{
    [self unwireSlider];

    self.slider = slider;
    [self wireUpSlider];
}

#pragma mark - Private methods

- (void)sliderChanged:(UISlider *)slider
{
    if (self.snapsToInteger)
    {
      slider.value = roundf(slider.value);
    }
    [self setFieldValue:@(slider.value)];
    [self updateView];
}

- (void)wireUpSlider
{
    [self.slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    self.slider.maximumValue = self.maximumValue;
    self.slider.minimumValue = self.minimumValue;
    self.slider.value = [[self actualFieldValue] floatValue];
    self.slider.continuous = self.continuous;
}

- (void)unwireSlider
{
    [self.slider removeTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
}


@end
