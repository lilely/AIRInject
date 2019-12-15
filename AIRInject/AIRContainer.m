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
#import "NSInvocation+Block.h"
#import <pthread.h>

@interface AIRContainer()

@property (nonatomic, strong) NSMutableDictionary<AIRServiceKey *,AIRServiceEntry *> *services;

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

- (AIRServiceEntry *)register:(Protocol *)protocol name:(NSString * __nullable)name paramOneFactory:(id _Nonnull (^)(id<AIRResolverProtocol> resolver,id param1))factory {
    return [self _register:protocol name:name commponFactory:factory];
}

- (AIRServiceEntry *)register:(Protocol *)protocol name:(NSString * __nullable)name paramTwoFactory:(id _Nonnull (^)(id<AIRResolverProtocol> resolver,id param1, id param2))factory {
    return [self _register:protocol name:name commponFactory:factory];
}

- (AIRServiceEntry *)register:(Protocol *)protocol name:(NSString * __nullable)name paramThreeFactory:(id _Nonnull (^)(id<AIRResolverProtocol> resolver,id param1, id param2,id param3))factory {
    return [self _register:protocol name:name commponFactory:factory];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"
- (AIRServiceEntry *)_register:(Protocol *)protocol name:(NSString *)name commponFactory:(id _Nonnull (^)())factory {
    AIRServiceKey *key = [[AIRServiceKey alloc] initWithKlassIdentifier:NSStringFromProtocol(protocol) name:name];
    AIRServiceEntry *entry = [[AIRServiceEntry alloc] initWithKey:key objectScope:self.scope factory:factory];
    self.services[key] = entry;
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

- (id)resolve:(Protocol *)protocol name:(NSString *)name arguments:(id)arguments, ...{
    va_list args;
    va_start(args, arguments);
    NSMutableArray *argumentsArray = [[NSMutableArray alloc] init];
    for (id argument = arguments; argument != nil; argument = va_arg(args, id)) {
        [argumentsArray addObject:argument];
    }
    va_end(args);
    id container = self;
    return [self _resolve:protocol name:name invoker:^id(id (^factory)()) {
        void *result;
        NSInvocation *invocation = [NSInvocation invocationWithBlock:factory];
        NSUInteger argumentCount = invocation.methodSignature.numberOfArguments;
        [invocation setArgument:&container atIndex:1];
        [argumentsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx+2 == argumentCount) {
                *stop = YES;
            } else {
                [invocation setArgument:&obj atIndex:idx+2];
            }
        }];
        [invocation invoke];
        [invocation getReturnValue:&result];
        return (__bridge id)result;
    }];
}

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
