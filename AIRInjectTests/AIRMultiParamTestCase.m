//
//  AIRMultiParamTestCase.m
//  AIRInjectTests
//
//  Created by Stanley on 2019/12/8.
//  Copyright © 2019 AIRInject contributers. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <AIRInject/AIRInject.h>
#import "TestClassA.h"
#import "TestClassB.h"
#import "TestClassC.h"
#import "TestProtocol.h"

@interface AIRMultiParamTestCase : XCTestCase

@end

@implementation AIRMultiParamTestCase

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

- (void)testCase001 {
    AIRContainer *container = [[AIRContainer alloc] initWithScope:AIRScopeTypeGraph parent:nil];
    
    [container register:@protocol(protocolC) name:nil paramOneFactory:^id(id<AIRResolverProtocol> _Nonnull resolver,NSString *param){
        TestClassC * instanceC = [[TestClassC alloc] initWithParam1:param];
        return instanceC;
    }];
    TestClassC * instance = [container resolve:@protocol(protocolC) name:nil arguments: @"321",@"123",@"1238",nil];
    XCTAssert([instance.param1 isEqualToString:@"321"], @"resolve class C with param failed");
}

- (void)testCase002 {
    AIRContainer *container = [[AIRContainer alloc] initWithScope:AIRScopeTypeGraph parent:nil];
    [container register:@protocol(protocolC) name:nil paramOneFactory:^id(id<AIRResolverProtocol> _Nonnull resolver,NSString *param){
        TestClassC * instanceC = [[TestClassC alloc] initWithParam1:param];
        return instanceC;
    }];
    TestClassC * instance = [container resolve:@protocol(protocolC) name:nil arguments: @"321",@"123",@"1238",nil];
    XCTAssert([instance.param1 isEqualToString:@"321"], @"resolve class C with param failed");
}

- (void)testCase003 {
    AIRContainer *container = [[AIRContainer alloc] initWithScope:AIRScopeTypeGraph parent:nil];
    [container register:@protocol(protocolC) name:nil paramOneFactory:^id _Nonnull(id<AIRResolverProtocol>  _Nonnull resolver,NSString *param) {
        TestClassC * instanceC = [[TestClassC alloc] initWithParam1:param];
        instanceC.obj = [resolver resolve:@protocol(protocolF) name:nil];
        return instanceC;
    }];

    [container register:@protocol(protocolF) factory:^id _Nonnull(id<AIRResolverProtocol>  _Nonnull resolver) {
        TestClassF *instanceF = [[TestClassF alloc] init];
        return instanceF;
    }];
    
    TestClassC * instanceC = [container resolve:@protocol(protocolC) name:nil arguments:@"321"];
    
    XCTAssert([instanceC.param1 isEqualToString:@"321"], @"resolve class C with param failed");
    XCTAssert(instanceC.obj&&[instanceC.obj isKindOfClass:TestClassF.class], @"resolve class C with param failed");
}

- (void)testCase004 {
    AIRContainer *container = [[AIRContainer alloc] initWithScope:AIRScopeTypeGraph parent:nil];
    
    [container register:@protocol(protocolC) name:nil paramOneFactory:^id _Nonnull(id<AIRResolverProtocol>  _Nonnull resolver,NSString *param) {
        TestClassC * instanceC = [[TestClassC alloc] initWithParam1:param];
        instanceC.obj = [resolver resolve:@protocol(protocolF) name:nil];
        return instanceC;
    }];

    [container register:@protocol(protocolF) factory:^id _Nonnull(id<AIRResolverProtocol>  _Nonnull resolver) {
        TestClassF *instanceF = [[TestClassF alloc] init];
        return instanceF;
    }];
    
    AIRSynchronizedResolver *resolver = [[AIRSynchronizedResolver alloc] initWithContainer:container];
    
    TestClassC * instanceC = [resolver resolve:@protocol(protocolC) name:nil arguments:@"321"];
    
    XCTAssert([instanceC.param1 isEqualToString:@"321"], @"resolve class C with param failed");
    XCTAssert(instanceC.obj&&[instanceC.obj isKindOfClass:TestClassF.class], @"resolve class C with param failed");
}


@end
