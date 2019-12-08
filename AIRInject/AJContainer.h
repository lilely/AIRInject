//
//  AJContainter.h
//  Inject
//
//  Created by jinxing on 2019/9/5.
//  Copyright © 2019 Tantan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AJResolver.h"
#import "AJServiceEntry.h"

/// The `Container` class represents a dependency injection container, which stores registrations of services
/// and retrieves registered services with dependencies injected.
///
/// **Example to register:**
///
///     AJContainter *container = [AJContainter new];
///     [container register:protocolB factory:^id _Nonnull(id<AJResolverProtocol>  _Nonnull resolver) {
///         ClassB * instanceB = [ClassB new];
///         instanceB.propertyC = [resolver resolve:protocolC];
///         return instanceB;
///     }];
///     [container register:protocolA factory:^id _Nonnull(id<AJResolverProtocol>  _Nonnull resolver) {
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

@interface AIRContainer : NSObject<AJResolverProtocol>
/*
 Initialize by scope type.
 */
- (instancetype)initWithScope:(AJScopeType)scopeType parent:(AIRContainer * _Nullable )parent;

/*
 Register a protocol with block to create or resolve one instance for that protocol.
 */
- (AJServiceEntry *)register:(Protocol *)protocol factory:(id _Nonnull (^)(id<AJResolverProtocol> resolver))factory;

- (AJServiceEntry *)register:(Protocol *)protocol name:(NSString * __nullable)name factory:(id _Nonnull (^)(id<AJResolverProtocol> resolver))factory;

- (AJServiceEntry *)register:(Protocol *)protocol name:(NSString * __nullable)name paramOneFactory:(id _Nonnull (^)(id<AJResolverProtocol> resolver,id param1))factory;

- (AJServiceEntry *)register:(Protocol *)protocol name:(NSString * __nullable)name paramTwoFactory:(id _Nonnull (^)(id<AJResolverProtocol> resolver,id param1, id param2))factory;

- (AJServiceEntry *)register:(Protocol *)protocol name:(NSString * __nullable)name paramThreeFactory:(id _Nonnull (^)(id<AJResolverProtocol> resolver,id param1, id param2,id param3))factory;

@end

NS_ASSUME_NONNULL_END
