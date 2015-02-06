//
//  EZFormDelegate.h
//  EZForm
//
//  Created by Rob Amos on 28/03/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EZForm, EZFormField;

/** The EZFormDelegate protocol defines the messages sent to an EZForm delegate as part of form handling.
 *
 * All of the methods of this protocol are optional.
 */
@protocol EZFormDelegate <NSObject>

@optional

/** Tells the delegate that the Done button was touched and the keyboard is closing.
 *
 *  This method tells the delegate that the Done button was touched and
 *  the keyboard is closing.
 *
 *  @param form The form containing the field for which editing began.
 */
- (void)formInputAccessoryViewDone:(EZForm *)form;

/** Tells the delegate that a form field value was updated.
 *
 *  @param form The form for which a field value was updated.
 *
 *  @param formField The form field for which the value was updated.
 *
 *  @param isValid Whether the form model is valid or not.
 */
- (void)form:(EZForm *)form didUpdateValueForField:(EZFormField *)formField modelIsValid:(BOOL)isValid;

/** Tells the delegate that the user finished form input on the last field.
 *
 *  This is normally called when the user hits the return key on the last
 *  text field of a form.
 *
 *  @param form The form for which input has finished on the last field.
 */
- (void)formInputFinishedOnLastField:(EZForm *)form;

/** Tells the delegate that editing began for the specified field.
 *
 *  This method tells the delegate that the specified field became the first
 *  responder.
 *
 *  @param form The form containing the field for which editing began.
 *
 *  @param formField The form field for which editing began.
 */
- (void)form:(EZForm *)form fieldDidBeginEditing:(EZFormField *)formField;

/** Tells the delegate that editing ended for the specified field.
 *
 *  This method tells the delegate that the specified field resigned the first
 *  responder.
 *
 *  @param form The form containing the field for which editing ended.
 *
 *  @param formField The form field for which editing end.
 */
- (void)form:(EZForm *)form fieldDidEndEditing:(EZFormField *)formField;

/** Asks the delegate for the index path to the row containing the user view
 *  for the specified field.
 *
 *  This should only be needed for forms presented using dynamic table views.
 *  EZForm won't be able to determine where in the table the field's view
 *  is located as it may be off screen and so not part of a table view cell.
 *
 *  If the delegate does not implement this method or returns nil then
 *  the form will attempt to determine the location of the field view, if
 *  possible.
 *
 *  @param form The form requesting the index path.
 *
 *  @param key The key of the field wired to a user view whose index path is
 *  requested.
 *
 *  @returns The indexPath of the cell containing the user view for the field.
 */
- (NSIndexPath *)form:(EZForm *)form indexPathToAutoScrollCellForFieldKey:(NSString *)key;

/**
 * Maintained for backwards compatibility. Use -form:indexPathToAutoScrollCellForFieldKey: instead.
 **/
- (NSIndexPath *)form:(EZForm *)form indexPathToAutoScrollTableForFieldKey:(NSString *)key;

@end

