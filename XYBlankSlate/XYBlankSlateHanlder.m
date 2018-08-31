//
//  XYBlankSlateHanlder.m
//  XYBlankSlateDemo
//
//  Created by xiayingying on 2018/8/31.
//  Copyright © 2018年 ejl. All rights reserved.
//

#import "XYBlankSlateHanlder.h"

NSInteger const XYDataLoadStateAll = XYDataLoadStateIdle | XYDataLoadStateLoading | XYDataLoadStateEmpty |XYDataLoadStateFailed;

@implementation XYBlankSlateHanlder

#pragma mark - Lifecycle
- (instancetype)init {
    
    self = [super init];
    if (!self) {
        return nil;
    }
    [self configure];
    
    return self;
}

#pragma mark - Setter
- (void)setScrollView:(UIScrollView *)scrollView {
    
    if (scrollView && ![scrollView isKindOfClass:[UIScrollView class]]) return;
    scrollView.emptyDataSetSource = self;
    scrollView.emptyDataSetDelegate = self;
    _scrollView = scrollView;
}

- (void)setState:(XYDataLoadState)state {
    
    //只能设置单个状态，不能设置多个状态
    BOOL singleState = state == XYDataLoadStateIdle || state == XYDataLoadStateLoading || state == XYDataLoadStateEmpty || state == XYDataLoadStateFailed;
    NSAssert(singleState, @"state is unavailable(do not use multiple options)");
    _state = state;
    [self.scrollView reloadEmptyDataSet];
    
}

#pragma mark - Other
- (void)configure {
    // 初始配置写在这里
    self.state = XYDataLoadStateIdle;
}

@end
