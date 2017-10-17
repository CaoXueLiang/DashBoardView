//
//  CXLDashBoardView.m
//  CXLDashBoardView
//
//  Created by bjovov on 2017/10/13.
//  Copyright © 2017年 CaoXueLiang.cn. All rights reserved.
//

#import "CXLDashBoardView.h"
#import <CoreText/CoreText.h>

#define BigCircleRadius    CGRectGetWidth(self.bounds)/2.0 - 20
#define MiddleCircleRadius BigCircleRadius - 45
#define DashCircleRadius   BigCircleRadius - 45 - 25
static CGFloat LineWidth = 25;
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
/*进度条*/
@property (nonatomic,strong) CAShapeLayer *progressLayer;
/*芝麻信用分数*/
@property (nonatomic,strong) UILabel *progressLabel;
/*指针图片*/
@property (nonatomic,strong) UIImageView *locationImageView;
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
    [self.layer addSublayer:self.fullLineLayer];
    [self.layer addSublayer:self.dashLineLayer];
    [self.layer addSublayer:self.parentDialLayer];
    [self.layer addSublayer:self.sortDialLayer];
    [self addTextMenthod];

    [self addSubview:self.progressLabel];
    self.progressLabel.frame = CGRectMake(0, 0, 80, 30);
    self.progressLabel.center = CGPointMake(self.center.x, self.center.y - 10);
    [self.layer addSublayer:self.progressLayer];
    
    [self addSubview:self.locationImageView];
    self.locationImageView.frame = CGRectMake(0, 0, 20, 20);
    
}

- (void)addTextMenthod{
    NSArray *textArray = @[@"1050",@"极好",@"900",@"优秀",@"750",@"良好",@"600",@"中等",@"450",@"较差",@"300",@"很差",@"150"];
    [textArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *str = obj;
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
        CATextLayer *textLayer = [CATextLayer layer];
        textLayer.bounds = CGRectMake(0, 0, 50, 20);
        textLayer.alignmentMode = kCAAlignmentCenter;
        textLayer.wrapped = YES;
        
        UIFont *font = [UIFont systemFontOfSize:11];
        CFStringRef fontName = (__bridge CFStringRef)font.fontName;
        CGFloat fontSize = font.pointSize;
        CTFontRef fontRef = CTFontCreateWithName(fontName, fontSize, NULL);
        NSDictionary *attribs = @{
                                  (__bridge id)kCTForegroundColorAttributeName:(__bridge id)[UIColor blackColor].CGColor,
                                  (__bridge id)kCTFontAttributeName: (__bridge id)fontRef
                                  };
        [attributeStr setAttributes:attribs range:NSMakeRange(0, [attributeStr length])];
        textLayer.string = attributeStr;
        textLayer.contentsScale = [UIScreen mainScreen].scale;
        
        /*取得每个点的position*/
        CGFloat length = BigCircleRadius - 30;
        CGFloat centerPointX = CGRectGetMidX(self.bounds);
        CGFloat centerPointY = CGRectGetMidY(self.bounds);
        CGFloat currentX = centerPointX + length *sinf((M_PI_2 - M_PI/6.0) + M_PI/9.0 *idx);
        CGFloat currentY = centerPointY + length *cosf((M_PI_2 - M_PI/6.0) + M_PI/9.0 *idx);
        textLayer.position = CGPointMake(currentX, currentY);
        [self.layer addSublayer:textLayer];
        
       /*旋转textLayer*/
        CATransform3D transform = CATransform3DIdentity;
        transform = CATransform3DRotate(transform, (M_PI_2 - M_PI/6.0) + M_PI/9.0 *idx + M_PI, 0, 0, -1);
        textLayer.transform = transform;
    }];
}

#pragma mark - Public Menthod
- (void)setProgress:(CGFloat)progress{
    CGFloat currentPoint = 150 + (1050 - 150)*progress;
    _progressLabel.text = [NSString stringWithFormat:@"%.0f",currentPoint];
    
    //设置图片的位置和旋转
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DRotate(transform, (M_PI_2 - M_PI/6.0) + (M_PI*2*2/3.0) *(1 - progress) + M_PI, 0, 0, -1);
    CGFloat length = MiddleCircleRadius;
    CGFloat centerPointX = CGRectGetMidX(self.bounds);
    CGFloat centerPointY = CGRectGetMidY(self.bounds);
    CGFloat currentX = centerPointX + length *sinf((M_PI_2 - M_PI/6.0) + (M_PI*2*2/3.0) *(1 - progress));
    CGFloat currentY = centerPointY + length *cosf((M_PI_2 - M_PI/6.0) + (M_PI*2*2/3.0) *(1 - progress));
    self.locationImageView.center = CGPointMake(currentX, currentY);
    self.locationImageView.layer.transform = transform;
    
    //设置进度条
    CGFloat endAngle = M_PI *5/6.0 + M_PI*2 *2/3.0 *progress;
    endAngle = endAngle > M_PI*2 ? endAngle - M_PI*2 : endAngle;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.bounds)/2.0, CGRectGetHeight(self.bounds)/2.0) radius:MiddleCircleRadius startAngle:M_PI *5/6.0 endAngle:endAngle  clockwise:1];
    _progressLayer.path = path.CGPath;
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
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.bounds)/2.0, CGRectGetHeight(self.bounds)/2.0) radius:BigCircleRadius startAngle:M_PI/6.0 endAngle:M_PI*5/6.0 clockwise:0];
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
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.bounds)/2.0, CGRectGetHeight(self.bounds)/2.0) radius:MiddleCircleRadius startAngle:M_PI/6.0 endAngle:M_PI*5/6.0 clockwise:0];
        _fullLineLayer.path = path.CGPath;
        _fullLineLayer.lineWidth = 1;
        _fullLineLayer.fillColor = [UIColor clearColor].CGColor;
        _fullLineLayer.strokeColor = [UIColor blackColor].CGColor;
    }
    return _fullLineLayer;
}

- (CAShapeLayer *)progressLayer{
    if (!_progressLayer) {
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.lineWidth = 1.5;
        _progressLayer.fillColor = [UIColor clearColor].CGColor;
        _progressLayer.strokeColor = [UIColor colorWithRed:48/255.0 green:191/255.0 blue:152/255.0 alpha:1].CGColor;
    }
    return _progressLayer;
}

- (CAShapeLayer *)dashLineLayer{
    if (!_dashLineLayer) {
        _dashLineLayer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.bounds)/2.0, CGRectGetHeight(self.bounds)/2.0) radius:DashCircleRadius startAngle:M_PI/6.0 endAngle:M_PI*5/6.0 clockwise:0];
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
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.bounds)/2.0, CGRectGetHeight(self.bounds)/2.0) radius:BigCircleRadius startAngle:M_PI/6.0 endAngle:M_PI*5/6.0 clockwise:0];
        _parentDialLayer.path = path.CGPath;
        _parentDialLayer.lineWidth = LineWidth;
        _parentDialLayer.fillColor = [UIColor clearColor].CGColor;
        _parentDialLayer.strokeColor = [UIColor whiteColor].CGColor;
        CGFloat lineWidth = (2*M_PI*(CGRectGetWidth(self.bounds)/2.0 - 20) *2/3.0 - 5*2)/6.0;
        [_parentDialLayer setLineDashPattern:@[@2,[NSNumber numberWithFloat:lineWidth]]];
        [_parentDialLayer setLineDashPhase:2];
    }
    return _parentDialLayer;
}

- (CAShapeLayer *)sortDialLayer{
    if (!_sortDialLayer) {
        _sortDialLayer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.bounds)/2.0, CGRectGetHeight(self.bounds)/2.0) radius:BigCircleRadius startAngle:M_PI/6.0 endAngle:M_PI*5/6.0 clockwise:0];
        _sortDialLayer.path = path.CGPath;
        _sortDialLayer.lineWidth = LineWidth;
        _sortDialLayer.fillColor = [UIColor clearColor].CGColor;
        _sortDialLayer.strokeColor = [UIColor whiteColor].CGColor;
        CGFloat lineWidth = (2*M_PI*(CGRectGetWidth(self.bounds)/2.0 - 20) *2/3.0)/60.0;
        [_sortDialLayer setLineDashPattern:@[@1,[NSNumber numberWithFloat:lineWidth - 1]]];
        [_sortDialLayer setLineDashPhase:0.5];
    }
    return _sortDialLayer;
}

- (UILabel *)progressLabel{
    if (!_progressLabel) {
        _progressLabel = [UILabel new];
        _progressLabel.textColor = [UIColor colorWithRed:48/255.0 green:191/255.0 blue:152/255.0 alpha:1];
        _progressLabel.font = [UIFont systemFontOfSize:32];
        _progressLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _progressLabel;
}

- (UIImageView *)locationImageView{
    if (!_locationImageView) {
        _locationImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow"]];
    }
    return _locationImageView;
}

@end

