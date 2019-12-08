//
//  AIRInstanceStorage.m
//  Inject
//
//  Created by Stanley on 2019/9/9.
//  Copyright © 2019 AIRInject contributers. All rights reserved.
//

#import "AIRInstanceStorage.h"

@class AIRWeakWrapper;

@interface AIRWeakWrapper : NSObject

@property (nonatomic, weak) id object;

@end

@implementation AIRWeakWrapper

@end

@interface AIRGraphStorage()

@property (nonatomic, strong) NSMutableDictionary<AIRGraphIdentifier *,AIRWeakWrapper *> *instances;

@end

@implementation AIRGraphStorage

@synthesize instance = _instance;

- (nonnull id)instance:(nonnull AIRGraphIdentifier *)graph {
    return self.instances[graph];
}

- (void)setInstance:(id _Nonnull)instance graph:(nonnull AIRGraphIdentifier *)graph {
    self.instance = instance;
    if (!self.instances[graph]) {
        self.instances[graph] = [AIRWeakWrapper new];
    }
    self.instances[graph] = instance;
}

- (void)graphResolutionCompleted {
    _instance = nil;
}

- (NSMutableDictionary<AIRGraphIdentifier *,AIRWeakWrapper *> *)instances {
    if (!_instances) {
        _instances = [[NSMutableDictionary alloc] init];
    }
    return _instances;
}

@end

@implementation AIRPermanentStorage

@synthesize instance = _instance;

- (void)graphResolutionCompleted {
    return;
}

- (nonnull id)instance:(nonnull AIRGraphIdentifier *)graph {
    return _instance;
}

- (void)setInstance:(id _Nonnull)instance graph:(nonnull AIRGraphIdentifier *)graph {
    self.instance = instance;
}

@end

@implementation AIRTransientStorage

@synthesize instance;

- (void)graphResolutionCompleted {
    return;
}

- (nonnull id)instance:(nonnull AIRGraphIdentifier *)graph {
    return nil;
}

- (void)setInstance:(id _Nonnull)instance graph:(nonnull AIRGraphIdentifier *)graph {
    return;
}

@end

@interface AIRWeakStorage()

@property (nonatomic, strong) AIRWeakWrapper *instanceWrapped;

@end

@implementation AIRWeakStorage

@synthesize instance = _instance;

- (void)graphResolutionCompleted {
    return;
}

- (nonnull id)instance:(nonnull AIRGraphIdentifier *)graph {
    return self.instance;
}

- (void)setInstance:(id _Nonnull)instance graph:(nonnull AIRGraphIdentifier *)graph {
    self.instance = instance;
}

- (AIRWeakWrapper *)instanceWrapped {
    if (!_instanceWrapped){
        _instanceWrapped = [AIRWeakWrapper new];
    }
    return _instanceWrapped;
}

- (id)instance {
    return self.instanceWrapped.object;
}

- (void)setInstance:(id)instance {
    self.instanceWrapped.object = instance;
}

@end
