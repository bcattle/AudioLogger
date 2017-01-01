//
//  OpusEncoderTap.swift
//  AudioLogger
//
//  Created by Bryan on 12/31/16.
//  Copyright © 2016 bcattle. All rights reserved.
//

import Foundation
//import OpusOSX

class OpusEncoder {
    
    init() {
        // must be one of 8000, 12000, 16000, 24000, or 48000
        let sampleRate = 48000
        let channels = 1
        let application = OPUS_APPLICATION_AUDIO
        var err: UnsafeMutablePointer<Int32>?
        
        // OpusEncoder *opus_encoder_create(opus_int32 Fs, int channels, int application, int *error)
        let encode = opus_encoder_create(opus_int32(sampleRate), Int32(channels), application, err)
        
    }
    
    
}
