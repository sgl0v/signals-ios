//
//  UBSignalEmitter.h
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

#import <Foundation/Foundation.h>

#import "UBSignal.h"

@protocol TestProtocol
@end

CreateSignalType(Tuple, NSString * __nullable stringData, NSString * __nullable otherStringData)
CreateSignalType(Triple, NSString * __nullable string1, NSString * __nullable string2, NSNumber * __nullable number1)
CreateSignalType(Quadruple, NSString * __nullable string1, NSString * __nullable string2, NSNumber * __nullable number1, NSNumber * __nullable number2)
CreateSignalType(Complex, NSNumber * __nullable number1, NSNumber * __nullable number2, NSNumber * __nullable number3, NSNumber * __nullable number4, NSNumber * __nullable number5)

@interface UBSignalEmitter : NSObject

@property (nonatomic, readonly, nonnull) UBSignal<EmptySignal> *onEmptySignal;
@property (nonatomic, readonly, nonnull) UBSignal<IntegerSignal> *onIntegerSignal;
@property (nonatomic, readonly, nonnull) UBSignal<TupleSignal> *onStringSignal;
@property (nonatomic, readonly, nonnull) UBSignal<TripleSignal> *onTripleSignal;
@property (nonatomic, readonly, nonnull) UBSignal<QuadrupleSignal> *onQuardrupleSignal;
@property (nonatomic, readonly, nonnull) UBSignal<ComplexSignal> *onComplexSignal;

@end
