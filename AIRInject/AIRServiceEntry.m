//
//  AIRServiceEntry.m
//  Inject
//
//  Created by Stanley on 2019/9/5.
//  Copyright © 2019 AIRInject contributers. All rights reserved.
//

#import "AIRServiceEntry.h"
#import "AIRServiceKey.h"

typedef void(^initCompleted)(id<AIRResolverProtocol> resolver, id service);

@interface AIRServiceEntry()

@property (nonatomic, strong) AIRServiceKey *key;

@property (nonatomic, copy) AIRFactoryBlock factory;

@property (nonatomic, strong) AIRObjectScope *objectScope;

@property (nonatomic, copy) NSMutableArray<initCompleted>* completedActions;

@end

@implementation AIRServiceEntry

@synthesize objectScope = _objectScope;
@synthesize storage = _storage;

- (instancetype)initWithKey:(AIRServiceKey *)key factory:(AIRFactoryBlock)factory {
    return [self initWithKey:key objectScope:nil factory:factory];
}

- (instancetype)initWithKey:(AIRServiceKey *)key objectScope:(AIRObjectScope *)objectScope factory:(AIRFactoryBlock)factory {
    if (self = [super init]) {
        _key = key;
        _factory = factory;
        _objectScope = objectScope;
    }
    return self;
}

- (instancetype)inObjectScope:(AIRObjectScope *)scope {
    self.objectScope = scope;
    return self;
}

- (instancetype)inObjectScopeType:(AIRScopeType)scopeType {
    return [self inObjectScope:[[AIRObjectScope alloc] initWithScopeType:scopeType]];
}

- (instancetype)initCompleted:(void (^)(id<AIRResolverProtocol> resolver, id service))completed {
    [self.completedActions addObject:completed];
    return self;
}

- (void)initCompleted:(id)instance resolver:(id<AIRResolverProtocol>)resolver{
    for (initCompleted completed in self.completedActions) {
        completed(resolver,instance);
    }
}

#pragma mark - getter

- (id<AIRInstanceStorageProtocol>)storage {
    if (!_storage) {
        _storage = [self.objectScope makeStorage];
    }
    return _storage;
}

- (AIRObjectScope *)objectScope {
    if (!_objectScope) {
        _objectScope = [[AIRObjectScope alloc] initWithScopeType:AIRScopeTypeGraph];
    }
    return _objectScope;
}

- (NSMutableArray<initCompleted>*)completedActions {
    if (!_completedActions) {
        _completedActions = [[NSMutableArray alloc] init];
    }
    return _completedActions;
}

@end
