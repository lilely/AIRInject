//
//  TestClassC.h
//  InjectTests
//
//  Created by Stanley on 2019/9/10.
//  Copyright © 2019 AIRInject contributers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface TestClassC : NSObject<protocolC>

@property (nonatomic, strong) NSString *param1;

- (instancetype)initWithParam1:(NSString *)param;

@end

NS_ASSUME_NONNULL_END
