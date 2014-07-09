//
//  ICUsedGoodImagePoster.m
//  iCampus
//
//  Created by EricLee on 14-6-4.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import "ICUsedGoodImagePoster.h"
#import "ICUsedGoodUpLoadImageview.h"

const CGFloat Grid = 65;
const CGFloat Space = (320 - Grid * 4) / 5;

@interface ICUsedGoodImagePoster () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, ICUsedGoodUploadImageViewDelegate>

@property (nonatomic) NSUInteger delPosition;
@property (nonatomic) NSMutableArray *imageList;
@property (nonatomic, strong) UIButton *additionButton;
- (void)initialize;

@end

@implementation ICUsedGoodImagePoster

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (NSString *)imageURLString{
    NSMutableString *URLString=[[NSMutableString alloc]init];
    for (ICUsedGoodUploadImageView *a in self.imageList) {
        [URLString appendString:a.URL.absoluteString];
        if (self.imageList.lastObject != a) {
            [URLString appendString:@";"];
        }
    }
    return URLString;
}

- (IBAction)chooseImage:(id)sender {
    
    UIActionSheet *sheet;
    
    // 判断是否支持相机
    
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    NSString *title;
    NSString *cancel;
    NSString *button1;
    NSString *button2;
    if ([currentLanguage isEqualToString:@"zh-Hans"]) {
        title =@"选择";
        cancel=@"取消";
        button1=@"拍照";
        button2=@"相册";
    }
    else{
        title =@"choose";
        cancel=@"cancel";
        button1=@"shoot";
        button2=@"album";
    }

    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:cancel destructiveButtonTitle:nil otherButtonTitles:button1, button2, nil];
        
    }
    else {
        
        sheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:cancel destructiveButtonTitle:nil otherButtonTitles: button2, nil];
        
    }
    
    sheet.tag = 255;
    
    [sheet showInView:self];
    
}


- (void)initialize {
    self.imageList=[NSMutableArray array];
    self.additionButton = [[UIButton alloc] initWithFrame:CGRectMake(Space, Space, Grid, Grid)];
    self.additionButton.backgroundColor = [UIColor darkGrayColor];
    [self.additionButton addTarget:self action:@selector(chooseImage:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.additionButton];}


-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        
        NSUInteger sourceType = 0;
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                case 0:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    
                    break;
                    
                case 1:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    
                    break;
                case 2:
                    // 取消
                    return;
            }
        }
        else {
            if (buttonIndex == 0) {
                //相册
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                
                
            } else {
                return;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        
        imagePickerController.allowsEditing = YES;
        
        imagePickerController.sourceType = sourceType;
        
        [self.delegate presentViewController:imagePickerController animated:YES completion:^{
            
        }];
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.delegate dismissViewControllerAnimated:YES completion:^{}];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    // UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *image = info[UIImagePickerControllerEditedImage];
//    NSLog(@"%@",image);
    /* 此处info 有六个值
     * UIImagePickerControllerMediaType; // an NSString UTTypeImage)
     * UIImagePickerControllerOriginalImage;  // a UIImage 原始图片
     * UIImagePickerControllerEditedImage;    // a UIImage 裁剪后图片
     * UIImagePickerControllerCropRect;       // an NSValue (CGRect)
     * UIImagePickerControllerMediaURL;       // an NSURL
     * UIImagePickerControllerReferenceURL    // an NSURL that references an asset in the AssetsLibrary framework
     * UIImagePickerControllerMediaMetadata    // an NSDictionary containing metadata from a captured photo
     */
    // 保存图片至本地，方法见下文
    //    [self saveImage:image withName:@"currentImage.png"];
    
    //    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
    //
    //    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    ICUsedGoodUploadImageView *postImageView = [[ICUsedGoodUploadImageView alloc]initWithFrame:CGRectMake((Space + Grid) * (self.imageList.count) + Space, Space, Grid, Grid)];
    postImageView.delegate = self;
    postImageView.image=image;
    [self addSubview:postImageView];
    [self.imageList addObject:postImageView];
    
    [picker dismissViewControllerAnimated:YES completion:^{
    [postImageView upload];
    if (self.imageList.count>=4) {
        self.additionButton.enabled = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.additionButton.alpha = 0;
        }];
        return;
    }
    NSUInteger additionButtonXOffset = (Space + Grid) * self.imageList.count + Space;
    [UIView animateWithDuration:0.4 animations:^{
        self.additionButton.frame = CGRectMake(additionButtonXOffset, Space, Grid, Grid);
    }];
    self.contentSize = CGSizeMake(additionButtonXOffset + Space + Grid, Grid);
    [self setContentOffset:CGPointMake(additionButtonXOffset + Space + Grid <= self.frame.size.width ? 0 : additionButtonXOffset + Space + Grid - self.frame.size.width, 0) animated:YES];
    self.bouncesZoom = NO;

/*
        NSOperationQueue *operationQueue=[[NSOperationQueue alloc]init];
        [self newImageSelected];
        NSInvocationOperation *op =[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(postImage) object:nil];
        [operationQueue addOperation:op];
 */
    }];
}
- (void)uploadImageViewDidPressDeleteButton:(ICUsedGoodUploadImageView *)uploadImageView{
    self.delPosition = [self.imageList indexOfObject:uploadImageView];
    
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    NSString *title;
    NSString *cancel;
    NSString *message;
    NSString *button1;

    if ([currentLanguage isEqualToString:@"zh-Hans"]) {
        title =@"删除？";
        cancel=@"取消";
        button1=@"确定";
        message=@"确认删除这张图片";
    }
    else{
        title =@"Really delete?";
        cancel=@"cancel";
        button1=@"Yes";
        message=@"Do you really want to delete this photo?";
    }

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Really delete?" message:@"Do you really want to delete this photo?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [alert addButtonWithTitle:@"Yes"];
    [alert show];
    
}

- (void)uploadImageView:(ICUsedGoodUploadImageView *)uploadImageView didUploaded:(BOOL)success {
    if (!success) {
        
        NSArray *languages = [NSLocale preferredLanguages];
        NSString *currentLanguage = [languages objectAtIndex:0];
        NSString *title;
        NSString *cancel;
        NSString *message;
        if ([currentLanguage isEqualToString:@"zh-Hans"]) {
            title =@"错误";
            cancel=@"确定";
            message=@"上传失败";

        }
        else{
            title =@"Error";
            cancel=@"yes";
            message=@"Upload Faild";

        }

        [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Upload Faild" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles: nil]show];
    }
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        ICUsedGoodUploadImageView *delImgView=(self.imageList)[self.delPosition];
        [UIView animateWithDuration:0.3 animations:^{
            delImgView.alpha = 0;
            for (size_t i = self.delPosition + 1; i < self.imageList.count; i++) {
                ICUsedGoodUploadImageView *imageView = self.imageList[i];
                CGRect frame = CGRectMake(imageView.frame.origin.x - Grid - Space, imageView.frame.origin.y, imageView.frame.size.width, imageView.frame.size.height);
                imageView.frame = frame;
            }
            if (self.imageList.count <= 4) {
                self.additionButton.alpha = 1;
                self.additionButton.enabled = YES;
                NSUInteger additionButtonXOffset = (Space + Grid) * (self.imageList.count-1) + Space;
                CGRect originalFrame = self.additionButton.frame;
                self.additionButton.frame = CGRectMake(additionButtonXOffset, originalFrame.origin.y, originalFrame.size.width, originalFrame.size.height);
            } else {
                self.additionButton.alpha = 0;
                self.additionButton.enabled = NO;
            }
        } completion:^(BOOL finished) {
            if (finished) {
                [self.imageList removeObject:delImgView];
                [delImgView removeFromSuperview];
            }
        }];
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
