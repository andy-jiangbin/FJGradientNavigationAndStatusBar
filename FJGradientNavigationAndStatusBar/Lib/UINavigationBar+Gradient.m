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
    CGFloat transfromTy = self.transform.ty + translationY;
    if (transfromTy > 0) {
        transfromTy = 0;
    }else if(transfromTy < -(self.frame.size.height + 20)){
        transfromTy = -(self.frame.size.height + 20);
    }
    self.transform = CGAffineTransformMakeTranslation(0, transfromTy);
}


- (void)fj_moveByTranslationY:(CGFloat)translationY
{
    self.transform = CGAffineTransformMakeTranslation(0, translationY);
}

@end
