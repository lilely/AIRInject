//
//  AIRInstanceStorage.h
//  Inject
//
//  Created by Stanley on 2019/9/9.
//  Copyright © 2019 AIRInject contributers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AIRGraphIdentifier.h"

NS_ASSUME_NONNULL_BEGIN

@protocol AIRInstanceStorageProtocol <NSObject>

@property (nonatomic, strong) id instance;

- (id)instance:(AIRGraphIdentifier *)graph;

- (void)setInstance:(id _Nonnull)instance graph:(AIRGraphIdentifier *)graph;

- (void)graphResolutionCompleted;

@end

/// Instances are shared only when an object graph is being created,
/// otherwise a new instance is created by the `Container`. This is the default scope.

@interface AIRGraphStorage : NSObject<AIRInstanceStorageProtocol>

@end

/// An instance provided by the `Container` is shared within the `Container``.

@interface AIRPermanentStorage : NSObject<AIRInstanceStorageProtocol>

@end

/// A new instance is always created by the `Container` when a type is resolved.
/// The instance is not shared.

@interface AIRTransientStorage : NSObject<AIRInstanceStorageProtocol>

@end

/// An instance provided by the `Container` is shared within the `Container`
/// as long as there are strong references to given instance. Otherwise new instance is created
/// when resolving the type.

@interface AIRWeakStorage : NSObject<AIRInstanceStorageProtocol>

@end

NS_ASSUME_NONNULL_END
