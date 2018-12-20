//
//  ICNews.m
//  iCampus-iOS-API
//
//  Created by Darren Liu on 13-11-4.
//  Copyright (c) 2013年 Darren Liu. All rights reserved.
//

#import "ICNews.h"
#import "ICNetworkManager.h"

@implementation ICNews

+(void)fetchNews:(ICNewsChannel *)channel
            page:(NSInteger)page
         success:(void(^)(NSArray*))success
         failure:(void(^)(NSString*))failure {
    
    NSString *chnlurl = channel.chnlurl;
        
    if (!channel) {
        failure(@"当前栏目信息获取失败");
    }
    
    NSString *url = [NSString stringWithFormat:@"http://job.xuzhengke.cn/ibistu.php?url=http://newsfeed.bistu.edu.cn/ibistu/%@/list%@.json", chnlurl, (page == 0 ? @"" : [NSString stringWithFormat:@"_%ld",(long)page])];
    
    [[ICNetworkManager defaultManager] GET:url
                                parameters:nil
                                   success:^(NSDictionary *dic) {
                                       NSMutableArray<ICNews *> *array = [NSMutableArray new];
                                       
                                       if ([dic[kMsgCode] integerValue] == 2) {
                                           for(NSDictionary *c in dic[kMsg][@"doclist"]){
                                               ICNews *news = [ICNews mj_objectWithKeyValues:c];
                                               [array addObject:news];
                                           }
                                           
                                           success([array copy]);
                                       }else{
                                           failure(@"请求失败");
                                       }
//                                       NSArray *data = dic[@"resource"];
//                                       NSMutableArray *array = [[NSMutableArray alloc] init];
//                                       for (NSDictionary *element in data) {
//                                           ICNews *news = [[ICNews alloc] init];
//                                           news.title = element[@"newsTitle"];
//                                           news.date = element[@"newsTime"];
//                                           news.detailKey = element[@"newsLink"];
//                                           news.imageURL = element[@"newsImage"];
//                                           news.preview = element[@"newsIntro"];
//                                           [array addObject:news];
//                                       }
//                                       success(array);
                                   }
                                   failure:^(NSError *error) {
                                       failure(error.userInfo[NSLocalizedFailureReasonErrorKey]);
                                   }];
}
@end
