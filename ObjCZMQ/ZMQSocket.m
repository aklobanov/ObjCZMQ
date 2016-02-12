//
//  ZMQSocket.m
//  ObjCZMQ
//
//  Created by ALEXEY LOBANOV on 10.02.16.
//  Copyright © 2016 Blue Skies Software. All rights reserved.
//

#import "ZMQSocket.h"
#import "ZMQException.h"
#include "zmq.h"

#define LOCAL_LEVEL_0 0
#define LOCAL_LEVEL_1 1
#define LOCAL_LEVEL_2 2

@implementation ZMQSocket
{
    __block void        *_socket;
    ZMQEndPoint         *_endPoint;
    dispatch_queue_t    _queue;
}
+ (ZMQSocket *)socketWithContext:(void *)context withType:(ZMQSocketType)type
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    return [ZMQSocket socketWithContext:context withType:type onQueue:dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)];
}
+ (ZMQSocket *)socketWithContext:(void *)context withType:(ZMQSocketType)type onQueue:(dispatch_queue_t)queue
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    ZMQSocket *socket = [[ZMQSocket alloc] initWithContext:context withType:type onQueue:queue];
    return socket;
}
- (instancetype)initWithContext:(void *)context withType:(ZMQSocketType)type
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    return [self initWithContext:context withType:type onQueue:dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)];
}
- (instancetype)initWithContext:(void *)context withType:(ZMQSocketType)type onQueue:(dispatch_queue_t)queue
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    self = [super init];
    if (self != nil)
    {
        dispatch_sync(queue, ^{
            _socket = zmq_socket(context,(int)type);
        });
        if (_socket == NULL)
        {
#if DEBUG >= LOCAL_LEVEL_0
            NSLog(@"ERROR in %@ '%@' - CODE: %i REASON: %s", self.class, NSStringFromSelector(_cmd),zmq_errno(),zmq_strerror(zmq_errno()));
#endif
            @throw [ZMQException new];
        }
        _queue = queue;
    }
    return self;
}
- (void)dealloc
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    if (_socket != NULL)
    {
        dispatch_sync(_queue, ^{
            int linger = 0;
            zmq_setsockopt(_socket, ZMQ_LINGER, &linger, sizeof(linger));
            zmq_close(_socket);
        });
    }
    _endPoint = nil;
    _socket = NULL;
    _queue = NULL;
}
- (BOOL)closeSyncWithError:(ZMQError *__autoreleasing *)error
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    __block int ret;
    dispatch_sync(_queue, ^{
        ret =zmq_close(_socket);
    });
    ZMQError *err = nil;
    if (ret == -1)
    {
        if (error != NULL)
        {
            err = [ZMQError new];
        }
    }
    else
    {
        _socket = NULL;
        _endPoint = nil;
    }
    if (error != NULL)
    {
        *error = err;
    }
    return (ret == 0);
}
- (void)closeAsyncWithCompletion:(void (^)(BOOL success,ZMQError *error))completion
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    dispatch_async(_queue, ^{
        ZMQError *error = nil;
        BOOL ret = NO;
        if (zmq_close(_socket) == -1)
        {
            error = [ZMQError new];
        }
        else
        {
            _socket = NULL;
            _endPoint = nil;
            ret = YES;
        }
        if (completion != NULL)
        {
            completion(ret, error);
        }
    });
}
- (BOOL)connectSyncWithEndPoint:(ZMQEndPoint *)endPoint withError:(ZMQError *__autoreleasing *)error
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    __block int ret;
    dispatch_sync(_queue, ^{
        ret = zmq_connect(_socket, [endPoint cString]);
    });
    ZMQError *err = nil;
    if (ret == -1)
    {
        _endPoint = nil;
        err = [ZMQError new];
    }
    else
    {
        _endPoint = endPoint;
    }
    if (error != NULL)
    {
        *error = err;
    }
    return (ret == 0);
}
- (void)connectAsyncWithEndPoint:(ZMQEndPoint *)endPoint withCompletion:(void (^)(BOOL success,ZMQError *error))completion
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    dispatch_async(_queue, ^{
        ZMQError *error = nil;
        BOOL ret = NO;
        if (zmq_connect(_socket, [endPoint cString]) == -1)
        {
            _endPoint = nil;
            error = [ZMQError new];
        }
        else
        {
            _endPoint = endPoint;
            ret = YES;
        }
        if (completion != NULL)
        {
            completion(ret, error);
        }
    });
}
- (BOOL)disconnectSyncWithError:(ZMQError *__autoreleasing *)error
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    if (_endPoint == nil)
    {
        *error = [[ZMQError alloc] initWithCode:ENOENT];
        return NO;
    }
    __block int ret;
    dispatch_sync(_queue, ^{
        ret =  zmq_disconnect(_socket, [_endPoint cString]);
    });
    ZMQError *err = nil;
    if (ret == -1)
    {
        err = [ZMQError new];
    }
    else
    {
        _endPoint = nil;
    }
    if (error != NULL)
    {
        *error = err;
    }
    return (ret == 0);
}
- (void)disconnectAsyncWithCompletion:(void (^)(BOOL success,ZMQError *error))completion
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    if (_endPoint == nil)
    {
        if (completion != NULL)
        {
            completion(NO, [[ZMQError alloc] initWithCode:ENOENT]);
        }
    }
    else
    {
        dispatch_async(_queue, ^{
            ZMQError *error = nil;
            BOOL ret = NO;
            if (zmq_disconnect(_socket, [_endPoint cString]) == -1)
            {
                error = [ZMQError new];
            }
            else
            {
                _endPoint = nil;
                ret = YES;
            }
            if (completion != NULL)
            {
                completion(ret, error);
            }
        });
    }
}
- (BOOL)bindSyncWithEndPoint:(ZMQEndPoint *)endPoint withError:(ZMQError *__autoreleasing *)error
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    __block int ret;
    dispatch_sync(_queue, ^{
        ret = zmq_bind(_socket, [endPoint cString]);
    });
    ZMQError *err = nil;
    if (ret == -1)
    {
        _endPoint = nil;
        err = [ZMQError new];
    }
    else
    {
        _endPoint = endPoint;
    }
    if (error != NULL)
    {
        *error = err;
    }
    return (ret == 0);
}
- (void)bindAsyncWithEndPoint:(ZMQEndPoint *)endPoint withCompletion:(void (^)(BOOL success,ZMQError *error))completion
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    dispatch_async(_queue, ^{
        ZMQError *error = nil;
        BOOL ret = NO;
        if (zmq_bind(_socket, [endPoint cString]) == -1)
        {
            _endPoint = nil;
            error = [ZMQError new];
        }
        else
        {
            _endPoint = endPoint;
            ret = YES;
        }
        if (completion != NULL)
        {
            completion(ret, error);
        }
    });
}
- (BOOL)sendSyncData:(NSData *)data multiPart:(BOOL)isMultiPart withError:(ZMQError *__autoreleasing *)error
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    NSUInteger len = [data length];
    ZMQError *err = nil;
    __block int ret = -1;
    if (len != 0)
    {
        dispatch_sync(_queue, ^{
            const void *buff = [data bytes];
            do {
                ret = zmq_send(_socket, buff, len, ZMQ_DONTWAIT | (isMultiPart?ZMQ_SNDMORE:0));
                if (ret == -1)
                {
                    ret = zmq_errno();
                }
                else
                {
                    ret = 0;
                }
            } while (ret == EAGAIN);
        });
        if (ret != 0)
        {
            err = [[ZMQError alloc] initWithCode:ret];
        }
    }
    if (error != NULL)
    {
        *error = err;
    }
    return (ret == 0);
}
- (void)sendAsyncData:(NSData *)data multiPart:(BOOL)isMultiPart withCompletion:(void (^)(BOOL success,ZMQError *error))completion
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    NSUInteger len = [data length];
    if (len == 0)
    {
        if (completion != NULL)
        {
            completion(NO, nil);
        }
    }
    else
    {
        dispatch_async(_queue, ^{
            ZMQError *error = nil;
            int ret = 0;
            const void *buff = [data bytes];
            do {
                ret = zmq_send(_socket, buff, len, ZMQ_DONTWAIT | (isMultiPart?ZMQ_SNDMORE:0));
                if (ret == -1)
                {
                    ret = zmq_errno();
                }
                else
                {
                    ret = 0;
                }
            } while (ret == EAGAIN);
            if (ret != 0)
            {
                error = [[ZMQError alloc] initWithCode:ret];
            }
            if (completion != NULL)
            {
                completion((ret == 0), error);
            }
        });
    }
}
- (BOOL)sendSyncData:(NSData *)data withPartSize:(NSUInteger)size withError:(ZMQError *__autoreleasing *)error
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    NSUInteger len = [data length];
    if (len < size)
    {
        return [self sendSyncData:data multiPart:NO withError:error];
    }
    NSData *part;
    NSRange range;
    for (NSUInteger i = 0; i < len; i += size)
    {
        range = NSMakeRange(i, size);
        part = [data subdataWithRange:range];
        if (![self sendSyncData:part multiPart:((len - i) != size) withError:error]) return NO;
    }
    if ((len % size) != 0)
    {
        range = NSMakeRange((len / size) * size, len % size);
        part = [data subdataWithRange:range];
        return [self sendSyncData:part multiPart:NO withError:error];
    }
    else return YES;
}
- (void)sendAsyncData:(NSData *)data withPartSize:(NSUInteger)size withCompletion:(void (^)(BOOL success,ZMQError *error))completion
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    NSUInteger len = [data length];
    if (len < size)
    {
        [self sendAsyncData:data multiPart:NO withCompletion:completion];
    }
    else
    {
        dispatch_async(_queue, ^{
            ZMQError *error = nil;
            int ret = -1;
            void *buff = (void *)[data bytes];
            void *ptr;
            for (ptr = buff; (ptr - buff) < len; ptr += size)
            {
                do {
                    ret = zmq_send(_socket, ptr, size, ZMQ_DONTWAIT | (((ptr - buff) != size)?ZMQ_SNDMORE:0));
                    if (ret == -1)
                    {
                        ret = zmq_errno();
                    }
                    else
                    {
                        ret = 0;
                    }
                } while (ret == EAGAIN);
                if (ret != 0)
                {
                    error = [[ZMQError alloc] initWithCode:ret];
                    break;
                }
            }
            if (((len % size) != 0) && (ret == 0))
            {
                do {
                    ret = zmq_send(_socket, (ptr - size), (len % size), ZMQ_DONTWAIT);
                    if (ret == -1)
                    {
                        ret = zmq_errno();
                    }
                    else
                    {
                        ret = 0;
                    }
                } while (ret == EAGAIN);
                if (ret != 0)
                {
                    error = [[ZMQError alloc] initWithCode:ret];
                }
            }
            if (completion != NULL)
            {
                completion((ret == 0), error);
            }
        });
    }
}
- (BOOL)sendSyncString:(NSString *)string withPartSize:(NSUInteger)size withError:(ZMQError **)error
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    if ([string length] < size)
    {
        return [self sendSyncString:string multiPart:NO withError:error];
    }
    const char *str = [string cStringUsingEncoding:NSUTF8StringEncoding];
    return [self sendSyncData:[NSData dataWithBytesNoCopy:(void *)str length:strlen(str)] withPartSize:(NSUInteger)size withError:error];
}
- (void)sendAsyncString:(NSString *)string withPartSize:(NSUInteger)size withCompletion:(void (^)(BOOL success,ZMQError *error))completion
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    if ([string length] < size)
    {
        [self sendAsyncString:string multiPart:NO withCompletion:completion];
    }
    else
    {
        const char *str = [string cStringUsingEncoding:NSUTF8StringEncoding];
        [self sendAsyncData:[NSData dataWithBytesNoCopy:(void *)str length:strlen(str)] withPartSize:(NSUInteger)size withCompletion:completion];
    }
}
- (BOOL)sendSyncString:(NSString *)string multiPart:(BOOL)isMultiPart withError:(ZMQError **)error
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    if ([string length] == 0)
    {
        if (error != NULL)
        {
            *error = nil;
        }
        return NO;
    }
    const char *str = [string cStringUsingEncoding:NSUTF8StringEncoding];
    return [self sendSyncData:[NSData dataWithBytesNoCopy:(void *)str length:strlen(str)] multiPart:isMultiPart withError:error];
}
- (void)sendAsyncString:(NSString *)string multiPart:(BOOL)isMultiPart withCompletion:(void (^)(BOOL success,ZMQError *error))completion
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    if ([string length] == 0)
    {
        if (completion != NULL)
        {
            completion(NO,nil);
        }
    }
    else
    {
        const char *str = [string cStringUsingEncoding:NSUTF8StringEncoding];
        [self sendAsyncData:[NSData dataWithBytesNoCopy:(void *)str length:strlen(str)] multiPart:isMultiPart withCompletion:completion];
    }
}
- (NSData *)receiveSyncWithError:(ZMQError *__autoreleasing *)error
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    __block ZMQError *err = nil;
    __block int ret;
    __block NSMutableData *data = nil;
    dispatch_sync(_queue, ^{
        int more = 0;
        size_t more_size = sizeof (more);
        do {
            zmq_msg_t part;
            ret = zmq_msg_init (&part);
            if (ret == 0)
            {
                do {
                    ret = zmq_recvmsg(_socket, &part, ZMQ_DONTWAIT);
                    if (ret == -1)
                    {
                        ret = zmq_errno();
                    }
                    else
                    {
                        ret = 0;
                    }
                } while (ret == EAGAIN);
                if (ret == 0)
                {
                    if (data == nil)
                    {
                        data = [NSMutableData dataWithBytes:zmq_msg_data(&part) length:zmq_msg_size(&part)];
                    }
                    else
                    {
                        [data appendBytes:zmq_msg_data(&part) length:zmq_msg_size(&part)];
                    }
                    if ((ret = zmq_getsockopt(_socket, ZMQ_RCVMORE, &more, &more_size)) != 0)
                    {
                        err = [ZMQError new];
                    }
                }
                else
                {
                    err = [[ZMQError alloc] initWithCode:ret];
                }
                zmq_msg_close (&part);
            }
            else
            {
                err = [ZMQError new];
            }
        } while ((more != 0) && (ret == 0));
    });
    if (error != NULL)
    {
        *error = err;
    }
    return data;
}
- (void)receiveAsyncWithCompletion:(void (^)(NSData *data,ZMQError *error))completion
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    dispatch_async(_queue, ^{
        ZMQError *error = nil;
        NSMutableData *data = nil;
        int more = 0;
        int ret;
        size_t more_size = sizeof (more);
        do {
            zmq_msg_t part;
            ret = zmq_msg_init(&part);
            if (ret == 0)
            {
                do {
                    ret = zmq_recvmsg(_socket, &part, ZMQ_DONTWAIT);
                    if (ret == -1)
                    {
                        ret = zmq_errno();
                    }
                    else
                    {
                        ret = 0;
                    }
                } while (ret == EAGAIN);
                if (ret == 0)
                {
                    if (data == nil)
                    {
                        data = [NSMutableData dataWithBytes:zmq_msg_data(&part) length:zmq_msg_size(&part)];
                    }
                    else
                    {
                        [data appendBytes:zmq_msg_data(&part) length:zmq_msg_size(&part)];
                    }
                    if ((ret = zmq_getsockopt(_socket, ZMQ_RCVMORE, &more, &more_size)) != 0)
                    {
                        error = [ZMQError new];
                    }
                }
                else
                {
                    error = [[ZMQError alloc] initWithCode:ret];
                }
                zmq_msg_close(&part);
            }
            else
            {
                error = [ZMQError new];
            }
        } while ((more != 0) && (ret == 0));
        if (completion != NULL)
        {
            completion(data, error);
        }
    });
}
@end
