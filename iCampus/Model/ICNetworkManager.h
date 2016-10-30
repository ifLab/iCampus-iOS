//
//  ICNetworkManager.h
//  iCampus
//
//  Created by Bill Hu on 16/8/3.
//  Copyright © 2016年 BISTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>
#import "AFNetworking.h"

@interface ICNetworkManager : NSObject

@property (nonatomic) AFHTTPRequestOperationManager *manager;
@property (nonatomic) NSDictionary *configuration;
@property (nonatomic) NSString *website;
@property (nonatomic) NSString *verfycodeWebsite;
@property (nonatomic) NSString *APIKey;
@property (nonatomic) NSString *token;
@property (nonatomic) NSString *SMSappKey;
@property (nonatomic) NSString *SMSappSecret;
@property (nonatomic) NSDictionary *path;
@property (nonatomic) NSNumber *successCode;
@property (nonatomic) NSNumber *internalErrorCode;

+(instancetype)defaultManager;

- (instancetype)initWithConfiguration:(NSDictionary*)configuration;

- (AFHTTPRequestOperation*)GET:(NSString *)key
                    parameters:(NSDictionary *)parameters
                       success:(void (^)(NSDictionary *))success
                       failure:(void (^)(NSError *))failure;
- (AFHTTPRequestOperation*)POST:(NSString *)key
                  GETParameters:(NSDictionary *)GETParameters
                 POSTParameters:(NSDictionary *)POSTParameters
                        success:(void (^)(NSDictionary *))success
                        failure:(void (^)(NSError *))failure;
- (AFHTTPRequestOperation*)PUT:(NSString *)key
                    parameters:(NSDictionary *)parameters
                       success:(void (^)(NSDictionary *))success
                       failure:(void (^)(NSError *))failure;
//- (AFHTTPRequestOperation*)request:(NSString *)key
//                     GETParameters:(NSDictionary *)GETParameters
//                    POSTParameters:(NSDictionary *)POSTParameters
//         constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> *data))block
//                           success:(void (^)(id))success
//                           failure:(void (^)(NSError *))failure;

- (void)cleanCookies;

//-(void)handleSuccess:(AFHTTPRequestOperation*)operation
//                data:(NSData*)data
//             success:(void (^)(id object))success
//             failure:(void (^)(NSError *error))failure;



@end
