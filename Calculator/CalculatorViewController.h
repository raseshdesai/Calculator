//
//  CalculatorViewController.h
//  Calculator
//
//  Created by Rasesh Desai on 10/4/12.
//  Copyright (c) 2012 Rasesh Desai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *display;

@property (weak, nonatomic) IBOutlet UILabel *userEnteredInstructionsDisplay;

@property (weak, nonatomic) IBOutlet UILabel *programDescription;

@end