#import "SpecHelper.h"

#import "CEDScheduler.h"

SpecBegin(CEDScheduler)

__block CEDScheduler *_scheduler;

describe(@"Scheduler", ^{
    before(^{
        _scheduler = [[CEDScheduler alloc] init];
    });
});

SpecEnd
