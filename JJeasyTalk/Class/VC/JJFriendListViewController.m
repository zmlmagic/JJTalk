//
//  JJFriendListViewController.m
//  JJeasyTalk
//
//  Created by 张明磊 on 14-2-20.
//  Copyright (c) 2014年 lvgou. All rights reserved.
//

#import "JJFriendListViewController.h"

typedef NS_ENUM(NSInteger, JJButtonTag)
{
    JJButtonTag_addFriend      = 0,
};

@interface JJFriendListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *array_data;


@end

@implementation JJFriendListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self installFriendView_title];
    [self installFriendView_data];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化title -
/**
 *  初始化title
 */
- (void)installFriendView_title
{
    UIView *view_title = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 64)];
    [view_title setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:view_title];
    IOS7(view_title);
    
    UILabel *label_title = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, self.view.frame.size.width, 30)];
    [label_title setBackgroundColor:[UIColor clearColor]];
    [label_title setTextColor:[UIColor whiteColor]];
    [label_title setTextAlignment:NSTextAlignmentCenter];
    [label_title setFont:[UIFont systemFontOfSize:20.0f]];
    [view_title addSubview:label_title];
    [label_title setText:@"好友列表"];
    
    UIButton *button_addFriend = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [button_addFriend setFrame:CGRectMake(200, 25, 30, 30)];
    [view_title addSubview:button_addFriend];
    button_addFriend.tag = JJButtonTag_addFriend;
    [button_addFriend addTarget:self action:@selector(didClickButton_friendList:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - 初始化朋友数据 -
/**
 *  初始化朋友数据
 */
- (void)installFriendView_data
{
    NSManagedObjectContext *context = [[JJManager_XMPP sharedInstance].xmppRosterStorage mainThreadManagedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    NSError *error ;
    NSArray *friends = [context executeFetchRequest:request error:&error];
    if(!_array_data)
    {
        NSMutableArray *array_tmp = [NSMutableArray arrayWithCapacity:8];
        _array_data = array_tmp;
        [_array_data addObjectsFromArray:friends];
    }
    else
    {
        [_array_data removeAllObjects];
        [_array_data addObjectsFromArray:friends];
    }
    
    UITableView *tableView_friend = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 320, 400)];
    tableView_friend.delegate = self;
    tableView_friend.dataSource = self;
    [self.view addSubview:tableView_friend];
}

#pragma mark - 初始化好友列表 -
/**
 *  初始化好友列表
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_array_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    XMPPUserCoreDataStorageObject *object = [_array_data objectAtIndex:indexPath.row];
    NSString *name = [object displayName];
    if (!name) {
        name = [object nickname];
    }
    if (!name) {
        name = [object jidStr];
    }
    cell.textLabel.text = name;
    cell.detailTextLabel.text = [[[object primaryResource] presence] status];
    cell.tag = indexPath.row;
    return cell;
}

#pragma mark - 按钮点击事件 -
/**
 *  按钮点击事件
 */
- (void)didClickButton_friendList:(UIButton *)button_click
{
    switch (button_click.tag)
    {
        case JJButtonTag_addFriend:
        {
            [[JJManager_XMPP sharedInstance] addFriendSubscribeWithName:@"xiangyu"];
        }break;
        default:
            break;
    }
}


/* -(void)xmppRoom:(XMPPRoom *)sender didFetchConfigurationForm:(DDXMLElement *)configForm { NSXMLElement *newConfig = [configForm copy]; NSArray* fields = [newConfig elementsForName:@"field"]; for (NSXMLElement *field in fields) { NSString *var = [field attributeStringValueForName:@"var"]; if ([var isEqualToString:@"muc#roomconfig_persistentroom"]) { [field removeChildAtIndex:0]; [field addChild:[NSXMLElement elementWithName:@"value" stringValue:@"1"]]; } } [sender configureRoomUsingOptions:newConfig]; }*/

@end
