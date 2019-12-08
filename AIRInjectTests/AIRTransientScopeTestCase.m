//
//  TransientScopeTestCase.m
//  InjectTests
//
//  Created by Stanley on 2019/9/10.
//  Copyright © 2019 AIRInject contributers. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TestClassA.h"
#import "TestClassB.h"
#import "TestClassC.h"
#import <AIRInject/AIRInject.h>
#import "TestProtocol.h"

@interface TransientScopeTestCase : XCTestCase

@end

@implementation TransientScopeTestCase

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

/*
 Testcase001 : Test Transient scope
 */
- (void)testCase001 {
    AIRContainer *container = [[AIRContainer alloc] initWithScope:AIRScopeTypeTransient parent:nil];
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
    
    TestClassA *instanceA1 = [container resolve:@protocol(protocolA)];
    TestClassA *instanceA2 = [container resolve:@protocol(protocolA)];
    
    XCTAssert(instanceA1 != instanceA2, @"resolve protocolA twice, there should be two different instance in graph scope");
    XCTAssert(instanceA1.propertyB != instanceA2.propertyB, @"resolve protocolA twice, there should be two different instance in graph scope");
    XCTAssert(((TestClassB *)instanceA1.propertyB).propertyC != ((TestClassB *)instanceA2.propertyB).propertyC, @"resolve protocolA twice, there should be two different instance in graph scope");
}

@end
