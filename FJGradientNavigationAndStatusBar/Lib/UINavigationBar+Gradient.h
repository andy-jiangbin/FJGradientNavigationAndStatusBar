//
//  UINavigationBar+Gradient.h
//  FJGradientNavigationAndStatusBar
//
//  Created by fjf on 16/6/13.
//  Copyright © 2016年 fjf. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NavigationBarStatusType) {
    NavigationBarStatusOfTypeNormal = 0,
    NavigationBarStatusOfTypeHidden,
    NavigationBarStatusOfTypeShow,
};

@interface UINavigationBar (Gradient)

- (void)fj_setImageViewAlpha:(CGFloat)alpha;

- (void)fj_setTranslationY:(CGFloat)translationY;

- (void)fj_moveByTranslationY:(CGFloat)translationY;

@end
