
//
//  UITabBar+Gradient.m
//  FJGradientNavigationAndStatusBar
//
//  Created by fjf on 16/6/13.
//  Copyright © 2016年 fjf. All rights reserved.
//

#import "UITabBar+Gradient.h"

@implementation UITabBar (Gradient)

- (void)fj_setTranslationY:(CGFloat)translationY
{
    self.transform = CGAffineTransformMakeTranslation(0, self.transform.ty - translationY);
}

- (void)fj_moveByTranslationY:(CGFloat)translationY
{
    self.transform = CGAffineTransformMakeTranslation(0, translationY);
}


- (void)fj_setImageViewAlpha:(CGFloat)alpha
{
    self.alpha = alpha;
}

@end
