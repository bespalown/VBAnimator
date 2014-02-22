//
//  VBAnimator.h
//  VBAnimator
//
//  Created by bespalown on 26/01/14.
//  Copyright (c) 2014 bespalown@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioPlayer.h>

#define VBAnimator15FPS (1.0/15)
#define VBAnimator12FPS (1.0/12)
#define VBAnimator10FPS (1.0/10)
#define VBAnimator5FPS (1.0/5)

@class VBAnimator;

@protocol VBAnimatorDelegate <NSObject>
@optional
-(void)vbAnimatorDidStart;
-(void)vbAnimatorDidStop;
@end

@interface VBAnimator : UIViewController {
    
@public
	NSArray *animationURLs;
	NSTimeInterval animationFrameDuration;
	NSInteger animationNumFrames;
	NSInteger animationRepeatCount;
	UIImageOrientation animationOrientation;
	NSURL *animationAudioURL;
    CGFloat animationAudioVolume;
    CGSize animationSize;

@private
	id <VBAnimatorDelegate> delegate;
    AVAudioPlayer *avAudioPlayer;
	UIImageView *imageView;
	NSArray *animationData;
	NSTimer *animationTimer;
	NSInteger animationStep;
	NSTimeInterval animationDuration;
	NSTimeInterval lastReportedTime;
}
@property (nonatomic, assign) id <VBAnimatorDelegate> delegate;

// public properties

@property (nonatomic, copy) NSArray *animationURLs;
@property (nonatomic, assign) NSTimeInterval animationFrameDuration;
@property (nonatomic, readonly) NSInteger animationNumFrames;
@property (nonatomic, assign) NSInteger animationRepeatCount;
@property (nonatomic, assign) UIImageOrientation animationOrientation;
@property (nonatomic, assign) UIViewContentMode contentMode;
@property (nonatomic, retain) NSURL *animationAudioURL;
@property (nonatomic, assign) CGFloat animationAudioVolume;
@property (nonatomic, assign) CGSize animationSize;

// private properties

@property (nonatomic, retain) AVAudioPlayer *avAudioPlayer;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, copy) NSArray *animationData;
@property (nonatomic, retain) NSTimer *animationTimer;
@property (nonatomic, assign) NSInteger animationStep;
@property (nonatomic, assign) NSTimeInterval animationDuration;

- (void) startAnimating;
- (void) stopAnimating;
- (BOOL) isAnimating;

- (void) animationShowFrame: (NSInteger) frame;

- (void) rotateToPortrait;
- (void) rotateToLandscape;
- (void) rotateToLandscapeRight;

+ (NSArray*) arrayWithNumberedNames:(NSString*)filenamePrefix
						 rangeStart:(NSInteger)rangeStart
						   rangeEnd:(NSInteger)rangeEnd
					   suffixFormat:(NSString*)suffixFormat;

+ (NSArray*) arrayWithResourcePrefixedURLs:(NSArray*)inNumberedNames;

@end
