//
//  AIRServiceEntry.h
//  Inject
//
//  Created by Stanley on 2019/9/5.
//  Copyright © 2019 AIRInject contributers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AIRResolver.h"
#import "AIRInstanceStorage.h"
#import "AIRObjectScope.h"
#import "AIRServiceKey.h"

/// This Class hold the factory block to create or resolve instances in specified scope.
/// In some scope the instance will be stored in the storage property of this class.
/// The defualt scope is graph.

NS_ASSUME_NONNULL_BEGIN

//typedef id _Nonnull (^AIRFactoryBlock)(id<AIRResolverProtocol> resolver);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"
typedef id _Nonnull (^AIRFactoryBlock)();
#pragma clang diagnostic pop

@protocol AIREntryProtocol <NSObject>

@property (nonatomic, strong, readonly) id<AIRInstanceStorageProtocol> storage;

@property (nonatomic, copy, readonly) AIRFactoryBlock factory;

@property (nonatomic, strong, readonly) AIRObjectScope *objectScope;

- (instancetype)inObjectScopeType:(AIRScopeType)scopeType;

- (instancetype)initCompleted:(void (^)(id<AIRResolverProtocol> resolver, id service))completed;

- (void)initCompleted:(id)instance resolver:(id<AIRResolverProtocol>)resolver;

@end

@interface AIRServiceEntry : NSObject <AIREntryProtocol>

- (instancetype)initWithKey:(AIRServiceKey *)key factory:(AIRFactoryBlock)factory;

- (instancetype)initWithKey:(AIRServiceKey *)key objectScope:(AIRObjectScope * __nullable)objectScope factory:(AIRFactoryBlock)factory;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
