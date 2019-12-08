//
//  AIRServiceKey.m
//  Inject
//
//  Created by Stanley on 2019/9/11.
//  Copyright © 2019 AIRInject contributers. All rights reserved.
//

#import "AIRServiceKey.h"

@interface AIRServiceKey()

@property (nonatomic, copy) NSString *klassIdentifier;

@property (nonatomic, copy) NSString *name;

@end

@implementation AIRServiceKey

- (instancetype)initWithKlassIdentifier:(NSString *)klassIdentifier name:(NSString *)name {
    if (self = [super init]) {
        _klassIdentifier = klassIdentifier;
        _name = name;
    }
    return self;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    AIRServiceKey *aCopy = [[AIRServiceKey allocWithZone:zone] initWithKlassIdentifier:[self.klassIdentifier copyWithZone:zone] name:[self.name copyWithZone:zone]];
    return aCopy;
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:AIRServiceKey.class] &&
        [((AIRServiceKey *)object).klassIdentifier isEqualToString:self.klassIdentifier] &&
        ([((AIRServiceKey *)object).name isEqualToString:self.name] || self.name == ((AIRServiceKey *)object).name)) {
        return YES;
    }
    return NO;
}

- (NSUInteger)hash {
    return self.klassIdentifier.hash ^ self.name.hash;
}

@end
