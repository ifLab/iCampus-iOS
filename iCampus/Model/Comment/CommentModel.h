//
//  CommentModel.h
//  iCampus
//
//  Created by 徐正科 on 2018/12/15.
//  Copyright © 2018 ifLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MasUser;

NS_ASSUME_NONNULL_BEGIN


static NSString* const kCommentTypeBlog = @"blog";
static NSString* const kCommentTypeComment = @"comment";


@interface CommentModel : NSObject

@property(nonatomic, assign)NSInteger comment_id;
@property(nonatomic, copy)NSString *comment_content;
@property(nonatomic, copy)NSString *comment_created_time;
@property(nonatomic, strong)MasUser *masuser;
@property(nonatomic, strong)NSMutableArray<CommentModel *> *child_comments;

+ (void)getCommentsWithBlogID:(NSInteger)blog_id page:(NSInteger)page success:(void(^)(NSArray<CommentModel *> *data))success failure:(void(^)(NSString *error))failure;

+ (void)commentWithContentType:(NSString *)contentType contentID:(NSInteger)contentID content:(NSString *)content parentID:(NSInteger)parentID success:(void(^)(NSString  *msg))success failure:(void(^)(NSString *err))failure;

@end

@interface ReplyUser : NSObject

@property(nonatomic, copy)NSString *nick_name;

@end

NS_ASSUME_NONNULL_END
