#import "SpecHelper.h"

#import "CEDScheduler.h"

SpecBegin(CEDScheduler)

__block CEDScheduler *_scheduler;

describe(@"Scheduler", ^{
    before(^{
        _scheduler = [[CEDScheduler alloc] init];
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
                expect([[NSDate date] timeIntervalSinceDate:then]).to.beCloseToWithin(0.2, 0.001);
                done();
            }
        } withTimeInterval:0.1];
    });
});

SpecEnd
