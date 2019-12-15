//
//  AIRContainer+Arguments.h
//  AIRInject
//
//  Created by Stanley on 2019/12/15.
//  Copyright © 2019 com.corp.jinxing. All rights reserved.
//

#import "AIRContainer.h"

NS_ASSUME_NONNULL_BEGIN

@interface AIRContainer(Arguments)

- (AIRServiceEntry *)register:(Protocol *)protocol name:(NSString * __nullable)name paramOneFactory:(id _Nonnull (^)(id<AIRResolverProtocol> resolver,id param1))factory;

- (AIRServiceEntry *)register:(Protocol *)protocol name:(NSString * __nullable)name paramTwoFactory:(id _Nonnull (^)(id<AIRResolverProtocol> resolver,id param1, id param2))factory;

- (AIRServiceEntry *)register:(Protocol *)protocol name:(NSString * __nullable)name paramThreeFactory:(id _Nonnull (^)(id<AIRResolverProtocol> resolver,id param1, id param2,id param3))factory;

- (AIRServiceEntry *)registerClass:(Class)class name:(NSString * __nullable)name paramOneFactory:(id _Nonnull (^)(id<AIRResolverProtocol> resolver,id param1))factory;

- (AIRServiceEntry *)registerClass:(Class)class name:(NSString * __nullable)name paramTwoFactory:(id _Nonnull (^)(id<AIRResolverProtocol> resolver,id param1, id param2))factory;

- (AIRServiceEntry *)registerClass:(Class)class name:(NSString * __nullable)name paramThreeFactory:(id _Nonnull (^)(id<AIRResolverProtocol> resolver,id param1, id param2,id param3))factory;

@end

NS_ASSUME_NONNULL_END
