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

@protocol AIRResolverProtocol <NSObject>

- (id)resolve:(Protocol *)protocol;

- (id)resolve:(Protocol *)protocol name:(NSString *)name;

- (id)resolve:(Protocol *)protocol name:(NSString *)name param1:(id)param1;

- (id)resolve:(Protocol *)protocol name:(NSString *)name param1:(id)param1 param2:(id)param2;

- (id)resolve:(Protocol *)protocol name:(NSString *)name param1:(id)param1 param2:(id)param2 param3:(id)param3;

@end

#endif /* AIRResolver_h */
