//
//  UIWindow+BGVideo.swift
//  FirstImpressionSwift
//
//  Created by Tealium User on 3/6/18.
//  Copyright © 2018 Jason Koo. All rights reserved.
//

import UIKit
import SwiftVideoBackground

extension UIWindow {
    
    @discardableResult
    func playBackgroundVideo(name: String,
                     type: String) -> Error? {
        
        let view = UIView(frame: CGRect(x: self.frame.origin.x,
                                        y: self.frame.origin.y,
                                        width: self.frame.width,
                                        height: self.frame.height))
        do {
            try VideoBackground.shared.play(view: view,
                                            videoName: name,
                                            videoType: type)
            self.insertSubview(view, at: 0)
            return nil
        } catch let e {
            return e
        }
        
    }
    
    func pauseBackgroundVideo() {
        VideoBackground.shared.pause()
    }
    
    func resumeBackgroundVideo(){
        VideoBackground.shared.resume()
    }
    
    func useBackgroundImage(name: String){
        guard let image = UIImage(named: name) else {
            Log.error("Unable to lot image named: \(name). Falling back to simple bg color")
            let view = UIView(frame: self.bounds)
            view.backgroundColor = UIColor(red: 0.21, green: 0.44, blue: 0.56, alpha: 1.0)
            self.insertSubview(view, at: 0)
            return
        }
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        self.insertSubview(imageView, at: 0)
    }
}
