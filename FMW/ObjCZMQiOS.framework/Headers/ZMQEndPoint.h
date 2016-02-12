//
//  ZMQEndPoint.h
//  ObjCZMQ
//
//  Created by ALEXEY LOBANOV on 10.02.16.
//  Copyright © 2016 Blue Skies Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZMQEndPoint : NSObject
@property (nonatomic, readonly) char const *cString;
+ (ZMQEndPoint *)tcpEndPointWithAddress:(NSString *)address withPort:(NSUInteger)port;
+ (ZMQEndPoint *)ipcEndPointWithPath:(NSString *)path;
+ (ZMQEndPoint *)inprocEndPointWithName:(NSString *)name;
+ (ZMQEndPoint *)pgmEndPointWithInterface:(NSString *)iface withAddress:(NSString *)address withPort:(NSUInteger)port;
+ (ZMQEndPoint *)epgmEndPointWithInterface:(NSString *)iface withAddress:(NSString *)address withPort:(NSUInteger)port;
@end
