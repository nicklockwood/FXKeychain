//
//  FXKeychain.m
//
//  Version 1.0
//
//  Created by Nick Lockwood on 29/12/2012.
//  Copyright 2012 Charcoal Design
//
//  Distributed under the permissive zlib License
//  Get the latest version from here:
//
//  https://github.com/nicklockwood/FXKeychain
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//


#import "FXKeychain.h"


#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif


NSString *const FXKeychainDefaultAccount = @"default";
NSString *const FXKeychainDefaultService = @"default";


@implementation FXKeychain

+ (instancetype)defaultKeychain
{
    id sharedInstance = nil;
    if (!sharedInstance)
    {
        sharedInstance = [[FXKeychain alloc] initWithAccount:FXKeychainDefaultAccount
                                                     service:FXKeychainDefaultService
                                                 accessGroup:nil];
    }
    return sharedInstance;
}

- (id)init
{
    return [self initWithAccount:nil service:nil accessGroup:nil];
}

- (id)initWithAccount:(NSString *)account
              service:(NSString *)service
          accessGroup:(NSString *)accessGroup
{
    if ((self = [super init]))
    {
        _account = [account copy];
        _service = [service copy];
        _accessGroup = [accessGroup copy];
    }
    return self;
}

- (BOOL)setObject:(id<NSCoding>)object forKey:(id<NSCopying>)key
{
    //generate query
    NSMutableDictionary *query = [NSMutableDictionary dictionary];
    if ([_account length]) query[(__bridge NSString *)kSecAttrAccount] = _account;
    if ([_service length]) query[(__bridge NSString *)kSecAttrService] = _service;
    query[(__bridge NSString *)kSecClass] = (__bridge id)kSecClassGenericPassword;
    query[(__bridge NSString *)kSecAttrGeneric] = key;
    
#if !TARGET_IPHONE_SIMULATOR
    if ([_accessGroup length]) query[(__bridge NSString *)kSecAttrAccessGroup] = _accessGroup;
#endif
    
    //encode object
    NSData *data = nil;
    if ([(id)object isKindOfClass:[NSString class]])
    {
        data = [(NSString *)object dataUsingEncoding:NSUTF8StringEncoding];
    }
    else
    {
        data = [NSKeyedArchiver archivedDataWithRootObject:object];
    }
    if (object && !data)
    {
        NSLog(@"FXKeychain failed to encode object for key '%@'", key);
        return NO;
    }
    
    //delete existing data
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)query);
    
    //write data
    if (data)
    {
        query[(__bridge NSString *)kSecValueData] = data;
        status = SecItemAdd ((__bridge CFDictionaryRef)query, NULL);
        if (status != errSecSuccess)
        {
            NSLog(@"FXKeychain failed to store data for key '%@', error: %ld", key, status);
            return NO;
        }
    }
    else if (status != errSecSuccess)
    {
        NSLog(@"FXKeychain failed to delete data for key '%@', error: %ld", key, status);
        return NO;
    }
    return YES;
}

- (BOOL)removeObjectForKey:(id<NSCopying>)key
{
    return [self setObject:nil forKey:key];
}

- (id)objectForKey:(id<NSCopying>)key
{
    //generate query
    NSMutableDictionary *query = [NSMutableDictionary dictionary];
    if ([_account length]) query[(__bridge NSString *)kSecAttrAccount] = _account;
    if ([_service length]) query[(__bridge NSString *)kSecAttrService] = _service;
    query[(__bridge NSString *)kSecClass] = (__bridge id)kSecClassGenericPassword;
    query[(__bridge NSString *)kSecMatchLimit] = (__bridge id)kSecMatchLimitOne;
    query[(__bridge NSString *)kSecReturnData] = (__bridge id)kCFBooleanTrue;
    query[(__bridge NSString *)kSecAttrGeneric] = key;
    
#if !TARGET_IPHONE_SIMULATOR
    if ([_accessGroup length]) query[(__bridge NSString *)kSecAttrAccessGroup] = _accessGroup;
#endif
    
    //recover data
    id object = nil;
    CFDataRef data = nil;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&data);
    if (status == errSecSuccess && data)
    {
        //check if file is a plist
        NSDictionary *dict = [NSPropertyListSerialization propertyListWithData:(__bridge NSData *)data
                                                                       options:NSPropertyListImmutable
                                                                        format:NULL
                                                                         error:NULL];
        
        if ([dict respondsToSelector:@selector(objectForKey:)] && dict[@"$archiver"])
        {
            //data represents a dictionary. attempt to decode as NSCoded archive
            object = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)data];
        }
        else if (!object)
        {
            //may be a string
            object = [[NSString alloc] initWithData:(__bridge NSData *)data encoding:NSUTF8StringEncoding];
        }
        if (!object)
        {
             NSLog(@"FXKeychain failed to decode data for key '%@'", key);
        }
        CFRelease(data);
        return object;
    }
    else
    {
        //no value found
        return nil;
    }
}

@end
