//
//  ALOpusEncoder.h
//  AudioLogger
//
//  Created by Bryan on 1/1/17.
//  Copyright © 2017 bcattle. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ALOpusEncoder : NSObject

@property (nonatomic, readonly) int frameSize;
@property (nonatomic, readonly) int maxFrameSize;
@property (nonatomic, readonly) int maxPacketSize;

@property (nonatomic, readonly) NSData *frameOut;

-(int32_t)encodeFrame:(NSData*)pcmFrame;

@end

NS_ASSUME_NONNULL_END
