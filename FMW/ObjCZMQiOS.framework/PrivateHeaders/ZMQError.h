//
//  ZMQError.h
//  ObjCZMQ
//
//  Created by ALEXEY LOBANOV on 03.02.16.
//  Copyright © 2016 Blue Skies Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kZMQErrorDomain   @"ZMQErrorDomain"

@interface ZMQError : NSError
- (instancetype)init;
@end
