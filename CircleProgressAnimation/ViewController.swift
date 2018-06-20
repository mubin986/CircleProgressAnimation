//
//  ViewController.swift
//  CircleProgressAnimation
//
//  Created by Mac on 6/6/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class ViewController: UIViewController, URLSessionDownloadDelegate {
    
    var downloadPercentage = CGFloat(0.0)
    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    
    let percentageLabel : UILabel = {
       let label = UILabel()
        label.text = "Start"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // adding percentageLabel
        view.addSubview(percentageLabel)
        percentageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        percentageLabel.center = view.center
        
        
        //let center = view.center
        
        
        // create my track layer
        
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = 10
        trackLayer.position = view.center
        
        view.layer.addSublayer(trackLayer)
        
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.strokeEnd = 0
        shapeLayer.lineCap = kCALineCapRound //kCALineCapRound is value of round the lineCap of our shapeLayer
        shapeLayer.position = view.center
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2.0, 0, 0, 1)
        
        view.layer.addSublayer(shapeLayer)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    
    // If download is not working, then change the link below.
    let urlString = "https://filehippo.com/download/file/98b07037f8256666881dc3e004f0fcff1067a79c766f540a73fcb54cc8dd48b5/"
    
    private func beginDownloadingFile() {
        print("this is from beginDownloadingFile()")
        percentageLabel.text = "0 %"
        
        shapeLayer.strokeEnd = 0
        
        let configuration = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        
        let urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
        
        guard let url = URL(string: urlString) else {return}
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
    }
    
    
    fileprivate func animateCircleStroke() {
        //shapeLayer.strokeEnd = 1
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        
        //required lines for animation staying
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "customString")
    }
    
    @objc private func handleTap() {
        print("this is from handleTap()")
        beginDownloadingFile()
        //animateCircleStroke()
    }
    
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        downloadPercentage = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        DispatchQueue.main.async {
            self.percentageLabel.text = "\(Int(self.downloadPercentage * 100)) %"
            self.shapeLayer.strokeEnd = self.downloadPercentage
        }
        print("\(Int(self.downloadPercentage * 100)) %\n")
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("finished downloading file")
    }
    
}

