//
//  CEDTask.h
//  Cedule
//
//  Created by Klaas Pieter Annema on 05-11-13.
//  Copyright (c) 2013 Annema. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CEDTaskBlock)(void);

@interface CEDTask : NSObject

@property (nonatomic, readonly, copy) CEDTaskBlock block;
@property (nonatomic, readonly, assign) NSTimeInterval interval;

@property (nonatomic, readonly, copy) NSDate *performAfter;

+ (instancetype)taskWithBlock:(CEDTaskBlock)block withTimeInterval:(NSTimeInterval)interval;
- (id)initWithBlock:(CEDTaskBlock)block withTimeInterval:(NSTimeInterval)interval;

@end
