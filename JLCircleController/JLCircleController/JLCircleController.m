//
//  JLCircleController.m
//  PathTest
//
//  Created by TSUNG-LUN LIAO on 2015/6/16.
//  Copyright (c) 2015年 TSUNG-LUN LIAO. All rights reserved.
//

#define kCircleAngleChangeRaet          2
#define kCircleRadiusChangeRate         3

#define kCirclePullLevelSampleRate      100

#import "JLCircleController.h"

@interface JLCircleController ()

{
    float           thita;
    float           pullLevel;
    CAShapeLayer    *pathLayer;
}



@end


@implementation JLCircleController

+ (JLCircleController*)creatCirlcleControllerWithFrame:(CGRect)frame withDelegate:(id)delegate{
    
    JLCircleController *circleController = [[JLCircleController alloc]initWithFrame:frame withDelegate:delegate];
    
    return circleController;
}

- (id)initWithFrame:(CGRect)frame withDelegate:(id)delegate{
    
    self = [super initWithFrame:frame];

    self.delegate = delegate;
    
    //set view background color
    self.viewColor          = [UIColor clearColor];
    self.backgroundColor    = self.viewColor;
    
    //set circle color
    self.circleColor        = [UIColor orangeColor];
    self.circleRadius       = 50.0;
    
    self.circleLineColor    = [UIColor clearColor];
    self.circleLineWidth    = 5.0;
    
    //set circleAnimation
    self.circleAnimation    = CircleAnimationvolumeChange;

    return self;
}

- (void)show{
    
    [[(UIViewController*)self.delegate view] addSubview:self];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    _startPoint = [[touches anyObject] locationInView:self];
    [self drawCircleControllerWithTouches:touches];
    
    //delegate
    if ([_delegate respondsToSelector:@selector(circleController:didStartControllerAtStarPoint:)]) {
        [_delegate circleController:self didStartControllerAtStarPoint:_startPoint];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self drawCircleControllerWithTouches:touches];
    
    CGPoint nowPoint = [[touches anyObject] locationInView:self];
    //delegate
    if ([_delegate respondsToSelector:@selector(circleController:didMoveAtPoint:Angle:pullLevel:)]) {
         [_delegate circleController:self didMoveAtPoint:nowPoint Angle:thita pullLevel:pullLevel];
    }
    
   
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    
    [UIView animateWithDuration:1
                     animations:^{
                         
                         pathLayer.frame = CGRectMake(pathLayer.frame.origin.x, pathLayer.frame.origin.y, 60, 60);
                         
                         pathLayer.opacity = 0;
                         
                         
                     }];
    
    CGPoint endPoint = [[touches anyObject] locationInView:self];
    
    //delegate
    if ([_delegate respondsToSelector:@selector(circleController:didStopControllerAtEndPoint:angle:pullLevel:)]) {
        [_delegate circleController:self didStopControllerAtEndPoint:endPoint angle:thita pullLevel:pullLevel];
    }
    
    
}

- (void)drawCircleControllerWithTouches:(NSSet*)touches{
    
    [pathLayer removeFromSuperlayer];
    
    CGPoint nowPoint = [[touches anyObject] locationInView:self];
    
    float angle = [self getAngleWithStartPoint:_startPoint withEndPoint:nowPoint];
    float angleDecrease;
    float radiusDecreasa;
    
    switch (_circleAnimation) {
        case CircleAnimationvolumeChange:
            angleDecrease   = M_PI_4 * [self getPullLevelWithNowPoint:nowPoint] / kCircleAngleChangeRaet;
            radiusDecreasa  = self.circleRadius * [self getPullLevelWithNowPoint:nowPoint] / kCircleRadiusChangeRate;
            break;
            
        case CircleAnimationLengthChange:
            angleDecrease   = M_PI_4 * [self getPullLevelWithNowPoint:nowPoint] / kCircleRadiusChangeRate;
            radiusDecreasa  = 0.0;
            break;
            
        case CircleAnimationNone:
            angleDecrease   = 0.0;
            radiusDecreasa  = 0.0;
            break;
            
        default:
            break;
    }
    
    if (angle > M_PI) {
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        CGFloat radius = self.circleRadius;
        CGFloat startAngle = 0.0;
        CGFloat endAngle = M_PI*2 ;
        
        [path addArcWithCenter:_startPoint
                        radius:radius
                    startAngle:startAngle
                      endAngle:endAngle
                     clockwise:YES];
        
        pathLayer = [CAShapeLayer layer];
        pathLayer.frame = self.bounds;
        pathLayer.path = path.CGPath;
        pathLayer.strokeColor = [self.circleLineColor CGColor];
        pathLayer.fillColor = [self.circleColor CGColor];
        pathLayer.opacity   = 0.8;
        pathLayer.lineWidth = self.circleLineWidth;
        pathLayer.lineJoin = kCALineJoinBevel;
        
        [self.layer addSublayer:pathLayer];
        
        return;
    }
    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:nowPoint];
    CGFloat radius = self.circleRadius - radiusDecreasa;
    CGFloat startAngle  =   angle  + (M_PI_4 - angleDecrease);
    CGFloat endAngle    =   angle  - (M_PI_4 - angleDecrease);
    
    [path addArcWithCenter:_startPoint
                    radius:radius
                startAngle:startAngle
                  endAngle:endAngle
                 clockwise:YES];
    
    
    [path closePath];
    
    pathLayer = [CAShapeLayer layer];
    pathLayer.frame = self.bounds;
    pathLayer.path = path.CGPath;
    pathLayer.strokeColor = [self.circleLineColor CGColor];
    pathLayer.fillColor = [self.circleColor CGColor];
    pathLayer.opacity   = 0.8;
    pathLayer.lineWidth = self.circleLineWidth;
    pathLayer.lineJoin = kCALineJoinBevel;
    
    [self.layer addSublayer:pathLayer];
    
    
    //    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    //    pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    //    pathAnimation.duration = 2.0;
    //    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    //    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    //    [pathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
    
}
/*====================================
//                90
//              ******
//            *   |    *
//          *     |      *
//        *       |        *
//        *       |        *
//  180   *_______|________* 0
//        *       |        *
//        *       |        *
//          *     |      *
//            *   |    *
//              ******
//                270
====================================*/

- (float)getAngleWithStartPoint:(CGPoint)startPoint withEndPoint:(CGPoint)endPoint{
    
    
    float tmp_redius = sqrtf(powf(fabsf(startPoint.x - endPoint.x), 2) + powf(fabsf(startPoint.y - endPoint.y), 2));
    
    if (tmp_redius < 50) {
        return M_PI*2;
    }
    
    float a1 = endPoint.x - startPoint.x;
    float a2 = endPoint.y - startPoint.y;
    float b1 = 1;
    float b2 = 0;
    
    float cosThita = ((a1*b1) + (a2*b2))/(sqrt(((pow(a1, 2)+pow(a2, 2))))*sqrt((pow(b1, 2)+pow(b2, 2))));
    
    //    NSLog(@"Arc cos : %f",acos(cosThita));
    
    float Thita = 0;
    
    //    NSLog(@"A1:%f A2:%f ",a1,a2);
    
    if (a1 >0 && a2>0) {
        Thita = acos(cosThita);
        thita = M_PI*2 - Thita;
    }
    else if (a1<0 && a2 >0){
        Thita = acos(cosThita);
        thita = M_PI*2 - Thita;
    }
    else if (a1<0 && a2 <0){
        
        Thita = -acos(cosThita) ;
        thita = -Thita;
    }
    else if (a1 >0 && a2 <0){
        
        Thita = -acos(cosThita);
        thita = -Thita;
        
    }
    
    //    NSLog(@"Thita : %f",Thita);
    
    
    return Thita;
}

- (float)getPullLevelWithNowPoint:(CGPoint)nowPoint{
    
    float total_Length = sqrtf(powf(self.frame.size.width, 2)+powf(self.frame.size.height, 2));
    float now_Length   = sqrtf(powf(fabsf(nowPoint.x-_startPoint.x),2)+powf(fabsf(nowPoint.y-_startPoint.y),2));
    
    pullLevel = now_Length/total_Length *kCirclePullLevelSampleRate;
    
    return now_Length/total_Length;
}


@end
