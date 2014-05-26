//
//  ICJobFavoritesJobTableViewController.m
//  iCampus
//
//  Created by Jerry Black on 14-5-25.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import "ICJobFavoritesJobTableViewController.h"

@interface ICJobFavoritesJobTableViewController ()

@end

@implementation ICJobFavoritesJobTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

@end
