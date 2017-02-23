//
//  ViewController.m
//  FFWebImage
//
//  Created by smile on 17/2/23.
//  Copyright © 2017年 haha. All rights reserved.
//

#import "ViewController.h"
#import "DownloaderOperation.h"
#import "AFNetworking.h"
#import "YYModel.h"
#import "HMAppModel.h"
#import "DownloaderOperation.h"
#import "DownloaderOperationManager.h"
@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (nonatomic, strong) NSArray *dataArray;

// 上一次下载的URLStr
@property (nonatomic, copy) NSString *lastURLStr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.userInteractionEnabled = false;
    self.view.backgroundColor = [UIColor grayColor];
    
    
    [self loadImageData];
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    // 下载图片
    // 随机数
    int random = arc4random()%self.dataArray.count;
    
    // 获取对应的模型
    HMAppModel *appModel = self.dataArray[random];

    // 判断当前的下载的地址 如果和上次的不同 需要删除上一次的那个操作
    if (self.lastURLStr != nil && ![self.lastURLStr isEqualToString:appModel.icon]) {
        [[DownloaderOperationManager shareManager] canceldownloadingWithLastURLStr:self.lastURLStr];
    }
    
    // 赋值
    self.lastURLStr = appModel.icon;
    
    [[DownloaderOperationManager shareManager] downloadImageWithURLStr:appModel.icon successBlock:^(UIImage *image) {
        self.imgView.image = image;
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)loadImageData{
    // 实例化afn
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 发送请求
    [manager GET:@"https://raw.githubusercontent.com/gitfyq/pro_hm24_loadImageData/master/apps.json" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"%@",responseObject);
        self.dataArray = [NSArray yy_modelArrayWithClass:[HMAppModel class] json:responseObject];
        NSLog(@"----%@",self.dataArray);
        self.view.backgroundColor = [UIColor whiteColor];
        self.view.userInteractionEnabled = true;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
    }];
}

@end
