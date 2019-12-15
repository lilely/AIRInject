//
//  AIRContainer+Arguments.m
//  AIRInject
//
//  Created by Stanley on 2019/12/15.
//  Copyright © 2019 com.corp.jinxing. All rights reserved.
//

#import "AIRContainer+Arguments.h"
#import "AIRContainer_priviate.h"
#import "NSInvocation+Block.h"

@implementation AIRContainer(Arguments)

- (AIRServiceEntry *)register:(Protocol *)protocol name:(NSString * __nullable)name paramOneFactory:(id _Nonnull (^)(id<AIRResolverProtocol> resolver,id param1))factory {
    return [self _register:protocol name:name commponFactory:factory];
}

- (AIRServiceEntry *)register:(Protocol *)protocol name:(NSString * __nullable)name paramTwoFactory:(id _Nonnull (^)(id<AIRResolverProtocol> resolver,id param1, id param2))factory {
    return [self _register:protocol name:name commponFactory:factory];
}

- (AIRServiceEntry *)register:(Protocol *)protocol name:(NSString * __nullable)name paramThreeFactory:(id _Nonnull (^)(id<AIRResolverProtocol> resolver,id param1, id param2,id param3))factory {
    return [self _register:protocol name:name commponFactory:factory];
}

- (AIRServiceEntry *)registerClass:(Class)class name:(NSString * __nullable)name paramOneFactory:(id _Nonnull (^)(id<AIRResolverProtocol> resolver,id param1))factory {
    return [self _registerClass:class name:name commponFactory:factory];
}

- (AIRServiceEntry *)registerClass:(Class)class name:(NSString * __nullable)name paramTwoFactory:(id _Nonnull (^)(id<AIRResolverProtocol> resolver,id param1, id param2))factory {
    return [self _registerClass:class name:name commponFactory:factory];
}

- (AIRServiceEntry *)registerClass:(Class)class name:(NSString * __nullable)name paramThreeFactory:(id _Nonnull (^)(id<AIRResolverProtocol> resolver,id param1, id param2,id param3))factory {
    return [self _registerClass:class name:name commponFactory:factory];
}

- (id)resolve:(Protocol *)protocol name:(NSString *)name arguments:(id)arguments, ...{
    va_list args;
    va_start(args, arguments);
    NSMutableArray *argumentsArray = [[NSMutableArray alloc] init];
    for (id argument = arguments; argument != nil; argument = va_arg(args, id)) {
        [argumentsArray addObject:argument];
    }
    va_end(args);
    id container = self;
    return [self _resolve:protocol name:name invoker:^id(id (^factory)()) {
        void *result;
        NSInvocation *invocation = [NSInvocation invocationWithBlock:factory];
        NSUInteger argumentCount = invocation.methodSignature.numberOfArguments;
        [invocation setArgument:&container atIndex:1];
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
}

- (id)resolveClass:(Class)klass name:(NSString * __nullable)name arguments:(id)arguments, ... {
    va_list args;
    va_start(args, arguments);
    NSMutableArray *argumentsArray = [[NSMutableArray alloc] init];
    for (id argument = arguments; argument != nil; argument = va_arg(args, id)) {
        [argumentsArray addObject:argument];
    }
    va_end(args);
    id container = self;
    return [self _resolveClass:klass name:name invoker:^id(id (^factory)()) {
        void *result;
        NSInvocation *invocation = [NSInvocation invocationWithBlock:factory];
        NSUInteger argumentCount = invocation.methodSignature.numberOfArguments;
        [invocation setArgument:&container atIndex:1];
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
}

@end
