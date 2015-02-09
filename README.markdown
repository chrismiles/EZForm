EZForm
======

<https://github.com/chrismiles/EZForm>

EZForm is a form handling and validation library for iOS. It is designed to be decoupled from your user interface layout, leaving you free to present your form UI any way you like. That doesn't mean EZForm won't integrate with your UI. You tell EZForm which of your controls and views you want to handle each form field, and EZForm will take care of input validation, input filtering and updating views when field values change.


Goals of EZForm
---------------

* To simplify form handling and validation while staying out of your way.

* To be decoupled from the user interface layout of the form. Design your form's interface any way you like: with Interface Builder, with code, or any way you choose.

* To assist managing form input and display by working with any user interface controls and views that you tell it about.

* To provide common input conveniences, if requested, such as: keyboard input accessories with navigation between text fields; automatic scrolling or repositioning of views to keep input fields visible; and invalid field indicator management.


Features
--------

 * Form field types including: text, boolean, radio. 

 * Text fields can integrate with views of type: UITextField, UITextView, UILabel.

 * Boolean fields can integrate with views of type: UISwitch, UIButton, UITableViewCell.

 * Radio fields can integrate with views of type: UILabel.

 * Block based validators. User-defined input validation rules can be added to fields as block objects.

 * Some common validators are included with EZForm.

 * Block based input filters. Input filters control what can be entered by the user. For example, an input filter could be added to a text field to allow only numeric characters to be typed.

 * Some common input filters are included with EZForm.

 * Standard input accessory and field navigation. A standard input accessory can be added to text fields by EZForm with one method call. It adds a bar to the keyboard with field navigation and done buttons, similar to Mobile Safari's input accessory. Navigation between fields is handled automatically by EZForm. 

 * Automatic view scrolling to keep active text fields visible. With the option enabled, EZForm will adjust a scroll view, table view or arbitrary view to keep the text field being edited on screen and not covered by a keyboard. 

 * Invalid field indicators. EZForm can automatically show invalid indicator views on text fields that fail validation. Invalid indicator views can be user-supplied or supplied by EZForm.

 * EZForm comes with an optional table view controller subclass that can be used to conveniently present radio choice selections, `EZFormRadioChoiceViewController`.
 
 * Optional model value transformers for easy passing of values between your form, UI and model layers.


Quick Start
-----------

Git clone the source.

Add EZForm/EZForm.xcodeproj to your project (or workspace).

Add `libEZForm.a` to the Linked Frameworks and Libraries for your project.

Add `-ObjC` to "Other Linker Flags" in your target's build settings.

Import the main header:

```objective-c 
#import <EZForm/EZForm.h>
```

Create an EZForm instance and add some EZFormField subclass instances to it. For example:

```objective-c 
- (void)initializeForm
{
    /*
     * Create EZForm instance to manage the form.
     */
    _myForm = [[EZForm alloc] init];
    _myForm.inputAccessoryType = EZFormInputAccessoryTypeStandard;
    _myForm.delegate = self;

    /*
     * Add an EZFormTextField instance to handle the name field.
     * Enables a validation rule of 1 character minimum.
     * Limits the input text field to 32 characters maximum (when hooked up to a control).
     */
    EZFormTextField *nameField = [[EZFormTextField alloc] initWithKey:@"name"];
    nameField.validationMinCharacters = 1;
    nameField.inputMaxCharacters = 32;
    [_myForm addFormField:nameField];
    
    /*
     * Add an EZFormTextField instance to handle the email address field.
     * Enables a validation rule that requires an email address format "x@y.z"
     * Limits the input text field to 128 characters maximum and filters input
     * to assist with entering a valid email address (when hooked up to a control).
     */
    EZFormTextField *emailField = [[EZFormTextField alloc] initWithKey:@"email"];
    emailField.inputMaxCharacters = 128;
    [emailField addValidator:EZFormEmailAddressValidator];
    [emailField addInputFilter:EZFormEmailAddressInputFilter];
    [_myForm addFormField:emailField];
}
```

You can update the form fields directly based on user input. But, more
commonly, you will wire up your input controls directly to EZForm so it
will handle input, validation, field navigation, etc, automatically.
For example:

```objective-c 
- (void)viewDidLoad
{
    [super viewDidLoad];

    /* Wire up form fields to user interface elements.
     * This needs to be done after the views are loaded (e.g. in viewDidLoad).
     */
    EZFormTextField *nameField = [_myForm formFieldForKey:@"name"];
    [nameField useTextField:self.nameTextField];
    
    EZFormTextField *emailField = [_myForm formFieldForKey:@"email"];
    [emailField useTextField:self.emailTextField];
    
    /* Automatically scroll (or move) the given view if needed to
     * keep the active form field control visible.
     */
    [_myForm autoScrollViewForKeyboardInput:self.tableView];
}
```

If you wire up any of your views to EZForm you should unwire them in
viewDidUnload, which you can do with one method call:

```objective-c 
- (void)viewDidUnload
{
    [super viewDidUnload];
    [_myForm unwireUserViews];
}
```

You can also nest child EZForm instances inside fields and address them using a key path:

```objective-c
- (void)initializeForm
{
	// continues from above
	
    // add a child form field to the form
    EZForm *addressForm = [[EZForm alloc] init];
    EZFormChildFormField *address = [[EZFormChildFormField alloc] initWithKey:@"address" childForm:addressForm];
    [_myForm addFormField:address];
    
    // add fields to the child form
    EZFormTextField *line1 = [[EZFormTextField alloc] initWithKey:@"line1"];
    [addressForm addFormField:line1];
    EZFormTextField *line2 = [[EZFormTextField alloc] initWithKey:@"line2"];
    [addressForm addFormField:line2];
    EZFormTextField *suburb = [[EZFormTextField alloc] initWithKey:@"suburb"];
    [addressForm addFormField:suburb];
    EZFormTextField *state = [[EZFormTextField alloc] initWithKey:@"state"];
    [addressForm addFormField:state];
    EZFormTextField *postcode = [[EZFormTextField alloc] initWithKey:@"postcode"];
    [addressForm addFormField:postcode];
    
    // now you can address those fields directly via a keypath, like so:
    NSString *line1Value = [_myForm modelValueForKey:@"address.line1"];
    
    // or a nested dictionary via -modelValues:
    NSDictionary *values = _myForm.modelValues;
    
    /**
     * values is now:
     * @{
     *     @"name": @"Jane Citizen",
     *     @"email": @"jane@citizen.com",
     *     @"address": @{
     *         @"line1": @"Address Line 1",
     *         @"line2": @"Address Line 2",
     *         @"suburb": @"Suburb",
     *         @"state": @"State",
     *         @"postcode": @"1234"
     *     }
     * }
    **/
}
```

When interacting with your UI or a model you can also supply NSValueTransformers to handle transforming your other object values into your field values.

```objective-c
- (void)initializeForm
{
	// continues from above
	
    // lets add coordinates to our address child form
    EZFormGenericField *latitude = [[EZFormGenericField alloc] initWithKey:@"latitude"];
    [addressForm addFormField:latitude];
    EZFormGenericField *longitude = [[EZFormGenericField alloc] initWithKey:@"longitude"];
    [addressForm addFormField:longitude];
    
    // the latitude/longitude informats might be obtained using a geo-coding service from the address details
    // lets assume the service returns a Location object which has latitude and longtiude properties and add value transformers to obtain the correct values
    latitude.valueTransformer = [EZFormValueTransformer valueTransformerWithKeyPath:@"latitude"];
    longitude.valueTransformer = [EZFormValueTransformer valueTransformerWithKeyPath:@"longitude"];
    
    // similarly, you can apply a form value transformer to assist with the import or export of entire forms
    _myForm.formValueTransformer = [EZFormReversibleValueTransformer reversibleValueTransformerWithForwardBlock:^id(id input) {
        
        // clear the form if the input is nil or invalid
        if (input == nil || ![input isKindOfClass:[Person class]]) {
            return nil;
        }
        
        // lets map our Person object into the form
        Person *person = (Person *)input;
        
        // only return the values you want to update. Use NSNull to clear (nil) field values
        return @{
                 @"name":		  person.fullName ?: [NSNull null],
                 @"email":		  person.email ?: [NSNull null],
                 @"address": @{
                         @"line1":	  person.address.line1 ?: [NSNull null],
                         @"line2":	  person.address.line2 ?: [NSNull null],
                         @"suburb":	  person.address.city ?: [NSNull null],
                         @"state":	  person.address.state ?: [NSNull null],
                         @"postcode":  person.address.postcode ?: [NSNull null],
                         @"latitude":  person.address.location != nil ? [NSString stringWithFormat:@"%.g", person.address.location.coordinate.latitude] : [NSNull null],
                         @"longitude":  person.address.location != nil ? [NSString stringWithFormat:@"%.g", person.address.location.coordinate.longitude] : [NSNull null],
                         }
                 };
        
    } reverseBlock:^id(id input) {
        
        // our input is an NSDictionary returned by -modelValues.
        NSDictionary *modelValues = (NSDictionary *)input;
        
        // Create our person object
        Person *person = [[Person alloc] init];
        person.fullName = modelValues[@"name"];
        person.email = modelValues[@"email"];
        
        person.address = [[Address alloc] init];
        person.address.line1 = modelValues[@"address"][@"line1"];
        person.address.line2 = modelValues[@"address"][@"line2"];
        person.address.city = modelValues[@"address"][@"suburb"];
        person.address.state = modelValues[@"address"][@"state"];
        person.address.postcode = modelValues[@"address"][@"postcode"];
        
        // transform the string values into a CLLocation object
        CLLocationDegrees latitude = [modelValues[@"address"][@"latitude"] doubleValue];
        CLLocationDegrees longitude = [modelValues[@"address"][@"longitude"] doubleValue];
        person.address.location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        
        return person;
    }];
}
```

Larger Example
--------------

This example demonstrates a complete Person form that provides a name and email field, as well as allowing multiple address child-forms to be added in a form group.

```objective-c
/**
 * Some basic EZForm subclasses for our forms.
**/
@interface AddressForm : EZForm
@end

@interface PersonForm : EZForm
@end

@implementation PersonForm

- (void)initialiseForm
{
    // Some fields (same as the ones above). Typically you configure your validations better than this
    [self addFormField:[[EZFormTextField alloc] initWithKey:@"name"]];
    [self addFormField:[[EZFormTextField alloc] initWithKey:@"email"]];

    // set it up so that we can add in AddressForm instances
    [self setFormClass:[AddressForm class] forChildFormGroupWithKey:@"addresses"];
    
    // we also have a form value transformer for easy translation
    self.formValueTransformer = [EZFormReversibleValueTransformer reversibleValueTransformerWithForwardBlock:^id(id input) {
        
        // clear the form if the input is nil or invalid
        if (input == nil || ![input isKindOfClass:[Person class]]) {
            return nil;
        }
        
        // map the Person into something the form can parse
        Person *person = (Person *)input;
        return @{
             @"name":       person.fullName ?: [NSNull null],
             @"email":      person.email ?: [NSNull null],
             
             // Because we supply a -formValueTransformer for the AddressForm subclass (which becomes the EZFormChildFormField's -valueTransformer
             // we don't want to transform those values here or they will be transformed twice.
             @"addresses":  person.addresses
        };
    
    } reverseBlock:^id(id input) {
        
        // our input is an NSDictionary of all the form values
        NSDictionary *modelValues = (NSDictionary *)input;
        
        // Create our person object
        Person *person = [[Person alloc] init];
        person.fullName = modelValues[@"name"];
        person.email = modelValues[@"email"];
        
        // the AddressForm instances in the addresses group will already have been transformed by its own -formValueTransformer, so we
        // can just pass it across. That is, modelValue[@"addresses"] will be an NSArray of Address objects.
        person.addresses = modelValues[@"addresses"];
        
        return person;
    }];
}

// Called by the UI to add a new address to the form, maybe via an "+ Add Address" button at the bottom of your table?
- (void)addNewAddress
{
    // we can create a default Address object to be used for the initial valute population
    // or just pass nil to leave everything blank.
    [self addObject:nil toGroupWithKey:@"addresses"];
}

// Called by the UI to remove an address from the form, maybe in response to a swipe and delete event.
- (void)removeAddressAtIndex:(NSUInteger)index
{
    EZFormChildFormField *field = [self formFieldInChildFormGroupWithKey:@"addresses" atIndex:index];
    if (field != nil) {
        [self removeFormFieldWithKey:field.key];
    }
}

// Called by the UI to submit your form, like say a Done button.
- (void)submitForm
{
    // let's pretend we have a nice SDK that encapsulates a well-formed Person object and sends it to our backend
    Person *person = self.transformedModelValue;

    [MagicalSDK updatePerson:person completion:^(BOOL success, NSError *error)
    {
        if (success) {
            // handle success
        } else {
            // handle error
        }
    }];
}

@end

@implementation AddressForm

- (instancetype)init
{
    if ((self = [super init])) {
        
        // Some fields. Typically you configure your validations better than this
        [self addFormField:[[EZFormTextField alloc] initWithKey:@"line1"]];
        [self addFormField:[[EZFormTextField alloc] initWithKey:@"line2"]];
        [self addFormField:[[EZFormTextField alloc] initWithKey:@"suburb"]];
        [self addFormField:[[EZFormTextField alloc] initWithKey:@"state"]];
        [self addFormField:[[EZFormTextField alloc] initWithKey:@"postcode"]];
        [self addFormField:[[EZFormGenericField alloc] initWithKey:@"latitude"]];
        [self addFormField:[[EZFormGenericField alloc] initWithKey:@"longitude"]];
        
        // we have a form value transformer for conversion between Address objects
        self.formValueTransformer = [EZFormReversibleValueTransformer reversibleValueTransformerWithForwardBlock:^id(id input) {
            
            // clear the form if the input is nil or invalid
            if (input == nil || ![input isKindOfClass:[AddressForm class]]) {
                return nil;
            }
            
            // lets map our Address object into the form
            Address *address = (Address *)input;
            
            // only return the values you want to update. Use NSNull to clear (nil) field values
            return @{
                 @"line1":	  address.line1 ?: [NSNull null],
                 @"line2":	  address.line2 ?: [NSNull null],
                 @"suburb":	  address.city ?: [NSNull null],
                 @"state":	  address.state ?: [NSNull null],
                 @"postcode":  address.postcode ?: [NSNull null],
                 @"latitude":  address.location != nil ? [NSString stringWithFormat:@"%.g", address.location.coordinate.latitude] : [NSNull null],
                 @"longitude":  address.location != nil ? [NSString stringWithFormat:@"%.g", address.location.coordinate.longitude] : [NSNull null]
             };
            
        } reverseBlock:^id(id input) {
            
            // our input is an NSDictionary returned by -modelValues.
            NSDictionary *modelValues = (NSDictionary *)input;
            
            // Create our address object
            Address *address = [[Address alloc] init];
            address.line1 = modelValues[@"line1"];
            address.line2 = modelValues[@"line2"];
            address.city = modelValues[@"suburb"];
            address.state = modelValues[@"state"];
            address.postcode = modelValues[@"postcode"];
            
            // transform the string values into a CLLocation object
            CLLocationDegrees latitude = [modelValues[@"latitude"] doubleValue];
            CLLocationDegrees longitude = [modelValues[@"longitude"] doubleValue];
            address.location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
            
            return address;
        }];
    }
    return self;
}

@end
```

See the demo app source for more examples of how to work with EZForm.


Demo
----

A demo universal iOS app is included with the source, containing some example form implementations.

![Simple Login Form Demo](https://lh5.googleusercontent.com/-eSo0Mi9Yx_I/T6mX9MyjGsI/AAAAAAAAAQY/ACZzzPUanJo/s640/screen-capture.png "Simple Login Form Demo")
![Registration Form Demo](https://lh4.googleusercontent.com/-It-OMpRf1XE/T6mX7tgsLcI/AAAAAAAAAQM/fUvPyPGrwpc/s640/screen-capture-1.png "Registration Form Demo")
![Registration Form Demo](https://lh3.googleusercontent.com/-EERtiMmLUXs/T6mX8lwzVTI/AAAAAAAAAQQ/kHPGOkgf6yc/s640/screen-capture-2.png "Registration Form Demo")


Documentation
-------------

EZForm comes with full API documentation, which is Xcode Document Set ready. Use appledoc to generate and install the document set into Xcode - http://gentlebytes.com/appledoc/

To generate the document set using appledoc from the command-line, cd to the root of the source directory and enter:

    ./gen-apple-doc-set


Requirements
------------

EZForm is compatible with iOS 6 and upwards.  EZForm uses automatic reference counting (ARC).

The demo app included with the source requires iOS 6.


ARC
---

EZForm uses automatic reference counting (ARC).


Support
-------

EZForm is provided open source with no warranty and no guarantee of support.
However, best effort is made to address [issues][1] raised on Github.

If you would like assistance with integrating EZForm or modifying it for your
needs, contact the author Chris Miles <miles.chris@gmail.com> for consulting
opportunities.

[1]: https://github.com/chrismiles/EZForm/issues "EZForm issues on Github"


Used In
-------

EZForm has been used in these iOS projects:

* "Paper Baron" - <https://itunes.apple.com/au/app/paper-baron/id484826203?mt=8>
* "Locayta Notes" - <https://itunes.apple.com/au/app/locayta-notes/id393819477?mt=8>
* "Coles App" - <https://itunes.apple.com/au/app/coles-app/id529118855?mt=8>
* "SEEK - Jobs" - <https://itunes.apple.com/au/app/seek-jobs/id520400855?mt=8>
* "realestate.com.au - Australia's No. 1 Real Estate Site" - <https://itunes.apple.com/au/app/realestate.com.au-australias/id404667893?mt=8>
* "Beanhunter - Find and share great coffee" - <https://itunes.apple.com/au/app/beanhunter-find-share-great/id349940968?mt=8>
* "Bendix Brake Pad Identifier" - <https://itunes.apple.com/au/app/bendix-brake-pad-identifier/id843103884?mt=8>
* "Kayako" - <https://itunes.apple.com/au/app/kayako/id843956132?mt=8>
* "Pocket Console" - <https://itunes.apple.com/app/pocket-console-for-aws/id919780618>
* _Your app here - let us know_


License
-------

EZForm is Copyright (c) 2011-2013 Chris Miles and released open source
under a MIT license:

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
