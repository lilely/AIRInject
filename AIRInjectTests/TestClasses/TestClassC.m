//
//  TestClassC.m
//  InjectTests
//
//  Created by Stanley on 2019/9/10.
//  Copyright © 2019 AIRInject contributers. All rights reserved.
//

#import "TestClassC.h"

@implementation TestClassC

- (instancetype)initWithParam1:(NSString *)param {
    if (self = [super init]) {
        _param1 = param;
    }
    return self;
}

@end
