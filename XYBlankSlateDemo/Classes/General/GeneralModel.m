//
//  GeneralModel.m
//  XYBlankSlateDemo
//
//  Created by xiayingying on 2018/8/31.
//  Copyright © 2018年 ejl. All rights reserved.
//

#import "GeneralModel.h"

@implementation GeneralModel

- (NSMutableArray *)images {
    if (_images) {
        return _images;
    }
    
    _images = [NSMutableArray array];
    
    return _images;
}

@end
