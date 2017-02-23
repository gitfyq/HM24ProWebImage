//
//  DownloaderOperation.m
//  FFWebImage
//
//  Created by smile on 17/2/23.
//  Copyright © 2017年 haha. All rights reserved.
//

#import "DownloaderOperation.h"

@implementation DownloaderOperation

- (void)main{
    NSLog(@"图片地址:%@",self.URLStr);
    [NSThread sleepForTimeInterval:15];
//    NSLog(@"%@",[NSThread currentThread]);
    NSURL *URL = [NSURL URLWithString:self.URLStr];
    NSData *data = [NSData dataWithContentsOfURL:URL];
    UIImage *image = [UIImage imageWithData:data];
    
    // 实现沙盒缓存
    if (image != nil) {
        [data writeToFile:[self.URLStr appendCache] atomically:YES];
    }
    
    if (self.isCancelled) {
        return;
    }
    
    NSAssert(self.successBlock != nil, @"山炮！请实例化block");
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.successBlock(image);
    }];
    
}

+(instancetype)downloadImageWithURLStr:(NSString *)URLStr successBlock:(void(^)(UIImage *image))successBlock{
    DownloaderOperation *op = [[DownloaderOperation alloc] init];
    op.URLStr = URLStr;
    op.successBlock = successBlock;
    return op;
}

@end
