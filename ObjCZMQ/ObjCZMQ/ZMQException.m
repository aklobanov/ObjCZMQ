//
//  ZMQException.m
//  ObjCZMQ
//
//  Created by ALEXEY LOBANOV on 03.02.16.
//  Copyright © 2016 Blue Skies Software. All rights reserved.
//

#import "ZMQException.h"
#include "zmq.h"

#define LOCAL_LEVEL_0 0
#define LOCAL_LEVEL_1 1
#define LOCAL_LEVEL_2 2

@implementation ZMQException
- (instancetype)init
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    static NSString *name = kZMQExceptionName;
    static NSString *key = kZMQExceptionKey;
    int code = zmq_errno();
    self = [super initWithName:name reason:[NSString stringWithUTF8String:zmq_strerror(code)] userInfo:@{key:@(code)}];
    return self;
}
@end
