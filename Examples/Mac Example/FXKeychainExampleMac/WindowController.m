//
//  WindowController.m
//  FXKeychainExampleMac
//
//  Created by Nick Lockwood on 30/12/2012.
//  Copyright (c) 2012 Charcoal Design. All rights reserved.
//

#import "WindowController.h"
#import "FXKeychain.h"


@interface WindowController ()

@property (nonatomic, weak) IBOutlet NSTextField *keyField;
@property (nonatomic, weak) IBOutlet NSTextField *dataField;

@end


@implementation WindowController

- (IBAction)save:(__unused id)sender
{
    //save data
    [FXKeychain defaultKeychain][[_keyField stringValue]] = [_dataField stringValue];
}

- (IBAction)load:(__unused id)sender
{
    //load data
    [_dataField setStringValue:[FXKeychain defaultKeychain][[_keyField stringValue]] ?: @""];
}

- (IBAction)delete:(__unused id)sender
{
    //clear field
    [_dataField setStringValue:@""];
    
    //delete data
    [[FXKeychain defaultKeychain] removeObjectForKey:[_keyField stringValue]];
}

@end
