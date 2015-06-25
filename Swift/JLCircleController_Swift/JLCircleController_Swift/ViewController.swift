//
//  ViewController.swift
//  JLCircleController_Swift
//
//  Created by TSUNG-LUN LIAO on 2015/6/24.
//  Copyright (c) 2015年 TSUNG-LUN LIAO. All rights reserved.
//

import UIKit

class ViewController: UIViewController,JLCircleControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var circleController = JLCircleController(frame: self.view.frame, delegate: self)
        circleController.viewColor          = UIColor.clearColor()
        
        circleController.circleColor        = UIColor.orangeColor()
        circleController.circleRadius       = 50.0
        
        circleController.circleLineColor    = UIColor.clearColor()
        circleController.circleLineWidth    = 5.0
        
        circleController.circleAnimation    =   CircleAnimation.VolumeChange
        
        circleController.show()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func circleController(circleController: JLCircleController!, didStartControllerAtStarPoint startPoint: CGPoint) {
        //
    }
    
    func circleController(circleController: JLCircleController!, didMoveAtPoint nowPoint: CGPoint, Angle angle: Float, PullLevel pullLavel: Float) {
        //
    }
    
    func circleController(circleController: JLCircleController!, didStopControllerAtEndPoint nowPoint: CGPoint, Angle angle: Float, PullLevel pullLavel: Float) {
        //
    }
    
 
    
}

