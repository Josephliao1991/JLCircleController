//
//  JLCircleController.swift
//  JLCircleController_Swift
//
//  Created by TSUNG-LUN LIAO on 2015/6/24.
//  Copyright (c) 2015年 TSUNG-LUN LIAO. All rights reserved.
//



import UIKit

enum CircleAnimation{
    
    case VolumeChange
    case LengthChange
    case None
    
}

protocol JLCircleControllerDelegate{
    
    func circleController(circleController:JLCircleController!, didStartControllerAtStarPoint startPoint:CGPoint)
    func circleController(circleController:JLCircleController!, didMoveAtPoint nowPoint:CGPoint ,Angle angle:Float ,PullLevel pullLavel:Float)
    func circleController(circleController:JLCircleController!, didStopControllerAtEndPoint endPoint:CGPoint, Angle angle:Float, PullLevel pullLevel:Float)
    
}

class JLCircleController: UIView {

    
// MARK: -
// MARK: #define
    let kCircleAngleChangeRaet      :Float = 2.0
    let kCircleRadiusChangeRate     :Float = 3.0
    
    let kCirclePullLevelSampleRate  :Float = 100.0

// MARK: - 
// MARK: Private Variable
    
    private var delegate    :JLCircleControllerDelegate?
    private var thita       :Float = 0.0
    private var pullLevel   :Float = 0.0
    private var pathLayer   :CAShapeLayer!

// MARK: -
// MARK: Public Variable
    
// MARK: CircleController Imformation
    
    var startPoint      :CGPoint!

// MARK: CircleController UI Setting

    //View
    var viewColor       :UIColor!        //default is clear  Color

    //Circle
    var circleColor     :UIColor!        //default is orange Color
    var circleRadius    :Float!          //default is 50.0
    
    //Circle Line
    var circleLineColor :UIColor!        //default is clear  Color
    var circleLineWidth :Float!          //default is 5.0
    
    //Animation
    var circleAnimation :CircleAnimation!    //default is CircleAnimationVolumeChange

// MARK: -
// MARK: Public Function
    
    init(frame:CGRect, delegate:AnyObject?){
        
        super.init(frame: frame)
        
        self.delegate = delegate as? JLCircleControllerDelegate
        
        //set view background color
        self.viewColor          = UIColor.clearColor()
        self.backgroundColor    = self.viewColor
        
        //set circle color
        self.circleColor        = UIColor.orangeColor()
        self.circleRadius       = 50.0
        
        self.circleLineColor    = UIColor.clearColor()
        self.circleLineWidth    = 5.0
        
        //set circleAnimation
        self.circleAnimation    = CircleAnimation.VolumeChange;
    
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(){
        
        var viewController:UIViewController = self.delegate as! UIViewController
        
        viewController.view.addSubview(self)
        
    }
    
// MARK: -
// MARK: Private Function
    
// MARK: Touch Event
    
    
    override internal func  touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
    
        if let touch = touches.first as? UITouch{
            
            self.startPoint = touch.locationInView(self)
            //Draw the CircleCOntroller
            drawCircleController(touch)
            
            //Delegate
            self.delegate!.circleController(self, didStartControllerAtStarPoint: self.startPoint)
        }
        
        super.touchesBegan(touches , withEvent:event)
    }
    
    override internal func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        if let touch = touches.first as? UITouch{
            
             //Draw the CircleCOntroller
            drawCircleController(touch)
            
            let nowPoint:CGPoint = touch.locationInView(self)

            //Delegate
            self.delegate!.circleController(self, didMoveAtPoint: nowPoint, Angle: self.thita, PullLevel: self.pullLevel)
            
        }
        
        super.touchesMoved(touches, withEvent: event)
    }
    
    override internal func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        UIView.animateWithDuration(1,
            animations: { () -> Void in
                //
                self.pathLayer.frame = CGRectMake(self.pathLayer.frame.origin.x, self.pathLayer.frame.origin.y, CGFloat(60), CGFloat(60))
                self.pathLayer.opacity = 0
                
        })
        
        if let touch = touches.first as? UITouch{
            
            let endPoint:CGPoint = touch.locationInView(self)
            
            //Delegate
            self.delegate!.circleController(self, didStopControllerAtEndPoint: endPoint, Angle: thita, PullLevel: pullLevel)
            
        }
        
        super.touchesEnded(touches, withEvent: event)
    }

/*
/*=============Swift 2===============*/
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            // ...
        }
        super.touchesBegan(touches, withEvent:event)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    if let touch = touches.first {
    // ...
    }
    super.touchesMoved(touches, withEvent:event)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    if let touch = touches.first {
    // ...
    }
    super.touchesEnded(touches, withEvent:event)
    }
    
*/
    
// MARK: Draw Circle Function
    
    private func drawCircleController(touch:UITouch!){
        
        if (self.pathLayer != nil){
            self.pathLayer.removeFromSuperlayer()
        }
        
        let nowPoint:CGPoint = touch.locationInView(self)
        
        var angle           :Float = getAngle(self.startPoint, endPoint: nowPoint)
        var angleDecrease   :Float = 0.0
        var radiusDecrease  :Float = 0.0
        
        switch self.circleAnimation!{
            
        case CircleAnimation.VolumeChange:
            
            angleDecrease   = Float(M_PI_4) * getPullLevel(nowPoint) / kCircleAngleChangeRaet
            radiusDecrease  = self.circleRadius * getPullLevel(nowPoint) / kCircleRadiusChangeRate
            
            break
            
        case CircleAnimation.LengthChange:
            
            angleDecrease   = Float(M_PI_4) * getPullLevel(nowPoint) / kCircleRadiusChangeRate
            radiusDecrease  = 0.0
            
            break
            
        case CircleAnimation.None:
            
            angleDecrease   = 0.0
            radiusDecrease  = 0.0
            
            break
            
        default:
            
            break
        }
        
        if angle > Float(M_PI){
            
            var path:UIBezierPath = UIBezierPath()
            
            let radius      :CGFloat = CGFloat(self.circleRadius)
            let startAngle  :CGFloat = 0.0
            let endAngle    :CGFloat = CGFloat(M_PI*2)
            
            path.addArcWithCenter(
                self.startPoint,
                radius: radius,
                startAngle: startAngle,
                endAngle: endAngle,
                clockwise: true)
            
            self.pathLayer          = CAShapeLayer()
            self.pathLayer.frame    = self.bounds
            self.pathLayer.path     = path.CGPath
            
            self.pathLayer.strokeColor  = self.circleLineColor.CGColor
            self.pathLayer.fillColor    = self.circleColor.CGColor
            self.pathLayer.opacity      = 0.8
            
            self.pathLayer.lineWidth    = CGFloat(self.circleLineWidth)
            self.pathLayer.lineJoin     = kCALineJoinBevel
            
            self.layer.addSublayer(self.pathLayer)
            
            return;
        }
        
        var path:UIBezierPath = UIBezierPath()
        
        path.moveToPoint(nowPoint)
        
        let radius      :CGFloat = CGFloat(self.circleRadius - radiusDecrease)
        let startAngle  :CGFloat = CGFloat(angle  + (Float(M_PI_4) - angleDecrease))
        let endAngle    :CGFloat = CGFloat(angle  - (Float(M_PI_4) - angleDecrease))
        
        path.addArcWithCenter(
            self.startPoint,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true)
        
        path.closePath()
        
        self.pathLayer          = CAShapeLayer()
        self.pathLayer.frame    = self.bounds
        self.pathLayer.path     = path.CGPath
        
        self.pathLayer.strokeColor  = self.circleLineColor.CGColor
        self.pathLayer.fillColor    = self.circleColor.CGColor
        self.pathLayer.opacity      = 0.8
        
        self.pathLayer.lineWidth    = CGFloat(self.circleLineWidth)
        self.pathLayer.lineJoin     = kCALineJoinBevel
        
        self.layer.addSublayer(self.pathLayer)
        
        
//        var pathAnimation:CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd" as String)
//        pathAnimation.duration      = 2.0
//        pathAnimation.fromValue     = 0.0
//        pathAnimation.toValue       = 1.0
//        
//        self.pathLayer.addAnimation(pathAnimation, forKey: "strokeEnd" as String)
        
    }

// MARK: Calculate
    
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
    
    private func getAngle(startPoint:CGPoint, endPoint:CGPoint) -> Float{
        
        var tmp_radius:Float = Float(sqrt(pow(fabs(startPoint.x - endPoint.x), 2) + pow(fabs(startPoint.y - endPoint.y), 2)))
        
        if tmp_radius < 50.0{
            
            return Float(M_PI*2.0)
        }
        
        let a1:Float = Float(endPoint.x - startPoint.x)
        let a2:Float = Float(endPoint.y - startPoint.y)
        let b1:Float = 1.0
        let b2:Float = 0.0
        
        let cosThita:Float = ((a1*b1) + (a2*b2))/(sqrt(((pow(a1, 2)+pow(a2, 2))))*sqrt((pow(b1, 2)+pow(b2, 2))))
        
        var Thita:Float = 0.0
        
        if a1>0 && a2>0{
            Thita = acos(cosThita)
            self.thita = Float(M_PI*2) - Thita
        }
        else if a1<0 && a2>0{
            Thita = acos(cosThita);
            self.thita = Float(M_PI*2) - Thita;
        }
        else if a1<0 && a2<0{
            Thita = -acos(cosThita) ;
            self.thita = -Thita;
            
        }
        else if a1>0 && a2<0{
            Thita = -acos(cosThita);
            self.thita = -Thita;

        }
        
        return Thita
        
    }

    private func getPullLevel(nowPoint:CGPoint) ->Float{
        
        let total_Length:Float = Float(sqrt(pow(self.frame.size.width, 2)+pow(self.frame.size.height, 2)))
        let now_Length  :Float = Float(sqrt(pow(fabs(nowPoint.x-self.startPoint.x),2)+pow(fabs(nowPoint.y-self.startPoint.y),2)))
        
        self.pullLevel = now_Length/total_Length*kCirclePullLevelSampleRate;
        
        return now_Length/total_Length
        
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
