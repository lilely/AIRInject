//
//  AIRContainer_priviate.h
//  AIRInject
//
//  Created by Stanley on 2019/12/7.
//  Copyright © 2019 AIRInject contributers. All rights reserved.
//

#ifndef AIRContainer_priviate_h
#define AIRContainer_priviate_h

#import "AIRContainer.h"
#import "SyncLock.h"

@interface AIRContainer()

@property (nonatomic, strong) SyncLock *lock;

@end

#endif /* AIRContainer_priviate_h */
