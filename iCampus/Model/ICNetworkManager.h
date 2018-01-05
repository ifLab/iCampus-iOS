//
//  ICNetworkManager.h
//  iCampus
//
//  Created by Bill Hu on 16/8/3.
//  Copyright © 2016年 BISTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>
@import AFNetworking;

@interface ICNetworkManager : NSObject

@property (nonatomic) AFHTTPSessionManager *manager;
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

- (NSURLSessionTask*)GET:(NSString *)key
              parameters:(NSDictionary *)parameters
                 success:(void (^)(NSDictionary *))success
                 failure:(void (^)(NSError *))failure;

- (NSURLSessionTask*)POST:(NSString *)key
            GETParameters:(NSDictionary *)GETParameters
           POSTParameters:(NSDictionary *)POSTParameters
                  success:(void (^)(NSDictionary *))success
                  failure:(void (^)(NSError *))failure;

- (NSURLSessionTask*)PUT:(NSString *)key
           GETParameters:(NSDictionary *)GETParameters
          POSTParameters:(NSDictionary *)POSTParameters
                 success:(void (^)(NSDictionary *))success
                 failure:(void (^)(NSError *))failure;

- (NSURLSessionTask*)PATCHWithWebSite:(NSString *)webSite
                        GETParameters:(NSDictionary *)GETParameters
                       POSTParameters:(NSDictionary *)POSTParameters
                              success:(void (^)(NSDictionary *))success
                              failure:(void (^)(NSError *))failure;

- (void)cleanCookies;

@end
