//
//  MainViewController2.m
//  IMyPhotos
//
//  Created by Dracuuula on 14-6-14.
//  Copyright (c) 2014年 D. All rights reserved.
//

#import "MainViewController2.h"
#import "GPUImage.h"
#import "GPUImageGaussianBlurFilterOld.h"
#import "NSString+SBJSON.h"
#import "SaveShareViewController.h"

#define SHOW_Y 213
#define HIDDEN_Y 73

static NSString* trackViewURL;

@interface MainViewController2 ()
{
    
    GPUImageShowcaseFilterType filterType;
    
    
    GPUImageView * gpuImageView;
    UIImageView * tempImageView;
    
    CGFloat filterValue;
    
    //1 保存到相册 2 保存编辑效果
    NSInteger saveType;
    
    //
    UIImage * tempImage;
    
    //是否显示保存图片信息
    BOOL isShowSaveImageMessage;
    
    NSInteger height;
    
    
    //是否有效果
    BOOL isFilter;
}
@property (strong, nonatomic) IBOutlet UIButton *bianxingButton;
@property (strong, nonatomic) IBOutlet UIButton *colorButton;
@property (strong, nonatomic) IBOutlet UIView *sliderView;
@property (strong, nonatomic) IBOutlet UIImageView *subBGImageView;
@property (strong, nonatomic) IBOutlet UIView *subBGView;
@property(nonatomic, strong)UIImage * saveImage;
@end

@implementation MainViewController2

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        saveType = 0;
        isFilter = NO;
    }
    return self;
}

-(void)checkUpdate
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        NSString *currentVersion = [infoDic objectForKey:@"CFBundleVersion"];
        
        NSString *url = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", APPLE_ID];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:url]];
        [request setHTTPMethod:@"POST"];
        
        NSHTTPURLResponse *urlResponse = nil;
        NSError *error = nil;
        NSData *recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
        
        NSString *results = [[NSString alloc] initWithBytes:[recervedData bytes] length:[recervedData length] encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [results JSONValue];
        NSArray *infoArray = [dic objectForKey:@"results"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([infoArray count]) {
                NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
                NSString *lastVersion = [releaseInfo objectForKey:@"version"];
                
                if (![lastVersion isEqualToString:currentVersion]) {
                    trackViewURL = [[NSString alloc] initWithString: [releaseInfo objectForKey:@"trackViewUrl"]];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新提示" message:@"亲，有新版本了，赶快去更新吧" delegate:self cancelButtonTitle:@"以后" otherButtonTitles:@"更新", nil];
                    alert.tag = 100;
                    [alert show];
                }
            }
        });
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (iPhone5) {
        height = 568;
    }else{
        height = 480;
    }
    
    if (!iOS7) {
        height = height - 44;
    }
    
    self.navigationController.navigationBar.hidden = NO;
    self.sliderView.hidden = YES;
    
    [self.view setFrame:CGRectMake(0, 0, 320, height)];
    
    [self.menuView setFrame:CGRectMake(0, height-HIDDEN_Y, 320, 213)];
    
    UIButton * buttonBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonBack setFrame:CGRectMake(0, 0, 50, 30)];
    [buttonBack.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [buttonBack setTitle:@"返回" forState:UIControlStateNormal];
    [buttonBack addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * itemBack = [[UIBarButtonItem alloc] initWithCustomView:buttonBack];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = itemBack;
    [buttonBack .titleLabel setTextColor:[UIColor blueColor]];
    
    UIButton * buttonSaveShare = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonSaveShare setFrame:CGRectMake(0, 0, 70, 30)];
    [buttonSaveShare.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [buttonSaveShare setTitle:@"保存/分享" forState:UIControlStateNormal];
    [buttonSaveShare addTarget:self action:@selector(saveShareAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * itemSaveShare = [[UIBarButtonItem alloc] initWithCustomView:buttonSaveShare];
    [buttonSaveShare.titleLabel setTextColor:[UIColor blueColor]];
    
    UIButton * buttonSaveEffect = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonSaveEffect setFrame:CGRectMake(0, 0, 60, 30)];
    [buttonSaveEffect.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [buttonSaveEffect setTitle:@"保存效果" forState:UIControlStateNormal];
    [buttonSaveEffect addTarget:self action:@selector(saveFilterAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * itemSaveEffect = [[UIBarButtonItem alloc] initWithCustomView:buttonSaveEffect];
    [buttonSaveEffect.titleLabel setTextColor:[UIColor blueColor]];
    self.navigationItem.rightBarButtonItems = @[itemSaveShare,itemSaveEffect];
    
    [self.subBGView setFrame:CGRectMake(0, 0, 320, height)];
    [self.subBGImageView setFrame:CGRectMake(0, 0, 320, height)];
    self.subBGImageView.alpha = 0.4;
    [self.subBGImageView setImage:self.chooseImage];
    
    tempImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 49, 320, height-49-78)];
    [tempImageView setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:tempImageView];
    [tempImageView setImage:self.chooseImage];
    
    gpuImageView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 49, 320, height-49-78)];
    [gpuImageView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:gpuImageView];
    gpuImageView.hidden = YES;
    
    CGRect frame;
    if ((tempImageView.frame.size.width/tempImageView.frame.size.height)>(self.chooseImage.size.width/self.chooseImage.size.height)) {
        CGFloat width = tempImageView.frame.size.height * (self.chooseImage.size.width/self.chooseImage.size.height);
        CGFloat height2 = tempImageView.frame.size.height;

        frame = tempImageView.frame;
        [tempImageView setFrame:CGRectMake((320-width)/2, frame.origin.y, width, height2)];
    }else{
        CGFloat width = tempImageView.frame.size.width;
        CGFloat height3 = tempImageView.frame.size.width/(self.chooseImage.size.width/self.chooseImage.size.height);

        frame = tempImageView.frame;
        [tempImageView setFrame:CGRectMake(frame.origin.x, frame.origin.y+((tempImageView.frame.size.height-height3)/2), width, height3)];
    }
    [gpuImageView setFrame:tempImageView.frame];

    UIGraphicsBeginImageContext(frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    UIRectFill(CGRectMake(0, 0, frame.size.width, frame.size.height));//clear background
    [self.chooseImage drawInRect:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    UIImage * thumbnalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [tempImageView setImage:thumbnalImage];
    tempImageView.hidden = NO;

    [self.view bringSubviewToFront:self.menuView];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(downMenuViewAction)];
    [self.view addGestureRecognizer:tapGesture];
    
    [self checkUpdate];
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveFilterAction:(UIButton *)sender {
    
    if (isFilter) {
        self.sliderView.hidden = YES;
        saveType = 2;
        [self processImage];
    }else{
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"您还没有编辑图片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

-(void)saveShareAction:(UIButton *)button
{
    if (isFilter) {
        self.sliderView.hidden = YES;
        saveType = 3;
        [self processImage];
    }else{
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"您还没有编辑图片,确定要保存" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 101;
        [alertView show];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    saveType = 0;
    
}

-(void)downMenuViewAction
{
    if (self.menuView.hidden == NO) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.menuView setFrame:CGRectMake(0, height-HIDDEN_Y, 320, 213)];
        }];
    }
}

-(void)processImage
{
    isFilter = YES;
    
    if (self.saveImage == nil) {
        tempImage = tempImageView.image;
    }else{
        tempImage = self.saveImage;
    }
    
    GPUImagePicture*  staticPicture = [[GPUImagePicture alloc] initWithImage:tempImage smoothlyScaleOutput:YES];
    
    tempImageView.hidden = YES;
    gpuImageView.hidden = NO;
    
    switch (filterType) {
        case GPUIMAGE_SATURATION:
            {
                GPUImageSaturationFilter * filter = [[GPUImageSaturationFilter alloc] init];
                [filter setSaturation:filterValue];
                
                [filter forceProcessingAtSize:gpuImageView.sizeInPixels];
                [filter addTarget:gpuImageView];
                
                [staticPicture addTarget:filter];
                [staticPicture processImage];

                if (saveType != 0) {
                    self.saveImage = [filter imageByFilteringImage:tempImage];
                }
            }
            break;
        case GPUIMAGE_CONTRAST:
            {
                GPUImageContrastFilter * filter = [[GPUImageContrastFilter alloc] init];
                [filter setContrast:filterValue];
                
                [filter forceProcessingAtSize:gpuImageView.sizeInPixels];
                [filter addTarget:gpuImageView];
                
                [staticPicture addTarget:filter];
                [staticPicture processImage];

                if (saveType != 0) {
                    self.saveImage = [filter imageByFilteringImage:tempImage];
                }
            }
            break;
        case GPUIMAGE_RGB_GREEN:
            {
                GPUImageRGBFilter * filter = [[GPUImageRGBFilter alloc] init];
                [filter setGreen:filterValue];
                
                [filter forceProcessingAtSize:gpuImageView.sizeInPixels];
                [filter addTarget:gpuImageView];
                
                [staticPicture addTarget:filter];
                [staticPicture processImage];

                if (saveType != 0) {
                    self.saveImage = [filter imageByFilteringImage:tempImage];
                }
            }
            break;
        case GPUIMAGE_RGB_BLUE:
        {
            GPUImageRGBFilter * filter = [[GPUImageRGBFilter alloc] init];
            [filter setBlue:filterValue];
            
            [filter forceProcessingAtSize:gpuImageView.sizeInPixels];
            [filter addTarget:gpuImageView];
            
            [staticPicture addTarget:filter];
            [staticPicture processImage];
            
            if (saveType != 0) {
                self.saveImage = [filter imageByFilteringImage:tempImage];
            }
        }
            break;
        case GPUIMAGE_RGB_RED:
        {
            GPUImageRGBFilter * filter = [[GPUImageRGBFilter alloc] init];
            [filter setRed:filterValue];
            
            [filter forceProcessingAtSize:gpuImageView.sizeInPixels];
            [filter addTarget:gpuImageView];
            
            [staticPicture addTarget:filter];
            [staticPicture processImage];
            
            if (saveType != 0) {
                self.saveImage = [filter imageByFilteringImage:tempImage];
            }
        }
            break;
        case GPUIMAGE_SHARPEN:
        {
            GPUImageSharpenFilter * filter = [[GPUImageSharpenFilter alloc] init];
            [filter setSharpness:filterValue];
            
            [filter forceProcessingAtSize:gpuImageView.sizeInPixels];
            [filter addTarget:gpuImageView];
            
            [staticPicture addTarget:filter];
            [staticPicture processImage];
            
            if (saveType != 0) {
                self.saveImage = [filter imageByFilteringImage:tempImage];
            }
        }
            break;
        case GPUIMAGE_COLORINVERT:
        {
            GPUImageColorInvertFilter * filter = [[GPUImageColorInvertFilter alloc] init];
            
            [filter forceProcessingAtSize:gpuImageView.sizeInPixels];
            [filter addTarget:gpuImageView];
            
            [staticPicture addTarget:filter];
            [staticPicture processImage];
            
            if (saveType != 0) {
                self.saveImage = [filter imageByFilteringImage:tempImage];
            }
        }
            break;
        case GPUIMAGE_GRAYSCALE:
        {
            GPUImageGrayscaleFilter * filter = [[GPUImageGrayscaleFilter alloc] init];
            
            [filter forceProcessingAtSize:gpuImageView.sizeInPixels];
            [filter addTarget:gpuImageView];
            
            [staticPicture addTarget:filter];
            [staticPicture processImage];
            
            if (saveType != 0) {
                self.saveImage = [filter imageByFilteringImage:tempImage];
            }
        }
            break;
        case GPUIMAGE_HUE:
        {
            GPUImageHueFilter * filter = [[GPUImageHueFilter alloc] init];
            [filter setHue:filterValue];
            [filter forceProcessingAtSize:gpuImageView.sizeInPixels];
            [filter addTarget:gpuImageView];
            
            [staticPicture addTarget:filter];
            [staticPicture processImage];
            
            if (saveType != 0) {
                self.saveImage = [filter imageByFilteringImage:tempImage];
            }
        }
            break;
        case GPUIMAGE_THRESHOLD:
        {
            GPUImageLuminanceThresholdFilter * filter = [[GPUImageLuminanceThresholdFilter alloc] init];
            [filter setThreshold:filterValue];
            [filter forceProcessingAtSize:gpuImageView.sizeInPixels];
            [filter addTarget:gpuImageView];
            
            [staticPicture addTarget:filter];
            [staticPicture processImage];
            
            if (saveType != 0) {
                self.saveImage = [filter imageByFilteringImage:tempImage];
            }
        }
            break;
        case GPUIMAGE_SKETCH:
        {
            GPUImageSketchFilter * filter = [[GPUImageSketchFilter alloc] init];
            [filter forceProcessingAtSize:gpuImageView.sizeInPixels];
            [filter addTarget:gpuImageView];
            
            [staticPicture addTarget:filter];
            [staticPicture processImage];
            
            if (saveType != 0) {
                self.saveImage = [filter imageByFilteringImage:tempImage];
            }
        }
            break;
        case GPUIMAGE_SMOOTHTOON:
        {
            GPUImageSmoothToonFilter * filter = [[GPUImageSmoothToonFilter alloc] init];
            [filter forceProcessingAtSize:gpuImageView.sizeInPixels];
            [filter addTarget:gpuImageView];
            
            [staticPicture addTarget:filter];
            [staticPicture processImage];
            
            if (saveType != 0) {
                self.saveImage = [filter imageByFilteringImage:tempImage];
            }
        }
            break;
        case GPUIMAGE_POSTERIZE:
        {
            GPUImagePosterizeFilter * filter = [[GPUImagePosterizeFilter alloc] init];
            [filter setColorLevels:filterValue];
            [filter forceProcessingAtSize:gpuImageView.sizeInPixels];
            [filter addTarget:gpuImageView];
            
            [staticPicture addTarget:filter];
            [staticPicture processImage];
            
            if (saveType != 0) {
                self.saveImage = [filter imageByFilteringImage:tempImage];
            }
        }
            break;
        case GPUIMAGE_EMBOSS:
        {
            GPUImageEmbossFilter * filter = [[GPUImageEmbossFilter alloc] init];
            [filter setIntensity:filterValue];
            [filter forceProcessingAtSize:gpuImageView.sizeInPixels];
            [filter addTarget:gpuImageView];
            
            [staticPicture addTarget:filter];
            [staticPicture processImage];
            
            if (saveType != 0) {
                self.saveImage = [filter imageByFilteringImage:tempImage];
            }
        }
            break;
        case GPUIMAGE_GAUSSIAN:
        {
            GPUImageGaussianBlurFilterOld * filter = [[GPUImageGaussianBlurFilterOld alloc] init];
            [filter setBlurSize:filterValue];
            [filter forceProcessingAtSize:gpuImageView.sizeInPixels];
            [filter addTarget:gpuImageView];
            
            [staticPicture addTarget:filter];
            [staticPicture processImage];
            
            if (saveType != 0) {
                self.saveImage = [filter imageByFilteringImage:tempImage];
            }
        }
            break;
        case GPUIMAGE_VIGNETTE:
        {
            GPUImageVignetteFilter * filter = [[GPUImageVignetteFilter alloc] init];
            [filter setVignetteEnd:filterValue];
            [filter forceProcessingAtSize:gpuImageView.sizeInPixels];
            [filter addTarget:gpuImageView];
            
            [staticPicture addTarget:filter];
            [staticPicture processImage];
            
            if (saveType != 0) {
                self.saveImage = [filter imageByFilteringImage:tempImage];
            }
        }
            break;
        case GPUIMAGE_SWIRL:
        {
            GPUImageSwirlFilter * filter = [[GPUImageSwirlFilter alloc] init];
            [filter setAngle:filterValue];
            [filter forceProcessingAtSize:gpuImageView.sizeInPixels];
            [filter addTarget:gpuImageView];
            
            [staticPicture addTarget:filter];
            [staticPicture processImage];
            
            if (saveType != 0) {
                self.saveImage = [filter imageByFilteringImage:tempImage];
            }
        }
            break;
        case GPUIMAGE_GLASSSPHERE:
        {
            GPUImageGlassSphereFilter * filter = [[GPUImageGlassSphereFilter alloc] init];
//            [filter setAngle:filterValue];
            [filter forceProcessingAtSize:gpuImageView.sizeInPixels];
            [filter addTarget:gpuImageView];
            
            [staticPicture addTarget:filter];
            [staticPicture processImage];
            
            if (saveType != 0) {
                self.saveImage = [filter imageByFilteringImage:tempImage];
            }
        }
            break;
        case GPUIMAGE_STRETCH:
        {
            GPUImageStretchDistortionFilter * filter = [[GPUImageStretchDistortionFilter alloc] init];
            //            [filter setAngle:filterValue];
            [filter forceProcessingAtSize:gpuImageView.sizeInPixels];
            [filter addTarget:gpuImageView];
            
            [staticPicture addTarget:filter];
            [staticPicture processImage];
            
            if (saveType != 0) {
                self.saveImage = [filter imageByFilteringImage:tempImage];
            }
        }
            break;
        case GPUIMAGE_DILATION:
        {
            GPUImageRGBDilationFilter * filter = [[GPUImageRGBDilationFilter alloc] initWithRadius:4];
//            [filter set:filterValue];
            [filter forceProcessingAtSize:gpuImageView.sizeInPixels];
            [filter addTarget:gpuImageView];
            
            [staticPicture addTarget:filter];
            [staticPicture processImage];
            
            if (saveType != 0) {
                self.saveImage = [filter imageByFilteringImage:tempImage];
            }
        }
            break;
        case GPUIMAGE_PINCH:
        {
            GPUImagePinchDistortionFilter * filter = [[GPUImagePinchDistortionFilter alloc] init];
            [filter setScale:filterValue];
            [filter forceProcessingAtSize:gpuImageView.sizeInPixels];
            [filter addTarget:gpuImageView];
            
            [staticPicture addTarget:filter];
            [staticPicture processImage];
            
            if (saveType != 0) {
                self.saveImage = [filter imageByFilteringImage:tempImage];
            }
        }
            break;
        case GPUIMAGE_BULGE:
        {
            GPUImageBulgeDistortionFilter * filter = [[GPUImageBulgeDistortionFilter alloc] init];
            [filter setRadius:0.5];
            [filter setScale:filterValue];
            [filter forceProcessingAtSize:gpuImageView.sizeInPixels];
            [filter addTarget:gpuImageView];
            
            [staticPicture addTarget:filter];
            [staticPicture processImage];
            
            if (saveType != 0) {
                self.saveImage = [filter imageByFilteringImage:tempImage];
            }
        }
            break;
        case GPUIMAGE_EROSION:
        {
            GPUImageRGBErosionFilter * filter = [[GPUImageRGBErosionFilter alloc] initWithRadius:4];
//            [filter setRadius:0.5];
//            [filter setScale:filterValue];
            [filter forceProcessingAtSize:gpuImageView.sizeInPixels];
            [filter addTarget:gpuImageView];
            
            [staticPicture addTarget:filter];
            [staticPicture processImage];
            
            if (saveType != 0) {
                self.saveImage = [filter imageByFilteringImage:tempImage];
            }
        }
            break;
        case GPUIMAGE_SPHEREREFRACTION:
        {
            GPUImageSphereRefractionFilter * filter = [[GPUImageSphereRefractionFilter alloc] init];
            [filter setRefractiveIndex:filterValue];
            [filter setRadius:0.5];
            //            [filter setScale:filterValue];
            [filter forceProcessingAtSize:gpuImageView.sizeInPixels];
            [filter addTarget:gpuImageView];
            
            [staticPicture addTarget:filter];
            [staticPicture processImage];
            
            if (saveType != 0) {
                self.saveImage = [filter imageByFilteringImage:tempImage];
            }
        }
            break;
            
        default:
            break;
    }
    
    if ((saveType == 3)&&self.saveImage) {
        SaveShareViewController * saveShareVC = [[SaveShareViewController alloc] init];
        saveShareVC.saveImage = self.saveImage;
        [self.navigationController pushViewController:saveShareVC animated:YES];
    }
}

- (IBAction)colorButtonAction:(id)sender {
    
    self.colorButton.selected = YES;
    self.bianxingButton.selected = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.menuView setFrame:CGRectMake(0, height-SHOW_Y, 320, SHOW_Y)];
    }];
    saveType = 0;
    self.colorView.hidden = NO;
    self.bianxingView.hidden = YES;
}

- (IBAction)bianxingButtonAction:(id)sender {
    self.colorButton.selected = NO;
    self.bianxingButton.selected = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.menuView setFrame:CGRectMake(0, height-SHOW_Y, 320, SHOW_Y)];
    }];
    saveType = 0;
    self.colorView.hidden = YES;
    self.bianxingView.hidden = NO;
}

- (IBAction)sliderChangeValue:(id)sender {
    UISlider * slider = (UISlider *)sender;
    filterValue = slider.value;
    
    [self processImage];
}

- (IBAction)buttonOfColorAction:(id)sender {
    UIButton * button = (UIButton *)sender;
    saveType = 0;
    
    switch (button.tag) {
        case 101:
        {
            filterType = GPUIMAGE_SATURATION;
            self.sliderView.hidden = NO;
            [self.valueSlider setMinimumValue:0.0];
            [self.valueSlider setMaximumValue:2.0];
            [self.valueSlider setValue:0.2];
            filterValue = self.valueSlider.value;
        }
            break;
        case 102:
        {
            filterType = GPUIMAGE_CONTRAST;
            self.sliderView.hidden = NO;
            [self.valueSlider setMinimumValue:0.0];
            [self.valueSlider setMaximumValue:4.0];
            [self.valueSlider setValue:1.0];
            filterValue = self.valueSlider.value;
        }
            break;
        case 103:
        {
            filterType = GPUIMAGE_RGB_GREEN;
            self.sliderView.hidden = NO;
            [self.valueSlider setMinimumValue:0.0];
            [self.valueSlider setMaximumValue:2.0];
            [self.valueSlider setValue:1.0];
            filterValue = self.valueSlider.value;
        }
            break;
        case 104:
        {
            filterType = GPUIMAGE_RGB_BLUE;
            self.sliderView.hidden = NO;
            [self.valueSlider setMinimumValue:0.0];
            [self.valueSlider setMaximumValue:2.0];
            [self.valueSlider setValue:1.0];
            filterValue = self.valueSlider.value;
        }
            break;
        case 105:
        {
            filterType = GPUIMAGE_RGB_RED;
            self.sliderView.hidden = NO;
            [self.valueSlider setMinimumValue:0.0];
            [self.valueSlider setMaximumValue:2.0];
            [self.valueSlider setValue:1.0];
            filterValue = self.valueSlider.value;
        }
            break;
        case 106:
        {
            filterType = GPUIMAGE_SHARPEN;
            self.sliderView.hidden = NO;
            [self.valueSlider setMinimumValue:-4.0];
            [self.valueSlider setMaximumValue:4.0];
            [self.valueSlider setValue:0.0];
            filterValue = self.valueSlider.value;
        }
            break;
        case 107:
        {
            filterType = GPUIMAGE_COLORINVERT;
            self.sliderView.hidden = YES;
        }
            break;
        case 108:
        {
            filterType = GPUIMAGE_GRAYSCALE;
            self.sliderView.hidden = YES;
        }
            break;
        case 109:
        {
            filterType = GPUIMAGE_HUE;
            self.sliderView.hidden = NO;
            [self.valueSlider setMinimumValue:0.0];
            [self.valueSlider setMaximumValue:360.0];
            [self.valueSlider setValue:180.0];
            filterValue = self.valueSlider.value;
        }
            break;
        case 110:
        {
            filterType = GPUIMAGE_THRESHOLD;
            self.sliderView.hidden = NO;
            [self.valueSlider setMinimumValue:0.0];
            [self.valueSlider setMaximumValue:1.0];
            [self.valueSlider setValue:0.5];
            filterValue = self.valueSlider.value;
        }
            break;
        case 111:
        {
            filterType = GPUIMAGE_SKETCH;
            self.sliderView.hidden = YES;
        }
            break;
        case 112:
        {
            filterType = GPUIMAGE_SMOOTHTOON;
            self.sliderView.hidden = YES;
        }
            break;
        case 113:
        {
            filterType = GPUIMAGE_POSTERIZE;
            self.sliderView.hidden = NO;
            [self.valueSlider setMinimumValue:0.0];
            [self.valueSlider setMaximumValue:20.0];
            [self.valueSlider setValue:10.0];
            filterValue = self.valueSlider.value;
        }
            break;
        case 114:
        {
            filterType = GPUIMAGE_EMBOSS;
            self.sliderView.hidden = NO;
            [self.valueSlider setMinimumValue:0.0];
            [self.valueSlider setMaximumValue:4.0];
            [self.valueSlider setValue:1.0];
            filterValue = self.valueSlider.value;
        }
            break;
        case 115:
        {
            filterType = GPUIMAGE_GAUSSIAN;
            self.sliderView.hidden = NO;
            [self.valueSlider setMinimumValue:0.0];
            [self.valueSlider setMaximumValue:10.0];
            [self.valueSlider setValue:1.0];
            filterValue = self.valueSlider.value;
        }
            break;
            
        default:
            break;
    }
    
    [self downMenuViewAction];
    [self processImage];
}

- (IBAction)buttonOfBianXingAction:(id)sender {
    UIButton * button = (UIButton *)sender;
    saveType = 0;
    
    switch (button.tag) {
        case 201:
        {//GPUIMAGE_VIGNETTE
            filterType = GPUIMAGE_VIGNETTE;
            self.sliderView.hidden = NO;
            [self.valueSlider setMinimumValue:0.5];
            [self.valueSlider setMaximumValue:1.0];
            [self.valueSlider setValue:0.75];
            filterValue = self.valueSlider.value;
        }
            break;
        case 202:
        {
            filterType = GPUIMAGE_SWIRL;
            self.sliderView.hidden = NO;
            [self.valueSlider setMinimumValue:0.0];
            [self.valueSlider setMaximumValue:2.0];
            [self.valueSlider setValue:0.75];
            filterValue = self.valueSlider.value;
        }
            break;
        case 203:
        {
            filterType = GPUIMAGE_GLASSSPHERE;
            self.sliderView.hidden = YES;
        }
            break;
        case 204:
        {
            filterType = GPUIMAGE_STRETCH;
            self.sliderView.hidden = YES;
        }
            break;
        case 205:
        {
            filterType = GPUIMAGE_DILATION;
            self.sliderView.hidden = YES;
        }
            break;
        case 206:
        {
            filterType = GPUIMAGE_PINCH;
            self.sliderView.hidden = NO;
            [self.valueSlider setMinimumValue:-2.0];
            [self.valueSlider setMaximumValue:2.0];
            [self.valueSlider setValue:0.0];
            filterValue = self.valueSlider.value;
        }
            break;
        case 207:
        {
            filterType = GPUIMAGE_BULGE;
            self.sliderView.hidden = NO;
            [self.valueSlider setMinimumValue:-1.0];
            [self.valueSlider setMaximumValue:1.0];
            [self.valueSlider setValue:0.5];
            filterValue = self.valueSlider.value;
        }
            break;
        case 208:
        {
            filterType = GPUIMAGE_EROSION;
            self.sliderView.hidden = YES;
        }
            break;
        case 209:
        {
            filterType = GPUIMAGE_SPHEREREFRACTION;
            self.sliderView.hidden = NO;
            [self.valueSlider setMinimumValue:0.0];
            [self.valueSlider setMaximumValue:1.0];
            [self.valueSlider setValue:0.5];
            filterValue = self.valueSlider.value;
        }
            break;
            
        default:
            break;
    }
    
    [self downMenuViewAction];
    [self processImage];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {
        if (buttonIndex == 1 && trackViewURL) {
            [[UIApplication sharedApplication] openURL: [NSURL URLWithString:trackViewURL]];
            trackViewURL = nil;
        }
    }else if (alertView.tag == 101){
        
        if (buttonIndex != alertView.cancelButtonIndex) {
            SaveShareViewController * saveShareVC = [[SaveShareViewController alloc] init];
            saveShareVC.saveImage = tempImageView.image;
            [self.navigationController pushViewController:saveShareVC animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
