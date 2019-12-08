//
//  AIRObjectScope.h
//  Inject
//
//  Created by Stanley on 2019/9/9.
//  Copyright © 2019 AIRInject contributers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AIRInstanceStorage.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, AIRScopeType) {
    AIRScopeTypeGraph,
    AIRScopeTypePermanent,
    AIRScopeTypeTransient,
    AIRScopeTypeWeak,
};

@protocol AIRObjectScopeProtocol <NSObject>

- (id<AIRInstanceStorageProtocol>)makeStorage;

@end

@interface AIRObjectScope : NSObject <AIRObjectScopeProtocol>

@property (nonatomic, assign, readonly) AIRScopeType scopeType;

- (instancetype)initWithScopeType:(AIRScopeType)scopeType NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
