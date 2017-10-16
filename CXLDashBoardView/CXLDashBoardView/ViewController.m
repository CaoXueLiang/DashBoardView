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
@end

@implementation ViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.navigationItem.title = @"首页";
    
    [self.view addSubview:self.boardView];
    self.boardView.center = self.view.center;
}

#pragma mark - Setter && Getter
- (CXLDashBoardView *)boardView{
    if (!_boardView) {
        _boardView = [[CXLDashBoardView alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
    }
    return _boardView;
}

@end
