//
//  JJManager_XMPP.m
//  JJeasyTalk
//
//  Created by 张明磊 on 14-2-19.
//  Copyright (c) 2014年 lvgou. All rights reserved.
//

#import "JJManager_XMPP.h"

static JJManager_XMPP *xmppManager = nil;

@implementation JJManager_XMPP

#pragma mark - 单例 -
/**
 *  单例
 *
 *  @return JJManager_XMPP
 */
+ (JJManager_XMPP *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,
    ^{
        xmppManager = [[self alloc] init];
    });
    return xmppManager;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        [self setupXmppStream];
    }
    return self;
}

#pragma mark - 初始化XmppStream -
/**
 *  初始化XmppStream
 */
- (void)setupXmppStream
{
    XMPPStream *stream_tmp = [[XMPPStream alloc] init];
	_xmppStream = stream_tmp;
#if !TARGET_IPHONE_SIMULATOR
    //支持后台操作
    _xmppStream.enableBackgroundingOnSocket = YES;
#endif
	//初始化链接
    XMPPReconnect *reconnect_tmp = [[XMPPReconnect alloc] init];
	_xmppReconnect = reconnect_tmp;
    
    [_xmppReconnect         activate:_xmppStream];
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [_xmppStream setHostName:Host_IP];
    [_xmppStream setHostPort:Port];
    
    NSString *string_userName = [[NSUserDefaults standardUserDefaults] objectForKey:JJUserName];
    if(!string_userName)
    {
        string_userName = nil;
    }
    XMPPJID *jid_tmp = [XMPPJID jidWithUser:string_userName domain:Host_name resource:Client_resource];
    _xmppStream.myJID = jid_tmp;
    
    [self configureAttribute];
    
    //记录初始化
    XMPPRosterCoreDataStorage *xmppStorage_tmp = [[XMPPRosterCoreDataStorage alloc] init];
    _xmppRosterStorage = xmppStorage_tmp;
    //	xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] initWithInMemoryStore];
	XMPPRoster *xmppRoster_tmp = [[XMPPRoster alloc] initWithRosterStorage:_xmppRosterStorage];
	_xmppRoster = xmppRoster_tmp;
	_xmppRoster.autoFetchRoster = YES;
	_xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
    [_xmppRoster activate:_xmppStream];
    [_xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    XMPPMessageArchivingCoreDataStorage *xmppArchiving_tmp = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    _xmppMessageArchivingCoreDataStorage = xmppArchiving_tmp;
    XMPPMessageArchiving *xmpp_Module = [[XMPPMessageArchiving alloc]initWithMessageArchivingStorage:_xmppMessageArchivingCoreDataStorage];
    _xmppMessageArchivingModule = xmpp_Module;
    [_xmppMessageArchivingModule setClientSideMessageArchivingOnly:YES];
    [_xmppMessageArchivingModule activate:_xmppStream];
    [_xmppMessageArchivingModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

#pragma mark - 初始化属性 -
/**
 *  初始化属性
 */
- (void)configureAttribute
{
    _bool_inOnline = NO;
}

#pragma mark - 链接到服务器 -
/**
 *  链接到服务器
 */
- (BOOL)connectToService
{
    if (![_xmppStream isDisconnected])
    {
		return YES;
	}
    
    NSError *error = nil;
	if (![_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
	{
        NSLog(@"%@",error);
		return NO;
	}
    
    return YES;
}

#pragma mark - 连接回调 -
/**
 *  连接回调
 */
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    NSLog(@"连接建立成功.");
}


#pragma mark - 断开服务器连接 -
/**
 *  断开服务器连接
 */
- (void)disConnectService
{
    if ([_xmppStream isDisconnected])
    {
		return;
	}
	[_xmppStream disconnect];
    //注销时候调用
    //[_xmppStream removeDelegate:self];
	//[_xmppReconnect deactivate];
    //[_xmppRoster removeDelegate:self];
	//[_xmppRoster deactivate];
    //[_xmppMessageArchivingModule removeDelegate:self];
    //[_xmppMessageArchivingModule deactivate];
}

#pragma mark - 断连回调 -
/**
 *  断连回调
 */
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
	NSLog(@"连接中断,%@",error);
}

#pragma mark - 用户注册 -
/**
 *  用户注册
 *
 *  @param model_user 用户注册
 */
- (void)registedInServiceWithModel:(JJModel_user *)model_user
{
    NSError *error = nil;
    XMPPJID *jid_tmp = [XMPPJID jidWithUser:model_user.string_userAccount domain:Host_name resource:Client_resource];
    _xmppStream.myJID = nil;
    _xmppStream.myJID = jid_tmp;
    if(![_xmppStream registerWithPassword:model_user.string_userPassword error:&error])
    {
        NSLog(@"%@",error);
    }
}

#pragma mark - 注册成功回调 -
/**
 *  注册成功回调
 */
- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    NSLog(@"注册成功!");
}

#pragma mark - 注册失败回调 -
/**
 *  注册失败回调
 */
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error
{
    NSLog(@"注册失败,当前用户已经存在");
}

#pragma mark - 用户登陆 -
/**
 *  用户登陆
 */
- (void)loginToServiceWithModel:(JJModel_user *)model_user
{
    if ([_xmppStream isDisconnected])
    {
        NSLog(@"未连接到服务器");
		return;
	}
    
    NSError *error = nil;
    XMPPJID *jid_tmp = [XMPPJID jidWithUser:model_user.string_userAccount domain:Host_name resource:Client_resource];
    _xmppStream.myJID = nil;
    _xmppStream.myJID = jid_tmp;
    
    //验证身份
    if (![_xmppStream authenticateWithPassword:model_user.string_userPassword error:&error])
	{
        NSLog(@"%@",error);
	}
}

#pragma mark - 验证成功 -
/**
 *  验证成功
 */
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
	NSLog(@"验证通过!");
	[self goOnline];
}

#pragma mark - 验证失败 -
/**
 *  验证失败
 */
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
	NSLog(@"验证失败:%@",error);
}

#pragma mark - 上线操作 -
/**
 *  上线操作
 */
- (void)goOnline
{
    XMPPPresence *presence = [XMPPPresence presence];
    //默认类型available
    //XMPPPresence *presence = [XMPPPresence presenceWithType:@"available"];
	[_xmppStream sendElement:presence];
    _bool_inOnline = YES;
    NSLog(@"上线!");
}

#pragma mark - 下线操作 - 
/**
 *  下线操作
 */
- (void)goOffline
{
	XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
	[_xmppStream sendElement:presence];
    _bool_inOnline = NO;
    NSLog(@"下线!");
}

#pragma mark - 添加好友 -
/**
 *  添加好友
 *
 *  @param name 名字
 */
- (void)addFriendSubscribeWithName:(NSString *)name
{
    XMPPJID *jid = [XMPPJID jidWithUser:name domain:Host_name resource:Client_resource];
    [_xmppRoster subscribePresenceToUser:jid];
}

#pragma mark - 添加好友回调 -
/**
 *  添加好友回调
 */
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    //取得好友状态
    NSString *presenceType = [NSString stringWithFormat:@"%@", [presence type]]; //online/offline
    //请求的用户
    NSString *presenceFromUser =[NSString stringWithFormat:@"%@", [[presence from] user]];
    NSLog(@"presenceType:%@",presenceType);
    NSLog(@"presence2:%@  sender2:%@",presence,sender);
    XMPPJID *jid = [XMPPJID jidWithString:presenceFromUser];
    [_xmppRoster acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];
}

//收到消息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    NSLog(@"message = %@", message);
    NSString *msg = [[message elementForName:@"body"] stringValue];
    NSString *from = [[message attributeForName:@"from"] stringValue];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:msg forKey:@"msg"];
    [dict setObject:from forKey:@"sender"];
    //消息接收到的时间
    //[dict setObject:[Statics getCurrentTime] forKey:@"time"];
    //消息委托(这个后面讲)
    //[messageDelegate newMessageReceived:dict];
}

//收到好友状态
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence{
    NSLog(@"presence = %@", presence);
    //取得好友状态
    NSString *presenceType = [presence type]; //online/offline
    //当前用户
    NSString *userId = [[sender myJID] user];
    //在线用户
    NSString *presenceFromUser = [[presence from] user];
    if (![presenceFromUser isEqualToString:userId]) {
        //在线状态
        if ([presenceType isEqualToString:@"available"]) {
            //用户列表委托(后面讲)
            //[chatDelegate newBuddyOnline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, @"nqc1338a"]];
        }else if ([presenceType isEqualToString:@"unavailable"]) {
            //用户列表委托(后面讲)
            //[chatDelegate buddyWentOffline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, @"nqc1338a"]];
        }
    }
}

@end
