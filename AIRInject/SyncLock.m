//
//  SyncLock.m
//  AIRInject
//
//  Created by Stanley on 2019/12/8.
//  Copyright © 2019 AIRInject contributers. All rights reserved.
//

#import "SyncLock.h"
#import <pthread.h>

@interface SyncLock()

@property (nonatomic, assign) pthread_mutex_t lock;

@end

@implementation SyncLock

- (instancetype)init {
    if (self = [super init]) {
        pthread_mutexattr_t attr;
        pthread_mutexattr_init(&attr);
        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
        pthread_mutex_init(&_lock,nil);
    }
    return self;
}

- (void)dealloc {
    pthread_mutex_destroy(&_lock);
}

- (id)sync:(id (^)(void))block {
    id(^syncBlock)(void) = ^id(){
        id ret;
        pthread_mutex_lock(&self->_lock);
        ret = block();
        pthread_mutex_unlock(&self->_lock);
        return ret;
    };
    return syncBlock();
}

@end
