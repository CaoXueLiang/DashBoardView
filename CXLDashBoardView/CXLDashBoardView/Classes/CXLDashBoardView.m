//
//  CXLDashBoardView.m
//  CXLDashBoardView
//
//  Created by bjovov on 2017/10/13.
//  Copyright © 2017年 CaoXueLiang.cn. All rights reserved.
//

#import "CXLDashBoardView.h"

@interface CXLDashBoardView()
/*颜色渐变背景*/
@property (nonatomic,strong) UIView *backGradientColorView;
@property (nonatomic,strong) CAShapeLayer *circleLayer;
@end

@implementation CXLDashBoardView
#pragma mark - Init Menthod
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews{
    [self addSubview:self.backGradientColorView];
    self.backGradientColorView.layer.mask = self.circleLayer;
}

#pragma mark - Setter && Getter
- (UIView *)backGradientColorView{
    if (!_backGradientColorView) {
        _backGradientColorView = [[UIView alloc]initWithFrame:self.bounds];
        _backGradientColorView.backgroundColor = [UIColor whiteColor];
        
        //左侧渐变
        CAGradientLayer *leftGradientLayer = [[CAGradientLayer alloc]init];
        leftGradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds)/2.0, CGRectGetHeight(self.bounds));
        leftGradientLayer.colors = @[(__bridge id)[UIColor yellowColor].CGColor,(__bridge id)[UIColor redColor].CGColor];
        leftGradientLayer.locations = @[@0.3, @0.9, @1];
        
        //右侧渐变
        CAGradientLayer *rightGradientLayer = [[CAGradientLayer alloc]init];
        rightGradientLayer.frame = CGRectMake(CGRectGetWidth(self.bounds)/2.0, 0, CGRectGetWidth(self.bounds)/2.0, CGRectGetHeight(self.bounds));
        rightGradientLayer.colors = @[(__bridge id)[UIColor yellowColor].CGColor,(__bridge id)[UIColor greenColor].CGColor];
        rightGradientLayer.locations = @[@0.3, @0.9, @1];

        [_backGradientColorView.layer addSublayer:leftGradientLayer];
        [_backGradientColorView.layer addSublayer:rightGradientLayer];
    }
    return _backGradientColorView;
}

- (CAShapeLayer *)circleLayer{
    if (!_circleLayer) {
        _circleLayer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.bounds)/2.0, CGRectGetHeight(self.bounds)/2.0) radius:CGRectGetWidth(self.bounds)/2.0 - 20 startAngle:M_PI/4.0 endAngle:M_PI*3/4.0 clockwise:0];
        _circleLayer.path = path.CGPath;
        _circleLayer.lineWidth = 20;
        _circleLayer.fillColor = [UIColor clearColor].CGColor;
        _circleLayer.strokeColor = [UIColor whiteColor].CGColor;
    }
    return _circleLayer;
}

@end

