//
//  EZFDRegistrationRadioChoiceViewController.m
//  EZFormDemo
//
//  Created by Chris Miles on 4/05/12.
//  Copyright (c) 2012 Chris Miles. All rights reserved.
//

#import "EZFDRegistrationRadioChoiceViewController.h"

@interface EZFDRegistrationRadioChoiceViewController ()

@end

@implementation EZFDRegistrationRadioChoiceViewController

@synthesize form = _form;
@synthesize radioFieldKey = _radioFieldKey;

- (void)dealloc
{
    [_form release];
    [_radioFieldKey release];
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
	return YES;
    }
    else {
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    EZFormRadioField *field = (EZFormRadioField *)[self.form formFieldForKey:self.radioFieldKey];
    return [field.choices count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FormRadioFieldChoice";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    EZFormRadioField *field = (EZFormRadioField *)[self.form formFieldForKey:self.radioFieldKey];
    NSString *choiceKey = [[field choiceKeys] objectAtIndex:indexPath.row];
    cell.textLabel.text = [field.choices valueForKey:choiceKey];
    
    if ([[self.form modelValueForKey:self.radioFieldKey] isEqualToString:choiceKey]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EZFormRadioField *field = (EZFormRadioField *)[self.form formFieldForKey:self.radioFieldKey];
    NSString *choiceKey = [[field choiceKeys] objectAtIndex:indexPath.row];
    [self.form setModelValue:choiceKey forKey:self.radioFieldKey];
    
    [self updateCellCheckmarks];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Update cell checkmarks

- (void)updateCellCheckmarks
{
    NSString *selection = [self.form modelValueForKey:self.radioFieldKey];
    EZFormRadioField *field = (EZFormRadioField *)[self.form formFieldForKey:self.radioFieldKey];
    NSArray *choiceKeys = [field choiceKeys];
    
    for (UITableViewCell *cell in [self.tableView visibleCells]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        NSString *choiceKey = [choiceKeys objectAtIndex:indexPath.row];
	
        if ([selection isEqualToString:choiceKey]) {
	    cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
	    cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
}

@end
