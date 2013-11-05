//
//  CEDTask.h
//  Cedule
//
//  Created by Klaas Pieter Annema on 05-11-13.
//  Copyright (c) 2013 Annema. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CEDSchedulerTask)(void);

@interface CEDTask : NSObject

@property (nonatomic, readonly, copy) CEDSchedulerTask block;
@property (nonatomic, readonly, copy) NSDate *performAfter;

+ (instancetype)taskWithBlock:(CEDSchedulerTask)block withTimeInterval:(NSTimeInterval)interval;
- (id)initWithBlock:(CEDSchedulerTask)block withTimeInterval:(NSTimeInterval)interval;

@end
