//
//  FXKeychain.h
//
//  Version 1.1
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


#import <Foundation/Foundation.h>
#import <Security/Security.h>


@interface FXKeychain : NSObject

+ (instancetype)defaultKeychain;

@property (nonatomic, copy, readonly) NSString *account;
@property (nonatomic, copy, readonly) NSString *service;
@property (nonatomic, copy, readonly) NSString *accessGroup;

- (id)initWithAccount:(NSString *)account
              service:(NSString *)service
          accessGroup:(NSString *)accessGroup;

- (BOOL)setObject:(id<NSCoding>)object forKey:(id<NSCopying>)key;
- (BOOL)setObject:(id<NSCoding>)object forKeyedSubscript:(id<NSCopying>)key;
- (BOOL)removeObjectForKey:(id<NSCopying>)key;
- (id)objectForKey:(id<NSCopying>)key;
- (id)objectForKeyedSubscript:(id<NSCopying>)key;

@end
