//
//  ViewController.m
//  VBAnimator
//
//  Created by Viktor Bespalov on 06/02/14.
//  Copyright (c) 2014 bespalown. All rights reserved.
//

#import "ViewController.h"
#import "VBAnimator.h"

@interface ViewController () <VBAnimatorDelegate>
@property (nonatomic, retain) VBAnimator *vbAnamator;

@end

@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _vbAnamator = [VBAnimator new];
    _vbAnamator.delegate = self;
    NSArray *names = [VBAnimator arrayWithNumberedNames:@"name_images"
                                                              rangeStart:1
                                                                rangeEnd:100
                                                            suffixFormat:@"%03i.png"];
    NSArray *URLs = [VBAnimator arrayWithResourcePrefixedURLs:names];
    
    _vbAnamator.animationSize = CGSizeMake(320, 480);
    _vbAnamator.animationOrientation = UIImageOrientationUp;
    _vbAnamator.animationFrameDuration = 23.0/110.0;
    _vbAnamator.animationURLs = URLs;
    _vbAnamator.animationRepeatCount = 0;
    _vbAnamator.animationAudioURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"name_audio"] ofType:@"mp3"]];
    _vbAnamator.animationAudioVolume = 0.3;
    _vbAnamator.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_vbAnamator.view];
    
    _vbAnamator.view.frame = CGRectMake(0, 0, 320, 480);
    //animatorViewController.view.backgroundColor = [UIColor orangeColor];
    _vbAnamator.view.clipsToBounds = YES;
    
    [_vbAnamator startAnimating];
}

-(void)vbAnimatorDidStart
{
    NSLog( @"AnimatorDidStart" );
}

-(void)vbAnimatorDidStop
{
    if (self.vbAnamator.animationRepeatCount == 0) {
        [_vbAnamator stopAnimating];
    }
    NSLog( @"AnimatorDidStop" );
}

@end
