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

#import "EZFormRadioField.h"
#import "EZForm+Private.h"


#pragma mark - EZFormRadioField class extension

@interface EZFormRadioField ()
@property (nonatomic, strong) NSArray *orderedKeys;
@end


#pragma mark - EZFormRadioField implementation

@implementation EZFormRadioField


#pragma mark - Public methods

- (void)setChoicesFromArray:(NSArray *)choices
{
    self.choices = [NSDictionary dictionaryWithObjects:choices forKeys:choices];
    self.orderedKeys = choices;	    // preserve order specified by user
}

- (void)setChoices:(NSDictionary *)newChoices
{
    _choices = newChoices;
    
    self.orderedKeys = [newChoices allKeys];
}

- (NSArray *)choiceKeys
{
    return self.orderedKeys;
}


#pragma mark - EZFormFieldConcrete methods

- (BOOL)typeSpecificValidation
{
    BOOL result = YES;
    
    id value = [self fieldValue];
    
    if (self.validationRequiresSelection && nil == self.fieldValue) {
	result = NO;
    }
    else if (self.validationRestrictedToChoiceValues && ![[self.choices allKeys] containsObject:value]) {
	result = NO;
    }
    
    if (result) {
	result = [super typeSpecificValidation];
    }
    
    return result;
}

@end
