//
//  JJViewController.m
//  JJeasyTalk
//
//  Created by 张明磊 on 14-2-20.
//  Copyright (c) 2014年 lvgou. All rights reserved.
//

#import "JJViewController.h"

@implementation JJViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        IOS7_STATEBAR;
        [self.view setBackgroundColor:[UIColor clearColor]];
        // Custom initialization
    }
    return self;
}

#pragma mark - 状态栏控制 -
/**状态栏控制**/
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)pushViewController:(JJViewController *)viewController
{
    viewController.navigationController_return = _navigationController_return;
    if(_navigationController_return)
    {
        [_navigationController_return pushViewController:viewController animated:YES];
    }
}

- (void)popViewController
{
    if(_navigationController_return)
    {
        [_navigationController_return popViewControllerAnimated:YES];
    }
}

@end
