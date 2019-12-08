//
//  AIRSynchronizedResolver.m
//  AIRInject
//
//  Created by Stanley on 2019/12/7.
//  Copyright © 2019 AIRInject contributers. All rights reserved.
//

#import "AIRSynchronizedResolver.h"
#import "AIRContainer_priviate.h"
#import <pthread.h>

@interface AIRSynchronizedResolver()

@property (nonatomic, strong) AIRContainer *container;

@end

@implementation AIRSynchronizedResolver

- (instancetype)initWithContainer:(AIRContainer *)container {
    if (self = [super init]) {
        _container = container;
    }
    return self;
}

- (id)resolve:(Protocol *)protocol {
    return self.container.lock.sync(^id{
        return [self.container resolve:protocol];
    });
}

- (id)resolve:(Protocol *)protocol name:(NSString *)name {
    return self.container.lock.sync(^id{
        return [self.container resolve:protocol name:name];
    });
}

- (id)resolve:(Protocol *)protocol name:(NSString *)name param1:(id)param1 {
    return self.container.lock.sync(^id{
        return [self.container resolve:protocol name:name param1:param1];
    });
}

- (id)resolve:(Protocol *)protocol name:(NSString *)name param1:(id)param1 param2:(id)param2 {
    return self.container.lock.sync(^id{
        return [self.container resolve:protocol name:name param1:param1 param2:param2];
    });
}

- (id)resolve:(Protocol *)protocol name:(NSString *)name param1:(id)param1 param2:(id)param2 param3:(id)param3 {
    return self.container.lock.sync(^id{
        return [self.container resolve:protocol name:name param1:param1 param2:param2 param3:param3];
    });
}


@end
