//
//  TestClassE.h
//  InjectTests
//
//  Created by Stanley on 2019/9/10.
//  Copyright © 2019 AIRInject contributers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface TestClassE : NSObject<protocolE>

@property (nonatomic, strong) id<protocolD> propertyD;

@end

NS_ASSUME_NONNULL_END
