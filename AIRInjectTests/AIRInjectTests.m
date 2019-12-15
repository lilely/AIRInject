//
//  InjectTests.m
//  InjectTests
//
//  Created by Stanley on 2019/9/5.
//  Copyright © 2019 AIRInject contributers. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TestClassA.h"
#import "TestClassB.h"
#import "TestClassC.h"
#import <AIRInject/AIRInject.h>
#import "TestProtocol.h"
#import "TestClassD.h"
#import "TestClassE.h"

@interface InjectTests : XCTestCase

@property (nonatomic, strong) AIRContainer* container;

@end

@implementation InjectTests

- (void)setUp {
    AIRContainer *container = [[AIRContainer alloc] init];
    [container register:@protocol(protocolC) factory:^id _Nonnull(id<AIRResolverProtocol>  _Nonnull resolver) {
        TestClassC * instanceC = [TestClassC new];
        return instanceC;
    }];
    
    [container register:@protocol(protocolB) factory:^id _Nonnull(id<AIRResolverProtocol>  _Nonnull resolver) {
        TestClassB * instanceB = [TestClassB new];
        instanceB.propertyC = [resolver resolve:@protocol(protocolC)];
        return instanceB;
    }];

    [container register:@protocol(protocolA) factory:^id _Nonnull(id<AIRResolverProtocol>  _Nonnull resolver) {
        TestClassA * instanceA = [TestClassA new];
        instanceA.propertyB = [resolver resolve:@protocol(protocolB)];
        return instanceA;
    }];
    self.container = container;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    [self testCase001];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

/*
 Testcase001 : Basic function test case
 */
- (void)testCase001 {
    TestClassA *instanceA = [self.container resolve:@protocol(protocolA)];
    XCTAssert([instanceA.propertyB isKindOfClass:TestClassB.class], @"resolve class A property B failed");
    XCTAssert([((TestClassB *)instanceA.propertyB).propertyC isKindOfClass:TestClassC.class], @"resolve class B property C failed");
}

/*
 Testcase002 : Test reference circle detection.
 This case is supposed to be fail for checking the assert of infinite recrusive resolve.
 */
//- (void)testCase002 {
//    AIRContainer *containerX = [[AIRContainer alloc] init];
//
//    [containerX register:@protocol(protocolD) factory:^id _Nonnull(id<AIRResolverProtocol>  _Nonnull resolver) {
//        TestClassD *instanceD = [TestClassD new];
//        instanceD.propertyE = [resolver resolve:@protocol(protocolE)];
//        return instanceD;
//    }];
//
//    [containerX register:@protocol(protocolE) factory:^id _Nonnull(id<AIRResolverProtocol>  _Nonnull resolver) {
//        TestClassE *instanceE = [TestClassE new];
//        instanceE.propertyD = [resolver resolve:@protocol(protocolD)];
//        return instanceE;
//    }];
//
//    TestClassD *instanceD = [containerX resolve:@protocol(protocolD)];
//    XCTAssert([instanceD.propertyE isKindOfClass:TestClassE.class], @"resolve class D property E failed");
//}

/*
 Testcase003 : Test graph Identifier.
 */
- (void)testCase003 {
    AIRGraphIdentifier *graphId1 = [AIRGraphIdentifier new];
    AIRGraphIdentifier *graphId2 = [AIRGraphIdentifier new];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"123" forKey:graphId1];
    [dic setObject:@"321" forKey:graphId2];
    XCTAssert(dic.count == 2,@"");
    XCTAssert([dic[graphId1] isEqualToString:@"123"],@"");
    XCTAssert([dic[graphId2] isEqualToString:@"321"],@"");
}

/*
 Testcase004 : Test service entry.
 */
- (void)testCase004 {
    
    AIRServiceKey *key1 = [[AIRServiceKey alloc] initWithKlassIdentifier:NSStringFromProtocol(@protocol(protocolA)) name:nil];
    AIRServiceEntry *entry1 = [[AIRServiceEntry alloc] initWithKey:key1 objectScope:[[AIRObjectScope alloc] initWithScopeType:AIRScopeTypePermanent] factory:^id _Nonnull(id<AIRResolverProtocol>  _Nonnull resolver) {
        return nil;
    }];
    
    AIRServiceKey *key2 = [[AIRServiceKey alloc] initWithKlassIdentifier:NSStringFromProtocol(@protocol(protocolA)) name:nil];
    AIRServiceEntry *entry2 = [[AIRServiceEntry alloc] initWithKey:key2 factory:^id _Nonnull(id<AIRResolverProtocol>  _Nonnull resolver) {
        return nil;
    }];
    
    XCTAssert(entry1.storage != nil,@"");
    XCTAssert(entry2.storage != nil,@"");
    XCTAssert(entry1.objectScope.scopeType == AIRScopeTypePermanent,@"");
    XCTAssert(entry2.objectScope.scopeType == AIRScopeTypeGraph,@"");
}

/*
 Testcase005 : Test service entry.
 */
- (void)testCase005 {
    AIRServiceKey *key1 = [[AIRServiceKey alloc] initWithKlassIdentifier:NSStringFromProtocol(@protocol(protocolA)) name:@"123"];
    AIRServiceKey *key2 = [[AIRServiceKey alloc] initWithKlassIdentifier:NSStringFromProtocol(@protocol(protocolA)) name:nil];
    
    AIRServiceKey *key3 = [[AIRServiceKey alloc] initWithKlassIdentifier:NSStringFromProtocol(@protocol(protocolA)) name:nil];
    AIRServiceKey *key4 = [[AIRServiceKey alloc] initWithKlassIdentifier:NSStringFromProtocol(@protocol(protocolB)) name:nil];
    
    AIRServiceKey *key5 = [[AIRServiceKey alloc] initWithKlassIdentifier:NSStringFromProtocol(@protocol(protocolA)) name:nil];
    AIRServiceKey *key6 = [[AIRServiceKey alloc] initWithKlassIdentifier:NSStringFromProtocol(@protocol(protocolA)) name:nil];
    
    XCTAssert(![key1 isEqual: key2],@"");
    XCTAssert(![key3 isEqual: key4],@"");
    XCTAssert([key5 isEqual: key6],@"");
}

/*
 Testcase006 : Test service entry initCompleted.
 */
- (void)testCase006 {
    AIRContainer *container = [[AIRContainer alloc] init];
    
    __weak AIRContainer *weakContainer = container;
    (void)[[container register:@protocol(protocolC) factory:^id _Nonnull(id<AIRResolverProtocol>  _Nonnull resolver) {
        TestClassC * instanceC = [TestClassC new];
        return instanceC;
    }] initCompleted:^(id<AIRResolverProtocol>  _Nonnull resolver, id  _Nonnull service) {
        XCTAssert(weakContainer == resolver,@"");
    }];
    
    
    (void)[[container register:@protocol(protocolB) factory:^id _Nonnull(id<AIRResolverProtocol>  _Nonnull resolver) {
        TestClassB * instanceB = [TestClassB new];
        instanceB.propertyC = [resolver resolve:@protocol(protocolC)];
        return instanceB;
    }] initCompleted:^(id<AIRResolverProtocol>  _Nonnull resolver, id  _Nonnull service) {
        XCTAssert(weakContainer == resolver,@"");
    }];
    
    (void)[[container register:@protocol(protocolA) factory:^id _Nonnull(id<AIRResolverProtocol>  _Nonnull resolver) {
        TestClassA * instanceA = [TestClassA new];
        instanceA.propertyB = [resolver resolve:@protocol(protocolB)];
        return instanceA;
    }] initCompleted:^(id<AIRResolverProtocol>  _Nonnull resolver, id  _Nonnull service) {
        XCTAssert(weakContainer == resolver,@"");
    }];
}

/*
 Testcase007 : Test service entry set scope.
 */
- (void)testCase007 {
    AIRContainer *container = [[AIRContainer alloc] init];
    (void)[[container register:@protocol(protocolC) factory:^id _Nonnull(id<AIRResolverProtocol>  _Nonnull resolver) {
        TestClassC * instanceC = [TestClassC new];
        return instanceC;
    }] inObjectScopeType:AIRScopeTypeTransient];
    
    (void)[[container register:@protocol(protocolB) factory:^id _Nonnull(id<AIRResolverProtocol>  _Nonnull resolver) {
        TestClassB * instanceB = [TestClassB new];
        instanceB.propertyC = [resolver resolve:@protocol(protocolC)];
        return instanceB;
    }] inObjectScopeType:AIRScopeTypeWeak];
    
    (void)[[container register:@protocol(protocolA) factory:^id _Nonnull(id<AIRResolverProtocol>  _Nonnull resolver) {
        TestClassA * instanceA = [TestClassA new];
        instanceA.propertyB = [resolver resolve:@protocol(protocolB)];
        return instanceA;
    }] inObjectScopeType:AIRScopeTypePermanent];
    
    TestClassA * instanceA1 = [container resolve:@protocol(protocolA)];
    TestClassA * instanceA2 = [container resolve:@protocol(protocolA)];
    
    TestClassB * instanceB1 = [container resolve:@protocol(protocolB)];
    TestClassB * instanceB2 = [container resolve:@protocol(protocolB)];
    __weak TestClassB *weakInstanceB1 = instanceB1;
    XCTAssert(instanceA1 == instanceA2,@"");
    XCTAssert(instanceB1 == instanceB2,@"");
    instanceB1 = nil;
    instanceB2 = nil;
    instanceA1.propertyB = nil;
    XCTAssert(weakInstanceB1 == nil,@"");
    
    TestClassC * instanceC1 = [container resolve:@protocol(protocolC)];
    TestClassC * instanceC2 = [container resolve:@protocol(protocolC)];
    XCTAssert(instanceC1 != instanceC2,@"");
}

/*
 Testcase008 : Test service entry initComplete for resolve cricle case
 */
- (void)testCase008 {
    AIRContainer *container = [[AIRContainer alloc] init];
    
    [container register:@protocol(protocolE) factory:^id _Nonnull(id<AIRResolverProtocol>  _Nonnull resolver) {
        TestClassE *instanceE = [TestClassE new];
        instanceE.propertyD = [resolver resolve:@protocol(protocolD)];
        return instanceE;
    }];
    
    (void)[[container register:@protocol(protocolD) factory:^id _Nonnull(id<AIRResolverProtocol>  _Nonnull resolver) {
        TestClassD *instanceD = [TestClassD new];
        return instanceD;
    }] initCompleted:^(id<AIRResolverProtocol>  _Nonnull resolver, TestClassD *service) {
        service.propertyE = [resolver resolve:@protocol(protocolE)];
    }];
    
    TestClassD *instanceD = [container resolve:@protocol(protocolD)];
    XCTAssert([instanceD.propertyE isKindOfClass:TestClassE.class], @"resolve class D property E failed");
    XCTAssert(((TestClassE *)instanceD.propertyE).propertyD == instanceD, @"resolve class D property E failed");
}

@end
