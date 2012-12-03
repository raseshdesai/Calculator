//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Rasesh Desai on 10/6/12.
//  Copyright (c) 2012 Rasesh Desai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

//Yet to do:
//1. Enter one postfix string and calculate it with all 3 testcases
//2. print in infix
//3. refer to homework and see whats missing
//4. fix UI (only if time permits)
//5. display pi without spelling it using symbol, as shown in assigment screenshot

-(void)pushOperand:(double)operand;

-(void)pushOperation:(NSString*)operation;

-(double)execute:(NSDictionary *) variableMap;

-(void)clearStack;

- (NSString *) describeProgram;

@property (readonly) id program;

+ (double) runProgram:(id) program
       usingVariables:(NSDictionary *) variableMap;

+ (NSString *) descriptionOfProgram: (id) program;

@end
