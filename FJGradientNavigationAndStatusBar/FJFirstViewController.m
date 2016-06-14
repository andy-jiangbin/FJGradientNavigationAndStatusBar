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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpTableView];
    [self setUpNavigationBar];
}


- (void)setUpTableView {
    self.tableView.frame = CGRectMake(0, -kNavigationBarHeight, kScreenWidth, kScreenHeight + kNavigationBarHeight);
    self.tableView.contentInset = UIEdgeInsetsMake(kNavigationBarHeight, 0, 0, 0);
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (void)setUpNavigationBar{
    self.navigationItem.title = @"导航栏(背景图)";
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
}

#pragma mark UITableViewDatasource

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


@end
