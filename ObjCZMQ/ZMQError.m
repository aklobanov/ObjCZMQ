//
//  ZMQError.m
//  ObjCZMQ
//
//  Created by ALEXEY LOBANOV on 03.02.16.
//  Copyright © 2016 Blue Skies Software. All rights reserved.
//

#import "ZMQError.h"

#define LOCAL_LEVEL_0 0
#define LOCAL_LEVEL_1 1
#define LOCAL_LEVEL_2 2


@implementation ZMQError
- (instancetype)init
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    return [self initWithCode:zmq_errno()];
}
- (instancetype)initWithCode:(int)code
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    static NSString *domain = kZMQErrorDomain;
    self = [super initWithDomain:domain code:(NSInteger)code userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithUTF8String:zmq_strerror(code)]}];
    return self;
}
@end
