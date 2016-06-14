
//
//  FJBaseTableViewController.m
//  LTNavigationBar
//
//  Created by fjf on 16/6/13.
//  Copyright © 2016年 ltebean. All rights reserved.
//

#import "UITabBar+Gradient.h"
#import "FJBaseTableViewController.h"
#import "UINavigationBar+Gradient.h"

@interface FJBaseTableViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    CGFloat _originalOffsetY; //上一次偏移量
}
@end

@implementation FJBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setUpNavigationBar];
}


- (void)setUpNavigationBar{
    //适配ios7
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    UINavigationBar *navBar = [self.navigationController navigationBar];
    if ([navBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        [navBar setBackgroundImage:[UIImage imageNamed:@"navi_bar_black.png"] forBarMetrics:UIBarMetricsDefault];
    }

}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"PlainTableViewControllerIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark --- UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat bottomOffset = scrollView.contentSize.height - scrollView.contentOffset.y - scrollView.frame.size.height;
    if (scrollView.contentOffset.y > - (2*kNavigationBarHeight) && bottomOffset > 0) {
        CGFloat offsetY = scrollView.contentOffset.y - _originalOffsetY;
        [self moveNavigationBarAndStatusBarByOffsetY:offsetY];
        _originalOffsetY = scrollView.contentOffset.y;
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self restoreNavigationBarAndStatusBarWithContentOffset:scrollView.contentOffset];
}

#pragma mark --- offset way
// 显示navigationBar 和 tabbar
- (void)showNavigationBarAndStatusBar{
    [self setNavigationBarTransformProgress:0 navigationBarStatusType:NavigationBarStatusOfTypeShow];
    [self setStatusBarTransformProgress:0 statusBarStatusType:StatusBarStatusTypeOfShow];
}

//隐藏navigationBar 和 tabbar
- (void)hideNavigationBarAndStatusBar{
    [self setNavigationBarTransformProgress:1 navigationBarStatusType:NavigationBarStatusOfTypeHidden];
    [self setStatusBarTransformProgress:1 statusBarStatusType:StatusBarStatusTypeOfHidden];
}


//恢复或隐藏navigationBar和statusBar
- (void)restoreNavigationBarAndStatusBarWithContentOffset:(CGPoint)contentOffset {
    CGFloat navigationBarCenterHeight  = kNavigationBarHeight/2.0;
    CGFloat transformTy = self.navigationController.navigationBar.transform.ty;
    if (transformTy < 0 && transformTy > -kNavigationBarHeight) {
        if (transformTy < -navigationBarCenterHeight && contentOffset.y > -navigationBarCenterHeight) {
            [UIView animateWithDuration:kDefaultAnimationTime animations:^{
                [self hideNavigationBarAndStatusBar];
            }];
            
        }else {
            [UIView animateWithDuration:kDefaultAnimationTime animations:^{
                [self showNavigationBarAndStatusBar];
            }];
        }
    }
}


// 通过偏移量移动NavigationBar和StatusBar
- (void)moveNavigationBarAndStatusBarByOffsetY:(CGFloat)offsetY {
    CGFloat transformTy = self.navigationController.navigationBar.transform.ty;
    CGFloat tabbarTransformTy = self.tabBarController.tabBar.transform.ty;
    
    if (offsetY > 0) {
        if (fabs(transformTy) >= kNavigationBarHeight) {
            [self setNavigationBarTransformProgress:1 navigationBarStatusType:NavigationBarStatusOfTypeHidden];
        } else {
            [self setNavigationBarTransformProgress:offsetY navigationBarStatusType:NavigationBarStatusOfTypeNormal];
        }
        
        if (fabs(tabbarTransformTy) >= kStatusBarHeight) {
            [self setStatusBarTransformProgress:1 statusBarStatusType:StatusBarStatusTypeOfHidden];
        } else {
            [self setStatusBarTransformProgress:offsetY statusBarStatusType:StatusBarStatusTypeOfNormal];
        }
        
    } else if(offsetY < 0){
        if (transformTy < 0 && fabs(transformTy) <= kNavigationBarHeight) {
            [self setNavigationBarTransformProgress:offsetY navigationBarStatusType:NavigationBarStatusOfTypeNormal];
        } else {
            [self setNavigationBarTransformProgress:0 navigationBarStatusType:NavigationBarStatusOfTypeShow];
        }
        
        if (tabbarTransformTy <= kStatusBarHeight && tabbarTransformTy > 0) {
            [self setStatusBarTransformProgress:offsetY statusBarStatusType:StatusBarStatusTypeOfNormal];
        } else {
            [self setStatusBarTransformProgress:0 statusBarStatusType:StatusBarStatusTypeOfShow];
        }
    }
 
}

// 根据传入的类型和渐变程度,改变StatusBar的颜色和位置
- (void)setStatusBarTransformProgress:(CGFloat)progress statusBarStatusType:(StatusBarStatusType)statusBarStatusType{
    CGFloat transfromTy = self.tabBarController.tabBar.transform.ty;
    if (statusBarStatusType == StatusBarStatusTypeOfHidden) {
        if (transfromTy != kStatusBarHeight) {
            [self.tabBarController.tabBar fj_moveByTranslationY:kStatusBarHeight * progress];
            [self.tabBarController.tabBar fj_setImageViewAlpha:progress];
        }
    }else if(statusBarStatusType == StatusBarStatusTypeOfNormal) {
        [self.tabBarController.tabBar fj_setTranslationY:-progress];
        CGFloat alpha = 1 - fabs(self.tabBarController.tabBar.transform.ty)/kStatusBarHeight;
        [self.tabBarController.tabBar fj_setImageViewAlpha:alpha];
    }else if(statusBarStatusType == StatusBarStatusTypeOfShow) {
        if (transfromTy != 0) {
            [self.tabBarController.tabBar fj_moveByTranslationY: -kStatusBarHeight * progress];
            [self.tabBarController.tabBar fj_setImageViewAlpha:(1-progress)];
        }
    }
}

// 根据传入的类型和渐变程度,改变NavigationBar的颜色和位置
- (void)setNavigationBarTransformProgress:(CGFloat)progress navigationBarStatusType:(NavigationBarStatusType)navigationBarStatusType{
    CGFloat transfromTy = self.navigationController.navigationBar.transform.ty;
    if (navigationBarStatusType == NavigationBarStatusOfTypeHidden) {
        if(transfromTy != -kNavigationBarHeight){
            [self.navigationController.navigationBar fj_moveByTranslationY:-kNavigationBarHeight * progress];
            [self.navigationController.navigationBar fj_setImageViewAlpha:progress];
        }
    }else if(navigationBarStatusType == NavigationBarStatusOfTypeNormal) {
        [self.navigationController.navigationBar fj_setTranslationY: - progress];
        CGFloat alpha = 1 - fabs(self.navigationController.navigationBar.transform.ty)/kNavigationBarHeight;
        [self.navigationController.navigationBar fj_setImageViewAlpha:alpha];
    }else if(navigationBarStatusType == NavigationBarStatusOfTypeShow) {
        if(transfromTy != 0){
            [self.navigationController.navigationBar fj_moveByTranslationY:-kNavigationBarHeight * progress];
            [self.navigationController.navigationBar fj_setImageViewAlpha:(1-progress)];
        }
    }
}
@end
