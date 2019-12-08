//
//  AIRContainter.h
//  Inject
//
//  Created by Stanley on 2019/9/5.
//  Copyright © 2019 AIRInject contributers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AIRResolver.h"
#import "AIRServiceEntry.h"

/// The `Container` class represents a dependency injection container, which stores registrations of services
/// and retrieves registered services with dependencies injected.
///
/// **Example to register:**
///
///     AIRContainter *container = [AIRContainter new];
///     [container register:protocolB factory:^id _Nonnull(id<AIRResolverProtocol>  _Nonnull resolver) {
///         ClassB * instanceB = [ClassB new];
///         instanceB.propertyC = [resolver resolve:protocolC];
///         return instanceB;
///     }];
///     [container register:protocolA factory:^id _Nonnull(id<AIRResolverProtocol>  _Nonnull resolver) {
///         ClassA * instanceA = [ClassA new];
///         instanceA.propertyB = [resolver resolve:protocolB];
///         return instanceA;
///     }];
///
/// **Example to retrieve:**
///
///     ClassA *A = [container resolve:protocolA];
///
/// where `A` and `X` are protocols, `B` is a type conforming `A`, and `Y` is a type conforming `X`
/// and depending on `A`.

NS_ASSUME_NONNULL_BEGIN

@interface AIRContainer : NSObject<AIRResolverProtocol>
/*
 Initialize by scope type.
 */
- (instancetype)initWithScope:(AIRScopeType)scopeType parent:(AIRContainer * _Nullable )parent;

/*
 Register a protocol with block to create or resolve one instance for that protocol.
 */
- (AIRServiceEntry *)register:(Protocol *)protocol factory:(id _Nonnull (^)(id<AIRResolverProtocol> resolver))factory;

- (AIRServiceEntry *)register:(Protocol *)protocol name:(NSString * __nullable)name factory:(id _Nonnull (^)(id<AIRResolverProtocol> resolver))factory;

- (AIRServiceEntry *)register:(Protocol *)protocol name:(NSString * __nullable)name paramOneFactory:(id _Nonnull (^)(id<AIRResolverProtocol> resolver,id param1))factory;

- (AIRServiceEntry *)register:(Protocol *)protocol name:(NSString * __nullable)name paramTwoFactory:(id _Nonnull (^)(id<AIRResolverProtocol> resolver,id param1, id param2))factory;

- (AIRServiceEntry *)register:(Protocol *)protocol name:(NSString * __nullable)name paramThreeFactory:(id _Nonnull (^)(id<AIRResolverProtocol> resolver,id param1, id param2,id param3))factory;

@end

NS_ASSUME_NONNULL_END
