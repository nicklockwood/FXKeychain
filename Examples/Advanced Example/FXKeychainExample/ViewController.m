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

@property (nonatomic, weak) IBOutlet UITextField *accountField;
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
    _accountField.text = [defaults objectForKey:@"account"] ?: @"default";
    _serviceField.text = [defaults objectForKey:@"service"] ?: @"default";
    _accessGroupField.text = [defaults objectForKey:@"accessGroup"];
    _keyField.text = [defaults objectForKey:@"key"] ?: @"password";
    
    //load data
    [self load];
}

- (void)saveSettings
{
    //preserve settings in NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_accountField.text forKey:@"account"];
    [defaults setObject:_serviceField.text forKey:@"service"];
    [defaults setObject:_accessGroupField.text forKey:@"accessGroup"];
    [defaults setObject:_keyField.text forKey:@"key"];
}

- (void)updateKeychainFromFields
{
    //create keychain
    _keychain = [[FXKeychain alloc] initWithAccount:_accountField.text
                                            service:_serviceField.text
                                        accessGroup:_accessGroupField.text];
}

- (IBAction)save
{
    //save settings
    [self saveSettings];
    
    //update keychain
    [self updateKeychainFromFields];
    
    //save data
    [_keychain setObject:_dataField.text forKey:_keyField.text];
}

- (IBAction)load
{
    //update keychain
    [self updateKeychainFromFields];
    
    //load data
    _dataField.text = [_keychain objectForKey:_keyField.text];
}

- (IBAction)delete
{
    //clear data
    _dataField.text = nil;
    
    //update keychain
    [self updateKeychainFromFields];
    
    //save data
    [_keychain removeObjectForKey:_keyField.text];
}

- (IBAction)tap
{
    [_accountField resignFirstResponder];
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
