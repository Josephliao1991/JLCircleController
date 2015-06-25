//
//  JLCircleController.h
//  PathTest
//
//  Created by TSUNG-LUN LIAO on 2015/6/16.
//  Copyright (c) 2015年 TSUNG-LUN LIAO. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CircleAnimation){
    
    CircleAnimationvolumeChange,
    CircleAnimationLengthChange,
    CircleAnimationNone
    
};

@class JLCircleController;

@protocol JLCircleControllerDelegate <NSObject>

@optional

- (void)circleController:(JLCircleController *)circleController didStartControllerAtStarPoint:(CGPoint)startPoint;
- (void)circleController:(JLCircleController *)circleController didMoveAtPoint:(CGPoint)nowPoint Angle:(float)angle pullLevel:(float)pullLavel;
- (void)circleController:(JLCircleController *)circleController didStopControllerAtEndPoint:(CGPoint)endPotin angle:(float)angle pullLevel:(float)pullLavel;

@end

@interface JLCircleController : UIView

@property (nonatomic, strong) id<JLCircleControllerDelegate> delegate;


# pragma mark - CircleController Imformation
@property (nonatomic, assign) CGPoint  startPoint;



# pragma mark - CircleController UI Setting
//View
@property (nonatomic, assign) UIColor   *viewColor;         //default is clear  Color

//Circle
@property (nonatomic, assign) UIColor   *circleColor;       //default is orange Color
@property (nonatomic, assign) float     circleRadius;       //default is 50.0

//Circle Line
@property (nonatomic, assign) UIColor   *circleLineColor;   //default is clear  Color
@property (nonatomic, assign) float     circleLineWidth;    //default is 5.0

//Animation
@property (nonatomic, assign) CircleAnimation circleAnimation; //default is CircleAnimationvolumeChange



+ (JLCircleController*)creatCirlcleControllerWithFrame:(CGRect)frame withDelegate:(id)delegate;
- (void)show;

@end
