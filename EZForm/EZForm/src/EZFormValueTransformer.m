//
//  EZFormValueTransformer.m
//  EZForm
//
//  Created by Rob Amos on 6/02/2015.
//  Copyright (c) 2015 Chris Miles. All rights reserved.
//

#import "EZFormValueTransformer.h"

@implementation EZFormValueTransformer

@synthesize forwardBlock=_forwardBlock;

// boilerplate
+ (BOOL)allowsReverseTransformation
{
    return NO;
}

- (id)transformedValue:(id)value
{
    return self.forwardBlock(value);
}

#pragma mark - Creating EZFormTransformers

- (instancetype)initWithBlock:(EZFormValueTransformationBlock)block
{
    if ((self = [self init])) {
        _forwardBlock = block;
    }
    return self;
}

+ (instancetype)valueTransformerWithBlock:(EZFormValueTransformationBlock)block
{
    return [[self alloc] initWithBlock:block];
}

+ (instancetype)valueTransformerWithKeyPath:(NSString *)keyPath
{
    return [self valueTransformerWithBlock:^id(id input) {
        
        if (input == nil) {
            return nil;
        }
        
        if ([input isKindOfClass:[NSString class]]) {
            return input;
        }
        
        // did we end up with an array? multi-select data
        if ([input isKindOfClass:[NSArray class]]) {
            
            // if it is an array of strings we can't map on that
            if ([((NSArray *)input).firstObject isKindOfClass:[NSString class]]) {
                return input;
            }
            
            NSMutableArray *keys = [NSMutableArray array];
            for (id i in (NSArray *)input) {
                [keys addObject:[i valueForKeyPath:keyPath]];
            }
            return [keys copy];
        }
        
        id value = [input valueForKeyPath:keyPath];
        return value;
    }];
}

+ (instancetype)valueTransformerWithKeyPathForValue:(NSString *)keyPath keyPathForDisplayValue:(NSString *)displayKeyPath
{
    return [self valueTransformerWithBlock:^id(id input) {
        
        if (input == nil)
            return nil;
        
        if ([input isKindOfClass:[NSString class]])
            return input;
        
        // did we end up with an array? multi-select data
        if ([input isKindOfClass:[NSArray class]]) {

            // if it is an array of strings we can't map on that
            if ([((NSArray *)input).firstObject isKindOfClass:[NSString class]])
                return input;
            
            NSMutableDictionary *choices = [[NSMutableDictionary alloc] initWithCapacity:0];
            for (id i in (NSArray *)input) {
                
                id<NSCopying> value = [i valueForKeyPath:keyPath];
                id displayValue = [i valueForKeyPath:displayKeyPath];
                
                [choices setObject:(displayValue ?: value) forKey:value];
            }
            return [choices copy];
        }
        
        id<NSCopying> value = [input valueForKeyPath:keyPath];
        id displayValue = [input valueForKeyPath:displayKeyPath];
        
        return @{ value: (displayValue ?: value) };
    }];
}

@end
