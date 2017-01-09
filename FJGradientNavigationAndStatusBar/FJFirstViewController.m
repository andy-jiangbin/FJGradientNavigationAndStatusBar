//
//  ViewController.m
//  FJGradientNavigationAndStatusBar
//
//  Created by fjf on 16/6/12.
//  Copyright © 2016年 fjf. All rights reserved.
//

#import "FJFirstViewController.h"

@interface FJFirstViewController ()

@end

@implementation FJFirstViewController

#pragma mark --- life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpTableView];
    
    [self setUpNavigationBar];
}


#pragma mark --- private method

// 设置 tableView 属性
- (void)setUpTableView {
    self.tableView.frame = CGRectMake(0, -kNavigationBarHeight, kScreenWidth, kScreenHeight + kNavigationBarHeight);
    self.tableView.contentInset = UIEdgeInsetsMake(kNavigationBarHeight, 0, 0, 0);
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

// 设置 导航栏
- (void)setUpNavigationBar {
    [super setUpNavigationBar];
    self.navigationItem.title = @"导航栏(背景图)";
}

#pragma mark --- custom delegate

/***************************************** UITableViewDelegate 和 UITableViewDataSource *****************************************/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld行", indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"第%ld行", indexPath.row);
}
@end
