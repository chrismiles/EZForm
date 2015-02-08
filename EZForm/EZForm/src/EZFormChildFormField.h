//
//  EZFormChildFormField.h
//  EZForm
//
//  Created by Rob Amos on 28/03/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "EZFormField.h"
#import "EZFormFieldConcreteProtocol.h"

@protocol EZFormDelegate;

/**
 * A form field designed to encapsulate another EZForm object.
 *
 * This field is not designed to be wired to user interface elements,
 * but instead used to enable dynamic length forms. That is, forms
 * that let you add/remove sections.
**/
@interface EZFormChildFormField : EZFormField <EZFormFieldConcrete>

/**
 * The child form.
**/
@property (nonatomic, strong) EZForm *childForm;

/**
 * Initialises an allocated EZFormField object with the specified key and child form.
 *
 * @param aKey The key of the form field.
 * @param aForm The child form.
 *
 * @returns Initialised EZFormField object.
 */
- (id)initWithKey:(NSString *)aKey childForm:(EZForm *)aForm;

@end
