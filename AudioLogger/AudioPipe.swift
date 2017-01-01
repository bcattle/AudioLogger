//
//  AudioPipe.swift
//  AudioLogger
//
//  Created by Bryan on 1/1/17.
//  Copyright © 2017 bcattle. All rights reserved.
//

import Foundation
import AVFoundation

class AudioPipe: NSObject, AVCaptureAudioDataOutputSampleBufferDelegate {
    let encoder: ALOpusEncoder
    let captureSession:AVCaptureSession
    
    override init() {
        encoder = ALOpusEncoder()
        captureSession = AVCaptureSession()
        super.init()
        
        guard let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeAudio) else {
            print("No audio capture device found")
            return
        }
        // TODO: choose the capture device
        guard let audioCaptureDevice:AVCaptureDevice = devices[1] as? AVCaptureDevice else {
            print("No audio capture device found")
            return
        }
        
        captureSession.beginConfiguration()
        do {
            let input = try AVCaptureDeviceInput(device: audioCaptureDevice)
            captureSession.addInput(input)
        }
        catch let error {
            print("Unable to add device to capture session: \(error)")
            return
        }
        
        let output = AVCaptureAudioDataOutput()
        let queue = DispatchQueue(label: "AudioPipe")
        output.setSampleBufferDelegate(self, queue:queue)
        
        // Opus expects big-endian bytes
        let audioSettings:[AnyHashable:Any] = [AVFormatIDKey: Int(kAudioFormatLinearPCM),
                                               AVLinearPCMIsBigEndianKey: true,
                                               AVLinearPCMIsFloatKey:false,
                                               AVSampleRateKey:48000,
                                               AVNumberOfChannelsKey:1,
                                               AVLinearPCMBitDepthKey:24,
                                               ]
        output.audioSettings = audioSettings
        captureSession.addOutput(output)
        captureSession.commitConfiguration()
        
        // Go
        captureSession.startRunning()
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!,
                       from connection: AVCaptureConnection!)
    {
        var audioBufferList = AudioBufferList()
        var blockBuffer:CMBlockBuffer?
        CMSampleBufferGetAudioBufferListWithRetainedBlockBuffer(sampleBuffer, nil, &audioBufferList, MemoryLayout<AudioBufferList>.size, nil, nil, 0, &blockBuffer)
        
        let bufferListPointer = UnsafeMutableAudioBufferListPointer(&audioBufferList)
        for buffer in bufferListPointer {
            if let data = buffer.mData {
                assert(buffer.mNumberChannels == 1)
                let pcmData = Data(bytes:data, count:Int(buffer.mDataByteSize))
                let bytesEncoded = encoder.encodeFrame(pcmData)
                // The result is in `encoder.frameOut`
                print("Encoder converted \(buffer.mDataByteSize) bytes to \(bytesEncoded)")
            }
        }
    }
}

