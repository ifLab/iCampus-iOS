

#import <Foundation/Foundation.h>

@interface PJUser : NSObject
/**
 *  当前用户
 *
 */
+ (PJUser *)currentUser;
+ (PJUser *)defaultManager;

/***************用户属性*****************/

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *first_name;//中文姓名
@property (nonatomic, strong) NSString *last_name;//==@"@"代表已通过CAS认证
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *last_login_date;

/**
 *  保存用户信息
 */
-(void)save;
/**
 *  删除当前用户
 */
+(void)logOut;
@end
