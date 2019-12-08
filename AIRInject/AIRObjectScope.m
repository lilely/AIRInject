//
//  AIRObjectScope.m
//  Inject
//
//  Created by Stanley on 2019/9/9.
//  Copyright © 2019 AIRInject contributers. All rights reserved.
//

#import "AIRObjectScope.h"
#import "AIRInstanceStorage.h"

@interface AIRObjectScope()

@property (nonatomic, assign) AIRScopeType scopeType;

@end

@implementation AIRObjectScope

- (instancetype)initWithScopeType:(AIRScopeType)scopeType {
    if (self = [super init]) {
        _scopeType = scopeType;
    }
    return self;
}

- (nonnull id<AIRInstanceStorageProtocol>)makeStorage {
    switch (self.scopeType) {
            case AIRScopeTypeGraph: {
                return [AIRGraphStorage new];
            }
            break;
            case AIRScopeTypePermanent: {
                return [AIRPermanentStorage new];
            }
            break;
            case AIRScopeTypeTransient: {
                return [AIRTransientStorage new];
            }
            break;
            case AIRScopeTypeWeak: {
                return [AIRWeakStorage new];
            }
            break;
        default:
            return [AIRGraphStorage new];
            break;
    }
}

@end
