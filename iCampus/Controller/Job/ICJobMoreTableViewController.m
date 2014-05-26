//
//  ICJobMoreTableViewController.m
//  iCampus
//
//  Created by Jerry Black on 14-4-13.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import "ICJobMoreTableViewController.h"

@interface ICJobMoreTableViewController ()

- (IBAction)cancel:(id)sender;

@end

@implementation ICJobMoreTableViewController

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
    return 2;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    if ([segue.identifier isEqualToString: @"IC_JOB_MORE_TO_MINE"]) {
        // 跳转到我的发布
        ICJobMyJobTableViewController *controller = (ICJobMyJobTableViewController*) segue.destinationViewController;
        controller.delegate = self;
    } else if ([segue.identifier isEqualToString:nil]) { }
}

- (void)tellICJobListTableViewControllerNeedReloadData {
    [self.delegate needReloadData];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
