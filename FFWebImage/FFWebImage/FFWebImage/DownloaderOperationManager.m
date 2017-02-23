//
//  DownloaderOperationManager.m
//  FFWebImage
//
//  Created by smile on 17/2/23.
//  Copyright © 2017年 haha. All rights reserved.
//

#import "DownloaderOperationManager.h"

@interface DownloaderOperationManager ()
@property (nonatomic, strong) NSOperationQueue *queue;
// 保存所有的操作
@property (nonatomic, strong) NSMutableDictionary *opCache;
// 图片缓存池
@property (nonatomic, strong) NSMutableDictionary *imagesCaches;

@end

@implementation DownloaderOperationManager

+(instancetype)shareManager{
    static DownloaderOperationManager * instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init{
    if (self = [super init]) {
        self.queue = [NSOperationQueue new];
        self.opCache = [[NSMutableDictionary alloc] init];
        self.imagesCaches = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)downloadImageWithURLStr:(NSString *)URLStr successBlock:(void(^)(UIImage *image))successBlock{
    
    // 判断如果内存中有图片直接使用
    if ([self.imagesCaches objectForKey:URLStr]) {
        if (successBlock != nil) {
            NSLog(@"从内存中取图片");
            successBlock([self.imagesCaches objectForKey:URLStr]);
            return;
        }
    }
    
    // 获取沙盒图片
    UIImage *memImage = [UIImage imageWithContentsOfFile:[URLStr appendCache]];
    
    if (memImage != nil) {
        if (successBlock != nil) {
            NSLog(@"从沙盒中取图片");
            // 保存到内存中一份
            [self.imagesCaches setObject:memImage forKey:URLStr];
            successBlock(memImage);
            return;
        }
    }
    
    if ([self.opCache objectForKey:URLStr]) {
        return;
    }
    
    
    DownloaderOperation *op = [DownloaderOperation downloadImageWithURLStr:URLStr successBlock:^(UIImage *image) {
//        self.imgView.image = image;
        if (successBlock != nil) {
            successBlock(image);
        }
        
        // 保存图片
        if (image != nil) {
            [self.imagesCaches setObject:image forKey:URLStr];
        }
        
        [self.opCache removeObjectForKey:URLStr];
    }];
    
    // 保存操作
    [self.opCache setObject:op forKey:URLStr];
    
    [self.queue addOperation:op];
}

- (void)canceldownloadingWithLastURLStr:(NSString *)lastURLStr{
    // 获取上一个操作
    [[self.opCache objectForKey:lastURLStr] cancel];
    // 删除操作缓存池中的操作
    [self.opCache removeObjectForKey:lastURLStr];
}

@end
