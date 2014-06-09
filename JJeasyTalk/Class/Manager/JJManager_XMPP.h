//
//  JJManager_XMPP.h
//  JJeasyTalk
//
//  Created by 张明磊 on 14-2-19.
//  Copyright (c) 2014年 lvgou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"

@class JJModel_user;

@interface JJManager_XMPP : NSObject<XMPPRosterDelegate>

@property (nonatomic, assign, readonly) XMPPStream *xmppStream;
@property (nonatomic, assign, readonly) XMPPReconnect *xmppReconnect;

#pragma mark - 用户圈记录 -
/**
 *  用户圈记录
 */
@property (nonatomic, assign) XMPPRoster *xmppRoster;
@property (nonatomic, assign) XMPPRosterCoreDataStorage *xmppRosterStorage;

#pragma mark - 消息记录 -
/**
 *  消息记录
 */
@property (nonatomic, assign) XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingCoreDataStorage;
@property (nonatomic, assign) XMPPMessageArchiving *xmppMessageArchivingModule;

#pragma mark - 标示在线状态 -
/**
 *  标示在线状态
 */
@property (nonatomic, assign) BOOL bool_inOnline;

#pragma mark - 单例 -
/**
 *  单例
 */
+ (JJManager_XMPP *)sharedInstance;

#pragma mark - 链接到服务器 -
/**
 *  链接到服务器
 */
- (BOOL)connectToService;

#pragma mark - 断开服务器连接 -
/**
 *  断开服务器连接
 */
- (void)disConnectService;

#pragma mark - 用户注册 -
/**
 *  用户注册
 */
- (void)registedInServiceWithModel:(JJModel_user *)model_user;

#pragma mark - 用户登陆 -
/**
 *  用户登陆
 */
- (void)loginToServiceWithModel:(JJModel_user *)model_user;

#pragma mark - 下线操作 -
/**
 *  下线操作
 */
- (void)goOffline;

#pragma mark - 添加好友 -
/**
 *  添加好友
 *
 *  @param name 名字
 */
- (void)addFriendSubscribeWithName:(NSString *)name;

@end
