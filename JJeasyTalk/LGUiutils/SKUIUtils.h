//
//  SKUIUtils.h
//  Gastrosoph
//
//  Created by 张明磊 on 7/16/13.
//  Copyright (c) 2013年 zhangminglei. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RGB(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#undef	DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
+ (__class *)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[[self class] alloc] init]; } ); \
return __singleton__; \
}

#define SK_TEXTFONT  @"ShiShangZhongHeiJianTi"

@interface SKUIUtils : NSObject

+ (UIImage *)didLoadImageNotCached:(NSString *)filename;
+ (NSString *)getCurrentDateString;
+ (NSString*)getDateStringAfterSeconds:(NSTimeInterval)seconds;
+ (NSString*)getDocumentDirName;
+ (void)hiddeView:(UIView *)view;
+ (void)showView:(UIView *)view;
+ (void)didLoadImageNotCached:(NSString *)filename inImageView:(UIImageView *)imageView;
+ (void)didLoadImageNotCached:(NSString *)filename inButton:(UIButton *)button withState:(UIControlState)state;
#pragma mark - 从时间戳获取时间 -
/**
 *  从时间戳获取时间
 *
 *  @param string_timeStamp 时间戳
 *
 *  @return 时间
 */
+ (NSString *)getTimeFromTimeStamp:(NSString *)string_timeStamp;
#pragma mark - MBProgressHUD
+ (void)showHUD:(NSString *)_infoContent afterTime:(float)time;
+ (void)dismissCurrentHUD;
+ (void)showAlterView:(NSString *)_infoContent afterTime:(float)time;


#pragma mark - 不遮盖式指示器 -
/**
 *  不遮盖式指示器
 *
 *  @param string_content 指示器内容
 *  @param view_cover     遮盖层
 */
+ (void)showHUDWithContent:(NSString *)string_content inCoverView:(UIView *)view_cover;


//+ (void)view_showProgressHUD:(NSString *) _infoContent inView:(UIView *)view withType:(NSInteger )type;
//+ (void)view_showProgressHUD:(NSString *) _infoContent inView:(UIView *)view withTime:(float)time;
//+ (void)view_hideProgressHUDinView:(UIView *)view;

#pragma mark - View
///渐变添加动画
//+ (void)addView:(UIView *)view toView:(UIView *)superView;
//+ (void)removeView:(UIView *)view;

#pragma mark - animation
///旋转动画
//+ (void)animationWhirlWith:(UIView *)_view withPointMake:(CGPoint)point andRemovedOnCompletion:(BOOL)remove andDirection:(NSInteger)direction;

///移动添加动画
//+ (void)addViewWithAnimation:(UIView *)view inCenterPoint:(CGPoint)point;
//+ (void)removeViewWithAnimation:(UIView *)view inCenterPoint:(CGPoint)point withBoolRemoveView:(BOOL)_remove;

/**
 清空控件上的视图
 三种参数组合
 目标控件
 删除上面button,imageView,label组合
 **/
+ (void)clearChildViewsInView:(UIView *)view
                withButtonTag:(BOOL)button
               orImageViewTag:(BOOL)imageView
                   orLabelTag:(BOOL)label;


/**
 圆形型HUD
 **/
//+ (void)showCircleHUDInView:(UIView *)view;
//+ (void)hiddenCircleHUDInView:(UIView *)view;



@end
