//
//  ViewController.m
//  FXKeychainExample
//
//  Created by Nick Lockwood on 29/12/2012.
//  Copyright (c) 2012 Charcoal Design. All rights reserved.
//

#import "ViewController.h"
#import "FXKeychain.h"


@interface ViewController () <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, weak) IBOutlet UITextField *keyField;
@property (nonatomic, weak) IBOutlet UITextView *dataField;

@end


@implementation ViewController

- (IBAction)save
{
    //save data
    [FXKeychain defaultKeychain][_keyField.text] = _dataField.text;
}

- (IBAction)load
{
    //load data
    _dataField.text = [FXKeychain defaultKeychain][_keyField.text];
}

- (IBAction)delete
{
    //clear field
    _dataField.text = @"";
    
    //delete data
    [[FXKeychain defaultKeychain] removeObjectForKey:_keyField.text];
}

- (IBAction)tap
{
    [_keyField resignFirstResponder];
    [_dataField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
