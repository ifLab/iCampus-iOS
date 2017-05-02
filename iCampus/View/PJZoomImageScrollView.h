
#import <UIKit/UIKit.h>

@protocol PJZoomImageScrollViewDelegate <NSObject>

-(void)addZoomImage;

@end

@interface PJZoomImageScrollView : UIScrollView

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, weak) id<PJZoomImageScrollViewDelegate>myDelegate;


-(void)reloadData;


@end
