//
//  UIScrollView+XYBlankSlate.m
//  XYBlankSlateDemo
//
//  Created by xiayingying on 2018/8/31.
//  Copyright © 2018年 ejl. All rights reserved.
//

#import "UIScrollView+XYBlankSlate.h"
#import "XYBlankSlateHanlder.h"
#import <objc/runtime.h>

@implementation UIScrollView (XYBlankSlate)

#pragma mark - handler
- (void)setXy_handler:(XYBlankSlateHanlder *)xy_handler {
    if (xy_handler != self.xy_handler) {
        [self willChangeValueForKey:@"xy_handler"]; // KVO
        objc_setAssociatedObject(self, @selector(xy_handler), xy_handler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        xy_handler.scrollView = self;
        [self didChangeValueForKey:@"xy_handler"]; // KVO
    }
}

- (XYBlankSlateHanlder *)xy_handler {
    return objc_getAssociatedObject(self, @selector(xy_handler));
}

@end
