//
//  ICGroup.m
//  iCampus
//
//  Created by Rex Ma on 14-5-25.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import "ICGroup.h"
#import "ICUser.h"

@interface ICGroup ()

@end

@implementation ICGroup

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
+(ICUser *)personalInformation{
    NSString *urlString = [NSString stringWithFormat:@"%@/usergroup.php?userid=%@", ICGroupAPIURLPrefix, ICCurrentUser.ID];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:nil
                                                     error:nil];
    NSDictionary *json = [[NSJSONSerialization JSONObjectWithData:data
                                                          options:kNilOptions
                                                            error:nil] firstObject];
    ICUser *user = [[ICUser alloc] init];
    user.ID = json[@"userid"];
    user.type = json[@"type"];
    user.group = json[@"group"];
    return user;
}

+(NSMutableArray *)personalInformationlist{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/usergroup.php?userid=%@", ICGroupAPIURLPrefix, ICCurrentUser.ID];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:nil
                                                     error:nil];
    NSDictionary *json = [[NSJSONSerialization JSONObjectWithData:data
                                                          options:kNilOptions
                                                            error:nil] firstObject];
    
    ICUser *user = [[ICUser alloc] init];
    user.group = json[@"group"];
    // NSLog(@"%@", user.group);
    NSString *urlString1 = [NSString stringWithFormat:@"%@/groupuser.php?group=%@&grouptype=class", ICGroupAPIURLPrefix, user.group];
    NSString *urlString2 = [urlString1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url1 = [NSURL URLWithString:urlString2];
    NSURLRequest *request1 = [NSURLRequest requestWithURL:url1];
    NSData *data1 = [NSURLConnection sendSynchronousRequest:request1
                                          returningResponse:nil
                                                      error:nil];

    NSMutableArray *json1 = [NSJSONSerialization JSONObjectWithData:data1
                                                           options:kNilOptions
                                                             error:nil];
    
    return json1;
}

//+(NSMutableArray *)personalDetailInformation{
//    NSMutableArray *detailInformation = [ICGroup personalInformationlist];
//    
//    NSMutableArray *person = [[NSMutableArray alloc]init];
//    
//    for(ICUser *user in detailInformation)
//    {
//        NSString *urlString = [NSString stringWithFormat:@"m.bistu.edu.cn/userinfo.php?userid=%@",user.ID];
//        NSURL *url = [NSURL URLWithString:urlString];
//        NSURLRequest *request = [NSURLRequest requestWithURL:url];
//        NSData *data = [NSURLConnection sendSynchronousRequest:request
//                                         returningResponse:nil
//                                                     error:nil];
//        NSDictionary *json = [[NSJSONSerialization JSONObjectWithData:data
//                                                          options:kNilOptions
//                                                            error:nil] firstObject];
//        
//        [person addObject:@{@"userid": json[@"userid"]}];
//        [person addObject:@{@"qq":json[@"qq"]}];
//        [person addObject:@{@"wechat": json[@"wechat"]}];
//        [person addObject:@{@"mobile":json[@"mobile"]}];
//        [person addObject:@{@"email": json[@"email"]}];
//    }
//    
//    return person;
//}


@end
