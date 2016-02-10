//
//  ZMQContext.h
//  ObjCZMQ
//
//  Created by ALEXEY LOBANOV on 03.02.16.
//  Copyright © 2016 Blue Skies Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZMQContext : NSObject
@property (nonatomic, assign)   NSInteger ioThreads;
@property (nonatomic, assign)   NSInteger maxSockets;
@property (nonatomic, assign)   BOOL      useIPV6;
@property (nonatomic, readonly) NSInteger socketLimit;
@property (nonatomic, assign)   NSInteger threadSchedulingPolicy;
@property (nonatomic, assign)   BOOL      blocky;
- (instancetype)init;
- (BOOL)destroy;
- (BOOL)terminate;
- (BOOL)shutdown;
- (BOOL)setOption:(int)option value:(int)value;

@end
