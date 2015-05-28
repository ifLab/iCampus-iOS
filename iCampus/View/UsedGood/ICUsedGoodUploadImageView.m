//
//  ICUsedGoodUploadImageView.m
//  iCampus
//
//  Created by EricLee on 14-6-4.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import "ICUsedGoodUploadImageView.h"
#import "AFNetworking.h"

@interface ICUsedGoodUploadImageView()

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIButton *deleteButton;

@end

@implementation ICUsedGoodUploadImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect fullFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.userInteractionEnabled = YES;
        self.indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:fullFrame];
        self.indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        self.maskView = [[UIView alloc] initWithFrame:fullFrame];
        self.maskView.backgroundColor = [UIColor blackColor];
        self.maskView.alpha = 0.5;
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.deleteButton.backgroundColor = [UIColor clearColor];
        self.deleteButton.frame = fullFrame;
        self.deleteButton.alpha = 1;
        [self.deleteButton addTarget:self
                              action:@selector(didPressDeleteButton:)
                    forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.maskView];
        [self addSubview:self.indicatorView];
        [self addSubview:self.deleteButton];
        [self.indicatorView startAnimating];
    }
    return self;
}

- (void)upload {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSData *imageData = UIImageJPEGRepresentation(self.image, 0.5);
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"%@/upload.php", ICUsedGoodAPIURLPrefix]
       parameters:nil constructingBodyWithBlock:
     ^(id<AFMultipartFormData> formData) {
         [formData appendPartWithFileData:imageData
                                     name:@"imgFile"
                                 fileName:@"photo.jpg"
                                 mimeType:@"image/jpeg"];
     } success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:nil];
         self.URL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",
                                                   json[@"url"]]];
         [UIView animateWithDuration:0.5
                          animations:^{
                              self.indicatorView.alpha = 0;
                              self.maskView.alpha = 0;
                          } completion:^(BOOL finished) {
                              if (self.delegate && [self.delegate conformsToProtocol:@protocol(ICUsedGoodUploadImageViewDelegate)]) {
                                  [self.delegate uploadImageView:self
                                                     didUploaded:YES];
                              }
                          }];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         self.indicatorView.alpha = 0;
         self.maskView.alpha = 0;
         if (self.delegate && [self.delegate conformsToProtocol:@protocol(ICUsedGoodUploadImageViewDelegate)]) {
             [self.delegate uploadImageView:self
                                didUploaded:NO];
         }
         self.deleteButton.backgroundColor=[UIColor redColor];
         self.deleteButton.alpha=0.3;
     }];
}

- (IBAction)didPressDeleteButton:(UIButton *)button {
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(ICUsedGoodUploadImageViewDelegate)]) {
        [self.delegate uploadImageViewDidPressDeleteButton:self];
    }
}

@end
