//
//  SaveShareViewController.m
//  IMyPhotos
//
//  Created by Dracuuula on 14-7-14.
//  Copyright (c) 2014年 D. All rights reserved.
//

#import "SaveShareViewController.h"

@interface SaveShareViewController ()

@end

@implementation SaveShareViewController

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
    self.navigationController.navigationBar.hidden = NO;
    
    NSInteger height;
    
    if (iPhone5) {
        height = 568;
    }else{
        height = 480;
    }
    
    if(!iOS7)
    {
        height = height - 44;
    }
    
    [self.view setFrame:CGRectMake(0, 0, 320, height)];
    
    self.title = @"分享";
    
    UIButton * buttonBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonBack setFrame:CGRectMake(0, 0, 50, 30)];
    [buttonBack.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [buttonBack setTitle:@"返回" forState:UIControlStateNormal];
    [buttonBack addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * itemBack = [[UIBarButtonItem alloc] initWithCustomView:buttonBack];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = itemBack;
    [buttonBack .titleLabel setTextColor:[UIColor blueColor]];
    
    [self.subImageView setFrame:CGRectMake(0, 10, 320, height-60)];
    [self.subImageView setImage:self.saveImage];
    
    [self.shareView setFrame:CGRectMake(0, height-60, 320, 60)];
    
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UIImageWriteToSavedPhotosAlbum(self.saveImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
    if (!error) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"图片保存成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"图片保存失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

#pragma mark - UMSocialUIDelegate
-(BOOL)closeOauthWebViewController:(UINavigationController *)navigationCtroller socialControllerService:(UMSocialControllerService *)socialControllerService
{
    return YES;
}

-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType
{
    
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"成功分享到%@",[[response.data allKeys] objectAtIndex:0]);
        NSString * msgStr = [NSString stringWithFormat:@"成功分享到%@",[[response.data allKeys] objectAtIndex:0]];
        
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:msgStr delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }else{
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"分享失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
{
    
}

-(BOOL)isDirectShareInIconActionSheet
{
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)haoyouAction:(id)sender {
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:@"" image:self.saveImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"分享成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }else{
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"分享失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }];
}

- (IBAction)pengyouquanAction:(id)sender {

    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:@"" image:self.saveImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"分享成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }else{
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"分享失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }];
}

- (IBAction)sinaAction:(id)sender {

    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:nil image:self.saveImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"分享成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }else{
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"分享失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }];
}
@end
