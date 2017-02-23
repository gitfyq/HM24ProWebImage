//
//  DownloaderOperation.h
//  FFWebImage
//
//  Created by smile on 17/2/23.
//  Copyright © 2017年 haha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NSString+path.h"
@interface DownloaderOperation : NSOperation

@property (nonatomic, copy) NSString *URLStr;

@property (nonatomic, copy) void(^successBlock)(UIImage *);

+(instancetype)downloadImageWithURLStr:(NSString *)URLStr successBlock:(void(^)(UIImage *image))successBlock;

@end
