//
//  ChoosePictureViewController.h
//  IMyPhotos
//
//  Created by Dracuuula on 14-7-14.
//  Copyright (c) 2014年 D. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChoosePictureViewController : UIViewController<UINavigationControllerDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate>

- (IBAction)buttonOpenAlbumAction:(id)sender;
- (IBAction)buttonActionCamera:(id)sender;

@end
