//
//  JJViewController.h
//  JJeasyTalk
//
//  Created by 张明磊 on 14-2-20.
//  Copyright (c) 2014年 lvgou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LGZmlNavigationController;

@interface JJViewController : UIViewController

@property (assign , nonatomic) LGZmlNavigationController *navigationController_return;

- (void)pushViewController:(JJViewController *)viewController;
- (void)popViewController;

@end
