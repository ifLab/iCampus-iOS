//
//  ICAboutViewController.m
//  iCampus
//
//  Created by 刘鸿喆 on 14-3-29.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import "ICAboutViewController.h"

@interface ICAboutViewController ()

@property (weak, nonatomic) IBOutlet UITableViewCell *introductionCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *historyCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *disciplinesCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *ifLabCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *creditsCell;

@end

@implementation ICAboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)        tableView:(UITableView *)tableView
  didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIViewController *detailViewController = [[UIViewController alloc] init];
    detailViewController.title = cell.textLabel.text;
    detailViewController.view.backgroundColor = [UIColor groupTableViewBackgroundColor]; // Necessary!
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:detailViewController.view.frame];
    [detailViewController.view addSubview:scrollView];
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10,
                                                                   scrollView.frame.size.width - 20,
                                                                   scrollView.frame.size.height - 20)];
    textLabel.font          = [UIFont systemFontOfSize:16.0];
    textLabel.textColor     = [UIColor darkGrayColor];
    textLabel.numberOfLines = 0;
    textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [scrollView addSubview:textLabel];
    if (cell == self.introductionCell) {
        textLabel.text = @"　　北京信息科技大学是由原北京机械工业学院和原北京信息工程学院合并组建，以工管为主体、工管理经文法多学科协调发展，以培养高素质应用型人才为主、北京市重点支持建设的全日制普通高等学校。\n　　学校秉承“勤以为学，信以立身”的校训，发扬“抢抓机遇、迎难而上、争先创优、挑战自我”的新大学精神，坚持办学指导思想，明确发展目标和办学定位，传承办学优势与特色，紧紧依靠广大师生员工，抓建设、促改革、谋发展，内涵建设与外延发展等各项事业取得显著成效。\n　　面向未来，学校正以坚定步伐朝着“在电子信息、现代制造与光机电一体化、知识管理与技术经济等领域的优势与特色更加突出，综合办学实力稳居北京市属高校前列，并早日达到国内同类高校的一流水平”的奋斗目标迈进。";
    } else if (cell == self.historyCell) {
        textLabel.text = @"　　原北京机械工业学院的前身是1986年陕西机械学院北京研究生部和北京机械工业管理专科学校合并成立的北京机械工业管理学院，其办学历史可追溯到20世纪30年代。\n　　原北京信息工程学院的前身是1978年第四机械工业部1915所举办北京大学第二分校。\n　　2003年8月21日，北京市委、市政府决定组建北京信息科技大学。\n　　2004年5月18日，教育部批准筹建北京信息科技大学。\n　　2008年3月26日，教育部批准正式设立北京信息科技大学。";
    } else if (cell == self.disciplinesCell) {
        textLabel.text = @"　　学校坚持优化体系、整合资源、凝练方向、寻求突破，以经济社会发展需要和学科发展前沿为导向，着眼于首都和行业需求，立足学校定位与发展目标，不断加强学科建设，初步形成了可持续发展的学科体系。学校坚持发挥优势、打造特色、科学规划、加强建设，主动适应社会需求，优化学科结构布局，努力建设重点学科、科研基地和特色专业。\n　　北京市重点学科 3个\n　　北京市重点建设学科 9个\n　　部级重点学科 2个\n　　教育部重点实验室 1个\n　　北京市重点实验室 3个\n　　北京市哲学社会科学研究基地 1个\n　　北京高校工程技术研究中心 1个\n　　机械工业重点实验室 2个\n　　硕士学位授权一级学科 14个\n　　硕士学位授权二级学科 22个\n　　专业学位门类（工程硕士、MBA） 2个\n　　工程硕士专业学位授权领域 8个\n　　本科专业 31个\n　　国家级特色专业建设点 4个\n　　北京市级特色专业建设点 9个\n　　在京第一批招生专业 10个";
    } else if (cell == self.ifLabCell) {
        textLabel.text = @"　　ifLab全称北京信息科技大学网络实践创新联盟，简称“创联”，是由学校信息网络中心组织和管理的技术社团。\n　　i代表internet（互联网），innovation（创新）；f代表future（未来），fulfill（实践）。\n　　我们的使命是学习和研究前沿互联网技术，建设和开发有助于学校教育信息化的项目；通过这些项目提高成员的IT水平，培养一批有专业造诣和项目实践经验的人才。\n　　我们的目标是成为校内最大最强的技术社团；在信息网络中心指导下协助建设学校信息化创新项目；帮助校内社团、组织及师生提高前沿IT技能；每年培养10个以上相当于1年专业工作经验的IT人才。\n　　我们欢迎校内的社团组织、学术机构与我们联盟合作。我们可以提供必要的技术协助，或者帮其他社团培养需要的技术人才。\n　　目前我们主要学习研究的领域为移动互联网以及云计算。\n　　你可以通过访问http://www.iflab.org或者关注新浪微博ifLab来了解我们。";
    } else if (cell == self.creditsCell) {
        textLabel.text = @"项目负责人 曾铮\n系统设计 曾铮 郑小博\n美工设计 马奎 肖晨曦\nAPI 顾翔\n管理后台 黄伟\niOS 马奎 刘鸿喆\nAndroid 李占宇 王鹏 黄伟 李轶男 刘相宇\nPhoneGap 熊伦\nWebApp 曾铮";
    }
    [textLabel sizeToFit];
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, textLabel.frame.size.height + 20);
    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
