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

@property (nonatomic, strong) IBOutlet UITextField *serviceField;
@property (nonatomic, strong) IBOutlet UITextField *accessGroupField;

@property (nonatomic, strong) IBOutlet UITextField *keyField;
@property (nonatomic, strong) IBOutlet UITextView *dataField;

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //get settings from NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.serviceField.text = [defaults objectForKey:@"service"] ?: [[NSBundle mainBundle] bundleIdentifier];
    self.accessGroupField.text = [defaults objectForKey:@"accessGroup"];
    self.keyField.text = [defaults objectForKey:@"key"] ?: @"password";
    
    //load data
    [self load];
}

- (void)saveSettings
{
    //preserve settings in NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.serviceField.text forKey:@"service"];
    [defaults setObject:self.accessGroupField.text forKey:@"accessGroup"];
    [defaults setObject:self.keyField.text forKey:@"key"];
    [defaults synchronize];
}

- (void)updateKeychainFromFields
{
    //create keychain
    self.keychain = [[FXKeychain alloc] initWithService:self.serviceField.text
                                            accessGroup:self.accessGroupField.text];
}

- (IBAction)save
{
    //save settings
    [self saveSettings];
    
    //update keychain
    [self updateKeychainFromFields];
    
    //save data
    self.keychain[self.keyField.text] = self.dataField.text;
}

- (IBAction)load
{
    //update keychain
    [self updateKeychainFromFields];
    
    //load data
    self.dataField.text = self.keychain[self.keyField.text];
}

- (IBAction)delete
{
    //clear data
    self.dataField.text = @"";
    
    //update keychain
    [self updateKeychainFromFields];
    
    //save data
    [self.keychain removeObjectForKey:self.keyField.text];
}

- (IBAction)tap
{
    [self.serviceField resignFirstResponder];
    [self.accessGroupField resignFirstResponder];
    [self.keyField resignFirstResponder];
    [self.dataField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
