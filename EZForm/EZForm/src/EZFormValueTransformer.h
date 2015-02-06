//
//  EZFormValueTransformer.h
//  EZForm
//
//  Created by Rob Amos on 6/02/2015.
//  Copyright (c) 2015 Chris Miles. All rights reserved.
//

/**
 * A block used in transformations. Accepts one object argument and should return that transformed object.
**/
typedef id(^EZFormValueTransformationBlock)(id value);

/**
 * A collection of forward-only (non-reversable) NSValueTransformers.
**/
@interface EZFormValueTransformer : NSValueTransformer

/**
 * The block used for forward transformations.
 **/
@property (nonatomic, readonly, copy) EZFormValueTransformationBlock forwardBlock;


/** @name Creating EZFormTransformers **/

/**
 * Creates and returns a model value transformer that returns the value at the specified key path.
 *
 * This is useful when working with model objects, you can set the value of your form field to be the model itself
 * and use this transformer to obtain the key value to be used in the form.
 *
 * Note that this transformer will work with NSArray inputs (it will return an appropriate NSArray) in order to support
 * EZFormMultiRadioFormField fields as well.
 *
 * @param       keyPath                 A keyPath to the value you wish to use in your form.
 * @returns                             A configured EZValueTransformer instance.
**/
+ (instancetype)valueTransformerWithKeyPath:(NSString *)keyPath;

/**
 * Creates and returns a model value transformer that returns an NSDictionary using the values at the specified key paths.
 *
 * This is useful when working with radio fields that have both a key value, and the value to be displayed to the user. You can
 * provide the two key paths on your model object and both the choices and value will be updated.
 *
 * Note: this transformer will update the choices on your radio form field. Use -modelValueTransformerWithKeyPath: if you just
 * want to update the value.
 *
 * The value at the displayKeyPath is ignored if the form field is not a EZFormRadioField or EZFormMultiRadioFormField subclass.
 *
 * @param       keyPath                 A key path to the value you wish to use as the new model value of your form field.
 * @param       displayKeyPath          A key path to the value you wish to use as the displayed choice of your form field.
 * @returns                             A configured EZValueTransformer instance.
**/
+ (instancetype)valueTransformerWithKeyPathForValue:(NSString *)keyPath keyPathForDisplayValue:(NSString *)displayKeyPath;

/**
 * Creates and returns a model value transformer that uses the provided block to transform the input.
 *
 * The block accepts one input value and should return the transformed output value.
 *
 * @param       block                   A block that accepts a single object argument and returns a transformed object.
 * @returns                             A configured EZValueTransformer instance.
**/
+ (instancetype)valueTransformerWithBlock:(EZFormValueTransformationBlock)block;

/**
 * Initialises a model value transformer that uses the provided block to transform the input.
 *
 * The block accepts one input value and should return the transformed output value.
 *
 * @param       block                   A block that accepts a single object argument and returns a transformed object.
 * @returns                             A configured EZValueTransformer instance.
**/
- (instancetype)initWithBlock:(EZFormValueTransformationBlock)block;

@end
