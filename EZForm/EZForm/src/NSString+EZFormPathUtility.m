//
//  NSString+EZFormPathUtility.m
//  EZForm
//
//  Created by Rob Amos on 9/02/2015.
//  Copyright (c) 2015 Chris Miles. All rights reserved.
//

#import "NSString+EZFormPathUtility.h"

@implementation NSString (EZFormPathUtility)

- (NSString *)formKeyForParentField
{
    if ([self rangeOfString:@"."].location == NSNotFound)
        return nil;
    
    // now we need to strip off the last one
    NSMutableArray *components = [[self componentsSeparatedByString:@"."] mutableCopy];
    [components removeLastObject];
    return [components componentsJoinedByString:@"."];
}

- (NSString *)lastFormKeyComponent
{
    if ([self rangeOfString:@"."].location == NSNotFound)
        return nil;
    
    // now we need to strip off the last one
    NSArray *components = [self componentsSeparatedByString:@"."];
    return components.lastObject;
}

@end
