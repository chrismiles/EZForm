//
//  EZReversableValueTransformer.m
//  EZForm
//
//  Created by Sash Zats on 11/2/14.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "EZFormReversibleValueTransformer.h"

@implementation EZFormReversibleValueTransformer

@synthesize reverseBlock=_reverseBlock;

// boilerplate
+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (instancetype)initWithForwardBlock:(EZFormValueTransformationBlock)forwardBlock reverseBlock:(EZFormValueTransformationBlock)reverseBlock
{
    if ((self = [self initWithBlock:forwardBlock])) {
        _reverseBlock = reverseBlock;
    }
    return self;
}

+ (instancetype)reversibleValueTransformerWithForwardBlock:(EZFormValueTransformationBlock)forwardBlock reverseBlock:(EZFormValueTransformationBlock)reverseBlock
{
    return [[self alloc] initWithForwardBlock:forwardBlock reverseBlock:reverseBlock];
}

- (id)reverseTransformedValue:(id)value
{
    return self.reverseBlock(value);
}

@end
