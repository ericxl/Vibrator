//
//  ViewController.m
//  Vibrator
//
//  Created by Eric Liang on 10/27/12.
//  Copyright (c) 2012 Eric Liang. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioServices.h>
#import <AVFoundation/AVFoundation.h>

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

@interface ViewController ()

@end

@implementation ViewController
@synthesize switchButton;
@synthesize timer;
@synthesize sliderLabel;
BOOL isOn;
BOOL isTorchOn;
float timerInterval = 1.0;

- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize

{
    
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
                                [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
                                UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
                                UIGraphicsEndImageContext();
    return scaledImage;
                                
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *image = nil;
    if (iPhone5) {
        image = [UIImage imageNamed:@"Default-568h.png"];
    }
    else {
        image = [UIImage imageNamed:@"Default.png"];
    }
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    [self.view insertSubview:imageView atIndex:0];
    
    switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [switchButton setImage:[self scaleImage:[UIImage imageNamed:@"dark_on.png"] toScale:1.5] forState:UIControlStateNormal];
    [switchButton setImage:[self scaleImage:[UIImage imageNamed:@"dark_on_pressed.png"] toScale:1.5] forState:UIControlStateHighlighted];
    [switchButton setFrame:CGRectMake(105, 80, 110, 135)];
    [switchButton addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:switchButton];
    
    
    
    isOn = YES;
    isTorchOn = NO;
    [sliderLabel setText:[NSString stringWithFormat:@"%.1f", timerInterval]];
    
    timer = [NSTimer timerWithTimeInterval:timerInterval target:self selector:@selector(vibrate) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    /*
    AudioServicesAddSystemSoundCompletion (
                                               kSystemSoundID_Vibrate,
                                               NULL,
                                               NULL,
                                               MyAudioServicesSystemSoundCompletionProc,
                                               NULL
                                               );
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
     */
    
    
	// Do any additional setup after loading the view, typically from a nib.
}
-(void)flash{
    [self torchOnOff:YES];
    [self performSelector:@selector(torchOFF) withObject:nil afterDelay:0.2];
}
-(void)torchOFF {
    [self torchOnOff:NO];
}

-(void) vibrate {
    if (isTorchOn) {
        [self flash];
    }
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
}
void MyAudioServicesSystemSoundCompletionProc (SystemSoundID  ssID, void *clientData)
{
    if (isOn) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)switchValueChanged:(UIControl *)sender {
    isOn = !isOn;
    if (isOn) {
        timer = [NSTimer timerWithTimeInterval:timerInterval target:self selector:@selector(vibrate) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    }
    else {
        [timer invalidate];
        timer = nil;
    }
    
    if (isOn) {
        [switchButton setImage:[self scaleImage:[UIImage imageNamed:@"dark_on.png"] toScale:1.5] forState:UIControlStateNormal];
        [switchButton setImage:[self scaleImage:[UIImage imageNamed:@"dark_on_pressed.png"] toScale:1.5] forState:UIControlStateHighlighted];
        [switchButton setNeedsDisplay];
    }
    else {
        [switchButton setImage:[self scaleImage:[UIImage imageNamed:@"dark_off.png"] toScale:1.5] forState:UIControlStateNormal];
        [switchButton setImage:[self scaleImage:[UIImage imageNamed:@"dark_off_pressed.png"]toScale:1.5] forState:UIControlStateHighlighted];
        [switchButton setNeedsDisplay];

    }
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    timerInterval = [sender value];
    [sliderLabel setText:[NSString stringWithFormat:@"%.1f", timerInterval]];
    if (isOn) {
        [timer invalidate];
        timer = nil;
        timer = [NSTimer timerWithTimeInterval:timerInterval target:self selector:@selector(vibrate) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];

    }
}

- (IBAction)torchSwitchValueChanged:(UISwitch *)sender {
    isTorchOn = sender.isOn;
}
- (void)torchOnOff: (BOOL) onOff
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        [device setTorchMode: onOff ? AVCaptureTorchModeOn : AVCaptureTorchModeOff];
        [device unlockForConfiguration];
    }
}
- (void)viewDidUnload {
    [self setSwitchButton:nil];
    [self setTimer:nil];
    [self setSliderLabel:nil];
    [super viewDidUnload];
}
@end
