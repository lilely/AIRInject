//
//  AIRSynchronizedResolver.m
//  AIRInject
//
//  Created by Stanley on 2019/12/7.
//  Copyright © 2019 AIRInject contributers. All rights reserved.
//

#import "AIRSynchronizedResolver.h"
#import "AIRContainer_priviate.h"
#import "AIRContainer+Arguments.h"
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
    return [self.container.lock sync:(^id{
        return [self.container resolve:protocol];
    })];
}

- (id)resolve:(Protocol *)protocol name:(NSString *)name {
    return [self.container.lock sync:(^id{
        return [self.container resolve:protocol name:name];
    })];
}

- (id)resolve:(Protocol *)protocol name:(NSString *)name arguments:(id)arguments, ...{
    return [self.container.lock sync:(^id{
        return [self.container resolve:protocol name:name arguments:arguments];
    })];
}

- (id)resolveClass:(Class)class {
    return [self.container.lock sync:(^id{
        return [self.container resolveClass:class];
    })];
}

- (id)resolveClass:(Class)class name:(NSString *)name {
    return [self.container.lock sync:(^id{
        return [self.container resolveClass:class name:name];
    })];
}

- (id)resolveClass:(Class)class name:(NSString *)name arguments:(id)arguments, ...{
    return [self.container.lock sync:(^id{
        return [self.container resolveClass:class name:name arguments:arguments];
    })];
}

@end
