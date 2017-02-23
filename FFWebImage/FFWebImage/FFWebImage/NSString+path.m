//
//  NSString+path.m
//  异步加载网络图片
//
//  Created by smile on 17/2/22.
//  Copyright © 2017年 haha. All rights reserved.
//

#import "NSString+path.h"

@implementation NSString (path)

- (NSString *)appendCache{
    // 获取路径
    NSString *file = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, true).lastObject;
    NSLog(@"%@",file);
    // 图片名字
    NSString *name = [self lastPathComponent];
    
    // 全路径
    NSString *fileName = [file stringByAppendingPathComponent:name];
    return fileName;
}

@end
