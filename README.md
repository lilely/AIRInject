# AIRInject
This is a lightweight Dependency Inject framework of Object-C.

Dependency injection is a softwaire pattern that implements Inversion of Control (IoC) for resolving dependencies.In this pattern AIRInject helps your app split into loosely-coupled components, which can be developed, tested and maintained more easily.The design of this framework is inspired by [SWInject] which is a Dependency Inject framework of Swift.

[SWinject]: https://github.com/Swinject/Swinject "SWInject"

## Features

### Basics

The `AIRContainter` class represents a dependency injection container, which stores registrations of services and retrieves registered services with dependencies injected.
```Object-C
     AIRContainter *container = [AIRContainter new];
     [container register:@protocol(protocolB) factory:^id (id<AIRResolverProtocol> resolver) {
         ClassB * instanceB = [ClassB new];
         instanceB.propertyC = [resolver resolve:protocolC];
         return instanceB;
     }];
     [container register:@protocol(protocolA) factory:^id (id<AIRResolverProtocol> resolver) {
         ClassA * instanceA = [ClassA new];
         instanceA.propertyB = [resolver resolve:protocolB];
         return instanceA;
     }];
     
     // Example to retrieve:
     ClassA *A = [container resolve:@protocol(protocolA)];
```    
`protocolA` and `ProtocolB` are protocols, `ClassA` is a type conforming `protocolA`, and `ClassB` is a type conforming `protocolB` and is depended by `ClassA`.
    
### Arguments

### Injection Patterns

### Circular Dependencies

### Object Scopes

### Container Hierarchy

### Thread Safety
