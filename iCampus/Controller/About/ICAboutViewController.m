//
//  ICAboutViewController.m
//  iCampus
//
//  Created by Darren Liu on 14-3-29.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import "ICAboutViewController.h"
#import "../../Model/About/ICAboutWebpage.h"

@interface ICAboutViewController ()

@property (weak, nonatomic) IBOutlet UITableViewCell *introductionCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *historyCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *collegeCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *ifLabCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *creditsCell;
@property (weak, nonatomic) NSArray *pages;

- (IBAction)dismiss:(id)sender;

@end

@implementation ICAboutViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    ICAboutViewController __weak *weakSelf = self;
    [ICAboutWebpage fetchPageWithSuccess:^(NSArray *pages) {
        weakSelf.pages = [NSArray arrayWithArray:pages];
    } failure:nil];
}

- (void)        tableView:(UITableView *)tableView
  didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIViewController *detailViewController = [[UIViewController alloc] init];
    detailViewController.title = cell.textLabel.text;
    detailViewController.view.backgroundColor = [UIColor groupTableViewBackgroundColor]; // Necessary!
    UIWebView *webView = [[UIWebView alloc] initWithFrame: CGRectMake(0, 0, detailViewController.view.bounds.size.width, detailViewController.view.bounds.size.height - 64)];
    [detailViewController.view addSubview:webView];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        ICAboutWebpage *aboutPage;
        if (cell == self.introductionCell) {
            aboutPage = self.pages[0];
        } else if (cell == self.historyCell) {
            aboutPage = self.pages[1];
        } else if (cell == self.collegeCell) {
            aboutPage = self.pages[2];
        } else if (cell == self.ifLabCell) {
            aboutPage = self.pages[3];
        } else if (cell == self.creditsCell) {
            aboutPage = self.pages[4];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [webView loadHTMLString:aboutPage.content baseURL:nil];
        });
    });
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
