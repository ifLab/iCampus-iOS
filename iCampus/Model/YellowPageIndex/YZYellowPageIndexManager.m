//
//  YZYellowPageIndexManager.m
//  iCampus
//
//  Created by Q YiZhong on 2018/1/26.
//  Copyright © 2018年 ifLab. All rights reserved.
//

#import "YZYellowPageIndexManager.h"
#import "ChineseString.h"
#import "pinyin.h"

@implementation YZYellowPageIndexManager

+ (NSMutableArray*)indexArrayWithDataArray:(NSArray*)dataArray{
    NSMutableArray *data = [[NSMutableArray alloc]initWithArray:dataArray];
    NSMutableArray *chineseStringsArray = [[NSMutableArray alloc]init];
    for (int i=0; i<data.count; i++) {
        NSDictionary *dataDict = data[i];
        ChineseString *chineseString = [[ChineseString alloc]init];
        chineseString.string = [dataDict objectForKey:@"name"];
        
        if (chineseString.string == nil) {
            chineseString.string = @"";
        }
        
        if(![chineseString.string isEqualToString:@""]){
            NSString *pinYinResult=[NSString string];
            
            for(int j=0;j<chineseString.string.length;j++){
                
                NSString *singlePinyinLetter=[[NSString stringWithFormat:@"%c",pinyinFirstLetter([chineseString.string characterAtIndex:j])]uppercaseString];
                
                pinYinResult=[pinYinResult stringByAppendingString:singlePinyinLetter];
                
            }
            chineseString.pinYin=pinYinResult;
        }else{
            chineseString.pinYin=@"";
        }
        [chineseStringsArray addObject:chineseString];
    }
    
    NSArray *letters = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#"];
    NSMutableArray *indexData = [[NSMutableArray alloc]init];
    for (int i = 0; i < 27; i++) {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        [indexData addObject:array];
    }
    
    for (int i = 0; i < chineseStringsArray.count; i++) {
        
        ChineseString *cString = chineseStringsArray[i];
        
        for (int j = 0; j < letters.count; j++) {
            
            if ([[cString.pinYin substringToIndex:1] isEqualToString:letters[j]]) {
                
                [indexData[j] insertObject:cString atIndex:0];
            }
        }
    }
    
    return indexData;
}


@end
