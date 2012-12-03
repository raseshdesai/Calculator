//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Rasesh Desai on 10/4/12.
//  Copyright (c) 2012 Rasesh Desai. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()

@property (nonatomic) BOOL userIsInMiddleOfTypingANumber;
@property (nonatomic, strong)CalculatorBrain * brain;

@end

@implementation CalculatorViewController

@synthesize display = _display;

@synthesize brain = _brain;

@synthesize userEnteredInstructionsDisplay = _userEnteredInstructionsDisplay;

-(CalculatorBrain *) brain {
    if(_brain == nil){
        _brain = [[CalculatorBrain alloc] init];
    }
    return _brain;
    
}


- (IBAction)digitPressed:(UIButton *)sender {
    
    NSString * digitPressed = sender.currentTitle;
    NSString * appendedDigitToDisplay = [self.display.text stringByAppendingString: digitPressed];
    
    if(self.userIsInMiddleOfTypingANumber){
        self.display.text = appendedDigitToDisplay;
        
    } else{
        self.display.text = digitPressed;
        self.userIsInMiddleOfTypingANumber = true;
    }
    [self addToUserEnteredInstructionsDisplay:digitPressed];
    
}

- (IBAction)periodPressed {
    if(!self.userIsInMiddleOfTypingANumber){
        self.display.text = @"0.";
        [self addToUserEnteredInstructionsDisplay:@"0."];
        
    } else if(![self displayContainsPeriod]){
        self.display.text = [self.display.text stringByAppendingString:@"."];
        [self addToUserEnteredInstructionsDisplay:@"."];
    }
    self.userIsInMiddleOfTypingANumber = true;
}

- (IBAction)operationPressed:(UIButton *)sender {
    [self autoPressEnterIfUserWasInMiddleOfTypingAndOperationWasPressed];
    [self.brain pushOperation:sender.currentTitle];
    [self addToUserEnteredInstructionsDisplayWithSpace:sender.currentTitle];
}


- (IBAction)executePressed:(UIButton *)sender {
    [self autoPressEnterIfUserWasInMiddleOfTypingAndOperationWasPressed];
    double result = [self.brain execute:nil];
    [self displayFormattedResult:result];
    //[self addToUserEnteredInstructionsDisplayWithEqualSign:sender.currentTitle];    //later. maybe display whole result in infix format
    self.programDescription.text = [self.brain describeProgram];
}

- (IBAction)testPressed:(UIButton *)sender {
    NSDictionary * testVariableMap;
    NSArray * keys = [NSArray arrayWithObjects:@"x", @"a", @"b", nil];
    NSString * testPressed = sender.currentTitle;
    if([@"Test1" isEqualToString:testPressed]){
        NSArray * values = [NSArray arrayWithObjects:
                            [NSNumber numberWithDouble:1],
                            [NSNumber numberWithDouble:2],
                            [NSNumber numberWithDouble:3],
                            nil];
        testVariableMap = [NSDictionary dictionaryWithObjects:values forKeys:keys];
        
    }
    if([@"Test2" isEqualToString:testPressed]){
        NSArray * values = [NSArray arrayWithObjects:
                            [NSNumber numberWithDouble:4],
                            [NSNumber numberWithDouble:5],
                            [NSNumber numberWithDouble:6],
                            nil];
        testVariableMap = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    }
    if([@"Test3" isEqualToString:testPressed]){
        NSArray * values = [NSArray arrayWithObjects:
                            [NSNumber numberWithDouble:7],
                            [NSNumber numberWithDouble:8],
                            [NSNumber numberWithDouble:9],
                            nil];
        testVariableMap = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    }
    [self autoPressEnterIfUserWasInMiddleOfTypingAndOperationWasPressed];
    double result = [self.brain execute:testVariableMap];
    [self displayFormattedResult:result];
    //[self addToUserEnteredInstructionsDisplayWithEqualSign:sender.currentTitle];    //later. maybe display whole result in infix format
}

- (IBAction)enterPressed {
    [self.brain pushOperand: [self.display.text doubleValue]];
    self.userIsInMiddleOfTypingANumber = false;
    [self addToUserEnteredInstructionsDisplay:@" "];
}

- (IBAction)clearPressed {
    [self.brain clearStack];
    self.display.text = @"0";
    self.userIsInMiddleOfTypingANumber = false;
    self.userEnteredInstructionsDisplay.text = @"";
    self.programDescription.text = @"";
}

- (IBAction)backspacePressed {
    NSString * displayText = self.display.text;
    if([self lastElementEnteredIsADigit] && ![displayText isEqualToString:@"0"]){
        self.display.text = [displayText substringToIndex:displayText.length - 1];
        
        NSString * instructionText = self.userEnteredInstructionsDisplay.text;
        self.userEnteredInstructionsDisplay.text = [instructionText substringToIndex:instructionText.length - 1];
    }
    if(self.display.text.length == 0){
        self.display.text = @"0";
    }
}
- (IBAction)variablePressed:(UIButton *)sender {
    [self autoPressEnterIfUserWasInMiddleOfTypingAndOperationWasPressed];
    [self.brain pushOperation:sender.currentTitle];
    [self addToUserEnteredInstructionsDisplayWithSpace:sender.currentTitle];
}

- (BOOL)lastElementEnteredIsADigit {
    BOOL lastElementEnteredIsADigit = false;
    NSString * instructionText = self.userEnteredInstructionsDisplay.text;
    if(instructionText.length > 0 ) {
        NSString * lastEnteredElement = [instructionText substringFromIndex:instructionText.length - 1];
        
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber * lastDigit = [f numberFromString:lastEnteredElement];
        
        if([lastEnteredElement isEqualToString:@"."] || lastDigit != nil) {
            lastElementEnteredIsADigit = true;
        }
    }
    return lastElementEnteredIsADigit;
}

- (void)addToUserEnteredInstructionsDisplay:(NSString *)elementPressed {
    self.userEnteredInstructionsDisplay.text = [self.userEnteredInstructionsDisplay.text stringByAppendingString:elementPressed];
}

- (void)addToUserEnteredInstructionsDisplayWithSpace:(NSString *)elementPressed {
    [self addToUserEnteredInstructionsDisplay: elementPressed];
    self.userEnteredInstructionsDisplay.text = [self.userEnteredInstructionsDisplay.text stringByAppendingString:@" "];
}


- (void)autoPressEnterIfUserWasInMiddleOfTypingAndOperationWasPressed {
    if(self.userIsInMiddleOfTypingANumber){
        [self enterPressed];
    }
}

- (void)displayFormattedResult:(double)result {
    self.display.text = [NSString stringWithFormat:@"%g", result];
}

- (BOOL)displayContainsPeriod {
    BOOL displayContainsPeriod = true;
    if([self.display.text rangeOfString:@"."].location == NSNotFound){
        displayContainsPeriod = false;
    }
    return displayContainsPeriod;
}



@end
