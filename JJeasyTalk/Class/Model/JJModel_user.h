//
//  JJModel_user.h
//  JJeasyTalk
//
//  Created by 张明磊 on 14-2-19.
//  Copyright (c) 2014年 lvgou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJModel_user : NSObject

#pragma mark - 用户账号 -
/**
 *  用户账号
 */
@property (nonatomic, assign) NSString *string_userAccount;

#pragma mark - 用户密码 -
/**
 *  用户密码
 */
@property (nonatomic, assign) NSString *string_userPassword;

@end
