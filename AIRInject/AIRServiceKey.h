//
//  AIRServiceKey.h
//  Inject
//
//  Created by Stanley on 2019/9/11.
//  Copyright © 2019 AIRInject contributers. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AIRServiceKey : NSObject<NSCopying>

@property (nonatomic, copy, readonly) NSString *klassIdentifier;

@property (nonatomic, copy, readonly) NSString *name;

- (instancetype)initWithKlassIdentifier:(NSString *)klassIdentifier name:(NSString * __nullable)name NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
