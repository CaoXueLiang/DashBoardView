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
/*环形遮罩*/
@property (nonatomic,strong) CAShapeLayer *circleLayer;
/*内部实线弧线*/
@property (nonatomic,strong) CAShapeLayer *fullLineLayer;
/*内部虚线弧线*/
@property (nonatomic,strong) CAShapeLayer *dashLineLayer;
/*父级刻度*/
@property (nonatomic,strong) CAShapeLayer *parentDialLayer;
/*子级刻度*/
@property (nonatomic,strong) CAShapeLayer *sortDialLayer;
@end

static CGFloat LineWidth = 25;
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
    [self.layer addSublayer:self.fullLineLayer];
    [self.layer addSublayer:self.dashLineLayer];
    [self.layer addSublayer:self.parentDialLayer];
    [self.layer addSublayer:self.sortDialLayer];
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
        leftGradientLayer.locations = @[@0.2, @0.95, @1];
        
        //右侧渐变
        CAGradientLayer *rightGradientLayer = [[CAGradientLayer alloc]init];
        rightGradientLayer.frame = CGRectMake(CGRectGetWidth(self.bounds)/2.0, 0, CGRectGetWidth(self.bounds)/2.0, CGRectGetHeight(self.bounds));
        rightGradientLayer.colors = @[(__bridge id)[UIColor yellowColor].CGColor,(__bridge id)[UIColor greenColor].CGColor];
        rightGradientLayer.locations = @[@0.2, @0.95, @1];

        [_backGradientColorView.layer addSublayer:leftGradientLayer];
        [_backGradientColorView.layer addSublayer:rightGradientLayer];
    }
    return _backGradientColorView;
}

- (CAShapeLayer *)circleLayer{
    if (!_circleLayer) {
        _circleLayer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.bounds)/2.0, CGRectGetHeight(self.bounds)/2.0) radius:CGRectGetWidth(self.bounds)/2.0 - 20 startAngle:M_PI/6.0 endAngle:M_PI*5/6.0 clockwise:0];
        _circleLayer.path = path.CGPath;
        _circleLayer.lineWidth = LineWidth;
        _circleLayer.fillColor = [UIColor clearColor].CGColor;
        _circleLayer.strokeColor = [UIColor whiteColor].CGColor;
    }
    return _circleLayer;
}

- (CAShapeLayer *)fullLineLayer{
    if (!_fullLineLayer) {
        _fullLineLayer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.bounds)/2.0, CGRectGetHeight(self.bounds)/2.0) radius:CGRectGetWidth(self.bounds)/2.0 - 20 - 40 startAngle:M_PI/6.0 endAngle:M_PI*5/6.0 clockwise:0];
        _fullLineLayer.path = path.CGPath;
        _fullLineLayer.lineWidth = 1;
        _fullLineLayer.fillColor = [UIColor clearColor].CGColor;
        _fullLineLayer.strokeColor = [UIColor blackColor].CGColor;
    }
    return _fullLineLayer;
}

- (CAShapeLayer *)dashLineLayer{
    if (!_dashLineLayer) {
        _dashLineLayer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.bounds)/2.0, CGRectGetHeight(self.bounds)/2.0) radius:CGRectGetWidth(self.bounds)/2.0 - 20 - 40 - 25 startAngle:M_PI/6.0 endAngle:M_PI*5/6.0 clockwise:0];
        _dashLineLayer.path = path.CGPath;
        _dashLineLayer.fillColor = [UIColor clearColor].CGColor;
        _dashLineLayer.strokeColor = [UIColor blackColor].CGColor;
        [_dashLineLayer setLineDashPattern:@[@5,@5]];
    }
    return _dashLineLayer;
}

- (CAShapeLayer *)parentDialLayer{
    if (!_parentDialLayer) {
        _parentDialLayer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.bounds)/2.0, CGRectGetHeight(self.bounds)/2.0) radius:CGRectGetWidth(self.bounds)/2.0 - 20 startAngle:M_PI/6.0 endAngle:M_PI*5/6.0 clockwise:0];
        _parentDialLayer.path = path.CGPath;
        _parentDialLayer.lineWidth = LineWidth;
        _parentDialLayer.fillColor = [UIColor clearColor].CGColor;
        _parentDialLayer.strokeColor = [UIColor whiteColor].CGColor;
        CGFloat lineWidth = (2*M_PI*(CGRectGetWidth(self.bounds)/2.0 - 20) *2/3.0 - 10)/6.0;
        [_parentDialLayer setLineDashPattern:@[@2,[NSNumber numberWithFloat:lineWidth]]];
        //[_parentDialLayer setLineDashPhase:lineWidth];
    }
    return _parentDialLayer;
}

- (CAShapeLayer *)sortDialLayer{
    if (!_sortDialLayer) {
        _sortDialLayer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.bounds)/2.0, CGRectGetHeight(self.bounds)/2.0) radius:CGRectGetWidth(self.bounds)/2.0 - 20 startAngle:M_PI/6.0 endAngle:M_PI*5/6.0 clockwise:0];
        _sortDialLayer.path = path.CGPath;
        _sortDialLayer.lineWidth = LineWidth;
        _sortDialLayer.fillColor = [UIColor clearColor].CGColor;
        _sortDialLayer.strokeColor = [UIColor whiteColor].CGColor;
        CGFloat lineWidth = (2*M_PI*(CGRectGetWidth(self.bounds)/2.0 - 20) *2/3.0)/60.0;
        [_sortDialLayer setLineDashPattern:@[@1,[NSNumber numberWithFloat:lineWidth - 1]]];
        [_sortDialLayer setLineDashPhase:lineWidth - 1];
    }
    return _sortDialLayer;
}

@end

