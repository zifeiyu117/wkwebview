
//
//  XMCenter.m
//  PracticeDemo
//
//  Created by xyt on 2018/9/26.
//  Copyright © 2018年 xyt. All rights reserved.
//

#import "XMCenter.h"

@implementation XMCenter

+(void)sendRequest:(void (^)(RequestModel *))configBlock{
    RequestModel *model = [[RequestModel alloc]init];
    configBlock(model);
    NSLog(@"打印数据");
}

@end
