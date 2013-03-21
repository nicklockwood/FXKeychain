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

@property (nonatomic, strong) FXKeychain *keychain;

@property (nonatomic, weak) IBOutlet UITextField *serviceField;
@property (nonatomic, weak) IBOutlet UITextField *accessGroupField;

@property (nonatomic, weak) IBOutlet UITextField *keyField;
@property (nonatomic, weak) IBOutlet UITextView *dataField;

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //get settings from NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _serviceField.text = [defaults objectForKey:@"service"] ?: [[NSBundle mainBundle] bundleIdentifier];
    _accessGroupField.text = [defaults objectForKey:@"accessGroup"];
    _keyField.text = [defaults objectForKey:@"key"] ?: @"password";
    
    //load data
    [self load];
}

- (void)saveSettings
{
    //preserve settings in NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_serviceField.text forKey:@"service"];
    [defaults setObject:_accessGroupField.text forKey:@"accessGroup"];
    [defaults setObject:_keyField.text forKey:@"key"];
    [defaults synchronize];
}

- (void)updateKeychainFromFields
{
    //create keychain
    _keychain = [[FXKeychain alloc] initWithService:_serviceField.text
                                        accessGroup:_accessGroupField.text];
}

- (IBAction)save
{
    //save settings
    [self saveSettings];
    
    //update keychain
    [self updateKeychainFromFields];
    
    //save data
    _keychain[_keyField.text] = _dataField.text;
}

- (IBAction)load
{
    //update keychain
    [self updateKeychainFromFields];
    
    //load data
    _dataField.text = _keychain[_keyField.text];
}

- (IBAction)delete
{
    //clear data
    _dataField.text = @"";
    
    //update keychain
    [self updateKeychainFromFields];
    
    //save data
    [_keychain removeObjectForKey:_keyField.text];
}

- (IBAction)tap
{
    [_serviceField resignFirstResponder];
    [_accessGroupField resignFirstResponder];
    [_keyField resignFirstResponder];
    [_dataField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
