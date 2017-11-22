//
//  BRLaunchingViewController.m
//  MyBaseProject
//
//  Created by 任波 on 2017/9/26.
//  Copyright © 2017年 任波. All rights reserved.
//

#import "BRLaunchingViewController.h"

@interface BRLaunchingViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation BRLaunchingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.hidden = NO;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        _imageView.image = [UIImage imageNamed:@"LaunchImage"];
        [self.view addSubview:_imageView];
    }
    return _imageView;
}

@end
