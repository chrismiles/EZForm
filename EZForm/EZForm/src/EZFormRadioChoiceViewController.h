//
//  EZForm
//
//  Copyright 2012-2013 Chris Miles. All rights reserved.
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

#import <UIKit/UIKit.h>
#import "EZForm.h"

/** A table view controller to use for presenting radio field choices.
 *
 *  An EZFormRadioChoiceViewController can be used to
 *  conveniently present radio field choices to the user.
 *  The form model is updated when the user makes a selection.
 *
 *  Values for the form and radioFieldKey properties are both
 *  required.
 *
 *  To customise the view and style, the view controller can be
 *  subclassed.
 */

@interface EZFormRadioChoiceViewController : UITableViewController

/** The form containing the radio field.
 *
 *  A form is required.
 */
@property (nonatomic, strong) EZForm *form;

/** The key of the radio field.
 *
 *  A key is required.
 */
@property (nonatomic, copy) NSString *radioFieldKey;


/** Similar to UITableView's allowsMultipleSelection method
 *
 *  This method tells the controller to attempt multiple selection on it's
 *  table view and it's form field.
 *
 *  Setting this to YES with a form field that doesn't support multiple selection
 *  has undefined behaviour.
 */

@property (nonatomic, assign) BOOL allowsMultipleSelection;

@end
