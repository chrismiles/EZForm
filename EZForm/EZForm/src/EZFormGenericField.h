//
//  EZForm
//
//  Copyright 2011-2012 Chris Miles. All rights reserved.
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
#import "EZFormField.h"
#import "EZFormFieldConcreteProtocol.h"


/** A form field to handle a generic value.
 *
 *  The field can be wired up to a UILabel (or any UIView with a setText:
 *  method).
 */
@interface EZFormGenericField : EZFormField <EZFormFieldConcrete>

/** Enables validation that the field value is not nil.
 *
 *  If set to YES, the field value will only pass validation if it
 *  is not nil.
 */
@property (nonatomic, assign) BOOL validationNotNil;

/** Wire up a UILabel to the form field.
 *
 *  The UILabel (or any UIView with a setText: method) is used to display the
 *  value of the form field. The view is automatically updated when the
 *  value changes.
 *
 *  @param label A UILabel (or any UIView with a setText: method).
 */
- (void)useLabel:(UIView *)label;

@end
