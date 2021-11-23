//
//  ARView.swift
//  lidarNewest
//
//  Created by Giovanni Zinzi on 11/16/21.
//

import Foundation
import ARKit
import SwiftUI

struct ARViewIndicator: UIViewControllerRepresentable {
   typealias UIViewControllerType = ARView
   
   func makeUIViewController(context: Context) -> ARView {
      return ARView()
   }
   func updateUIViewController(_ uiViewController:
   ARViewIndicator.UIViewControllerType, context:
   UIViewControllerRepresentableContext<ARViewIndicator>) { }
}

class ARView: UIViewController, ARSCNViewDelegate, ARSessionDelegate {
    
    var takePhoto = false
    
    var arView: ARSCNView {
          return self.view as! ARSCNView
       }
    
       override func loadView() {
         self.view = ARSCNView(frame: .zero)
       }
    
    override func viewDidLoad() {
         super.viewDidLoad()
         arView.delegate = self
         arView.scene = SCNScene()
      }
    
    override func viewDidAppear(_ animated: Bool) {
        guard ARWorldTrackingConfiguration.isSupported else {
                    fatalError("""
                        ARKit is not available on this device. For apps that require ARKit
                        for core functionality, use the `arkit` key in the key in the
                        `UIRequiredDeviceCapabilities` section of the Info.plist to prevent
                        the app from installing. (If the app can't be installed, this error
                        can't be triggered in a production scenario.)
                        In apps where AR is an additive feature, use `isSupported` to
                        determine whether to show UI for launching AR experiences.
                    """) // For details, see https://developer.apple.com/documentation/arkit
                }
          super.viewDidAppear(animated)
       }
       override func viewDidLayoutSubviews() {
          super.viewDidLayoutSubviews()
       }
       override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
           if !ARWorldTrackingConfiguration.supportsFrameSemantics([.sceneDepth, .smoothedSceneDepth]) {
               Text("Unsupported Device: This app requires the LiDAR Scanner to access the scene's depth.")
           }
          let configuration = ARWorldTrackingConfiguration()
               configuration.worldAlignment = .gravityAndHeading
               configuration.planeDetection = .horizontal
           configuration.frameSemantics = [.sceneDepth, .smoothedSceneDepth]
          arView.session.run(configuration)
          arView.session.delegate = self
       }
       override func viewWillDisappear(_ animated: Bool) {
          super.viewWillDisappear(animated)
          arView.session.pause()
       }
       // MARK: - ARSCNViewDelegate
       func sessionWasInterrupted(_ session: ARSession) {
           session.pause()
       }
       
       func sessionInterruptionEnded(_ session: ARSession) {}
    
       func session(_ session: ARSession, didFailWithError error: Error)
       {}
    
       func session(_ session: ARSession, cameraDidChangeTrackingState
       camera: ARCamera) {
           
           var message: String? = nil
                   
                   switch camera.trackingState {
                   case .notAvailable:
                       message = "Tracking not available"
                   case .limited(.initializing):
                       message = "Initializing AR session"
                   case .limited(.excessiveMotion):
                       message = "Too much motion"
                   case .limited(.insufficientFeatures):
                       message = "Not enough surface details"
                   case .normal:
                       message = "does this work?"
                   default:
                       // We are only concerned with the tracking states above.
                       message = "Camera changed tracking state"
                   }
                   
           print(message ?? "eh")
           delayText()
               }
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        if(frame.sceneDepth != nil) && (frame.smoothedSceneDepth != nil) && (takePhoto) {
            let depthImage = frame.sceneDepth?.depthMap
            let depthSmoothImage = frame.smoothedSceneDepth?.depthMap
            session.pause()
            print("Is this printing depth", depthImage!)
            print("Is this printing smoothed depth?", depthSmoothImage!)
            let defaults = UserDefaults.standard
            defaults.setValue(depthImage, forKey: "ARRAW")
            defaults.setValue(depthSmoothImage, forKey: "ARSMOOTH")

        }
    }
    
    private func delayText() {
            // Delay of 7.5 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.takePhoto = true
            }
        }

       }
