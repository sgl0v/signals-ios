//
//  UBSignalTests.m
//  UberSignalsTests
//
//  Copyright (c) 2015 Uber Technologies, Inc.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import <XCTest/XCTest.h>

#import "UBSignalEmitter.h"

@interface UBSignalTests : XCTestCase
@end

@implementation UBSignalTests

- (void)testFireEmptySignal
{
    XCTestExpectation *fire = [self expectationWithDescription:@"Fire"];
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];

    __block id callbackSelf;
    
    [emitter.onEmptySignal addObserver:self callback:^(typeof(self) self) {
        callbackSelf = self;
        [fire fulfill];
    }];
    
    emitter.onEmptySignal.fire();
    [self waitForExpectationsWithTimeout:0.2 handler:nil];
    XCTAssertEqual(callbackSelf, self, @"Callback should contain correct self argument");
}

- (void)testFireSignalWithData
{
    XCTestExpectation *fire = [self expectationWithDescription:@"Fire"];
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];

    __block id callbackSelf;
    __block NSNumber *callbackInteger;
    
    [emitter.onIntegerSignal addObserver:self callback:^(id self, NSNumber *integer) {
        callbackSelf = self;
        callbackInteger = integer;
        [fire fulfill];
    }];
    
    emitter.onIntegerSignal.fire(@(10));

    [self waitForExpectationsWithTimeout:0.2 handler:nil];
    XCTAssertEqual(callbackSelf, self, @"Callback should contain correct self argument");
    XCTAssertEqual(callbackInteger, @(10), @"Should fire correct number");
}

- (void)testFireSignalWithTwoDataTypes
{
    XCTestExpectation *fire = [self expectationWithDescription:@"Fire"];
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];

    __block id callbackSelf;
    __block NSString *callbackStringData;
    __block NSString *callbackOtherStringData;
    
    [emitter.onStringSignal addObserver:self callback:^(typeof(self) self, NSString *stringData, NSString *otherStringData) {
        callbackSelf = self;
        callbackStringData = stringData;
        callbackOtherStringData = otherStringData;
        [fire fulfill];
    }];
    
    emitter.onStringSignal.fire(@"First", @"Second");
    
    [self waitForExpectationsWithTimeout:0.2 handler:nil];
    XCTAssertEqual(callbackSelf, self, @"Callback should contain correct self argument");
    XCTAssertEqual(callbackStringData, @"First", @"Should fire correct string");
    XCTAssertEqual(callbackOtherStringData, @"Second", @"Should fire correct string");
}

- (void)testFireSignalWithThreeDataTypes
{
    XCTestExpectation *fire = [self expectationWithDescription:@"Fire"];
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    
    [emitter.onTripleSignal addObserver:self callback:^(id self, NSString *string1, NSString *string2, NSNumber *number1) {
        XCTAssertEqual(string1, @"string1", @"Should get correct argument");
        XCTAssertEqual(string2, @"string2", @"Should get correct argument");
        XCTAssertEqual(number1, @(1), @"Should get correct argument");
        [fire fulfill];
    }];
    
    emitter.onTripleSignal.fire(@"string1", @"string2", @(1));

    [self waitForExpectationsWithTimeout:0.2 handler:nil];
}

- (void)testFireSignalWithFourDataType
{
    XCTestExpectation *fire = [self expectationWithDescription:@"Fire"];
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    
    [emitter.onQuardrupleSignal addObserver:self callback:^(id self, NSString *string1, NSString *string2, NSNumber *number1, NSNumber *number2) {
        XCTAssertEqual(string1, @"string1", @"Should get correct argument");
        XCTAssertEqual(string2, @"string2", @"Should get correct argument");
        XCTAssertEqual(number1, @(1), @"Should get correct argument");
        XCTAssertEqual(number2, @(2), @"Should get correct argument");
        [fire fulfill];
    }];
    
    emitter.onQuardrupleSignal.fire(@"string1", @"string2", @(1), @(2));
    
    [self waitForExpectationsWithTimeout:0.2 handler:nil];
}

- (void)testFireSignalWithFiveDataTypes
{
    XCTestExpectation *fire = [self expectationWithDescription:@"Fire"];
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    
    [emitter.onComplexSignal addObserver:self callback:^(id self, NSNumber *number1, NSNumber *number2, NSNumber *number3, NSNumber *number4, NSNumber *number5) {

        XCTAssertEqual(number1, @(1), @"Should get correct argument");
        XCTAssertEqual(number2, @(2), @"Should get correct argument");
        XCTAssertEqual(number3, @(3), @"Should get correct argument");
        XCTAssertEqual(number4, @(4), @"Should get correct argument");
        XCTAssertEqual(number5, @(5), @"Should get correct argument");
        [fire fulfill];
    }];
    
    emitter.onComplexSignal.fire(@(1), @(2), @(3), @(4), @(5));
    
    [self waitForExpectationsWithTimeout:0.2 handler:nil];
}

- (void)testCreatingSignalWithUnsupportedProtocol
{
    XCTAssertThrows([[UBSignal alloc] initWithProtocol:@protocol(TestProtocol)], @"Should have thrown assert");
}

- (void)testFireSignalWithNilData
{
    XCTestExpectation *fire = [self expectationWithDescription:@"Fire"];
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];

    __block id callbackSelf = nil;
    __block NSString *callbackStringData = @"test";
    __block NSString *callbackOtherStringData = @"test";
    
    [emitter.onStringSignal addObserver:self callback:^(typeof(self) self, NSString *stringData, NSString *otherStringData) {
        callbackSelf = self;
        callbackStringData = stringData;
        callbackOtherStringData = otherStringData;
        [fire fulfill];
    }];
    
    emitter.onStringSignal.fire(nil, nil);

    [self waitForExpectationsWithTimeout:0.2 handler:nil];
    XCTAssertEqual(callbackSelf, self, @"Callback should contain correct self argument");
    XCTAssertNil(callbackStringData, @"Should fire correct string");
    XCTAssertNil(callbackOtherStringData, @"Should fire correct string");
}

- (void)testFireSignalForSpecificObserver
{
    XCTestExpectation *fire = [self expectationWithDescription:@"Fire"];
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    
    UBSignalObserver *firstSignalObserver = [emitter.onEmptySignal addObserver:self callback:^(typeof(self) self) {
        [fire fulfill];
    }];
    [emitter.onEmptySignal addObserver:self callback:^(typeof(self) self) {
        XCTFail(@"Signal should not have fired");
    }];
    
    emitter.onEmptySignal.fireForSignalObserver(firstSignalObserver);

    [self waitForExpectationsWithTimeout:0.2 handler:nil];
}

- (void)testFireSignalWithDataForSpecificObserver
{
    XCTestExpectation *fire = [self expectationWithDescription:@"Fire"];
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    
    UBSignalObserver *firstSignalObserver = [emitter.onIntegerSignal addObserver:self callback:^(id self, NSNumber *integer) {
        [fire fulfill];
    }];
    [emitter.onIntegerSignal addObserver:self callback:^(id self, NSNumber *integer) {
        XCTFail(@"Signal should not have fired");
    }];
    
    emitter.onIntegerSignal.fireForSignalObserver(firstSignalObserver, @(10));

    [self waitForExpectationsWithTimeout:0.2 handler:nil];
}

- (void)testFireSignalWithTwoDataTypesForSpecificObserver
{
    XCTestExpectation *fire = [self expectationWithDescription:@"Fire"];
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    
    UBSignalObserver *firstSignalObserver = [emitter.onStringSignal addObserver:self callback:^(typeof(self) self, NSString *stringData, NSString *otherStringData) {
        [fire fulfill];
    }];
    [emitter.onStringSignal addObserver:self callback:^(typeof(self) self, NSString *stringData, NSString *otherStringData) {
        XCTFail(@"Signal should not have fired");
    }];
    
    emitter.onStringSignal.fireForSignalObserver(firstSignalObserver, @"First", @"Second");

    [self waitForExpectationsWithTimeout:0.2 handler:nil];
}

- (void)testFireSignalWithThreeDataTypesForSpecificObserver
{
    XCTestExpectation *fire = [self expectationWithDescription:@"Fire"];
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    
    UBSignalObserver *firstSignalObserver = [emitter.onTripleSignal addObserver:self callback:^(id self, NSString *string1, NSString *string2, NSNumber *number1) {
        [fire fulfill];
    }];
    [emitter.onTripleSignal addObserver:self callback:^(id self, NSString *string1, NSString *string2, NSNumber *number1) {
        XCTFail(@"Signal should not have fired");
    }];
    
    emitter.onTripleSignal.fireForSignalObserver(firstSignalObserver, @"string1", @"string2", @(1));

    [self waitForExpectationsWithTimeout:0.2 handler:nil];
}

- (void)testFireSignalWithFourDataTypeForSpecificObserver
{
    XCTestExpectation *fire = [self expectationWithDescription:@"Fire"];
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    
    UBSignalObserver *firstSignalObserver = [emitter.onQuardrupleSignal addObserver:self callback:^(id self, NSString *string1, NSString *string2, NSNumber *number1, NSNumber *number2) {
        [fire fulfill];
    }];
    [emitter.onQuardrupleSignal addObserver:self callback:^(id self, NSString *string1, NSString *string2, NSNumber *number1, NSNumber *number2) {
        XCTFail(@"Signal should not have fired");
    }];
    
    emitter.onQuardrupleSignal.fireForSignalObserver(firstSignalObserver, @"string1", @"string2", @(1), @(2));

    [self waitForExpectationsWithTimeout:0.2 handler:nil];
}

- (void)testFireSignalWithFiveDataTypesForSpecificObserver
{
    XCTestExpectation *fire = [self expectationWithDescription:@"Fire"];
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    
    UBSignalObserver *firstSignalObserver = [emitter.onComplexSignal addObserver:self callback:^(id self, NSNumber *number1, NSNumber *number2, NSNumber *number3, NSNumber *number4, NSNumber *number5) {
        [fire fulfill];
    }];
    [emitter.onComplexSignal addObserver:self callback:^(id self, NSNumber *number1, NSNumber *number2, NSNumber *number3, NSNumber *number4, NSNumber *number5) {
        XCTFail(@"Signal should not have fired");
    }];
    
    emitter.onComplexSignal.fireForSignalObserver(firstSignalObserver, @(1), @(2), @(3), @(4), @(5));

    [self waitForExpectationsWithTimeout:0.2 handler:nil];
}

- (void)testRemovingAnObserver
{
    XCTestExpectation *fire = [self expectationWithDescription:@"Fire"];
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    NSObject *observer1 = [[NSObject alloc] init];
    NSObject *observer2 = [[NSObject alloc] init];
    
    [emitter.onStringSignal addObserver:observer1 callback:^(id observer, NSString *stringData, NSString *otherStringData) {
        XCTFail(@"Signal should not have fired");
    }];
    [emitter.onStringSignal addObserver:observer2 callback:^(id observer, NSString *stringData, NSString *otherStringData) {
        [fire fulfill];
    }];

    [emitter.onStringSignal removeObserver:observer1];
    
    emitter.onStringSignal.fire(nil, nil);

    [self waitForExpectationsWithTimeout:0.2 handler:nil];
}

- (void)testRemovingAllObservers
{
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    NSObject *observer1 = [[NSObject alloc] init];
    NSObject *observer2 = [[NSObject alloc] init];

    [emitter.onStringSignal addObserver:observer1 callback:^(id observer, NSString *stringData, NSString *otherStringData) {
        XCTFail(@"Signal should not have fired");
    }];
    [emitter.onStringSignal addObserver:observer2 callback:^(id observer, NSString *stringData, NSString *otherStringData) {
        XCTFail(@"Signal should not have fired");
    }];
    
    [emitter.onStringSignal removeAllObservers];
    emitter.onStringSignal.fire(nil, nil);
}

- (void)testCancelASignalObserver
{
    XCTestExpectation *fire = [self expectationWithDescription:@"Fire"];
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    
    UBSignalObserver *signalObserver = [emitter.onStringSignal addObserver:self callback:^(typeof(self) self, NSString *stringData, NSString *otherStringData) {
        XCTFail(@"Signal should not have fired");
    }];
    [emitter.onStringSignal addObserver:self callback:^(typeof(self) self, NSString *stringData, NSString *otherStringData) {
        [fire fulfill];
    }];
    
    [signalObserver cancel];
    
    emitter.onStringSignal.fire(nil, nil);
    [self waitForExpectationsWithTimeout:0.2 handler:nil];
}

- (void)testCancelsAfterFire
{
    XCTestExpectation *fire = [self expectationWithDescription:@"Fire"];
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    NSObject *observer1 = [[NSObject alloc] init];

    __block NSUInteger fireCount = 0;
    
    UBSignalObserver *observer = [emitter.onStringSignal addObserver:observer1 callback:^(id observer, NSString *stringData, NSString *otherStringData) {
        fireCount++;
        if (fireCount == 2) {
            [fire fulfill];
        }
    }];

    emitter.onStringSignal.fire(nil, nil);
    
    observer.cancelsAfterNextFire = YES;
    
    emitter.onStringSignal.fire(nil, nil);
    emitter.onStringSignal.fire(nil, nil);

    [self waitForExpectationsWithTimeout:0.2 handler:nil];
}

//- (void)testCancelsAfterFireWithPreviousData
//{
//    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
//    NSObject *observer1 = [[NSObject alloc] init];
//    emitter.onStringSignal.fire(nil, nil);
//    
//    __block NSUInteger fireCount = 0;
//
//    UBSignalObserver *observer = [emitter.onStringSignal addObserver:observer1 callback:^(id observer, NSString *stringData, NSString *otherStringData) {
//        fireCount++;
//    }];
//    
//    observer.cancelsAfterNextFire = YES;
//    [observer firePreviousData];
//    
//    XCTAssertEqual(fireCount, 1u, @"Signal fire should have been observed one time");
//    
//    emitter.onStringSignal.fire(nil, nil);
//    XCTAssertEqual(fireCount, 1u, @"Signal fire should have been observed one time");
//}

- (void)testRetainingOfWeakSelfForDurationOfCallback
{
    XCTestExpectation *fire = [self expectationWithDescription:@"Fire"];
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    __block NSObject *observer = [[NSObject alloc] init];
    
    [emitter.onStringSignal addObserver:observer callback:^(id weakifiedObject, NSString *stringData, NSString *otherStringData) {
        observer = nil;
        XCTAssertNotNil(weakifiedObject, @"The weakified object should not have been collected");
        [fire fulfill];
    }];
    
    emitter.onStringSignal.fire(nil, nil);
    [self waitForExpectationsWithTimeout:0.2 handler:nil];
}

- (void)testRemovalOfDeallocatedListeners
{
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    NSObject *observer = [[NSObject alloc] init];

    [emitter.onStringSignal addObserver:observer callback:^(id theWeakifiedObject, NSString *stringData, NSString *otherStringData) {
         XCTFail(@"Signal should not have fired callbacks on deallocated listener");
    }];
    
    observer = nil;
    emitter.onStringSignal.fire(nil, nil);
}

- (void)testLateFiringOfSignal
{
    XCTestExpectation *fire = [self expectationWithDescription:@"Fire"];
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];

    __block id callbackSelf = nil;
    __block NSString *callbackStringData;
    __block NSString *callbackOtherStringData;
    
    UBSignalObserver *signalObserver = [emitter.onStringSignal addObserver:self callback:^(typeof(self) self, NSString *stringData, NSString *otherStringData) {}];
    BOOL didFire = [signalObserver firePreviousData];
    
    emitter.onStringSignal.fire(@"First", @"Second");
    
    signalObserver = [emitter.onStringSignal addObserver:self callback:^(typeof(self) self, NSString *stringData, NSString *otherStringData) {
        [fire fulfill];
        callbackSelf = self;
        callbackStringData = stringData;
        callbackOtherStringData = otherStringData;
    }];
    
    BOOL didFire2 = [signalObserver firePreviousData];

    [self waitForExpectationsWithTimeout:0.2 handler:nil];
    XCTAssertFalse(didFire, @"firePastData should not report data being fired");
    XCTAssertTrue(didFire2, @"firePastData should report data being fired");
    XCTAssertEqual(callbackSelf, self, @"Callback should contain correct self argument");
    XCTAssertEqual(callbackStringData, @"First", @"Should fire correct string");
    XCTAssertEqual(callbackOtherStringData, @"Second", @"Should fire correct string");
}

- (void)testSettingOperationQueueForCallback
{
    XCTestExpectation *fire1 = [self expectationWithDescription:@"Fire 1"];
    XCTestExpectation *fire2 = [self expectationWithDescription:@"Fire 2"];
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.qualityOfService = NSOperationQueuePriorityLow;
    
    [emitter.onStringSignal addObserver:self callback:^(id weakifiedObject, NSString *stringData, NSString *otherStringData) {
        XCTAssert(NSOperationQueue.currentQueue == NSOperationQueue.mainQueue, @"Should have been called on the correct queue");
        [fire1 fulfill];
    }].operationQueue = NSOperationQueue.mainQueue;
    
    [emitter.onStringSignal addObserver:self callback:^(id weakifiedObject, NSString *stringData, NSString *otherStringData) {
        XCTAssert(NSOperationQueue.currentQueue == queue, @"Should have been called on the correct queue");
        [fire2 fulfill];
    }].operationQueue = queue;
    
    emitter.onStringSignal.fire(nil, nil);
    
    [self waitForExpectationsWithTimeout:0.2 handler:nil];
}

- (void)testFiringSignalOnSameOperationQueue
{
    XCTestExpectation *fire = [self expectationWithDescription:@"Fire"];
    
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.qualityOfService = NSOperationQueuePriorityLow;
    
    [emitter.onStringSignal addObserver:self callback:^(id weakifiedObject, NSString *stringData, NSString *otherStringData) {
        XCTAssert(NSOperationQueue.currentQueue == queue, @"Should have been called on the correct queue");
        [fire fulfill];
    }].operationQueue = queue;
    
    [queue addOperationWithBlock:^{
        emitter.onStringSignal.fire(nil, nil);
    }];
    
    [self waitForExpectationsWithTimeout:0.2 handler:nil];
}

- (void)testNilObserverCallback
{
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    XCTAssertThrowsSpecificNamed([emitter.onStringSignal addObserver:self callback:nil], NSException, NSInternalInconsistencyException, "Should have returned back a NSInternalInconsistencyException because the callback cannot be nil");
}

- (void)testDelegateAddCallback
{
    XCTestExpectation *fire = [self expectationWithDescription:@"Fire"];
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];

    emitter.onEmptySignal.observerAdded = ^(UBSignalObserver *signalObserver) {
        [fire fulfill];
    };
    
    [emitter.onEmptySignal addObserver:self callback:^(id self) {
        // this space left intentionally blank
    }];
    
    [self waitForExpectationsWithTimeout:0.2 handler:nil];
}

- (void)testDelegateRemoveCallbackOnCancel
{
    XCTestExpectation *fire = [self expectationWithDescription:@"Fire"];
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    
    __block UBSignalObserver *observer = nil;
    emitter.onEmptySignal.observerRemoved = ^(UBSignalObserver *signalObserver) {
        XCTAssertEqual(signalObserver, observer, @"signalObserver should be the same object as was originally returned by addObserver:");
        [fire fulfill];
    };
    
    observer = [emitter.onEmptySignal addObserver:self callback:^(id self) {
        // this space left intentionally blank
    }];
    [observer cancel];
    
    [self waitForExpectationsWithTimeout:0.2 handler:nil];
}

- (void)testDelegateRemoveCallbackOnExplicitRemoval
{
    XCTestExpectation *fire = [self expectationWithDescription:@"Fire"];
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    
    __block UBSignalObserver *observer = nil;
    emitter.onEmptySignal.observerRemoved = ^(UBSignalObserver *signalObserver) {
        XCTAssertEqual(signalObserver, observer, @"signalObserver should be the same object as was originally returned by addObserver:");
        [fire fulfill];
    };
    
    observer = [emitter.onEmptySignal addObserver:self callback:^(id self) {
        // this space left intentionally blank
    }];
    [emitter.onEmptySignal removeObserver:self];
    
    [self waitForExpectationsWithTimeout:0.2 handler:nil];
}

- (void)testDelegateRemoveCallbackOnObserverNil
{
    XCTestExpectation *fire = [self expectationWithDescription:@"Fire"];
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    
    __block UBSignalObserver *observer = nil;
    emitter.onEmptySignal.observerRemoved = ^(UBSignalObserver *signalObserver) {
        XCTAssertEqual(signalObserver, observer, @"signalObserver should be the same object as was originally returned by addObserver:");
        [fire fulfill];
    };
    
    NSObject *observerObject = [[NSObject alloc] init];
    observer = [emitter.onEmptySignal addObserver:observerObject callback:^(id self) {
        // this space left intentionally blank
    }];
    observerObject = nil;
    
    [emitter.onEmptySignal addObserver:self callback:^(id self) {
        // this space left intentionally blank
    }];
    
    [self waitForExpectationsWithTimeout:0.2 handler:nil];
}

- (void)testMaxObservers
{
    UBSignal<EmptySignal> *signal = (UBSignal<EmptySignal> *)[[UBSignal alloc] initWithProtocol:@protocol(EmptySignal)];
    signal.maxObservers = 2;
    
    [signal addObserver:self callback:^(id self) {}];
    [signal addObserver:self callback:^(id self) {}];
    
    XCTAssertThrows([signal addObserver:self callback:^(id self) {}], @"Should have complained about max observers");
}

- (void)testSettingMaxObserversBelowObservers
{
    UBSignal<EmptySignal> *signal = (UBSignal<EmptySignal> *)[[UBSignal alloc] initWithProtocol:@protocol(EmptySignal)];
    [signal addObserver:self callback:^(id self) {}];
    [signal addObserver:self callback:^(id self) {}];
    
    XCTAssertNoThrow(signal.maxObservers = 2, @"Shouldn't have complained about max observers");
    XCTAssertThrows(signal.maxObservers = 1, @"Should have complained about max observers");
}

- (void)testAllArgumentCounts
{
    UBSignal<EmptySignal> *signal = (UBSignal<EmptySignal> *)[[UBSignal alloc] initWithProtocol:@protocol(EmptySignal)];
    signal.maxObservers = 2;
    
    [signal addObserver:self callback:^(id self) {}];
    [signal addObserver:self callback:^(id self) {}];
    
    XCTAssertThrows([signal addObserver:self callback:^(id self) {}], @"Should have complained about max observers");
}

- (void)testObservingWithoutCallback
{
    UBSignal<EmptySignal> *signal = (UBSignal<EmptySignal> *)[[UBSignal alloc] initWithProtocol:@protocol(EmptySignal)];
    XCTAssertThrows([signal addObserver:nil callback:^(id self) {}], @"Should have complained about nil observer");
    XCTAssertThrows([signal addObserver:self callback:nil], @"Should have complained about nil callback");
}

- (void)testRemovingListenerWhileInObserverCallback {
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    
    __block NSUInteger fireCount = 0;
    __block UBSignalObserver *observer = nil;
    __block UBSignalObserver *observer2 = nil;
    
    observer = [emitter.onEmptySignal addObserver:self callback:^(typeof(self) self) {
        fireCount++;
        [observer cancel];
    }];
    observer2 = [emitter.onEmptySignal addObserver:self callback:^(typeof(self) self) {
        fireCount++;
        [observer cancel];
    }];
    
    emitter.onEmptySignal.fire();
    
    XCTAssertEqual(fireCount, 2u, @"Signal fired");
}

- (void)testAddListenerWhileInObserverCallback {
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    
    __block NSUInteger fireCount = 0;

    [emitter.onEmptySignal addObserver:self callback:^(typeof(self) self) {
        fireCount++;
        [emitter.onEmptySignal addObserver:self callback:^(typeof(self) self) {
            fireCount++;
        }];
    }];
    
    emitter.onEmptySignal.fire();
    emitter.onEmptySignal.fire();
    
    XCTAssertEqual(fireCount, 3u, @"Signal fired");
}

- (void)testFiringShouldNotRetainObserver {
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    
    __block NSUInteger fireCount = 0;
    
    
    NSObject *observer = [[NSObject alloc] init];
    __weak NSObject *weakObserver = observer;
    
    @autoreleasepool {
        [emitter.onEmptySignal addObserver:observer callback:^(typeof(self) self) {
            fireCount++;
        }];
        emitter.onEmptySignal.fire();
        emitter.onEmptySignal.fire();
    }
    
    observer = nil;
    
    XCTAssertEqual(fireCount, 2u, @"Signal fired");
    XCTAssertNil(weakObserver, @"Should have deallocated observer");
}

- (void)testRemovingObserverWhileFiringShouldNotRetainObserver {
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    
    __block NSUInteger fireCount = 0;
    
    NSObject *observer = [[NSObject alloc] init];
    __weak NSObject *weakObserver = observer;
    
    @autoreleasepool {
        [emitter.onEmptySignal addObserver:observer callback:^(typeof(self) self) {
            fireCount++;
            [emitter.onEmptySignal removeObserver:observer];
        }];
        
        emitter.onEmptySignal.fire();
        emitter.onEmptySignal.fire();
        
        observer = nil;
    }
    XCTAssertEqual(fireCount, 1u, @"Signal fired");
    XCTAssertNil(weakObserver, @"Should have deallocated observer");
}

- (void)testUBSignalHelper
{
    UBSignal<EmptySignal> *emptySignalWithHelper = [UBSignal emptySignal];
    XCTAssertEqualObjects([emptySignalWithHelper class], [UBSignal class], @"Object created with helper factory method should be a UBSignal");
}

@end
