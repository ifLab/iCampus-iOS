

//
//  BlogDetailView.m
//  iCampus
//
//  Created by 徐正科 on 2018/12/15.
//  Copyright © 2018 ifLab. All rights reserved.
//

#import "BlogDetailView.h"
#import "BlogModel.h"
#import "UserModel.h"
#import "CommentModel.h"

static NSString * const kCellID = @"commentCell";

@interface BlogDetailView()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray<CommentModel *> *_comments;
}

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, assign) CGFloat headerViewHeight;

@end

@implementation BlogDetailView

- (instancetype)init {
    if(self = [super init]){
        self.frame = UIScreen.mainScreen.bounds;
        
        [self initView];
    }
    
    return self;
}

- (void)initView {
    self.tableView = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStyleGrouped];
    _tableView.backgroundColor = UIColor.whiteColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];
}

- (void)setDataSource:(BlogModel *)dataSource {
    _dataSource = dataSource;
    
    self.nameLabel.text = dataSource.masuser.nick_name;
    
    self.contentLabel.text = dataSource.content;
    [_contentLabel sizeToFit];
    
    CGRect textFrame = self.contentLabel.frame;
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:_contentLabel.font,NSFontAttributeName, nil];
    textFrame.size.height = [_contentLabel.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-8, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size.height;
    
    _contentLabel.frame = CGRectMake(15, self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height + 20, SCREEN_WIDTH-30, textFrame.size.height);

    self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _contentLabel.frame.origin.y + _contentLabel.frame.size.height + 10);
    
    self.headerViewHeight = self.headerView.frame.size.height;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH, 10)];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont boldSystemFontOfSize:18];
        _nameLabel.numberOfLines = 0;
    }
    
    return _nameLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _contentLabel.font = [UIFont systemFontOfSize:15.0f];
        _contentLabel.numberOfLines = 0;
    }
    
    return _contentLabel;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        [_headerView addSubview:self.nameLabel];
        [_headerView addSubview:self.contentLabel];
    }
    
    return _headerView;
}

- (NSMutableArray<CommentModel *> *)comments {
    if(!_comments){
        _comments = [@[] mutableCopy];
    }
    
    return _comments;
}

- (void)setComments:(NSMutableArray<CommentModel *> *)comments {
    _comments = comments;
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 0;
    }else{
        return self.comments.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellID];
    }
    
    CommentModel *comment = (CommentModel *)self.comments[indexPath.row];
    cell.textLabel.text = comment.masuser.nick_name;
    cell.detailTextLabel.text = comment.comment_content;
    cell.detailTextLabel.numberOfLines = 0;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return self.headerView;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return _headerViewHeight;
    }else{
        return 10;
    }
}

@end
