//
//  EZReversableValueTransformer.m
//  EZForm
//
//  Created by Sash Zats on 11/2/14.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "EZReversableValueTransformer.h"

@implementation EZReversableValueTransformer

+ (instancetype)reversableValueTransformerWithForwardBlock:(EZTranformationBlock)forwardBlock
                                              reverseBlock:(EZTranformationBlock)reverseBlock {
    EZReversableValueTransformer *transformer = [[self alloc] init];
    transformer.forwardBlock = forwardBlock;
    transformer.reverseBlock = reverseBlock;
    return transformer;
}

- (id)transformedValue:(id)value {
    return self.forwardBlock(value);
}

- (id)reverseTransformedValue:(id)value {
    return self.reverseBlock(value);
}

@end
