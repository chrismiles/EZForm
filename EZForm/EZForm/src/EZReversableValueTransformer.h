//
//  EZReversableValueTransformer.h
//  EZForm
//
//  Created by Sash Zats on 11/2/14.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id(^EZTranformationBlock)(id value);

@interface EZReversableValueTransformer : NSValueTransformer

+ (instancetype)reversableValueTransformerWithForwardBlock:(EZTranformationBlock)forward reverseBlock:(EZTranformationBlock)reverseBlock;

@property (nonatomic, copy) EZTranformationBlock forwardBlock;
@property (nonatomic, copy) EZTranformationBlock reverseBlock;

- (id)reverseTransformedValue:(id)value;

@end
