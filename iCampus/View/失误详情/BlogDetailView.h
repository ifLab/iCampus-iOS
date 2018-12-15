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

NS_ASSUME_NONNULL_BEGIN

@interface BlogDetailView : UIView

@property (nonatomic ,strong) BlogModel *dataSource;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray<CommentModel *> *comments;

@end

NS_ASSUME_NONNULL_END
