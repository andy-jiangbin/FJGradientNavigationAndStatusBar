# FJGradientNavigationAndStatusBar
导航栏和状态栏 上滚渐变隐藏 下拉渐变显示 (备注:上滚一半动画隐藏，未超过一半动画显示)

由于项目需求要做一个这样的功能，所以做好之后，抽取出来，封装了下，希望能帮到有需要的朋友。

# 1.效果图
![UINavigationBar和UITabbar渐变.gif](http://upload-images.jianshu.io/upload_images/2252551-3b2c85bff3411328.gif?imageMogr2/auto-orient/strip)

# 2.思路
## A. 设置tableView

### a.因为当UINavigationBar和UITabBar隐藏的时候，tableView要完全占据整个屏幕，当UINavigationBar和UITabBar显示的时候，tableView又要显示在UINavigationBar下方，所以需要设置tablewView的frame和contentInset：

> self.tableView.frame=CGRectMake(0, -kNavigationBarHeight,kScreenWidth,kScreenHeight+kNavigationBarHeight);

> self.tableView.contentInset=UIEdgeInsetsMake(kNavigationBarHeight,0,0,0);

## B.当tableView向上移动一个属性,UINavigationBar要向上移动一个属性，UITabBar要向下移动一个像素，所以需要在- (void)scrollViewDidScroll:(UIScrollView*)scrollView方法中获取每一次tableView滚动的距离，因此需要记住上次tableView的偏移量距离：CGFloat_originalOffsetY;//上一次偏移量

> CGFloat offsetY = scrollView.contentOffset.y-_originalOffsetY;//获取每次滚动偏移的距离

> _originalOffsetY= scrollView.contentOffset.y;//将这次tableView偏移量重新赋值给_originalOffsetY

又因为当UINavigationBar和UITabBar已经隐藏，继续向上滚动，已经不需要隐藏，同样的当tableView滚动到最后滚不动的时候UINavigationBar和UITabBar也不需要移动，所以添加判断条件

> CGFloat bottomOffset = scrollView.contentSize.height- scrollView.contentOffset.y- scrollView.frame.size.height; //判断是否滚动到底部

> scrollView.contentOffset.y> - (2*kNavigationBarHeight)//判断UINavigationBar是否已经隐藏

//UIScrollView 函数

> - (void)scrollViewDidScroll:(UIScrollView*)scrollView {

> CGFloat bottomOffset = scrollView.contentSize.height- scrollView.contentOffset.y- scrollView.frame.size.height;

> if(scrollView.contentOffset.y> - (2*kNavigationBarHeight) && bottomOffset >0) {

> CGFloat offsetY = scrollView.contentOffset.y-_originalOffsetY;

> [self moveNavigationBarAndStatusBarByOffsetY:offsetY];
> }
> _originalOffsetY= scrollView.contentOffset.y;
> }

## C.moveNavigationBarAndStatusBarByOffsetY函数设置UINavigationBar和UITabBar相关transform.ty位置的值，同时设置相关背景图片的透明度

// 通过偏移量移动NavigationBar和StatusBar
- (void)moveNavigationBarAndStatusBarByOffsetY:(CGFloat)offsetY {
    
    CGFloat transformTy = self.navigationController.navigationBar.transform.ty;
    CGFloat tabbarTransformTy = self.tabBarController.tabBar.transform.ty;
    // 向上滚动
    if (offsetY > 0) {
        if (fabs(transformTy) >= kNavigationBarHeight) {
            //当NavigationBar的transfrom.ty大于NavigationBar高度，导航栏离开可视范围，设置NavigationBar隐藏
            [self setNavigationBarTransformProgress:1 navigationBarStatusType:NavigationBarStatusOfTypeHidden];
        } else {
            //当NavigationBar的transfrom.ty小于NavigationBar高度，导航栏在可视范围内，设置NavigationBar偏移位置和背景透明度
            [self setNavigationBarTransformProgress:offsetY navigationBarStatusType:NavigationBarStatusOfTypeNormal];
        }
        
        if (fabs(tabbarTransformTy) >= kStatusBarHeight) {
            //当StatusTabBar的transfrom.ty大于StatusTabBar高度，导航栏离开可视范围，设置StatusTabBar隐藏
            [self setStatusBarTransformProgress:1 statusBarStatusType:StatusBarStatusTypeOfHidden];
        } else {
            //当当StatusTabBar的transfrom.ty小于StatusTabBar高度，导航栏在可视范围内，设置StatusTabBar偏移位置和背景透明度
            [self setStatusBarTransformProgress:offsetY statusBarStatusType:StatusBarStatusTypeOfNormal];
        }
  // 向下滚动
    } else if(offsetY < 0){
        if (transformTy < 0 && fabs(transformTy) <= kNavigationBarHeight) {
            //当NavigationBar的transfrom.ty小于NavigationBar高度，导航栏进入可视范围内，设置NavigationBar偏移位置和背景透明度
            [self setNavigationBarTransformProgress:offsetY navigationBarStatusType:NavigationBarStatusOfTypeNormal];
        } else {
            //当NavigationBar的transfrom.ty超过NavigationBar原来位置，设置NavigationBar显示
            [self setNavigationBarTransformProgress:0 navigationBarStatusType:NavigationBarStatusOfTypeShow];
        }
        
        if (tabbarTransformTy <= kStatusBarHeight && tabbarTransformTy > 0) {
            //当StatusTabBar的transfrom.ty小于StatusTabBar高度，导航栏进入可视范围内，设置StatusTabBar偏移位置和背景透明度
            [self setStatusBarTransformProgress:offsetY statusBarStatusType:StatusBarStatusTypeOfNormal];
        } else {
            //当StatusTabBar的transfrom.ty超过StatusTabBar原来位置，设置StatusTabBar显示
            [self setStatusBarTransformProgress:0 statusBarStatusType:StatusBarStatusTypeOfShow];
        }
    }
}

## D.通过这两个函数- (void)setStatusBarTransformProgress:(CGFloat)progress statusBarStatusType:(StatusBarStatusType)statusBarStatusType和 (void)setNavigationBarTransformProgress:(CGFloat)progress navigationBarStatusType:(NavigationBarStatusType)navigationBarStatusType改变NavigationBarStatusTabBar背景图透明图和颜色

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
## E.设置UITabBar和UINavigationBar类方法
// 设置背景图透明度
- (void)fj_setImageViewAlpha:(CGFloat)alpha;
// 根据translationY在原来位置上偏移
- (void)fj_setTranslationY:(CGFloat)translationY;
// 设置偏移translationY
- (void)fj_moveByTranslationY:(CGFloat)translationY;
## F.在- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate函数里面判断当前NavigationBar偏移是否超过一半，如果一半则动画隐藏，如果没有则动画显示:

//恢复或隐藏navigationBar和statusBar
- (void)restoreNavigationBarAndStatusBarWithContentOffset:(CGPoint)contentOffset {
    CGFloat navigationBarCenterHeight  = kNavigationBarHeight/2.0;
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

## G.最后这是[demo](https://github.com/fangjinfeng/FJGradientNavigationAndStatusBar)，大家有兴趣可以看一下，如果觉得不错，麻烦给个喜欢或星，谢谢！
