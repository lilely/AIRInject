//
//  AIRContainter.m
//  Inject
//
//  Created by Stanley on 2019/9/5.
//  Copyright © 2019 AIRInject contributers. All rights reserved.
//

#import "AIRContainer.h"
#import "AIRContainer_priviate.h"
#import "AIRGraphIdentifier.h"
#import "AIRServiceKey.h"

@interface AIRContainer()

@property (nonatomic, strong) NSMutableDictionary<AIRServiceKey *,AIRServiceEntry *> *services;

@property (nonatomic, strong) NSMutableDictionary<AIRServiceKey *,AIRServiceEntry *> *klassServices;

@property (nonatomic, assign) NSUInteger resolutionDepth;

@property (nonatomic, strong) AIRGraphIdentifier *currentObjectGraph;

@property (nonatomic, assign) AIRScopeType scopeType;

@property (nonatomic, strong) AIRObjectScope *scope;

@property (nonatomic, strong) AIRContainer *parenet;

@end

@implementation AIRContainer

- (instancetype)initWithScope:(AIRScopeType)scopeType parent:(AIRContainer *)parent{
    if (self = [super init]) {
        _scopeType = scopeType;
        _parenet = parent;
        _scope = [[AIRObjectScope alloc] initWithScopeType:scopeType];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        _scopeType = AIRScopeTypeGraph;
        _parenet = nil;
        _scope = [[AIRObjectScope alloc] initWithScopeType:AIRScopeTypeGraph];
    }
    return self;
}

- (AIRServiceEntry *)register:(Protocol *)protocol factory:(id _Nonnull (^)(id<AIRResolverProtocol> resolver))factory {
    return [self register:protocol name:nil factory:factory];
}

- (AIRServiceEntry *)register:(Protocol *)protocol name:(NSString *)name factory:(id _Nonnull (^)(id<AIRResolverProtocol> resolver))factory {
    return [self _register:protocol name:name commponFactory:factory];
}

- (AIRServiceEntry *)registerClass:(Class)klass factory:(id _Nonnull (^)(id<AIRResolverProtocol> resolver))factory {
    return [self registerClass:klass name:nil factory:factory];
}

- (AIRServiceEntry *)registerClass:(Class)klass name:(NSString * __nullable)name factory:(id _Nonnull (^)(id<AIRResolverProtocol> resolver))factory {
    return [self _registerClass:klass name:name commponFactory:factory];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"
- (AIRServiceEntry *)_register:(Protocol *)protocol name:(NSString *)name commponFactory:(id _Nonnull (^)())factory {
    AIRServiceKey *key = [[AIRServiceKey alloc] initWithKlassIdentifier:NSStringFromProtocol(protocol) name:name];
    AIRServiceEntry *entry = [[AIRServiceEntry alloc] initWithKey:key objectScope:self.scope factory:factory];
    self.services[key] = entry;
    return entry;
}

- (AIRServiceEntry *)_registerClass:(Class)klass name:(NSString *)name commponFactory:(id _Nonnull (^)())factory {
    AIRServiceKey *key = [[AIRServiceKey alloc] initWithKlassIdentifier:NSStringFromClass(klass) name:name];
    AIRServiceEntry *entry = [[AIRServiceEntry alloc] initWithKey:key objectScope:self.scope factory:factory];
    self.klassServices[key] = entry;
    return entry;
}

#pragma clang diagnostic pop

- (id)_resolve:(Protocol *)protocol name:(NSString*)name invoker:(id (^)(id (^)(id<AIRResolverProtocol>)))invoker {
    AIRServiceKey *key = [[AIRServiceKey alloc] initWithKlassIdentifier:NSStringFromProtocol(protocol) name:name];
    AIRServiceEntry *entry = [self entryOfServiceKey:key];
    id instance = nil;
    if (!entry) {
        return nil;
    }
    instance = [self resolveByEntry:entry invoker:invoker];
    if (![instance conformsToProtocol:protocol]) {
        NSAssert(NO, @"Instace resolved does not confrim to protocol");
    }
    return instance;
}

- (id)_resolveClass:(Class)class name:(NSString*)name invoker:(id (^)(id (^)(id<AIRResolverProtocol>)))invoker {
    AIRServiceKey *key = [[AIRServiceKey alloc] initWithKlassIdentifier:NSStringFromClass(class) name:name];
    AIRServiceEntry *entry = [self classEntryOfServiceKey:key];
    id instance = nil;
    if (!entry) {
        return nil;
    }
    instance = [self resolveByEntry:entry invoker:invoker];
    if (![instance isKindOfClass:class]) {
        NSAssert(NO, @"Instace resolved does not confrim to protocol");
    }
    return instance;
}

- (id)resolveByEntry:(AIRServiceEntry *)entry invoker:(id (^)(id (^)(id<AIRResolverProtocol>)))invoker {
    if (!entry) {
        return nil;
    }
    [self incrementResolutionDepth];
    AIRGraphIdentifier *graphIdentifier = self.currentObjectGraph;
    if (!graphIdentifier) {
        NSAssert(NO, @"If accessing container from multiple threads, make sure to use a synchronized resolver.");
    }
    id persistedInstance = [entry.storage instance:graphIdentifier];
    if (persistedInstance) {
        [self decrementResolutionDepth];
        return persistedInstance;
    }
    id resolvedInstance = invoker(entry.factory);
    persistedInstance = [entry.storage instance:graphIdentifier];
    if (persistedInstance) {
        [self decrementResolutionDepth];
        return persistedInstance;
    }
    [entry.storage setInstance:resolvedInstance graph:graphIdentifier];
    if (resolvedInstance) {
        [entry initCompleted:resolvedInstance resolver:self];
    }
    
    [self decrementResolutionDepth];
    return resolvedInstance;
}

- (id)resolve:(Protocol *)protocol invoker:(id (^)(id (^)(id<AIRResolverProtocol>)))invoker {
    return [self _resolve:protocol name:nil invoker:invoker];
}

- (AIRServiceEntry *)entryOfServiceKey:(AIRServiceKey *)key {
    if (!key) {
        return nil;
    }
    AIRServiceEntry *entry = [self.services objectForKey:key];
    if (!entry) {
        entry = [self.parenet entryOfServiceKey:key];
    }
    return entry;
}

- (AIRServiceEntry *)classEntryOfServiceKey:(AIRServiceKey *)key {
    if (!key) {
        return nil;
    }
    AIRServiceEntry *entry = [self.klassServices objectForKey:key];
    if (!entry) {
        entry = [self.parenet classEntryOfServiceKey:key];
    }
    return entry;
}

- (void)incrementResolutionDepth {
    if (self.resolutionDepth == 0 && self.currentObjectGraph == nil) {
        self.currentObjectGraph = [AIRGraphIdentifier new];
    }
    if (self.resolutionDepth > 200) {
        NSAssert(NO, @"Infinite recursive call for circular dependency has been detected.");
        return;
    }
    self.resolutionDepth += 1;
}

- (void)decrementResolutionDepth {
    NSAssert(self.resolutionDepth > 0, @"The depth cannot be negative.");
    self.resolutionDepth -= 1;
    if (self.resolutionDepth == 0) {
        [self graphResolutionCompleted];
    }
}

- (void)graphResolutionCompleted {
    [self.services.allValues enumerateObjectsUsingBlock:^(AIRServiceEntry * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.storage graphResolutionCompleted];
    }];
    self.currentObjectGraph = nil;
}

#pragma mark - AIRResolverProtocol

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"
- (id)resolve:(Protocol *)protocol {
    return [self _resolve:protocol name:nil invoker:^id(id (^factory)()) {
        return factory(self);
    }];
}

- (id)resolve:(Protocol *)protocol name:(NSString *)name {
    return [self _resolve:protocol name:name invoker:^id(id (^factory)()) {
        return factory(self);
    }];
}
#pragma clang diagnostic pop

#pragma mark - Getter

- (NSDictionary<AIRServiceKey *,AIRServiceEntry *> *)services {
    if (!_services) {
        _services = [[NSMutableDictionary alloc] init];
    }
    return _services;
}

- (SyncLock *)lock{
    if (!_lock) {
        _lock = [[SyncLock alloc] init];
    }
    return _lock;
}

@end
