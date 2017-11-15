//
//  ZKNewsDetailShareView.m
//  iCampus
//
//  Created by 徐正科 on 2017/11/4.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "ZKNewsDetailShareView.h"

@interface ZKNewsDetailShareView ()

@end

@implementation ZKNewsDetailShareView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect viewFrame = self.view.frame;
    viewFrame.size.height += self.imageSize.height;
    self.view.frame = viewFrame;
    
    self.titleLabel.text = self.newsTitle;
    self.bodyImage.image = self.image;
    CGPoint bodyPoint = self.bodyImage.center;
    bodyPoint.x = [UIScreen mainScreen].bounds.size.width * 0.5;
    
//    self.tableView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.tableView.contentSize.height);
//    CGRect frame = self.bodyView.frame;
//    frame.size.height = self.tableView.frame.size.height;
//    self.bodyView.frame = frame;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
