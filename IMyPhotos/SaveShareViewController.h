//
//  SaveShareViewController.h
//  IMyPhotos
//
//  Created by Dracuuula on 14-7-14.
//  Copyright (c) 2014年 D. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocial.h"

@interface SaveShareViewController : UIViewController<UMSocialUIDelegate>
@property (strong, nonatomic) IBOutlet UIView *shareView;
- (IBAction)haoyouAction:(id)sender;
- (IBAction)pengyouquanAction:(id)sender;
- (IBAction)sinaAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *subImageView;
@property(nonatomic, strong)UIImage * saveImage;
@end
