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

- (IBAction)dismiss:(id)sender;

@end

@implementation ICAboutViewController

- (void)        tableView:(UITableView *)tableView
  didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIViewController *detailViewController = [[UIViewController alloc] init];
    detailViewController.title = cell.textLabel.text;
    detailViewController.view.backgroundColor = [UIColor groupTableViewBackgroundColor]; // Necessary!
    UIWebView *webView = [[UIWebView alloc] initWithFrame:detailViewController.view.frame];
    [detailViewController.view addSubview:webView];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        ICAboutWebpage *aboutPage;
        if (cell == self.introductionCell) {
            aboutPage = [ICAboutWebpage introductionPage];
        } else if (cell == self.historyCell) {
            aboutPage = [ICAboutWebpage historyPage];
        } else if (cell == self.collegeCell) {
            aboutPage = [ICAboutWebpage collegePage];
        } else if (cell == self.ifLabCell) {
            aboutPage = [ICAboutWebpage ifLabPage];
        } else if (cell == self.creditsCell) {
            aboutPage = [ICAboutWebpage creditsPage];
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
