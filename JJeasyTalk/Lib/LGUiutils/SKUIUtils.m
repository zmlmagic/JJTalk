//
//  SKUIUtils.m
//  Gastrosoph
//
//  Created by 张明磊 on 7/16/13.
//  Copyright (c) 2013年 zhangminglei. All rights reserved.
//

#import "SKUIUtils.h"
#import <QuartzCore/QuartzCore.h>
#import "MBHUDView.h"
//#import "SKSpinningCircle.h"
#import "UIImage+UIImageExt.h"


#define RGB(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

@implementation SKUIUtils

+ (UIImage *)didLoadImageNotCached:(NSString *)filename
{
    /*@autoreleasepool
    {
        NSString *imageFile = [[NSString alloc]initWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], filename];
        UIImage *image =  [UIImage imageWithContentsOfFile:imageFile];
        return image;
    }*/
    @autoreleasepool
    {
        NSString *imageFile = [[NSString alloc]initWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], filename];
        UIImage *image =  [[UIImage alloc] initWithContentsOfFile:imageFile];
        UIImage *image_scaling = [image imageByScalingAndCroppingForSize:CGSizeMake([UIScreen mainScreen].currentMode.size.width, [UIScreen mainScreen].currentMode.size.height)];
        return image_scaling;
    }
}

//返回当前时间的字符串
+ (NSString *)getCurrentDateString
{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    //alloc后对不使用的对象别忘了release
    //[dateFormatter release];
    return currentDateStr;
}

//返回若干秒后的时间的字符串
+ (NSString*)getDateStringAfterSeconds:(NSTimeInterval)seconds
{
    NSDate *destDate = [NSDate dateWithTimeIntervalSinceNow:seconds];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //用[NSDate date]可以获取系统当前时间
    NSString *dateStr = [dateFormatter stringFromDate:destDate];
    //alloc后对不使用的对象别忘了release
    //[dateFormatter release];
    return dateStr;
}

#pragma mark - 从时间戳获取时间 -
/**
 *  从时间戳获取时间
 *
 *  @param string_timeStamp 时间戳
 *
 *  @return 时间
 */
+ (NSString *)getTimeFromTimeStamp:(NSString *)string_timeStamp
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    //设置时区,这个对于时间的处理有时很重要
    //例如你在国内发布信息,用户在国外的另一个时区,你想让用户看到正确的发布时间就得注意时区设置,时间的换算.YYYY-MM-dd HH:mm:ss
    //例如你发布的时间为2010-01-26 17:40:50,那么在英国爱尔兰那边用户看到的时间应该是多少呢?
    //他们与我们有7个小时的时差,所以他们那还没到这个时间呢...那就是把未来的事做了
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    //NSDate* date = [formatter dateFromString:timeStr];
    //------------将字符串按formatter转成nsdate
    //NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    //NSString *nowtimeStr = [formatter stringFromDate:datenow];
    //----------将nsdate按formatter格式转成nsstring
    //时间转时间戳的方法:
    //NSString *timeSp = [NSString stringWithFormat:@"%ld",(long)[datenow timeIntervalSince1970]];
    //NSLog(@"timeSp:%@",timeSp);
    //时间戳转时间的方法
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[string_timeStamp integerValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}



//返回文档目录
+ (NSString*)getDocumentDirName
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (void)hiddeView:(UIView *)view
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [view setAlpha:0.0f];
    [UIView commitAnimations];
}

+ (void)showView:(UIView *)view
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [view setAlpha:1.0f];
    [UIView commitAnimations];
}

/**imageView加载图片**/
#pragma mark - imageView加载图片 -
+ (void)didLoadImageNotCached:(NSString *)filename inImageView:(UIImageView *)imageView
{
    @autoreleasepool
    {
        NSString *imageFile = [[NSString alloc]initWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], filename];
        UIImage *image =  [[UIImage alloc] initWithContentsOfFile:imageFile];
        UIImage *image_scaling;
        if([UIScreen mainScreen].currentMode.size.width == 320)
        {
            image_scaling = [image imageByScalingAndCroppingForSize:CGSizeMake(imageView.frame.size.width, imageView.frame.size.height)];
        }
        else
        {
            image_scaling = [image imageByScalingAndCroppingForSize:CGSizeMake(imageView.frame.size.width * 2, imageView.frame.size.height * 2)];
        }
        [imageView setImage:image_scaling];
    }
    //NSString *imageFile = [[NSString alloc]initWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], filename];
    //UIImage *image =  [[UIImage alloc] initWithContentsOfFile:imageFile];
    //[imageView setImage:image];
}

/**button加载图片**/
#pragma mark - button加载图片 -
+ (void)didLoadImageNotCached:(NSString *)filename inButton:(UIButton *)button withState:(UIControlState)state
{
    @autoreleasepool
    {
        NSString *imageFile = [[NSString alloc]initWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], filename];
        UIImage *image =  [[UIImage alloc] initWithContentsOfFile:imageFile];
        UIImage *image_scaling;
        if([UIScreen mainScreen].currentMode.size.width == 320)
        {
            image_scaling = [image imageByScalingAndCroppingForSize:CGSizeMake(button.frame.size.width, button.frame.size.height)];
        }
        else
        {
            image_scaling = [image imageByScalingAndCroppingForSize:CGSizeMake(button.frame.size.width * 2, button.frame.size.height * 2)];
        }
        [button setBackgroundImage:image_scaling forState:state];
    }
    
    //NSString *imageFile = [[NSString alloc]initWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], filename];
    //UIImage *image =  [[UIImage alloc] initWithContentsOfFile:imageFile];
    //[button setBackgroundImage:image forState:state];
}

#pragma mark -
#pragma mark MBProgressHUD
+ (void)showHUD:(NSString *)_infoContent afterTime:(float)time 
{
    [MBHUDView hudWithBody:_infoContent type:MBAlertViewHUDTypeActivityIndicator hidesAfter:time show:YES];
}

+ (void)dismissCurrentHUD
{
    [MBHUDView dismissCurrentHUD];
}

+ (void)showAlterView:(NSString *)_infoContent afterTime:(float)time
{
    [MBHUDView hudWithBody:_infoContent type:MBAlertViewHUDTypeDefault hidesAfter:time show:YES];
}

#pragma mark - 不遮盖式指示器 -
/**
 *  不遮盖式指示器
 *
 *  @param string_content 指示器内容
 *  @param view_cover     遮盖层
 */
+ (void)showHUDWithContent:(NSString *)string_content inCoverView:(UIView *)view_cover
{
    [MBHUDView hudWithBody:string_content type:MBAlertViewHUDTypeActivityIndicator hidesAfter:888.0f show:YES inCoverView:view_cover];
}


/**
清空控件上的视图
三种参数组合
目标控件
删除上面button,imageView,label组合
**/
+ (void)clearChildViewsInView:(UIView *)view
                withButtonTag:(BOOL)button
               orImageViewTag:(BOOL)imageView
                   orLabelTag:(BOOL)label
{
    if(button && imageView && label)
    {
        [self clearChildButtonInView:view];
        [self clearChildImageViewInView:view];
        [self clearChildLabelViewInView:view];
    }
    else if(button && imageView && !label)
    {
        [self clearChildButtonInView:view];
        [self clearChildImageViewInView:view];
    }
    else if(button && !imageView &&label)
    {
        [self clearChildButtonInView:view];
        [self clearChildLabelViewInView:view];
    }
    else if(!button && imageView &&label)
    {
        [self clearChildImageViewInView:view];
        [self clearChildLabelViewInView:view];
    }
    else if(button && !imageView && !label)
    {
        [self clearChildButtonInView:view];
    }
    else if(!button && imageView && !label)
    {
        [self clearChildImageViewInView:view];
    }
    else if(!button && !imageView && label)
    {
        [self clearChildLabelViewInView:view];
    }
}


+ (void)clearChildButtonInView:(UIView *)view
{
    for(id button in view.subviews)
    {
        if([button isKindOfClass:[UIButton class]])
        {
            UIButton *button_remove = (UIButton *)button;
            [button_remove removeFromSuperview];
        }
    }
}

+ (void)clearChildImageViewInView:(UIView *)view
{
    for(id imageView in view.subviews)
    {
        if([imageView isKindOfClass:[UIImageView class]])
        {
            UIImageView *imageView_remove = (UIImageView *)imageView;
            [imageView_remove removeFromSuperview];
        }
    }
}

+ (void)clearChildLabelViewInView:(UIView *)view
{
    for(id label in view.subviews)
    {
        if([label isKindOfClass:[UILabel class]])
        {
            UILabel *label_remove = (UILabel *)label;
            [label_remove removeFromSuperview];
        }
    }
}

/*+ (void)view_showProgressHUD:(NSString *) _infoContent inView:(UIView *)view withType:(NSInteger )type
{
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    [progressHUD setCenter:CGPointMake(progressHUD.center.x, progressHUD.center.y -20)];
    [progressHUD setAnimationType:MBProgressHUDAnimationZoom];
    switch (type)
    {
        case 0:
        {
            [progressHUD setMode: MBProgressHUDModeIndeterminate];
        }break;
        case 1:
        {
            [progressHUD setMode:MBProgressHUDModeCustomView];
            UIView *view_back = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
            [view_back setBackgroundColor:[UIColor clearColor]];
            [progressHUD setCustomView:view_back];
        }break;
        default:
            break;
    }
    
    [progressHUD setLabelText:_infoContent];
    [progressHUD setLabelFont:[UIFont fontWithName:@"Helvetica-Bold" size:20.0]];
    [progressHUD setRemoveFromSuperViewOnHide:YES];
}

+ (void)view_showProgressHUD:(NSString *) _infoContent inView:(UIView *)view withTime:(float)time
{
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    [progressHUD setCenter:CGPointMake(progressHUD.center.x, progressHUD.center.y -20)];
    [progressHUD setAnimationType:MBProgressHUDAnimationZoom];
    UIView *view_back = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    [view_back setBackgroundColor:[UIColor clearColor]];
    [progressHUD setCustomView:view_back];
    [progressHUD setMode:MBProgressHUDModeCustomView];
    [progressHUD setLabelText:_infoContent];
    [progressHUD setLabelFont:[UIFont fontWithName:@"Helvetica-Bold" size:20.0]];
    [progressHUD setRemoveFromSuperViewOnHide:YES];
    [self performSelector:@selector(view_hideProgressHUDinView:) withObject:view afterDelay:time];
}

+ (void)view_hideProgressHUDinView:(UIView *)view
{
    [MBProgressHUD hideHUDForView:view animated:YES];
}


#pragma mark - View
+ (void)addView:(UIView *)view toView:(UIView *)superView
{
    [superView addSubview:view];
    [view setAlpha:0.0f];
    [self showView:view];
    [view release];
}

+ (void)removeView:(UIView *)view
{
    [self hiddeView:view];
    [self performSelector:@selector(removeViewWithAnimation:) withObject:view afterDelay:1.0f];
}

+ (void)removeViewWithAnimation:(UIView *)view
{
    [view removeFromSuperview];
}

+ (void)animationWhirlWith:(UIView *)_view withPointMake:(CGPoint)point andRemovedOnCompletion:(BOOL)remove andDirection:(NSInteger)direction
{
    CABasicAnimation *aAnimation = [CABasicAnimation animation];
    aAnimation.keyPath = @"position";
    aAnimation.keyPath = @"transform.rotation.z";
    //aAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(28, 23)];
    aAnimation.toValue = [NSNumber numberWithFloat:M_PI * direction];
    aAnimation.duration = 0.3f;
    aAnimation.removedOnCompletion = remove;//完成后停止
    aAnimation.fillMode = kCAFillModeForwards;
    aAnimation.autoreverses = NO;
    _view.layer.position = point;
    [_view.layer addAnimation: aAnimation forKey:@"rotation"];
}

+ (void)addViewWithAnimation:(UIView *)view inCenterPoint:(CGPoint)point
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationRepeatCount:1];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [view setCenter:point];
    [UIView commitAnimations];
}

+ (void)removeViewWithAnimation:(UIView *)view inCenterPoint:(CGPoint)point withBoolRemoveView:(BOOL)_remove
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationRepeatCount:1];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [view setCenter:point];
    [UIView commitAnimations];
    if(_remove)
    {
        [self performSelector:@selector(removeViewWithAnimation:) withObject:view afterDelay:0.5f];
    }
}

#pragma mark - 
#pragma mark ShowCircleHUD
+ (void)showCircleHUDInView:(UIView *)view 
{
    MBProgressHUD *_HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    [_HUD setAnimationType:MBProgressHUDAnimationZoom];
    SKSpinningCircle *activityIndicator = [SKSpinningCircle circleWithSize:NSSpinningCircleSizeLarge color:[UIColor colorWithRed:50.0/255.0 green:155.0/255.0 blue:255.0/255.0 alpha:1.0]];
    activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    activityIndicator.frame = CGRectMake(0, 28.0f, 50.0f, 50.0f);
    activityIndicator.circleSize = NSSpinningCircleSizeLarge;
    activityIndicator.hasGlow = YES;
    activityIndicator.isAnimating = YES;
    activityIndicator.speed = 0.55;
    [activityIndicator setIsAnimating:YES];
    [_HUD setCustomView:activityIndicator];
    [activityIndicator release];
    [_HUD setMode:MBProgressHUDModeCustomView];
    [_HUD setLabelText:@"加载中..."];
    [_HUD setLabelFont:[UIFont fontWithName:@"ShiShangZhongHeiJianTi" size:15.0]];
    [_HUD setRemoveFromSuperViewOnHide:YES];
}

+ (void)hiddenCircleHUDInView:(UIView *)view
{
    [MBProgressHUD hideHUDForView:view animated:YES];
}
*/



@end
