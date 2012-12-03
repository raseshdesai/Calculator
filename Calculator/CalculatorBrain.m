//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Rasesh Desai on 10/6/12.
//  Copyright (c) 2012 Rasesh Desai. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()

@property (nonatomic, strong)  NSMutableArray* programStack;

@property (nonatomic, strong) NSString * allContentsOfStackInPostFix;

//Handling multiple programs...

//@property (nonatomic, strong) NSArray * listOfProgramResults;
//
//@property (nonatomic, strong) NSArray * listOfPrograms;
//
//@property (nonatomic, strong) NSString * currentProgram;
//
//@property (nonatomic, strong) NSNumber * currentResult;

@end

@implementation CalculatorBrain

//Local Variable for private property: Program Stack - synthesize, getter and setter
@synthesize programStack = _programStack;

-(void) setProgramStack:(NSMutableArray *)operandStack{
    _programStack = operandStack;
}

-(NSMutableArray*)programStack{
    if(_programStack == nil){
        self.programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}
//End of local Variable for private property: Program Stack - synthesize, getter and setter

//Class utility methods to check what type of operation is it (requiring 1, 2 or none)
+ (BOOL) isOperationRequiringTwoOperands:(NSString *) operation {
    NSSet * setOfOperations = [NSSet setWithObjects:@"+", @"-", @"*", @"/", nil];
    if([setOfOperations containsObject:operation]){
        return YES;
    }
    return NO;
}

+ (BOOL) isOperationRequiringOneOperand:(NSString *) operation {
    NSSet * setOfOperations = [NSSet setWithObjects:@"sin", @"cos", @"sqrt", @"log", @"+/-", nil];
    if([setOfOperations containsObject:operation]){
        return YES;
    }
    return NO;
}


+ (BOOL) isOperationRequiringNoOperand:(NSString *) operation {
    NSSet * setOfOperations = [NSSet setWithObjects:@"pi", nil];
    if([setOfOperations containsObject:operation]){
        return YES;
    }
    return NO;
}

//TODO: you can remove hard coding of variable supported in this method, by doing not operations (using all utility methods) and not a number (very low priority)
+ (BOOL) isVariable:(NSString *) operation {
    NSSet * setOfOperations = [NSSet setWithObjects:@"x", @"a", @"b", nil];
    if([setOfOperations containsObject:operation]){
        return YES;
    }
    return NO;
}


//End of utility methods

//getter for property 'program' defined in interface that returns immutabe copy of internal programsStack, note: no synthesize used
-(id)program{
    return [self.programStack copy];
}

//*********Class Methods (declared on the interface)

+ (double) runProgram:(id)program
       usingVariables:(NSDictionary *) variableMap{
    NSMutableArray * stack;
    if([program isKindOfClass:[NSArray class]]){
        stack = [program mutableCopy];
    }
    return [self popOperandOffStack:stack
                   usingVariableMap:variableMap];
}

+(NSString *) descriptionOfProgram:(id)program{
    return @"to be implemented";
}

//TODO: Save the smaller results (currently NSLogged) into a stack and print the complete thing here, First calculate one complicated calculation and see what is being calculated and printed [Example: 9sqrt3E5*45sin-12E4/+] step-by-step
//Note: Excute cuurrently calculates only top-program-of-stack and displays results, this needs to be UNDONE, and we need to be able to show csv of programs
+ (double)popOperandOffStack:(NSMutableArray *)stack
            usingVariableMap:(NSDictionary *) variableMap {
    
    id topOfStack = [stack lastObject];
    if(topOfStack){
        [stack removeLastObject];
    }
    
    if([self isVariable:topOfStack]){
        return [self lookUpVariableMap:variableMap
                              usingKey:topOfStack];
    }
    if([topOfStack isKindOfClass:[NSNumber class]]){
        return [topOfStack doubleValue];
    }
    if([topOfStack isKindOfClass:[NSString class]]){
        NSString * operation = topOfStack;
        
        double operandA;
        double operandB;
        
        if([self isOperationRequiringOneOperand:operation] || [self isOperationRequiringTwoOperands:operation]){
            operandA = [self popOperandOffStack:stack
                               usingVariableMap:variableMap];
        }
        if([self isOperationRequiringTwoOperands:operation]){
            operandB = [self popOperandOffStack:stack
                               usingVariableMap:variableMap];
        }
        
        return [self implementOperation:operation
                          givenOperandA:operandA
                            andOperandB:operandB];
    }
    
    return 0;
}

+(double)lookUpVariableMap:(NSDictionary *) variableMap
                  usingKey:(id) key{
    if(variableMap){
        return [(NSNumber *) [variableMap valueForKey:key] doubleValue];
    }
    return 0;
}

+ (double)implementOperation:(NSString *)operation
               givenOperandA:(double)operandA
                 andOperandB: (double)operandB {
    
    //Display whats being executed...
    if([CalculatorBrain isOperationRequiringTwoOperands:operation]){
        NSString * operandAAsString = [NSString stringWithFormat:@"%g", operandA];
        NSString * operandBAsString = [NSString stringWithFormat:@"%g", operandB];
        NSString * operationDesc = [@"(" stringByAppendingString:[operandBAsString stringByAppendingString:[operation stringByAppendingString:[operandAAsString stringByAppendingString:@")"]]]];
        NSLog(@" Operation Desc = %@", operationDesc);
    }
    if([CalculatorBrain isOperationRequiringOneOperand:operation]){
        NSString * operandAAsString = [NSString stringWithFormat:@"%g", operandA];
        NSString * operationDesc = [operation stringByAppendingString:[@"(" stringByAppendingString:[operandAAsString stringByAppendingString:@")"]]];
        NSLog(@" Operation Desc = %@", operationDesc);
    }
    if([CalculatorBrain isOperationRequiringNoOperand:operation]){
        NSString * operationDesc = operation;
        NSLog(@" Operation Desc = %@", operationDesc);
    }
    
    if([@"+" isEqualToString:operation]){
        return operandB + operandA;
    }
    if([@"-" isEqualToString:operation]){
        return operandB - operandA;
    }
    if([@"*" isEqualToString:operation]){
        return operandB * operandA;
    }
    if([@"/" isEqualToString:operation]){
        if(operandA != 0){
            return operandB / operandA;
        }
    }
    if([@"sin" isEqualToString:operation]){
        return sin(operandA);
    }
    if([@"cos" isEqualToString:operation]){
        return cos(operandA);
    }
    if([@"sqrt" isEqualToString:operation]){
        return sqrt(operandA);
    }
    if([@"log" isEqualToString:operation]){
        return sqrt(operandA);
    }
    if([@"+/-" isEqualToString:operation]){
        return  0 - operandA;
    }
    if([@"pi" isEqualToString:operation]){
        return M_PI;
    }
    return 0;
}


//***********instance methods...

-(void)pushOperand:(double)operand{
    NSNumber *operandAsNumber = [NSNumber numberWithDouble:operand];
    [self.programStack addObject:operandAsNumber];
}

-(void)pushOperation:(NSString*)operation{
    [self.programStack addObject:operation];
}

-(double)execute:(NSDictionary *) variableMap {
    return [CalculatorBrain runProgram:self.program
                        usingVariables:variableMap];
}

-(void)clearStack{
    [self.programStack removeAllObjects];
}

-(double)popOperand{
    NSNumber * operandOnTopOfTheStack = self.programStack.lastObject;
    if(operandOnTopOfTheStack != nil){
        [self.programStack removeLastObject];
    }
    return operandOnTopOfTheStack.doubleValue;
}

- (NSString *) describeProgram {
    self.allContentsOfStackInPostFix = @"";
    
    NSMutableArray * tempProgramStack = [self.programStack mutableCopy];  //mutable copy, for our calculation purpose only
    
    while (tempProgramStack.lastObject) {
        id topOfStackObject = [tempProgramStack lastObject];
        NSString * topOfStackAsString = @"";
        if ([topOfStackObject isKindOfClass:[NSNumber class]]) {
            topOfStackAsString = [(NSNumber *) topOfStackObject stringValue];
            
        } else{
            topOfStackAsString = (NSString *) topOfStackObject;
        }
        self.allContentsOfStackInPostFix = [self.allContentsOfStackInPostFix stringByAppendingString:topOfStackAsString];
        
        [tempProgramStack removeLastObject];
    }
    
    return self.allContentsOfStackInPostFix;
    
    //Currently just displaying whats saved into Stack
    //Infix
    //Differentiate: 3E6E as 3,6 and 3E6+ as 3+6
    //Handle multiple values
    //Work on description while executing and not be having separate local variables here, if possible
}

@end