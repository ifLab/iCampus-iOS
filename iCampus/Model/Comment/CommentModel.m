
//
//  CommentModel.m
//  iCampus
//
//  Created by 徐正科 on 2018/12/15.
//  Copyright © 2018 ifLab. All rights reserved.
//

#import "CommentModel.h"
#import "ICNetworkManager.h"

@implementation CommentModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"masuser": @"MasUser",
             @"child_comments": @"CommentModel",
             @"reply_to_masuser": @"ReplyUser"
             };
}

+ (void)getCommentsWithBlogID:(NSInteger)blog_id page:(NSInteger)page success:(void (^)(NSArray<CommentModel *> * _Nonnull))success failure:(void (^)(NSString * _Nonnull))failure {
    [[ICNetworkManager defaultManager] POST:@"Comment" GETParameters:nil POSTParameters:@{@"blog_id": @(blog_id), @"page": @(page)} success:^(NSDictionary *dic) {
        if([dic[kMsgCode] intValue] == ICNetworkResponseCodeSuccess) {
            NSMutableArray<CommentModel *> *comments = [@[] mutableCopy];
            for(NSDictionary *data in dic[kMsg][@"comments"]){
                CommentModel *comment = [CommentModel mj_objectWithKeyValues:data];
                [comments addObject:comment];
            }
            
            success([comments copy]);
        }else{
            failure(@"评论请求失败");
        }
    } failure:^(NSError *err) {
        failure(@"评论请求失败");
    }];
}

+ (void)commentWithContentType:(NSString *)contentType contentID:(NSInteger)contentID content:(NSString *)content parentID:(NSInteger)parentID success:(nonnull void (^)(NSString * _Nonnull))success failure:(nonnull void (^)(NSString * _Nonnull))failure {
    NSMutableDictionary *params = [@{
                             @"content_type": contentType,
                             @"content_id": @(contentID),
                             @"content": content,
                             } mutableCopy];
    if(parentID != 0){
        params[@"parent_id"] = @(parentID);
    }
        
    [[ICNetworkManager defaultManager] POST:@"CreateComment" GETParameters:nil POSTParameters: [params copy] success:^(NSDictionary *dic) {
        if([dic[kMsgCode] integerValue] == ICNetworkResponseCodeSuccess) {
            success(@"评论成功");
        } else {
            failure(@"评论失败，请重试");
        }
    } failure:^(NSError *err) {
        failure(@"评论失败，网络不稳定");
    }];
}

@end
