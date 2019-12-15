//
//  AIRResolver.h
//  Inject
//
//  Created by Stanley on 2019/9/5.
//  Copyright © 2019 AIRInject contributers. All rights reserved.
//

#ifndef AIRResolver_h
#define AIRResolver_h

/// This Protocol defines interfaces for resolving one protocol to coresponding instance.
/// New interfaces will be defined in later versions.

NS_ASSUME_NONNULL_BEGIN

@protocol AIRResolverProtocol <NSObject>

- (id)resolve:(Protocol *)protocol;

- (id)resolve:(Protocol *)protocol name:(NSString * __nullable)name;

- (id)resolveClass:(Class)klass;

- (id)resolveClass:(Class)klass name:(NSString * __nullable)name;

@optional

- (id)resolve:(Protocol *)protocol name:(NSString * __nullable)name arguments:(id)arguments, ...;

- (id)resolveClass:(Class)klass name:(NSString * __nullable)name arguments:(id)arguments, ...;

@end

NS_ASSUME_NONNULL_END

#endif /* AIRResolver_h */
