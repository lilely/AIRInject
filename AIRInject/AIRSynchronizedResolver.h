//
//  AIRSynchronizedResolver.h
//  AIRInject
//
//  Created by Stanley on 2019/12/7.
//  Copyright © 2019 AIRInject contributers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AIRContainer.h"

NS_ASSUME_NONNULL_BEGIN

@interface AIRSynchronizedResolver : NSObject<AIRResolverProtocol>

- (instancetype)initWithContainer:(AIRContainer *)container;

@end

NS_ASSUME_NONNULL_END
