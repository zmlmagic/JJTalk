//
//  JJConfigureFile.h
//  JJeasyTalk
//
//  Created by 张明磊 on 14-2-19.
//  Copyright (c) 2014年 lvgou. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - 用户名 -
/**
 *  用户名
 */
FOUNDATION_EXPORT NSString *const JJUserName;

#pragma mark - 用户密码 -
/**
 *  用户密码
 */
FOUNDATION_EXPORT NSString *const JJPassword;

#pragma mark - 服务器IP -
/**
 *  服务器IP
 */
FOUNDATION_EXPORT NSString *const Host_IP;

#pragma mark - 服务器端口 -
/**
 *  服务器端口
 */
FOUNDATION_EXPORT const int Port;

#pragma mark - 服务器主机名,可设置 -
/**
 *  服务器主机名,可设置
 */
FOUNDATION_EXPORT NSString *const Host_name;

#pragma mark - 服务器标示 -
/**
 *  服务器标示
 */
FOUNDATION_EXPORT NSString *const Client_resource;



@interface JJConfigureFile : NSObject

@end
