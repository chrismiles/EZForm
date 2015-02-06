//
//  EZReversableValueTransformer.h
//  EZForm
//
//  Created by Sash Zats on 11/2/14.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "EZFormValueTransformer.h"

@interface EZFormReversibleValueTransformer : EZFormValueTransformer

/**
 * The block used for forward transformations.
**/
@property (nonatomic, readonly, copy) EZFormValueTransformationBlock reverseBlock;

/**
 * Creates and returns a model value transformer that uses the provided block to transform the input.
 *
 * The block accepts one input value and should return the transformed output value.
 *
 * @param       forwardBlock            A block used in forward transformations that accepts a single object argument and returns a transformed object.
 * @param       reverseBlock            A block used in reverse transformations that accepts a single object argument and returns a transformed object.
 * @returns                             A configured EZValueTransformer instance.
 **/
+ (instancetype)reversibleValueTransformerWithForwardBlock:(EZFormValueTransformationBlock)forwardBlock reverseBlock:(EZFormValueTransformationBlock)reverseBlock;

/**
 * Creates and returns a model value transformer that uses the provided block to transform the input.
 *
 * The block accepts one input value and should return the transformed output value.
 *
 * @param       forwardBlock            A block used in forward transformations that accepts a single object argument and returns a transformed object.
 * @param       reverseBlock            A block used in reverse transformations that accepts a single object argument and returns a transformed object.
 * @returns                             A configured EZValueTransformer instance.
**/
- (instancetype)initWithForwardBlock:(EZFormValueTransformationBlock)forwardBlock reverseBlock:(EZFormValueTransformationBlock)reverseBlock;


@end
