//
//  ParticleViewController.swift
//  Amur
//
//  Created by Shreyas Hirday on 4/2/16.
//  Copyright © 2016 Shreyas Hirday. All rights reserved.
//

//
//  ViewController.swift
//  SwiftSpace
//
//  Created by Simon Gladman on 20/08/2015.
//  Copyright © 2015 Simon Gladman. All rights reserved.
//

import UIKit
import SceneKit
import CoreMotion
import AVFoundation

class ParticleViewController: UIViewController
{
    
    
    
    //let buttonBar = UIToolbar()
    
    let cameraDistance: Float = 2
    
    
    let sceneKitView = SCNView.init(frame: UIScreen.mainScreen().bounds);
    let cameraNode = SCNNode()
    
    var initialAttitude: (roll: Double, pitch:Double)?
    let motionManager = CMMotionManager()
    
    let currentDrawingLayerSize = 512
    
    var currentDrawingNode: SCNNode?
    var currentDrawingLayer: CAShapeLayer?
    
    let hermitePath = UIBezierPath()
    var interpolationPoints = [CGPoint]()
    
    override func viewDidLoad()
    {
        guard motionManager.gyroAvailable else
        {
            fatalError("CMMotionManager not available.")
        }
        
        super.viewDidLoad()
        
        //camera crap
        
        
        var captureSession: AVCaptureSession?
        var stillImageOutput: AVCaptureStillImageOutput?
        var previewLayer: AVCaptureVideoPreviewLayer?
        
        
        
        captureSession = AVCaptureSession()
        captureSession!.sessionPreset = AVCaptureSessionPresetPhoto
        
        let backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        var error: NSError?
        var input: AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: backCamera)
        } catch let error1 as NSError {
            error = error1
            input = nil
        }
        
        if error == nil && captureSession!.canAddInput(input) {
            captureSession!.addInput(input)
            
            stillImageOutput = AVCaptureStillImageOutput()
            stillImageOutput!.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
            if captureSession!.canAddOutput(stillImageOutput) {
                captureSession!.addOutput(stillImageOutput)
                
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                previewLayer!.videoGravity = AVLayerVideoGravityResizeAspect
                previewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.Portrait
                view.layer.addSublayer(previewLayer!)
                previewLayer!.frame = UIScreen.mainScreen().bounds;
                captureSession!.startRunning()
            }
        }
        
        
        
        
        //let title = UIBarButtonItem(title: "flexmonkey.co.uk", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        //let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        //let clearButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Trash, target: self, action: "clear")
        //buttonBar.items = [title, spacer, clearButton]
        
        view.addSubview(sceneKitView)
        //view.addSubview(buttonBar)
        
        sceneKitView.backgroundColor = UIColor.clearColor();
        sceneKitView.opaque=false;
        
        
        sceneKitView.scene = SCNScene()
        
        
        
        // centreNode
        
        let centreNode = SCNNode()
        centreNode.position = SCNVector3(x: 0, y: 0, z: 0)
        scene.rootNode.addChildNode(centreNode)
        
        // camera
        
        let camera = SCNCamera()
        camera.xFov = 60
        camera.yFov = 60
        
        cameraNode.camera = camera
        scene.rootNode.addChildNode(cameraNode)
        
        let constraint = SCNLookAtConstraint(target: centreNode)
        cameraNode.constraints = [constraint]
        
        cameraNode.pivot = SCNMatrix4MakeTranslation(0, 0, -cameraDistance)
        
        
        let air=SCNParticleSystem(named: "air.scnp", inDirectory: nil)!;
        
        scene.rootNode.addParticleSystem(air);
        
        // motion manager
        
        let queue = NSOperationQueue.mainQueue
        
        motionManager.deviceMotionUpdateInterval = 1 / 60
        
        motionManager.startDeviceMotionUpdatesToQueue(queue())
        {
            (deviceMotionData: CMDeviceMotion?, error: NSError?) in
            
            
            
            if let deviceMotionData = deviceMotionData
            {
                if (self.initialAttitude == nil)
                {
                    self.initialAttitude = (deviceMotionData.attitude.roll,
                                            deviceMotionData.attitude.pitch)
                }
                
                self.cameraNode.eulerAngles.y = Float(self.initialAttitude!.roll - deviceMotionData.attitude.roll)
                self.cameraNode.eulerAngles.x = Float(self.initialAttitude!.pitch + deviceMotionData.attitude.pitch)
                
                print("z is \(self.cameraNode.eulerAngles.z)")
                
 
            }
        }
        
    }
    
    
    /*
     
     override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
     {
     super.touchesBegan(touches, withEvent: event)
     
     currentDrawingNode = SCNNode(geometry: SCNBox(width: 1, height: 1, length: 0, chamferRadius: 0))
     currentDrawingLayer = CAShapeLayer()
     
     if let currentDrawingNode = currentDrawingNode, currentDrawingLayer = currentDrawingLayer
     {
     currentDrawingNode.position = SCNVector3(x: 0, y: 0, z: 0)
     
     currentDrawingNode.eulerAngles.x = self.cameraNode.eulerAngles.x
     currentDrawingNode.eulerAngles.y = self.cameraNode.eulerAngles.y
     
     scene.rootNode.addChildNode(currentDrawingNode)
     
     currentDrawingLayer.strokeColor = UIColor.whiteColor().CGColor
     currentDrawingLayer.fillColor = nil
     currentDrawingLayer.lineWidth = 10
     currentDrawingLayer.lineJoin = kCALineJoinRound
     currentDrawingLayer.lineCap = kCALineCapRound
     currentDrawingLayer.frame = CGRect(x: 0, y: 0, width: currentDrawingLayerSize, height: currentDrawingLayerSize)
     
     let material = SCNMaterial()
     
     material.diffuse.contents = currentDrawingLayer
     material.lightingModelName = SCNLightingModelConstant
     
     currentDrawingNode.geometry?.materials = [material]
     }
     }
     
     override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?)
     {
     super.touchesMoved(touches, withEvent: event)
     
     let locationInView = touches.first?.locationInView(view)
     
     if let hitTestResult:SCNHitTestResult = sceneKitView.hitTest(locationInView!, options: nil).filter( { $0.node == currentDrawingNode }).first,
     currentDrawingLayer = currentDrawingLayer
     {
     if currentDrawingLayer.path == nil
     {
     let newX = CGFloat((hitTestResult.localCoordinates.x + 0.5) * Float(currentDrawingLayerSize))
     let newY = CGFloat((hitTestResult.localCoordinates.y + 0.5) * Float(currentDrawingLayerSize))
     
     interpolationPoints = [CGPoint(x: newX, y: newY)]
     }
     
     let newX = CGFloat((hitTestResult.localCoordinates.x + 0.5) * Float(currentDrawingLayerSize))
     let newY = CGFloat((hitTestResult.localCoordinates.y + 0.5) * Float(currentDrawingLayerSize))
     
     interpolationPoints.append(CGPoint(x: newX, y: newY))
     
     hermitePath.removeAllPoints()
     hermitePath.interpolatePointsWithHermite(interpolationPoints)
     
     currentDrawingLayer.path = hermitePath.CGPath
     }
     }
     
     override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
     {
     super.touchesEnded(touches, withEvent: event)
     
     currentDrawingLayer = nil
     currentDrawingNode = nil
     
     hermitePath.removeAllPoints()
     interpolationPoints.removeAll()
     }
     
     func clear()
     {
     scene.rootNode.childNodes.filter( {$0.geometry != nil} ).forEach
     {
     $0.removeFromParentNode()
     }
     }
     
     */
    
    var scene: SCNScene
    {
        return sceneKitView.scene!
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        //let topMargin = topLayoutGuide.length
        //let toolbarHeight = buttonBar.intrinsicContentSize().height
        
        sceneKitView.frame = UIScreen.mainScreen().bounds;
        
        //buttonBar.frame = CGRect(x: 0, y: view.frame.height - toolbarHeight, width: view.frame.width, height: toolbarHeight)
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask
    {
        return UIInterfaceOrientationMask.Portrait
    }
    
    
    
    
}

