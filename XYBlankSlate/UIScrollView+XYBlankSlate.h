//
//  UIScrollView+XYBlankSlate.h
//  XYBlankSlateDemo
//
//  Created by xiayingying on 2018/8/31.
//  Copyright © 2018年 ejl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYBlankSlateHanlder;

@interface UIScrollView (XYBlankSlate)

/** 空白状态配置项 */
@property (nonatomic,strong) XYBlankSlateHanlder *xy_handler;

@end
