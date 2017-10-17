//
//  ViewController.m
//  CXLDashBoardView
//
//  Created by bjovov on 2017/10/13.
//  Copyright © 2017年 CaoXueLiang.cn. All rights reserved.
//

#import "ViewController.h"
#import "CXLDashBoardView.h"

@interface ViewController ()
@property (nonatomic,strong) CXLDashBoardView *boardView;
@property (nonatomic,strong) UISlider *slider;
@end

@implementation ViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.navigationItem.title = @"首页";
    
    [self.view addSubview:self.boardView];
    self.boardView.center = self.view.center;
    [self.boardView setProgress:0.5];
    [self.view addSubview:self.slider];
    self.slider.center = CGPointMake(self.view.center.x, CGRectGetHeight(self.view.bounds) - 100);
}

#pragma mark - Event Response
- (void)sliderChanged:(UISlider *)slider{
    [self.boardView setProgress:slider.value];
}

#pragma mark - Setter && Getter
- (CXLDashBoardView *)boardView{
    if (!_boardView) {
        _boardView = [[CXLDashBoardView alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
    }
    return _boardView;
}

- (UISlider *)slider{
    if (!_slider) {
        _slider = [[UISlider alloc]initWithFrame:CGRectMake(0, 0, 250, 40)];
        [_slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
        _slider.minimumValue = 0;
        _slider.maximumValue = 1;
        _slider.value = 0.5;
    }
    return _slider;
}
@end
