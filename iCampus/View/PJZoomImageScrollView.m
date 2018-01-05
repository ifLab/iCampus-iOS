
#import "PJZoomImageScrollView.h"
#import "ICNetworkManager.h"

@implementation PJZoomImageScrollView

-(void)awakeFromNib {
    [super awakeFromNib];
    [self initUI];
}

- (void)initUI {
    _dataSource = [@[] mutableCopy];
    self.showsVerticalScrollIndicator = false;
    self.showsHorizontalScrollIndicator = false;
    [self reloadData];
}
- (void)reloadData {
    for (UIView *view in self.subviews) {
        [view  removeFromSuperview];
    }
    CGFloat X = 0;
    int i = 0;
    for (id image in _dataSource) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(X, 10, 70, 70)];
        if ([image isKindOfClass:[UIImage class]]) {
            imageView.image = image;
        }else{
            NSString *website = [NSString stringWithFormat:@"%@%@?api_key=%@&session_token=%@", [ICNetworkManager defaultManager].website, image, [ICNetworkManager defaultManager].APIKey, [ICNetworkManager defaultManager].token];
            [imageView sd_setImageWithURL:[NSURL URLWithString:website] placeholderImage:[UIImage imageNamed:@"nopic"]];
        }
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = true;
        [self addSubview:imageView];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(X+63, 5, 15, 15)];
        [btn setImage:[UIImage imageNamed:@"del"] forState:0];
        [btn addTarget:self action:@selector(delImage:) forControlEvents:1<<6];
        [self addSubview:btn];
        btn.tag = i;
        X+=80;
        i++;
    }
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(X, 10, 70, 70)];
    imageView.image = [UIImage imageNamed:@"addpic"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = true;
    [self addSubview:imageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addZoomImage)];
    imageView.userInteractionEnabled = true;
    [imageView addGestureRecognizer:tap];
    X+=80;
    [self setContentSize:CGSizeMake(X, 70)];
}

-(void)addZoomImage {
    [_myDelegate addZoomImage];
}

-(void)delImage:(UIButton *)btn {
    [_dataSource removeObjectAtIndex:btn.tag];
    [self reloadData];
}

@end
