//
//  KPAScheduler.h
//  Cedule
//
//  Created by Klaas Pieter Annema on 04-11-13.
//  Copyright (c) 2013 Annema. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CEDSchedulerTask)(void);

@interface CEDScheduler : NSObject

@property (nonatomic, readonly, copy) NSArray *tasks;

- (void)scheduleTask:(CEDSchedulerTask)task withTimeInterval:(NSTimeInterval)interval;

@end
