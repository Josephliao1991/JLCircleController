//
//  ViewController.m
//  JLCircleController
//
//  Created by TSUNG-LUN LIAO on 2015/6/16.
//  Copyright (c) 2015年 TSUNG-LUN LIAO. All rights reserved.
//

#import "ViewController.h"
#import "JLCircleController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    JLCircleController *cc = [JLCircleController creatCirlcleControllerWithFrame:self.view.frame withDelegate:self];
    
    cc.viewColor        = [UIColor clearColor];
    
    cc.circleColor      = [UIColor orangeColor];
    cc.circleRadius     = 50.0;
    
    cc.circleLineColor  = [UIColor clearColor];
    cc.circleLineWidth  = 5.0;
    
    cc.circleAnimation  = CircleAnimationvolumeChange;
    
    [cc show];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Do any additional setup after loading the view, typically from a nib.


#pragma mark - JLCircleController Delegate

- (void)circleController:(JLCircleController *)circleController didStartControllerAtStarPoint:(CGPoint)startPoint{
    
    NSLog(@"Start At x:%f y:%f",startPoint.x,startPoint.y);
    
}

- (void)circleController:(JLCircleController *)circleController didMoveAtPoint:(CGPoint)nowPoint Angle:(float)angle pullLevel:(float)pullLavel{
    
    NSLog(@"Now Move To x:%f y:%f \n",nowPoint.x,nowPoint.y);
    
    float angle_Pi      = (angle/M_PI);
    float angle_Degree  = angle_Pi*180;
    NSLog(@"Now Angle %f Pi ,%f Degree",angle_Pi,angle_Degree);
    
    NSLog(@"Now PullLevel is %f",pullLavel);
    
}

- (void)circleController:(JLCircleController *)circleController didStopControllerAtEndPoint:(CGPoint)endPotin angle:(float)angle pullLevel:(float)pullLavel{
    
    NSLog(@"Stop At x:%f y:%f \n",endPotin.x,endPotin.y);
    
    float angle_Pi      = (angle/M_PI);
    float angle_Degree  = angle_Pi*180;
    NSLog(@"Stpo At Angle %f Pi ,%f Degree",angle_Pi,angle_Degree);
    
    NSLog(@"Stop PullLevel is %f",pullLavel);
    
    
    
}


@end
