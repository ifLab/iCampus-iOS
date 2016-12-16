//
//  ICNetworkManager.m
//  iCampus
//
//  Created by Bill Hu on 16/8/3.
//  Copyright © 2016年 BISTU. All rights reserved.
//

#import "ICNetworkManager.h"

@implementation ICNetworkManager

- (instancetype)initWithConfiguration:(NSDictionary*)configuration
{
    self = [super init];
    if (self) {
        self.configuration = configuration;
        if (self.configuration[@"Website"] == nil ||
            self.configuration[@"Paths"] == nil ||
            self.configuration[@"Verfycode API Key"] == nil ||
            self.configuration[@"Verfycode App Secret"] == nil ||
            self.configuration[@"Verfycode Website"] == nil) {
            return nil;
        }
    }
    return self;
}

- (AFHTTPRequestOperationManager *)manager {
    if (!_manager) {
        _manager = [AFHTTPRequestOperationManager manager];
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        [_manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return _manager;
}

- (AFHTTPRequestOperation*)GET:(NSString *)key
                    parameters:(NSDictionary *)parameters
                       success:(void (^)(NSDictionary *))success
                       failure:(void (^)(NSError *))failure
{
    return [self request:key method:nil GETParameters:parameters POSTParameters:nil constructingBodyWithBlock:nil success:success failure:failure];
}

- (AFHTTPRequestOperation*)POST:(NSString *)key
                  GETParameters:(NSDictionary *)GETParameters
                 POSTParameters:(NSDictionary *)POSTParameters
                        success:(void (^)(NSDictionary *))success
                        failure:(void (^)(NSError *))failure
{
    return [self request:key method:nil GETParameters:GETParameters POSTParameters:POSTParameters constructingBodyWithBlock:nil success:success failure:failure];
}

- (AFHTTPRequestOperation*)PUT:(NSString *)key
                    parameters:(NSDictionary *)parameters
                       success:(void (^)(NSDictionary *))success
                       failure:(void (^)(NSError *))failure
{
    return [self request:key method:@"PUT" GETParameters:nil POSTParameters:parameters constructingBodyWithBlock:nil success:success failure:failure];
}

- (AFHTTPRequestOperation*)request:(NSString *)key
                            method:(NSString *)method
                     GETParameters:(NSDictionary *)GETParameters
                    POSTParameters:(NSDictionary *)POSTParameters
         constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> *data))block
                           success:(void (^)(id))success
                           failure:(void (^)(NSError *))failure
{
    @try {
        NSMutableDictionary *GETP = [NSMutableDictionary dictionaryWithDictionary:GETParameters];
        NSString *websiteString;
//        if ([key  isEqual: @"Verfycode Website"]) {
//             websiteString = self.verfycodeWebsite;
//        } else {
            GETP[@"api_key"] = self.APIKey;
            GETP[@"session_token"] = self.token;
            GETP[@"Content-Type"] = @"application/x-www-form-urlencoded";
            websiteString = [NSString stringWithFormat:@"%@%@", self.website, self.path[key]];
//        }
        NSString *URLString = [self.manager.requestSerializer requestWithMethod:@"GET" URLString:websiteString parameters:[NSDictionary dictionaryWithDictionary:GETP]].URL.absoluteString;
//        NSLog(@"%@",URLString);
        ICNetworkManager __weak *weakSelf = self;
        if ([method  isEqual: @"PUT"]) {
            return [self.manager PUT:URLString parameters:POSTParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [weakSelf handleSuccess:operation data:responseObject success:success failure:failure];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (failure) {
                    failure(error);
                }
            }];
        } else if (POSTParameters.count > 0) {
            return [self.manager POST:URLString
                           parameters:POSTParameters
                              success:^(AFHTTPRequestOperation * operation, NSData *data){
                                  [weakSelf handleSuccess:operation data:data success:success failure:failure];
                              }
                              failure:^(AFHTTPRequestOperation *operation, NSError *error){
                                  if (failure) {
                                      failure(error);
                                  }
                              }];
        } else {
            return [self.manager GET:URLString
                          parameters:nil
                             success:^(AFHTTPRequestOperation * operation, NSData *data){
                                 [weakSelf handleSuccess:operation data:data success:success failure:failure];
                             } failure:^(AFHTTPRequestOperation *operation, NSError *error){
                                 if (failure) {
                                     failure(error);
                                 }
                             }];
        }
    } @catch (NSError *error) {
        failure(error);
        return nil;
    }
}

- (void)cleanCookies {
    [ICNetworkManager defaultManager].token = @"";
}

- (void)handleSuccess:(AFHTTPRequestOperation*)operation
                data:(NSData*)data
             success:(void (^)(NSDictionary *))success
             failure:(void (^)(NSError *))failure {
    NSError *error;
    id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error != nil || object == nil || !([object isKindOfClass:[NSDictionary class]])) {
        NSMutableDictionary *userInfo = [@{
                                           NSLocalizedDescriptionKey: @"Failed to parse JSON.",
                                           NSLocalizedFailureReasonErrorKey: @"The data returned from the server does not meet the JSON syntax.",
                                           NSURLErrorKey: operation.response.URL,
                                           NSUnderlyingErrorKey: operation.error} mutableCopy];
        if (operation.error != nil) {
            userInfo[NSUnderlyingErrorKey] = operation.error;
        }
        error = [NSError errorWithDomain:self.website code:self.internalErrorCode.integerValue userInfo:userInfo];
        NSLog(@"%@\n%@\n%@",operation.response.URL ,error, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        if (failure) {
            failure(error);
        }
        return;
    }
    NSDictionary *datas = object;
    if (datas[@"error"][@"code"] == nil) {
        id info = datas;
//        NSLog(@"\(operation.response.URL!)\n\(info)");
        if (success) {
            success(info);
        }
        return;
    } else {
        NSDictionary *data = datas[@"error"];
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey: data[@"message"],
                                   NSURLErrorKey: operation.response.URL
                                   };
        NSError *error = [NSError errorWithDomain:self.website code:self.internalErrorCode.integerValue userInfo:userInfo];
        NSLog(@"%@", error);
        failure(error);
    }
}


+ (instancetype)defaultManager {
    static dispatch_once_t ID = 0;
    static ICNetworkManager *manager = nil;
    dispatch_once(&ID, ^{
        manager = [[ICNetworkManager alloc] initWithConfiguration:[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist" ]]];
    });
    return manager;
}

- (NSString *)website {
    return self.configuration[@"Website"];
}

- (NSString *)SMSappKey {
    return self.configuration[@"Verfycode API Key"];
}

- (NSString *)SMSappSecret {
    return self.configuration[@"Verfycode App Secret"];
}

- (NSString *)verfycodeWebsite {
    return self.configuration[@"Verfycode Website"];
}

- (NSString *)token {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
}

- (void)setToken:(NSString*)newToken {
    [[NSUserDefaults standardUserDefaults] setObject:newToken forKey:@"token"];
}

- (NSString *)APIKey {
    return self.configuration[@"APIKey"];
}

- (NSDictionary *)path {
    return self.configuration[@"Paths"];
}

@end
