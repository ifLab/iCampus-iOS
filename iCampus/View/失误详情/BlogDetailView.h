//
//  BlogDetailView.h
//  iCampus
//
//  Created by 徐正科 on 2018/12/15.
//  Copyright © 2018 ifLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BlogModel;
@class CommentModel;

@protocol BlogDetailViewDelegate <NSObject>

- (void) clickWithComment: (CommentModel *)comment;
- (void) longPressWithComment: (CommentModel *)comment;

@end

NS_ASSUME_NONNULL_BEGIN

typedef void(^clickHandler)(CommentModel *comment);
typedef void(^longClickHandler)(CommentModel *comment);

@interface BlogDetailView : UIView

@property (nonatomic ,strong) BlogModel *dataSource;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray<CommentModel *> *comments;

@property (nonatomic,weak)id<BlogDetailViewDelegate> delegate;

//@property (nonatomic, copy)clickHandler clickHandler;
//@property (nonatomic, copy)longClickHandler longClickHandler;


@end

NS_ASSUME_NONNULL_END
