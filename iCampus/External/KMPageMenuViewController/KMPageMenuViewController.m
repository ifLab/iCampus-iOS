//
//  KMPageMenuViewController.m
//  KMPageMenuViewControllerDemo
//
//  Created by Kwei Ma on 14-8-27.
//  Copyright (c) 2014年 KWEIMA. All rights reserved.
//

#import "KMPageMenuViewController.h"

#pragma mark - KMPageMenuItem Implementation

@interface KMPageMenuItem () {
    @public
    int _page;
    int _position;
}

@property (strong, nonatomic) UILabel *itemTitleLabel;

@end

@implementation KMPageMenuItem

- (id)initWithIcon:(UIImage *)icon title:(NSString *)title
{
    if (self = [super init]) {
        self.icon = icon;
        self.title = title;
        //[self setImage:[UIImage imageNamed:@"DemoIconHighlighted"] forState:UIControlStateHighlighted];
    }
    return self;
}

- (void)setIcon:(UIImage *)icon
{
    _icon = icon;
    [self setImage:icon forState:UIControlStateNormal];
}

- (UILabel *)itemTitleLabel
{
    if (!_itemTitleLabel) {
        _itemTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(-10.0f, 60.0f, 80.0f, 20.0f)];
        _itemTitleLabel.font = [UIFont systemFontOfSize:12.0f];
        _itemTitleLabel.textAlignment = NSTextAlignmentCenter;
        _itemTitleLabel.textColor = [UIColor colorWithWhite:0.4f alpha:1.0f];
        [self addSubview:_itemTitleLabel];
    }
    return _itemTitleLabel;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.itemTitleLabel.text = title;;
}

@end

#pragma mark - KMPageMenuViewController Category

@interface KMPageMenuViewController () {
    @public
    float _itemWidth;
    float _itemHeight;
    float _paddingInItems;
    float _paddingInRows;
}

@property (strong, nonatomic) UIScrollView *scrollView;

@end

#pragma mark - KMPageMenuViewController Implementation

@implementation KMPageMenuViewController

- (id)initWithPageCount:(int)numberOfPages itemsPerRow:(int)itemsPerRow
{
    if (self = [super init]) {
        _numberOfPages = numberOfPages;
        _itemsPerRow = itemsPerRow;
    }
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    _paddingInItems = screenSize.width / (_itemsPerRow + 1);
    
    
    return self;
}

- (void)awakeFromNib
{
    _numberOfPages = [_dataSource numberOfPagesInPageMenuViewController:self];
    _itemsPerRow = [_dataSource pageMenuViewController:self numberOfItemsInPage:0];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    _paddingInItems = screenSize.width / (_itemsPerRow + 1);
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        CGRect frame = self.view.bounds;
        _scrollView = [[UIScrollView alloc] initWithFrame:frame];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

- (void)arrangesItemInScrollView
{
    for (int page = 0; page < _numberOfPages; page++) {
        for (int position = 0; position < _itemsPerPage; position++) {
            KMPageMenuItem *item = [_dataSource pageMenuViewController:self itemAtPage:page position:position];
            item->_page = page;
            item->_position = position;
            
            float xAxis = (position%_itemsPerRow + 1) * _paddingInItems + _itemWidth * (position%_itemsPerRow);
            float yAxis = (position/_itemsPerRow + 1) * _paddingInRows + _itemHeight * (position/_itemsPerRow);
            
            item.frame = CGRectMake(xAxis, yAxis, _itemWidth, _itemWidth);
            
            [item addTarget:self action:@selector(handleIconSelection:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollView addSubview:item];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view = self.scrollView;
    
    _numberOfPages = [_dataSource numberOfPagesInPageMenuViewController:self];
    for (int i = 0; i < _numberOfPages; i++) {
        _itemsPerPage = [_dataSource pageMenuViewController:self numberOfItemsInPage:i];
    }
    _itemsPerRow = 3;
    
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    
    _itemWidth = 60.0f;
    _itemHeight = _itemWidth;
    
    _paddingInItems = (viewSize.width - _itemsPerRow * _itemWidth) / (_itemsPerRow + 1);
    _paddingInRows = _paddingInItems;
    
    // arrange item only one time
    [self arrangesItemInScrollView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleIconSelection:(KMPageMenuItem *)sender
{
    [_delegate pageMenuViewController:self didSelectItemAtPage:sender->_page position:sender->_position];
}

@end
