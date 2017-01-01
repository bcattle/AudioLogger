//
//  ALOpusEncoder.m
//  AudioLogger
//
//  Created by Bryan on 1/1/17.
//  Copyright © 2017 bcattle. All rights reserved.
//

#import "ALOpusEncoder.h"
#import <opus/opus.h>

@interface ALOpusEncoder ()
@property (nonatomic, assign, readonly) opus_int32 bitrate;
@property (nonatomic, assign, readonly) opus_int32 sampleRate;
@property (nonatomic, assign, readonly) int channels;
@property (nonatomic, assign) OpusEncoder *encoder;
@end

@implementation ALOpusEncoder

-(instancetype) init {
    self = [super init];
    if (self) {
        // Not sure what these mean, they came from trivial_example.c
        _frameSize = 960;
        _maxFrameSize = 6 * _frameSize;
        _maxPacketSize = 3 * 1276;
        _bitrate = 64000;
        // Sample rate must be one of 8000, 12000, 16000, 24000, or 48000
        _sampleRate = 48000;
        _channels = 1;
        
        _frameOut = [NSMutableData dataWithLength:_maxPacketSize];
        
        BOOL success = [self setupEncoder];
        if (!success) {
            return nil;
        }
    }
    return self;
}

-(BOOL)setupEncoder {
    int errCode = 0;
    
    _encoder = opus_encoder_create(_sampleRate, _channels, OPUS_APPLICATION_AUDIO, &errCode);
    if (errCode < 0) {
        NSLog(@"Error: %s", opus_strerror(errCode));
        return NO;
    }
    
    // Set the bitrate
    errCode = opus_encoder_ctl(_encoder, OPUS_SET_BITRATE(_bitrate));
    if (errCode < 0) {
        NSLog(@"Error: %s", opus_strerror(errCode));
        return NO;
    }
    return YES;
}

-(int32_t)encodeFrame:(NSData*)pcmFrame {
    // This expect big-endian?
    opus_int32 bytesEncoded = opus_encode(_encoder, pcmFrame.bytes, _frameSize, (unsigned char*)_frameOut.bytes, _maxPacketSize);
    if (bytesEncoded < 0) {
        NSLog(@"Error: %s", opus_strerror(bytesEncoded));
    }
    return bytesEncoded;
}

-(void)dealloc {
    opus_encoder_destroy(_encoder);
}

@end
