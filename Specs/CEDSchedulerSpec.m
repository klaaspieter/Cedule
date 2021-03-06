#import "SpecHelper.h"

#import "CEDScheduler.h"

@interface CEDScheduler (Specs)
@property (nonatomic, readonly, strong) NSTimer *timer;
@end

SpecBegin(CEDScheduler)

__block CEDScheduler *_scheduler;

describe(@"Scheduler", ^{
    before(^{
        _scheduler = [[CEDScheduler alloc] init];
    });

    after(^{
        [_scheduler removeAllTasks];
    });

    it(@"can schedule a task", ^{
        CEDTaskBlock block = ^{};
        [_scheduler scheduleTask:block withTimeInterval:0.0];
        CEDTask *task = _scheduler.tasks[0];
        expect(task.block).to.equal(block);
    });

    it(@"schedules the task after the correct interval", ^{
        [_scheduler scheduleTask:^{} withTimeInterval:10.0];
        CEDTask *task = _scheduler.tasks[0];
        expect(task.performAfter.timeIntervalSinceNow).to.beCloseToWithin(10.0, 1.0);
    });

    it(@"performs the task after the interval", ^AsyncBlock{
        NSDate *then = [NSDate date];
        [_scheduler scheduleTask:^{
            expect([[NSDate date] timeIntervalSinceDate:then]).to.beGreaterThanOrEqualTo(0.25);
            done();
        } withTimeInterval:0.25];
    });

    it(@"reschedules the task after it's performed", ^AsyncBlock{
        __block NSUInteger numberOfCalls = 0;
        NSDate *then = [NSDate date];
        [_scheduler scheduleTask:^{
            numberOfCalls++;

            if (numberOfCalls == 2) {
                expect([[NSDate date] timeIntervalSinceDate:then]).to.beCloseToWithin(0.2, 0.01);
                done();
            }
        } withTimeInterval:0.1];
    });

    it(@"handles tasks with different intervals", ^AsyncBlock{
        NSDate *then = [NSDate date];

        __block NSUInteger numberOfCallsToFirst = 0;
        [_scheduler scheduleTask:^{
            numberOfCallsToFirst++;
            expect([[NSDate date] timeIntervalSinceDate:then]).to.beCloseToWithin(numberOfCallsToFirst * 0.1, 0.01);
        } withTimeInterval:0.1];

        __block NSUInteger numberOfCallsToSecond = 0;
        [_scheduler scheduleTask:^{
            numberOfCallsToSecond++;
            expect([[NSDate date] timeIntervalSinceDate:then]).to.beCloseToWithin(numberOfCallsToSecond * 0.15, 0.01);
            done();
        } withTimeInterval:0.15];
    });

    it(@"coalesces tasks that end up at the same interval", ^AsyncBlock{
        NSDate *then = [NSDate date];

        __block NSUInteger numberOfCalls = 0;
        [_scheduler scheduleTask:^{
            numberOfCalls++;
            expect([[NSDate date] timeIntervalSinceDate:then]).to.beCloseToWithin(numberOfCalls * 1.0, 0.1);
        } withTimeInterval:1.0];

        [_scheduler scheduleTask:^{
            expect([[NSDate date] timeIntervalSinceDate:then]).to.beCloseToWithin(2.0, 0.1);
            done();
        } withTimeInterval:2.0];
    });

    it(@"can remove tasks", ^{
        CEDTaskBlock task = ^{};
        [_scheduler scheduleTask:task withTimeInterval:1.0];
        [_scheduler removeTask:task];
        expect(_scheduler.tasks).to.haveCountOf(0);
    });

    it(@"doesn't schedule anoter time if the last task is removed", ^{
        CEDTaskBlock task = ^{};
        [_scheduler scheduleTask:task withTimeInterval:1.0];
        [_scheduler removeTask:task];
        expect(_scheduler.timer.isValid).to.beFalsy();
    });
});

SpecEnd
