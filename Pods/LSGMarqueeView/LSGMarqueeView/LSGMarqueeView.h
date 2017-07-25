//
//  WZMarqueeView.h
//  WZMarqueeViewDemo
//
//  Created by wangzz on 14-3-2.
//  Copyright (c) 2014年 foogry. All rights reserved.
//  version 1.0.2

#import <UIKit/UIKit.h>

@interface LSGMarqueeView : UIView

@property (nonatomic, strong) UILabel *lable;
@property (nonatomic) NSTimeInterval duration;

- (void)showInView:(UIView *)view;

@end
