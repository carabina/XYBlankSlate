//
//  GeneralViewModel.h
//  XYBlankSlateDemo
//
//  Created by xiayingying on 2018/8/31.
//  Copyright © 2018年 ejl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GeneralModel.h"

@interface GeneralViewModel : NSObject

@property (nonatomic, strong) NSArray<GeneralModel *>    *list;

- (void)queryListWithPage:(NSUInteger)page success:(void(^)(void))success failure:(void(^)(NSError *error))failure;

@end
