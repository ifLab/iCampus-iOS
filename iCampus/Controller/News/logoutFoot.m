

#import "logoutFoot.h"

@implementation logoutFoot

-(void)awakeFromNib{
    [super awakeFromNib];
    [self initUI];
}
/*
 * 初始化UI
 */
-(void)initUI{
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 69);
    _logoutBtn.layer.cornerRadius = 10;
    _logoutBtn.layer.masksToBounds = true;
}


@end
