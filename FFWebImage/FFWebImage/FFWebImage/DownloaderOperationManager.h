//
//  DownloaderOperationManager.h
//  FFWebImage
//
//  Created by smile on 17/2/23.
//  Copyright © 2017年 haha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloaderOperation.h"
@interface DownloaderOperationManager : NSObject

+(instancetype)shareManager;

- (void)downloadImageWithURLStr:(NSString *)URLStr successBlock:(void(^)(UIImage *image))successBlock;

- (void)canceldownloadingWithLastURLStr:(NSString *)lastURLStr;

@end
