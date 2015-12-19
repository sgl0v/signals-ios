//
//  UBSignal.m
//  UberSignals
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

#import "UBSignal.h"

#import <objc/runtime.h>

#import "UBSignalObserver+Internal.h"

#define WrapNil(name) (name == nil ? [NSNull null] : name)
#define weakself __weak typeof(self) weakSelf = self
#define strongself __strong typeof(weakSelf) self = weakSelf

@interface UBSignal ()

@property (nonatomic, readonly) id fire;
@property (nonatomic, readonly) id fireForSignalObserver;
@property (nonatomic, strong) NSMutableArray *signalObservers;
@property (nonatomic, strong) NSArray *lastData;
@property (nonatomic, strong) dispatch_queue_t operationQueue;

@end

@implementation UBSignal

+ (UBSignal<EmptySignal> *)emptySignal
{
    return (UBSignal<EmptySignal> *)[[UBSignal alloc] initWithProtocol:@protocol(EmptySignal)];
}

#pragma mark - Initializers

- (instancetype)initWithProtocol:(Protocol *)protocol
{
    self = [super init];
    if (self) {
        _signalObservers = [NSMutableArray array];
        _maxObservers = 100;
        dispatch_queue_attr_t qos_attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_UTILITY, 0);
        _operationQueue = dispatch_queue_create("com.uber.signals.ios", qos_attr);
        
        weakself;
        if (protocol_conformsToProtocol(protocol, @protocol(EmptySignal))) {
            _fire = ^{
                strongself;
                dispatch_async(self.operationQueue, ^{
                    strongself;
                    [self _fireData:nil forSignalObservers:self.signalObservers];
                });
            };
            _fireForSignalObserver = ^(UBSignalObserver *signalObserver) {
                strongself;
                dispatch_async(self.operationQueue, ^{
                    strongself;
                    [self _fireData:nil forSignalObservers:@[signalObserver]];
                });
            };
        } else if (protocol_conformsToProtocol(protocol, @protocol(UBSignalArgumentCount1))) {
            _fire = ^(id arg1) {
                strongself;
                dispatch_async(self.operationQueue, ^{
                    strongself;
                    [self _fireNewData:@[WrapNil(arg1)] forSignalObservers:self.signalObservers];
                });
            };
            _fireForSignalObserver = ^(UBSignalObserver *signalObserver, id arg1) {
                strongself;
                dispatch_async(self.operationQueue, ^{
                    strongself;
                    [self _fireNewData:@[WrapNil(arg1)] forSignalObservers:@[signalObserver]];
                });
            };
        } else if (protocol_conformsToProtocol(protocol, @protocol(UBSignalArgumentCount2))) {
            _fire = ^(id arg1, id arg2) {
                strongself;
                dispatch_async(self.operationQueue, ^{
                    strongself;
                    [self _fireNewData:@[WrapNil(arg1), WrapNil(arg2)] forSignalObservers:self.signalObservers];
                });
            };
            _fireForSignalObserver = ^(UBSignalObserver *signalObserver, id arg1, id arg2) {
                strongself;
                dispatch_async(self.operationQueue, ^{
                    strongself;
                    [self _fireNewData:@[WrapNil(arg1), WrapNil(arg2)] forSignalObservers:@[signalObserver]];
                });
            };
        } else if (protocol_conformsToProtocol(protocol, @protocol(UBSignalArgumentCount3))) {
            _fire = ^(id arg1, id arg2, id arg3) {
                strongself;
                dispatch_async(self.operationQueue, ^{
                    strongself;
                    [self _fireNewData:@[WrapNil(arg1), WrapNil(arg2), WrapNil(arg3)] forSignalObservers:self.signalObservers];
                });
            };
            _fireForSignalObserver = ^(UBSignalObserver *signalObserver, id arg1, id arg2, id arg3) {
                strongself;
                dispatch_async(self.operationQueue, ^{
                    strongself;
                    [self _fireNewData:@[WrapNil(arg1), WrapNil(arg2), WrapNil(arg3)] forSignalObservers:@[signalObserver]];
                });
            };
        } else if (protocol_conformsToProtocol(protocol, @protocol(UBSignalArgumentCount4))) {
            _fire = ^(id arg1, id arg2, id arg3, id arg4) {
                strongself;
                dispatch_async(self.operationQueue, ^{
                    strongself;
                    [self _fireNewData:@[WrapNil(arg1), WrapNil(arg2), WrapNil(arg3), WrapNil(arg4)] forSignalObservers:self.signalObservers];
                });
            };
            _fireForSignalObserver = ^(UBSignalObserver *signalObserver, id arg1, id arg2, id arg3, id arg4) {
                strongself;
                dispatch_async(self.operationQueue, ^{
                    strongself;
                    [self _fireNewData:@[WrapNil(arg1), WrapNil(arg2), WrapNil(arg3), WrapNil(arg4)] forSignalObservers:@[signalObserver]];
                });
            };
        } else if (protocol_conformsToProtocol(protocol, @protocol(UBSignalArgumentCount5))) {
            _fire = ^(id arg1, id arg2, id arg3, id arg4, id arg5) {
                strongself;
                dispatch_async(self.operationQueue, ^{
                    strongself;
                    [self _fireNewData:@[WrapNil(arg1), WrapNil(arg2), WrapNil(arg3), WrapNil(arg4), WrapNil(arg5)] forSignalObservers:self.signalObservers];
                });
            };
            _fireForSignalObserver = ^(UBSignalObserver *signalObserver, id arg1, id arg2, id arg3, id arg4, id arg5) {
                strongself;
                dispatch_async(self.operationQueue, ^{
                    strongself;
                    [self _fireNewData:@[WrapNil(arg1), WrapNil(arg2), WrapNil(arg3), WrapNil(arg4), WrapNil(arg5)] forSignalObservers:@[signalObserver]];
                });
            };
        } else {
            NSAssert(false, @"Protocol doesn't provide parameter count");
        }
    }
    return self;
}

- (instancetype)init
{
    [NSException raise:@"Incorrect initializer" format:@"%@ is unavailable, use %@.", NSStringFromSelector(_cmd), NSStringFromSelector(@selector(initWithProtocol:))];
    return nil;
}

#pragma mark - NSObject

- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"<%@: %p, signalObservers: %@", NSStringFromClass([self class]), self, [self.signalObservers debugDescription]];
}


#pragma mark - Properties

- (void)setMaxObservers:(NSUInteger)maxObservers
{
    _maxObservers = maxObservers;
    NSAssert(_signalObservers.count <= _maxObservers, @"Maximum observer count exceeded for this signal");
}


#pragma mark - Public interface

- (UBSignalObserver *)addObserver:(NSObject *)observer callback:(UBSignalCallback)callback
{
    NSParameterAssert(observer != nil);
    NSParameterAssert(callback != nil);
    if (observer == nil && callback == nil) {
        return nil;
    }
    NSAssert(_signalObservers.count <= _maxObservers, @"Maximum observer count exceeded for this signal");

    __block UBSignalObserver *signalObserver = nil;
    weakself;
    dispatch_sync(_operationQueue, ^{
        strongself;

        [self _purgeDeallocedListeners];
        signalObserver = [[UBSignalObserver alloc] initWithSignal:self observer:observer callback:callback];
        [_signalObservers addObject:signalObserver];

        if (self.observerAdded) {
            self.observerAdded(signalObserver);
        }
    });

    return signalObserver;
}

- (void)removeObserver:(NSObject *)observer
{
    weakself;
    dispatch_barrier_async(_operationQueue, ^{
        strongself;

        [self _purgeDeallocedListeners];
        NSMutableArray *removedSignalObservers = [NSMutableArray array];
        for (UBSignalObserver *signalObserver in _signalObservers) {
            if (signalObserver.observer == observer) {
                [_signalObservers removeObject:signalObserver];
                [removedSignalObservers addObject:signalObserver];
            }
        }

        if (removedSignalObservers.count && self.observerRemoved) {
            for (UBSignalObserver *removedSignalObserver in removedSignalObservers) {
                self.observerRemoved(removedSignalObserver);
            }
        }
    });

}

- (void)removeAllObservers
{
    weakself;
    dispatch_barrier_async(_operationQueue, ^{
        strongself;
        [self.signalObservers removeAllObjects];
    });
}


#pragma mark - Internal Interface

- (void)removeSignalObserver:(UBSignalObserver *)signalObserver
{
    weakself;
    dispatch_barrier_async(_operationQueue, ^{
        strongself;
        [_signalObservers removeObject:signalObserver];
        if (self.observerRemoved) {
            self.observerRemoved(signalObserver);
        }
    });
}

- (BOOL)firePastDataForSignalObserver:(UBSignalObserver *)signalObserver
{
    __block BOOL isFired = NO;

    weakself;
    dispatch_sync(_operationQueue, ^{
        strongself;
        if (!_lastData) {
            return;
        }
        isFired = YES;
        [self _fireData:_lastData forSignalObservers:@[signalObserver]];
    });

    return isFired;
}


#pragma mark - Private Interface

- (void)_purgeDeallocedListeners
{
    NSMutableArray *deallocedListeners;
    for (UBSignalObserver *signalObserver in _signalObservers) {
        if (signalObserver.observer == nil) {
            [_signalObservers removeObject:signalObserver];
            
            if (!deallocedListeners) {
                deallocedListeners = [NSMutableArray array];
            }
            [deallocedListeners addObject:signalObserver];
        }
    }
    for (UBSignalObserver *removedObserver in deallocedListeners) {
        if (self.observerRemoved) {
            self.observerRemoved(removedObserver);
        }
    }
}

- (void)_fireNewData:(NSArray *)arguments forSignalObservers:(NSArray *)signalObsevers
{
    _lastData = arguments;
    [self _fireData:arguments forSignalObservers:signalObsevers];
}

- (void)_fireData:(NSArray *)arguments forSignalObservers:(NSArray *)signalObservers
{
    NSAssert(arguments.count < 6, @"A maximum of 5 arguments are supported when firing a Signal");

    [self _purgeDeallocedListeners];

    
    id arg1, arg2, arg3, arg4, arg5;
    switch (arguments.count) {
        case 5:
            arg5 = arguments[4] != [NSNull null] ? arguments[4] : nil;
        case 4:
            arg4 = arguments[3] != [NSNull null] ? arguments[3] : nil;
        case 3:
            arg3 = arguments[2] != [NSNull null] ? arguments[2] : nil;
        case 2:
            arg2 = arguments[1] != [NSNull null] ? arguments[1] : nil;
        case 1:
            arg1 = arguments[0] != [NSNull null] ? arguments[0] : nil;
    }
    
    for (UBSignalObserver *signalObserver in signalObservers) {
        __strong id observer = signalObserver.observer;
        
        void (^fire)() = ^{
            UBSignalCallback callback = signalObserver.callback;
            
            if (signalObserver.cancelsAfterNextFire == YES) {
                [signalObserver cancel];
            }
            
            switch (arguments.count) {
                case 0:
                    callback(observer); break;
                case 1:
                    ((UBSignalCallbackArgCount1)callback)(observer, arg1); break;
                case 2:
                    ((UBSignalCallbackArgCount2)callback)(observer, arg1, arg2); break;
                case 3:
                    ((UBSignalCallbackArgCount3)callback)(observer, arg1, arg2, arg3); break;
                case 4:
                    ((UBSignalCallbackArgCount4)callback)(observer, arg1, arg2, arg3, arg4); break;
                case 5:
                    ((UBSignalCallbackArgCount5)callback)(observer, arg1, arg2, arg3, arg4, arg5); break;
            }
        };
        
        if (signalObserver.operationQueue == nil) {
            fire();
        } else {
            [signalObserver.operationQueue addOperationWithBlock:^{
                fire();
            }];
        }
    }
}

@end
