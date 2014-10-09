//
//  ChoosePictureViewController.m
//  IMyPhotos
//
//  Created by Dracuuula on 14-7-14.
//  Copyright (c) 2014年 D. All rights reserved.
//

#import "ChoosePictureViewController.h"
#import "MainViewController2.h"

@interface ChoosePictureViewController ()
{
    UIImagePickerController *imagePicker;
}
@property (strong, nonatomic) IBOutlet UIView *subView;

@end

@implementation ChoosePictureViewController

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
    
    imagePicker = [[UIImagePickerController alloc] init];
    
    NSInteger height = 0;
    
    if (iPhone5) {
        height = 568;
    }else{
        height = 480;
    }
    
    [self.view setFrame:CGRectMake(0, 0, 320, height)];
    [self.subView setFrame:CGRectMake(0, (height-self.subView.frame.size.height)/2, self.subView.frame.size.width, self.subView.frame.size.height)];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonOpenAlbumAction:(id)sender {
    //UIImagePickerControllerSourceTypeSavedPhotosAlbum
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    //设置选择后的图片可被编辑
    imagePicker.allowsEditing = NO;
    //    [self presentModalViewController:picker animated:YES];
    [self presentViewController:imagePicker animated:YES completion:^{
        
    }];
}

- (IBAction)buttonActionCamera:(id)sender {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"您的设备不支持照相机模式" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = self;
    //设置选择后的图片可被编辑
    imagePicker.allowsEditing = NO;
    //    [self presentModalViewController:picker animated:YES];
    [self presentViewController:imagePicker animated:YES completion:^{
        
    }];
}

#pragma mark - imagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    if(picker.sourceType== UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum([info objectForKey:UIImagePickerControllerOriginalImage], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
        [picker dismissViewControllerAnimated:YES completion:^{
            MainViewController2 * mainVC = [[MainViewController2 alloc] init];
            mainVC.chooseImage = [info objectForKey:UIImagePickerControllerOriginalImage];
            [self.navigationController pushViewController:mainVC animated:YES];
        }];
        
    }else{
        
        //通过UIImagePickerControllerMediaType判断返回的是照片还是视频
        NSString* type = [info objectForKey:UIImagePickerControllerMediaType];
        
        //如果返回的type等于kUTTypeImage，代表返回的是照片,并且需要判断当前相机使用的sourcetype是拍照还是相册
        //    if ([type isEqualToString:(NSString*)kUTTypeImage]&&picker.sourceType==UIImagePickerControllerSourceTypeCamera) {
        if ([type isEqualToString:@"public.image"]) {
            
            NSLog(@"info %@", info);
            
            //获取照片的原图
            //        UIImage * original = [info objectForKey:UIImagePickerControllerOriginalImage];
            //获取图片裁剪的图
            //        UIImage* edit = [info objectForKey:UIImagePickerControllerEditedImage];
            //获取图片裁剪后，剩下的图
            //        UIImage* crop = [info objectForKey:UIImagePickerControllerCropRect];
            //获取图片的url
            //        NSURL * url = [info objectForKey:UIImagePickerControllerReferenceURL];
            //        NSString * imageStr = [NSString stringWithFormat:@"%@",[info objectForKey:UIImagePickerControllerOriginalImage]];
            //        NSString * imageType = [info objectForKey:UIImagePickerControllerMediaType];
            //
            //        NSString * urlStr = [NSString stringWithFormat:@"%@", url];

            
            
            //        [self.subBGImageView setImage:chooseImage];
            //        CGRect frame;
            //        if ((tempImageView.frame.size.width/tempImageView.frame.size.height)>(chooseImage.size.width/chooseImage.size.height)) {
            //            CGFloat width = tempImageView.frame.size.height * (chooseImage.size.width/chooseImage.size.height);
            //            CGFloat height = tempImageView.frame.size.height;
            //
            //            frame = tempImageView.frame;
            //            [tempImageView setFrame:CGRectMake((320-width)/2, frame.origin.y, width, height)];
            //        }else{
            //            CGFloat width = tempImageView.frame.size.width;
            //            CGFloat height = tempImageView.frame.size.width/(chooseImage.size.width/chooseImage.size.height);
            //
            //            frame = tempImageView.frame;
            //            [tempImageView setFrame:CGRectMake(frame.origin.x, frame.origin.y+((tempImageView.frame.size.height-height)/2), width, height)];
            //        }
            //        [gpuImageView setFrame:tempImageView.frame];
            //
            //        UIGraphicsBeginImageContext(frame.size);
            //        CGContextRef context = UIGraphicsGetCurrentContext();
            //        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
            //        UIRectFill(CGRectMake(0, 0, frame.size.width, frame.size.height));//clear background
            //        [chooseImage drawInRect:CGRectMake(0, 0, frame.size.width, frame.size.height)];
            //        UIImage * thumbnalImage = UIGraphicsGetImageFromCurrentImageContext();
            //        UIGraphicsEndImageContext();
            //        [tempImageView setImage:thumbnalImage];
            //        tempImageView.hidden = NO;
            
            //        [self.view bringSubviewToFront:self.menuView];
            [picker dismissViewControllerAnimated:YES completion:^{
                MainViewController2 * mainVC = [[MainViewController2 alloc] init];
                mainVC.chooseImage = [info objectForKey:UIImagePickerControllerOriginalImage];
                [self.navigationController pushViewController:mainVC animated:YES];
            }];
        }
    }

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
    if (!error) {
    }
    else
    {
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
}

@end
