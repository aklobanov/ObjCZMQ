//
//  ZMQEndPoint.m
//  ObjCZMQ
//
//  Created by ALEXEY LOBANOV on 10.02.16.
//  Copyright © 2016 Blue Skies Software. All rights reserved.
//

#import "ZMQEndPoint.h"

#define LOCAL_LEVEL_0 0
#define LOCAL_LEVEL_1 1
#define LOCAL_LEVEL_2 2

typedef NS_ENUM(NSUInteger,ZMQSocketTransport)
{
    kZMQSocketTransportTCP = 0,
    kZMQSocketTransportIPC,
    kZMQSocketTransportINPROC,
    kZMQSocketTransportPGM,
    kZMQSocketTransportEPGM
};

@implementation ZMQEndPoint
{
    ZMQSocketTransport  transport;
    NSString            *_endPoint;
    NSString            *_iface;
    NSInteger           _port;
}

static NSString *kTransportTCP      = @"tcp://";
static NSString *kTransportIPC      = @"ipc://";
static NSString *kTransportINPROC   = @"inproc://";
static NSString *kTransportPGM      = @"pgm://";
static NSString *kTransportEPGM     = @"epgm://";

+ (ZMQEndPoint *)tcpEndPointWithAddress:(NSString *)address withPort:(NSUInteger)port
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    ZMQEndPoint *endPoint = [ZMQEndPoint new];
    endPoint->transport = kZMQSocketTransportTCP;
    endPoint->_endPoint = address;
    endPoint->_port = port;
    return endPoint;
}
+ (ZMQEndPoint *)ipcEndPointWithPath:(NSString *)path
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    ZMQEndPoint *endPoint = [ZMQEndPoint new];
    endPoint->transport = kZMQSocketTransportIPC;
    endPoint->_endPoint = path;
    endPoint->_port = -1;
    return endPoint;
}
+ (ZMQEndPoint *)inprocEndPointWithName:(NSString *)name
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    ZMQEndPoint *endPoint = [ZMQEndPoint new];
    endPoint->transport = kZMQSocketTransportINPROC;
    endPoint->_endPoint = name;
    endPoint->_port = -1;
    return endPoint;
}
+ (ZMQEndPoint *)pgmEndPointWithInterface:(NSString *)iface withAddress:(NSString *)address withPort:(NSUInteger)port
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    ZMQEndPoint *endPoint = [ZMQEndPoint new];
    endPoint->transport = kZMQSocketTransportPGM;
    endPoint->_iface = iface;
    endPoint->_endPoint = address;
    endPoint->_port = port;
    return endPoint;
}
+ (ZMQEndPoint *)epgmEndPointWithInterface:(NSString *)iface withAddress:(NSString *)address withPort:(NSUInteger)port
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    ZMQEndPoint *endPoint = [ZMQEndPoint new];
    endPoint->transport = kZMQSocketTransportEPGM;
    endPoint->_iface = iface;
    endPoint->_endPoint = address;
    endPoint->_port = port;
    return endPoint;
}
- (char const *)cString
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    NSString *endPoint;
    switch (transport) {
        case kZMQSocketTransportTCP:
            endPoint = [NSString stringWithFormat:@"%@%@:%li",kTransportTCP,_endPoint,(long)_port];
            break;
        case kZMQSocketTransportIPC:
            endPoint = [NSString stringWithFormat:@"%@%@",kTransportIPC,_endPoint];
            break;
        case kZMQSocketTransportINPROC:
            endPoint = [NSString stringWithFormat:@"%@%@",kTransportINPROC,_endPoint];
            break;
        case kZMQSocketTransportPGM:
            endPoint = [NSString stringWithFormat:@"%@%@:%@:%li",kTransportPGM,_iface,_endPoint,_port];
            break;
        case kZMQSocketTransportEPGM:
            endPoint = [NSString stringWithFormat:@"%@%@:%@:%li",kTransportEPGM,_iface,_endPoint,_port];
            break;
        default:
            endPoint = [NSString stringWithFormat:@"%@%@:%li",kTransportTCP,_endPoint,(long)_port];
            break;
    }
    return [endPoint UTF8String];
}
@end
