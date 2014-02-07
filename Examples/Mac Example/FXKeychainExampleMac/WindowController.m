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

@property (nonatomic, strong) IBOutlet NSTextField *keyField;
@property (nonatomic, strong) IBOutlet NSTextField *dataField;

@end


@implementation WindowController

- (IBAction)save:(__unused id)sender
{
    //save data
    [FXKeychain defaultKeychain][[self.keyField stringValue]] = [self.dataField stringValue];
}

- (IBAction)load:(__unused id)sender
{
    //load data
    [self.dataField setStringValue:[FXKeychain defaultKeychain][[self.keyField stringValue]] ?: @""];
}

- (IBAction)delete:(__unused id)sender
{
    //clear field
    [self.dataField setStringValue:@""];
    
    //delete data
    [[FXKeychain defaultKeychain] removeObjectForKey:[self.keyField stringValue]];
}

@end
