//
//  AppDelegate.h
//  FXKeychainExampleMac
//
//  Created by Nick Lockwood on 30/12/2012.
//  Copyright (c) 2012 Charcoal Design. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, assign) IBOutlet NSWindow *window;
@property (nonatomic, strong) IBOutlet NSWindowController *windowController;

@end
