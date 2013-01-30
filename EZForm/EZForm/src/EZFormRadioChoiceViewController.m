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

#import "EZFormRadioChoiceViewController.h"

@implementation EZFormRadioChoiceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.allowsMultipleSelection = self.allowsMultipleSelection;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (self.navigationController) {
	/* If managed by a nav controller then return rotation choice of previous view
	 * controller in the stack (if any).
	 */
	NSUInteger thisIndex = [self.navigationController.viewControllers indexOfObject:self];
	if (thisIndex != NSNotFound && thisIndex > 0) {
	    UIViewController *previousViewController = (self.navigationController.viewControllers)[thisIndex-1];
	    return [previousViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
	}
    }

    // Default behaviour; subclass to customize
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
	return YES;
    }
    else {
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    #pragma unused(tableView)

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    #pragma unused(tableView, section)

    EZFormRadioField *field = [self.form formFieldForKey:self.radioFieldKey];
    return (NSInteger)[field.choices count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FormRadioFieldChoiceCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (nil == cell) {
	cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    EZFormRadioField *field = [self.form formFieldForKey:self.radioFieldKey];
    NSString *choiceKey = [field choiceKeys][(NSUInteger)indexPath.row];
    cell.textLabel.text = [field.choices valueForKey:choiceKey];

    id modelValueArray = [self.form modelValueForKey:self.radioFieldKey];
    if (modelValueArray != nil && ![modelValueArray isKindOfClass:[NSArray class]]) {
        modelValueArray = @[modelValueArray];
    }

    if ([(NSArray *)modelValueArray containsObject:choiceKey]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EZFormRadioField *field = [self.form formFieldForKey:self.radioFieldKey];
    NSString *choiceKey = [field choiceKeys][(NSUInteger)indexPath.row];

    id modelValueArray = [self.form modelValueForKey:self.radioFieldKey];
    if (modelValueArray != nil && ![modelValueArray isKindOfClass:[NSArray class]]) {
        modelValueArray = @[modelValueArray];
    }

    if (self.allowsMultipleSelection && [modelValueArray containsObject:choiceKey]) {
        [(EZFormMultiRadioFormField *)field unsetFieldValue:choiceKey];
    }
    else {
        [self.form setModelValue:choiceKey forKey:self.radioFieldKey];
    }

    [self updateCellCheckmarks];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Update cell checkmarks

- (void)updateCellCheckmarks
{
    id modelValueArray = [self.form modelValueForKey:self.radioFieldKey];
    if (modelValueArray != nil && ![modelValueArray isKindOfClass:[NSArray class]]) {
        modelValueArray = @[modelValueArray];
    }

    EZFormRadioField *field = [self.form formFieldForKey:self.radioFieldKey];
    NSArray *choiceKeys = [field choiceKeys];
    
    for (UITableViewCell *cell in [self.tableView visibleCells]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        NSString *choiceKey = choiceKeys[(NSUInteger)indexPath.row];
        __block BOOL selected = NO;

        [(NSArray *)modelValueArray enumerateObjectsUsingBlock:^(id selection, __unused NSUInteger idx, BOOL *stop) {
            if ([selection isEqualToString:choiceKey]) {
                selected = YES;
                *stop = YES;
            }
        }];
        if (selected) {
	    cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else {
	    cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
}

@end
