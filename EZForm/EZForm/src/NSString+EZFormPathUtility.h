//
//  NSString+EZFormPathUtility.h
//  EZForm
//
//  Created by Rob Amos on 9/02/2015.
//  Copyright (c) 2015 Chris Miles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (EZFormPathUtility)

- (NSString *)formKeyForParentField;
- (NSString *)lastFormKeyComponent;

@end
