//
//  FJBaseTableViewController.h
//  LTNavigationBar
//
//  Created by fjf on 16/6/13.
//  Copyright © 2016年 ltebean. All rights reserved.
//

//获取当前屏幕的宽高
#define  kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define  kScreenHeight [[UIScreen mainScreen] bounds].size.height

#import <UIKit/UIKit.h>

@interface FJBaseTableViewController : UIViewController
@property (nonatomic, strong)UITableView *tableView;
@end
