//
//  ViewController.h
//  Vibrator
//
//  Created by Eric Liang on 10/27/12.
//  Copyright (c) 2012 Eric Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *switchButton;
@property (strong, nonatomic) NSTimer *timer;
- (void)switchValueChanged:(UIControl *)sender;
- (IBAction)sliderValueChanged:(UISlider *)sender;
- (IBAction)torchSwitchValueChanged:(UISwitch *)sender;
@property (strong, nonatomic) IBOutlet UILabel *sliderLabel;
@end
