//
//  ViewController.swift
//  AudioLogger
//
//  Created by Bryan on 12/31/16.
//  Copyright © 2016 bcattle. All rights reserved.
//

import Cocoa
//import AudioKit

class ViewController: NSViewController {
    var audioPipe:AudioPipe!
    
//    @IBOutlet var audioInputPlot: EZAudioPlot!
//    var mic: AKMicrophone!
//    var silence: AKBooster!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initalize the encoder. Bombs away...
        audioPipe = AudioPipe()
        
        // Do any additional setup after loading the view.
//        mic = AKMicrophone()
//        silence = AKBooster(tracker, gain: 0)
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
//        AudioKit.output = silence
//        AudioKit.start()
        setupPlot()
    }
    
    func setupPlot() {
//        let plot = AKNodeOutputPlot(mic, frame: audioInputPlot.bounds)
//        plot.plotType = .Rolling
//        plot.shouldFill = true
//        plot.shouldMirror = true
//        plot.color = UIColor.blueColor()
//        audioInputPlot.addSubview(plot)
    }

//    @IBAction func goButtonTapped() {
//        
//    }
}

