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

//动画默认时间
#define kDefaultAnimationTime 0.3

//navigationBarHeight的高度
#define   kNavigationBarHeight 64

//statusBar的高度
#define   kStatusBarHeight self.tabBarController.tabBar.frame.size.height



#import <UIKit/UIKit.h>

@interface FJBaseTableViewController : UIViewController
// tableView
@property (nonatomic, strong) UITableView *tableView;
// 设置 导航栏
- (void)setUpNavigationBar;
@end
