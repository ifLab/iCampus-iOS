//
//  NSString+RSA.m
//  NSString+RSA
//
//  Created by Darren Liu on 13-10-22.
//  Copyright (c) 2013年 Darren Liu. All rights reserved.
//

#import "NSString+RSA.h"
#import "Base64.h"

@implementation NSString (RSA)

- (NSString *)rsaEncryptedStringWithPublicKey:(const NSString *)publicKey
{
    int i, bufferSize;
    NSData             *certificateData = [NSData dataWithBase64EncodedString:publicKey];
    SecCertificateRef   certificate     = SecCertificateCreateWithData(kCFAllocatorDefault,
                                                                       (__bridge CFDataRef)certificateData);
    SecPolicyRef        policy          = SecPolicyCreateBasicX509();
    SecTrustRef         trust;
    SecTrustResultType  trustResult;
    if (SecTrustCreateWithCertificates(certificate, policy, &trust) == noErr) {
        SecTrustEvaluate(trust, &trustResult);
        SecKeyRef  publicKeyRef     = SecTrustCopyPublicKey(trust);
        size_t     cipherBufferSize = SecKeyGetBlockSize(publicKeyRef);
        uint8_t   *cipherBuffer     = malloc(cipherBufferSize * sizeof(uint8_t));
        NSData    *stringBytes      = [self dataUsingEncoding:NSUTF8StringEncoding];
        size_t     blockSize        = cipherBufferSize - 11;
        size_t     blockCount       = (size_t)ceil(stringBytes.length / (double)blockSize);
        NSMutableData *encryptedData = [[NSMutableData alloc] init];
        for (i = 0; i < blockCount; i++) {
            bufferSize = (int)MIN(blockSize, stringBytes.length - i * blockSize);
            NSData *buffer = [stringBytes subdataWithRange:NSMakeRange(i * blockSize, bufferSize)];
            OSStatus status = SecKeyEncrypt(publicKeyRef,
                                            kSecPaddingPKCS1,
                                            buffer.bytes,
                                            buffer.length,
                                            cipherBuffer,
                                            &cipherBufferSize);
            if (status == noErr){
                NSData *encryptedBytes = [[NSData alloc] initWithBytes:cipherBuffer
                                                                length:cipherBufferSize];
                [encryptedData appendData:encryptedBytes];
            } else {
                if (cipherBuffer) {
                    free(cipherBuffer);
                }
                return nil;
            }
        }
        if (cipherBuffer) {
            free(cipherBuffer);
        }
        return [encryptedData base64EncodedString];
    }
    CFRelease(certificate);
    CFRelease(policy);
    CFRelease(trust);
    return nil;
}

@end
