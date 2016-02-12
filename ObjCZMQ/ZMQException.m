//
//  ZMQException.m
//  ObjCZMQ
//
//  Created by ALEXEY LOBANOV on 03.02.16.
//  Copyright © 2016 Blue Skies Software. All rights reserved.
//

#import "ZMQException.h"

#define LOCAL_LEVEL_0 0
#define LOCAL_LEVEL_1 1
#define LOCAL_LEVEL_2 2

@implementation ZMQException
static NSString *exceptionName = kZMQExceptionName;
static NSString *exceptionKey = kZMQExceptionKey;
- (instancetype)init
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    int code = zmq_errno();
    self = [super initWithName:exceptionName reason:[NSString stringWithUTF8String:zmq_strerror(code)] userInfo:@{exceptionKey:@(code)}];
    return self;
}
+ (ZMQException *)exceptionWithError:(ZMQError *)error
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    return (ZMQException *)[NSException exceptionWithName:exceptionName reason:([error userInfo][NSLocalizedDescriptionKey]) userInfo:@{exceptionKey:@([error code])}];
}
@end
