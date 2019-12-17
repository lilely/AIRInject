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

A service type(protocol or class) and its corresponding component are registered with the register method of the container. If the component depends on another service, the factory block can call resolve on the passed in resolver objection to "inject" the dependency. The actual underlying type of the dependency will be determined later when the component instance is created.

Here is an example of service registration:

```Object-C
AIRContainter *container = [AIRContainter new];
[container register:@protocol(StutentProtocol) factory:^id (id<AIRResolverProtocol> resolver) {     
     StutentClass * stutent = [[StutentClass alloc] initWithName:@"Peter"];
     return stutent;
}];
[container register:@protocol(TeacherProtocol) factory:^id (id<AIRResolverProtocol> resolver) {
     TeacherClass * teacher = [[TeacherClass alloc] initWithName:@"David"];
     teacher.stutent = [resolver resolve:@protocol(StutentProtocol)];
     return teacher;
}];
     // StutentClass comfirms to StutentProtocol and TeacherClass confirms to TeacherProtocol.
``` 
The factory block passed to the register method can take arguments that are passed when the service is resolved. Then you can pass arguments to determin the actual initialize properties or the actual type of the component when it is resolved.Here is some examples:

```Object-C
[container register:@protocol(StutentProtocol) paramOnefactory:^id (id<AIRResolverProtocol> resolver,NSString *param1) {
     StutentClass * stutent = [[StutentClass alloc] initWithName:param1];
     return stutent;
}];
[container register:@protocol(TeacherProtocol) factory:^id (id<AIRResolverProtocol> resolver,NSString *param1) {
     TeacherClass * teacher = [[TeacherClass alloc] initWithName:param1];
     teacher.stutent = [resolver resolve:@protocol(StutentProtocol) arguments:@"Peter"];
     return teacher;
}];

id<TeacherProtocol> teacher = [container resolve:@protocol(TeacherProtocol) arguments:@"David"];
/// teacher.name is @"David", teacher.stutent.name is @"Peter"
```

Here is the example that how to determine the type of the component when it is resolved.

```Object-C
[container register:@protocol(StutentProtocol) paramOnefactory:^id (id<AIRResolverProtocol> resolver,NSString *param1,NString *param2) {
     if([param2 isEqutoToString:@"English"]) {
          EngilishStutentClass * stutent = [[EngilishStutentClass alloc] initWithName:param1];
         return stutent;
         } else {
              StutentClass * stutent = [[StutentClass alloc] initWithName:param1];
              return stutent;
         }
     }];
[container register:@protocol(TeacherProtocol) factory:^id (id<AIRResolverProtocol> resolver,NSString *param1,NString *param2) {
     if([param2 isEqutoToString:@"English"]) {
          EnglishTeacherClass * teacher = [[EnglishTeacherClass alloc] initWithName:param1];
          teacher.stutent = [resolver resolve:@protocol(StutentProtocol) arguments:"@"Jack",@"English",nil];  
          return teacher;     
     } else {
          TeacherClass * teacher = [[TeacherClass alloc] initWithName:param1]; 
          teacher.stutent = [resolver resolve:@protocol(StutentProtocol) arguments:@"Peter"];
          return teacher;
     }
}];
     
id<TeacherProtocol> teacher = [container resolve:@protocol(TeacherProtocol) arguments:@"David",@"English"];
/// teacher.name is @"David", teacher.stutent.name is @"Jack"
```

### Object Scopes

AIRInject support four kinds of Object scope type.They are Graph, Permanent, Weak, Transient.

#### Graph:
In Graph scope Component will be instantiated only once in the particular resloving process.This measn,the senond time when resolver try to resolve the Component of its type, the instance stored when first instantiated will be used.

#### Permanent:
It is easy to understand.In Permanent scope, Component Instantiated in the first time will be used every time in each resloving process until the Container is dealloced.

#### Weak:
In Weak scope, Component object will be stored if there is at least one other object capture it, and it will be release when there is not captured anymore.

#### Transient:
In Transient scope, Component will be Instantiated every time it is resolved.

The default object scope is Graph.You can spicify the object scope for particular service.
Here is the example of setting the object scope.

```Object-C
AIRContainter *container = [AIRContainter new];
[[container register:@protocol(StutentProtocol) factory:^id (id<AIRResolverProtocol> resolver) {
     StutentClass * stutent = [[StutentClass alloc] initWithName:@"Peter"];
     return stutent;
}] inObjectScopeType:AIRScopeTypeWeak];
     
/// The object scope of StutentProtocol service is assigned as weak scope type.
```

### Container Hierarchy
A container hierarchy is a tree of containers for the purposes of sharing the registrations of dependency injections. Service types registered to a parent container can be resolved in its child containers too.
Here is the example:

```Object-C
AIRContainter *parentContainer = [[AIRContainter alloc] init];
AIRContainter *childContainer = [[AIRContainter alloc] initWithParent:parentContainer];
[parentContainer register:@protocol(CarProtocol) factory:^id (id<AIRResolverProtocol> resolver) {
     Passat * car = [[Passat alloc] init];
     return car;
}];

id<CarProtocol> car = [childContainer resolve:@protocol(CarProtocol)];

```

### Thread Safety
The API of AIRContainer is not thread safe.If you want to use resolve api in serveral threads, AIRSynchronizedResolver is the way.AIRSynchronizedResolver confrims to AIRResolver protocol, and it is a wrapper of AIRContainer.
Here is the example of AIRSynchronizedResolver.
```Object-C
AIRContainter *container = [AIRContainter new];
[container register:@protocol(StutentProtocol) factory:^id (id<AIRResolverProtocol> resolver) {
         StutentClass * stutent = [[StutentClass alloc] initWithName:@"Peter"];
         return stutent;
     }];
AIRSynchronizedResolver *synchonizedResolver = [[AIRSynchronizedResolver alloc] initWithContainer:container];
id<StutentProtocol> stutent = [synchonizedResolver resolve:@protocol(StutentProtocol)];
/// Thread safe.

```
