//
//  VBAnimator.m
//  VBAnimator
//
//  Created by bespalown on 26/01/14.
//  Copyright (c) 2014 bespalown@gmail.com. All rights reserved.
//

#import "VBAnimator.h"

@implementation VBAnimator

@synthesize animationURLs, animationFrameDuration, animationNumFrames, animationRepeatCount,
imageView, animationData, animationTimer, animationStep, animationDuration, animationOrientation, animationSize;
@synthesize animationAudioURL, avAudioPlayer, animationAudioVolume;
@synthesize contentMode;
@synthesize delegate;

- (void)dealloc {
	// This object can't be deallocated while animating, this could
	// only happen if user code incorrectly dropped the last ref.

    NSAssert([self isAnimating] == FALSE, @"dealloc while still animating");

    self.animationURLs = nil;
    self.imageView = nil;
    self.animationData = nil;
    self.animationTimer = nil;
    self.delegate = nil;
    self = nil;
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.

- (void)loadView {
	UIView *myView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, animationSize.width, animationSize.width)];
	[myView autorelease];
	self.view = myView;
    isTouchEnabled = NO;

	// FIXME: Additional Supported Orientations
	if (animationOrientation == UIImageOrientationUp) {
		// No-op
	} else if (animationOrientation == UIImageOrientationLeft) {
		// 90 deg CCW
		[self rotateToLandscape];
	} else if (animationOrientation == UIImageOrientationRight) {
		// 90 deg CW
		[self rotateToLandscapeRight];		
	} else {
		NSAssert(FALSE,@"Unsupported animationOrientation");
	}

	// Foreground animation images
	UIImageView *myImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    myImageView.contentMode = contentMode;
	[myImageView autorelease];
	self.imageView = myImageView;

	// Animation data should have already been loaded into memory as a result of
	// setting the animationURLs property
	NSAssert(animationURLs, @"animationURLs was not defined");
	NSAssert([animationURLs count] > 1, @"animationURLs must include at least 2 urls");
	NSAssert(animationFrameDuration, @"animationFrameDuration was not defined");

	// Load animationData by reading from animationURLs
	NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithCapacity:[animationURLs count]];

	NSMutableArray *muArray = [NSMutableArray arrayWithCapacity:[animationURLs count]];
	for ( NSURL* aURL in animationURLs ) {
		NSString *urlKey = aURL.path;
		NSData *dataForKey = [dataDict objectForKey:urlKey];

		if (dataForKey == nil) {
			dataForKey = [NSData dataWithContentsOfURL:aURL];
			NSAssert(dataForKey, @"dataForKey");
			
			[dataDict setObject:dataForKey forKey:urlKey];
		}
		[muArray addObject:dataForKey];
	}
	self.animationData = [NSArray arrayWithArray:muArray];

	int numFrames = [animationURLs count];
	float duration = animationFrameDuration * numFrames;

	self->animationNumFrames = numFrames;
	self.animationDuration = duration;

	[self.view addSubview:imageView];

	// Display first frame of image animation

	self.animationStep = 0;
	[self animationShowFrame: animationStep];
	self.animationStep = animationStep + 1;
}

-(void)setAnimationAudioVolume:(CGFloat)volume
{
    if (animationAudioURL != nil) {
		AVAudioPlayer *avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:animationAudioURL error:nil];
        [avPlayer autorelease];
		NSAssert(avPlayer, @"AVAudioPlayer could not be allocated");
		self.avAudioPlayer = avPlayer;
        avAudioPlayer.volume = volume;
		[avAudioPlayer prepareToPlay];
	}
}

// Create an array of file/resource names with the given filename prefix,
// the file names will have an integer appended in the range indicated
// by the rangeStart and rangeEnd arguments. The suffixFormat argument
// is a format string like "%02i.png", it must format an integer value
// into a string that is appended to the file/resource string.
//
// For example: [createNumberedNames:@"Image" rangeStart:1 rangeEnd:3 rangeFormat:@"%02i.png"]
//
// returns: {"Image01.png", "Image02.png", "Image03.png"}

+ (NSArray*) arrayWithNumberedNames:(NSString*)filenamePrefix
							  rangeStart:(NSInteger)rangeStart
								rangeEnd:(NSInteger)rangeEnd
							 suffixFormat:(NSString*)suffixFormat
{
	NSMutableArray *numberedNames = [[NSMutableArray alloc] initWithCapacity:40];

	for (int i = rangeStart; i <= rangeEnd; i++) {
		NSString *suffix = [NSString stringWithFormat:suffixFormat, i];
		NSString *filename = [NSString stringWithFormat:@"%@%@", filenamePrefix, suffix];

		[numberedNames addObject:filename];
	}

	NSArray *newArray = [NSArray arrayWithArray:numberedNames];
	[numberedNames release];
	return newArray;
}

// Given an array of resource names (as returned by arrayWithNumberedNames)
// create a new array that contains these resource names prefixed as
// resource paths and wrapped in a NSURL object.

+ (NSArray*) arrayWithResourcePrefixedURLs:(NSArray*)inNumberedNames
{
	NSMutableArray *URLs = [[NSMutableArray alloc] initWithCapacity:[inNumberedNames count]];
	NSBundle* appBundle = [NSBundle mainBundle];

	for ( NSString* path in inNumberedNames ) {
		NSString* resPath = [appBundle pathForResource:path ofType:nil];
        NSURL* aURL = [NSURL fileURLWithPath:resPath];
		[URLs addObject:aURL];
	}
	NSArray *newArray = [NSArray arrayWithArray:URLs];
	[URLs release];
	return newArray;
}

- (void) rotateToPortrait
{
	float angle = 0;  //rotate 0°
	self.view.layer.transform = CATransform3DMakeRotation(angle, 0, 0.0, 1.0);
}

- (void) rotateToLandscape
{
	float angle = M_PI / 2;  //rotate CCW 90°, or π/2 radians
	self.view.layer.transform = CATransform3DMakeRotation(angle, 0, 0.0, 1.0);
}

- (void) rotateToLandscapeRight
{
	float angle = -1 * (M_PI / 2);  //rotate CW 90°, or -π/2 radians
	self.view.layer.transform = CATransform3DMakeRotation(angle, 0, 0.0, 1.0);
}

// Invoke this method to start the animation

- (void) startAnimating
{
	self.animationTimer = [NSTimer timerWithTimeInterval: animationFrameDuration
											 target: self
										   selector: @selector(animationTimerCallback:)
										   userInfo: NULL
											repeats: TRUE];

    [[NSRunLoop currentRunLoop] addTimer: animationTimer forMode: NSDefaultRunLoopMode];

	animationStep = 0;

	if (avAudioPlayer != nil)
		[avAudioPlayer play];

	// Call delegate method that regestered interest in a start action
    
    SEL selector = @selector(vbAnimatorDidStart);
	if (delegate && [delegate respondsToSelector:selector]) {
		[delegate performSelector:selector];
	}
}

// Invoke this method to stop the animation, note that this method must not
// invoke other methods and it must cancel any pending callbacks since
// it could be invoked in a low-memory situation or when the object
// is being deallocated. Invoking this method will not generate a
// animation stopped notification, that callback is only invoked when
// the animation reaches the end normally.

- (void) stopAnimating
{
	if (![self isAnimating])
		return;

	[animationTimer invalidate];
	self.animationTimer = nil;

	animationStep = animationNumFrames - 1;
	[self animationShowFrame: animationStep];

	if (avAudioPlayer != nil) {
		[avAudioPlayer stop];
		avAudioPlayer.currentTime = 0.0;
		self->lastReportedTime = 0.0;
	}

	// Call delegate method that regestered interest in a stop action
    SEL selector = @selector(vbAnimatorDidStop);
	if (delegate && [delegate respondsToSelector:selector]) {
		[delegate performSelector:selector];
	}
}

- (BOOL) isAnimating
{
	return (animationTimer != nil);
}

// Invoked at framerate interval to implement the animation

- (void) animationTimerCallback: (NSTimer *)timer {
	if (![self isAnimating])
		return;

    self.animationStep += 1;
	[self animationShowFrame: animationStep];

	if (animationStep >= animationNumFrames) {
		[self stopAnimating];
		// Continue to loop animation until loop counter reaches 0

		if (animationRepeatCount > 0) {
			self.animationRepeatCount = animationRepeatCount - 1;
			[self startAnimating];
		}
	}
}

// Display the given animation frame, in the range [1 to N]
// where N is the largest frame number.

- (void) animationShowFrame: (NSInteger) frame {
	if ((frame >= animationNumFrames) || (frame < 0))
		return;
	
	NSData *data = [animationData objectAtIndex:frame];
	UIImage *img = [UIImage imageWithData:data];
	imageView.image = img;
}

- (void) isTouchEnabled:(BOOL)touch
{
    isTouchEnabled = touch;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (isTouchEnabled) {
        if ([self isAnimating])
        {
            self.animationRepeatCount = 0;
            [self stopAnimating];
        }
        else
            [self startAnimating];
    }
}

@end
