//
//  AIRContainer_priviate.h
//  AIRInject
//
//  Created by Stanley on 2019/12/7.
//  Copyright © 2019 AIRInject contributers. All rights reserved.
//

#ifndef AIRContainer_priviate_h
#define AIRContainer_priviate_h

#import "AIRContainer.h"
#import "SyncLock.h"

@interface AIRContainer()

@property (nonatomic, strong) SyncLock * _Nonnull lock;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"
- (AIRServiceEntry *)_register:(Protocol *)protocol name:(NSString * __nullable)name commponFactory:(id _Nonnull (^)())factory;

- (AIRServiceEntry *)_registerClass:(Class)klass name:(NSString * __nullable)name commponFactory:(id _Nonnull (^)())factory;

- (id)_resolve:(Protocol *)protocol name:(NSString* __nullable)name invoker:(id (^)(id (^)(id<AIRResolverProtocol>)))invoker;

- (id)_resolveClass:(Class)class name:(NSString* __nullable)name invoker:(id (^)(id (^)(id<AIRResolverProtocol>)))invoker;
#pragma clang diagnostic pop

@end

#endif /* AIRContainer_priviate_h */
