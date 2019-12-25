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
#import "NSInvocation+Block.h"
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
    __block va_list args;
    va_start(args, arguments);
    NSMutableArray *argumentsArray = [[NSMutableArray alloc] init];
    for (id argument = arguments; argument != nil; argument = va_arg(args, id)) {
        [argumentsArray addObject:argument];
    }
    va_end(args);
    return [self.container.lock sync:(^id{
        void *containerRef = &(self->_container);
        return [self.container _resolve:protocol name:name invoker:^id(id (^factory)()) {
            void *result;
            NSInvocation *invocation = [NSInvocation invocationWithBlock:factory];
            NSUInteger argumentCount = invocation.methodSignature.numberOfArguments;
            [invocation setArgument:containerRef atIndex:1];
            [argumentsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx+2 == argumentCount) {
                    *stop = YES;
                } else {
                    [invocation setArgument:&obj atIndex:idx+2];
                }
            }];
            [invocation invoke];
            [invocation getReturnValue:&result];
            return (__bridge id)result;
        }];
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

- (id)resolveClass:(Class)klass name:(NSString *)name arguments:(id)arguments, ...{
    __block va_list args;
    va_start(args, arguments);
    NSMutableArray *argumentsArray = [[NSMutableArray alloc] init];
    for (id argument = arguments; argument != nil; argument = va_arg(args, id)) {
        [argumentsArray addObject:argument];
    }
    va_end(args);
    return [self.container.lock sync:(^id{
        void* containerRef = &(self->_container);
        return [self.container _resolveClass:klass name:name invoker:^id(id (^factory)()) {
            void *result;
            NSInvocation *invocation = [NSInvocation invocationWithBlock:factory];
            NSUInteger argumentCount = invocation.methodSignature.numberOfArguments;
            [invocation setArgument:containerRef atIndex:1];
            [argumentsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx+2 == argumentCount) {
                    *stop = YES;
                } else {
                    [invocation setArgument:&obj atIndex:idx+2];
                }
            }];
            [invocation invoke];
            [invocation getReturnValue:&result];
            return (__bridge id)result;
        }];
    })];
}

@end
