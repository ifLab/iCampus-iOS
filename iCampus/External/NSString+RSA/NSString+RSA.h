//
//  NSString+RSA.h
//  NSString+RSA
//
//  Created by Darren Liu on 13-10-22.
//  Copyright (c) 2013年 Darren Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RSA)

- (NSString *)rsaEncryptedStringWithPublicKey:(const NSString *)publicKey;

@end
