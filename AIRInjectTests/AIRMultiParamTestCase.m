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
    
    TestClassC *instanceC0 = [container resolve:@protocol(protocolC) name:nil];
    TestClassC *instanceC1 = [container resolve:@protocol(protocolC) name:nil param1:@"123"];
    TestClassC *instanceC2 = [container resolve:@protocol(protocolC) name:nil param1:@"123" param2:@"456"];
    TestClassC *instanceC3 = [container resolve:@protocol(protocolC) name:nil param1:@"123" param2:@"456" param3:@"789"];
    XCTAssert(instanceC0.param1 == nil, @"resolve class C with param failed");
    XCTAssert([instanceC1.param1 isEqualToString:@"123"], @"resolve class C with param failed");
    XCTAssert([instanceC2.param1 isEqualToString:@"123"], @"resolve class C with param failed");
    XCTAssert([instanceC3.param1 isEqualToString:@"123"], @"resolve class C with param failed");
}

@end
