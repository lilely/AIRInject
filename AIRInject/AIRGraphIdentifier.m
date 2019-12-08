//
//  AIRGraphIdentifier.m
//  Inject
//
//  Created by Stanley on 2019/9/9.
//  Copyright © 2019 AIRInject contributers. All rights reserved.
//

#import "AIRGraphIdentifier.h"

@interface AIRGraphIdentifier()

@property (nonatomic, copy) NSString *identifier;

@end

@implementation AIRGraphIdentifier

- (instancetype)init {
    if (self = [super init]) {
        _identifier = [[NSUUID UUID] UUIDString];
    }
    return self;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    AIRGraphIdentifier *aCopy = [[AIRGraphIdentifier allocWithZone:zone] init];
    if (aCopy) {
        [aCopy setIdentifier:[self.identifier copyWithZone:zone]];
    }
    return aCopy;
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:AIRGraphIdentifier.class] &&
        [((AIRGraphIdentifier *)object).identifier isEqualToString:self.identifier ]) {
        return YES;
    }
    return NO;
}

- (NSUInteger)hash {
    return self.identifier.hash;
}

@end
