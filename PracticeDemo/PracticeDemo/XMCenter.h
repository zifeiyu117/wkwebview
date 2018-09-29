//
//  XMCenter.h
//  PracticeDemo
//
//  Created by xyt on 2018/9/26.
//  Copyright © 2018年 xyt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestModel.h"

@interface XMCenter : NSObject

+(void)sendRequest:(void(^)(RequestModel*model))configBlock;

@end
