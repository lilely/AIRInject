//
//  SyncLock.h
//  AIRInject
//
//  Created by Stanley on 2019/12/8.
//  Copyright © 2019 AIRInject contributers. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef id _Nonnull (^executeBlock)(void);

@interface SyncLock : NSObject

@property (nonatomic, copy, readonly) executeBlock(^sync)(id (^)(void));

@end

NS_ASSUME_NONNULL_END
