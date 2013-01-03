//
//  EZForm
//
//  Copyright 2011-2013 Chris Miles. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import <Foundation/Foundation.h>
#import "EZFormField.h"
#import "EZFormFieldConcreteProtocol.h"

typedef enum : NSInteger {
    EZFormBooleanFieldStateAny = 0,
    EZFormBooleanFieldStateOn = 1,
    EZFormBooleanFieldStateOff = 2
} EZFormBooleanFieldState;


/** A form field to handle boolean input.
 *
 *  EZFormBooleanField can be wired up to user views of type:
 *  UISwitch, UIButton or UITableViewCell.
 */
@interface EZFormBooleanField : EZFormField <EZFormFieldConcrete> {
    
}

@property (nonatomic, assign)	EZFormBooleanFieldState	validationStates;

/** Toggle the value of the field.
 *
 * Convenience method to toggle the field value.
 */
- (void)toggleValue;

/** Wire the field to a user-specified button.
 *
 *  A button can be used to indicate the on/off state of a boolean field.
 *
 *  The wired button will have its state toggled between default ("off")
 *  and selected ("on").
 *
 *  @param button The UIButton to wire the field to.
 */
- (void)useButton:(UIButton *)button;

/** Wire the field to a user-specified switch.
 *
 *  The switch on/off state will be synced to the field value.
 *
 *  @param switchControl The UISwitch to wire the field to.
 */
- (void)useSwitch:(UISwitch *)switchControl;

/** Wire the field to a user-specified table view cell.
 *
 *  A table view cell can be used to indicate the on/off state of a boolean
 *  field.
 *
 *  The field will set the table view cell accessory type to checkmark
 *  when "on", and set the accessory type to none when off.
 *
 *  The user must update the field value when the cell is selected using
 *  tableView:didSelectRowAtIndexPath:. The toggleValue method is useful
 *  for this.
 *
 *  @param tableViewCell The UITableViewCell to wire the field to.
 */
- (void)useTableViewCell:(UITableViewCell *)tableViewCell;

@end
