//
//  ICSchoolDetailViewController.m
//  iCampus
//
//  Created by Darren Liu on 13-12-22.
//  Copyright (c) 2013年 BISTU. All rights reserved.
//

#import "ICSchoolDetailViewController.h"
#import "../../Model/School/ICSchool.h"
#import "../../View/School/ICSchoolDetailView.h"

@interface ICSchoolDetailViewController ()

@property (nonatomic, strong) ICSchoolDetail *schoolDetail;

@end

@implementation ICSchoolDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.school.name;
    [self.view addSubview:[[ICSchoolDetailView alloc] initWithSchool:self.school
                                                               frame:self.view.frame]];
}

@end
