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

EZForm is compatible with iOS 5 and upwards.  EZForm uses automatic reference counting (ARC).

The demo app included with the source requires iOS 5.


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
