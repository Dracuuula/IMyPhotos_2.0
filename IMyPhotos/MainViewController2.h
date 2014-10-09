//
//  MainViewController2.h
//  IMyPhotos
//
//  Created by Dracuuula on 14-6-14.
//  Copyright (c) 2014年 D. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    GPUIMAGE_SATURATION,
    GPUIMAGE_CONTRAST,
    GPUIMAGE_RGB_GREEN,
    GPUIMAGE_RGB_BLUE,
    GPUIMAGE_RGB_RED,
    GPUIMAGE_SHARPEN,
    GPUIMAGE_COLORINVERT,
    GPUIMAGE_GRAYSCALE,
    GPUIMAGE_HUE,
    GPUIMAGE_THRESHOLD,
    GPUIMAGE_SKETCH,
    GPUIMAGE_SMOOTHTOON,
    GPUIMAGE_POSTERIZE,
    GPUIMAGE_EMBOSS,
    GPUIMAGE_GAUSSIAN,
    GPUIMAGE_VIGNETTE,
    GPUIMAGE_SWIRL,
    GPUIMAGE_GLASSSPHERE,
    GPUIMAGE_STRETCH,
    GPUIMAGE_DILATION,
    GPUIMAGE_PINCH,
    GPUIMAGE_BULGE,
    GPUIMAGE_EROSION,
    GPUIMAGE_SPHEREREFRACTION,
} GPUImageShowcaseFilterType;

@interface MainViewController2 : UIViewController<UIAlertViewDelegate>

@property(strong, nonatomic)UIImage * chooseImage;

@property (strong, nonatomic) IBOutlet UIView *bianxingView;
@property (strong, nonatomic) IBOutlet UIView *colorView;
@property (strong, nonatomic) IBOutlet UIView *menuView;
@property (strong, nonatomic) IBOutlet UISlider *valueSlider;
- (IBAction)colorButtonAction:(id)sender;
- (IBAction)bianxingButtonAction:(id)sender;

- (IBAction)sliderChangeValue:(id)sender;

- (IBAction)buttonOfColorAction:(id)sender;
- (IBAction)buttonOfBianXingAction:(id)sender;

@end
