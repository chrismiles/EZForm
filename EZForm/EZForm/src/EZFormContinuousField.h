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

#import <Foundation/Foundation.h>
#import "EZFormGenericField.h"

@interface EZFormContinuousField : EZFormGenericField

@property (nonatomic, assign) NSInteger minimumValue;
@property (nonatomic, assign) NSInteger maximumValue;
@property (nonatomic, assign) BOOL snapsToInteger;

//TODO: Condier adding more general support for value display transformers
///     https://github.com/jessedc/EZForm/issues/2

@property (nonatomic, strong) NSNumberFormatter *valueFormatter;

/** Sets the continuous value of the UISider when
 *  the slider is set.
 *
 *  This value must be set prior to setting the slider with userSlider:
 */

@property (nonatomic, assign) BOOL continuous;

/** Wire up a UISlider to the form field.
 *
 *  The UISlider can control the value of the form field automatically as it's
 *  value changes.
 *
 *  @param slider A UISlider.
 */
- (void)useSlider:(UISlider *)slider;

@end
