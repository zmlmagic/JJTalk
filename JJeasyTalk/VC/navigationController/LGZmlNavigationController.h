//
//  LGZmlNavigationController.h
//  lvgouProjectIphone
//
//  Created by lvgou on 13-12-4.
//  Copyright (c) 2013年 lvgou. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KEY_WINDOW  [[UIApplication sharedApplication]keyWindow]
#define kkBackViewHeight [UIScreen mainScreen].bounds.size.height
#define kkBackViewWidth [UIScreen mainScreen].bounds.size.width

#define iOS7  ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

// 背景视图起始frame.x
#define startX -200;


@interface LGZmlNavigationController : UINavigationController
{
    CGFloat startBackViewX;
}
// 默认为特效开启
@property (nonatomic, assign) BOOL canDragBack;

@end
