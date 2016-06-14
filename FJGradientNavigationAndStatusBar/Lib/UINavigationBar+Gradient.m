//
//  UINavigationBar+Gradient.m
//  FJGradientNavigationAndStatusBar
//
//  Created by fjf on 16/6/13.
//  Copyright © 2016年 fjf. All rights reserved.
//

#import "UINavigationBar+Gradient.h"


@implementation UINavigationBar (Gradient)

- (void)fj_setImageViewAlpha:(CGFloat)alpha
{
    for (UIView *tmpView in self.subviews) {
        if ([tmpView isKindOfClass:[UIImageView class]]) {
            tmpView.alpha = alpha;
        }
    }
}

- (void)fj_setTranslationY:(CGFloat)translationY
{
    self.transform = CGAffineTransformMakeTranslation(0, self.transform.ty + translationY);
}


- (void)fj_moveByTranslationY:(CGFloat)translationY
{
    self.transform = CGAffineTransformMakeTranslation(0, translationY);
}

@end
