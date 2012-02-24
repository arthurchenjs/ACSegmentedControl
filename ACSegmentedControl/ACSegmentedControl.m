//
//  ACSegmentedControl.m
//  ACSegmentedControl
//
//  Created by Cedric Vandendriessche on 10/11/10.
//  Copyright 2010 FreshCreations. All rights reserved.
//
//	Modify by chenjianshe

#import "ACSegmentedControl.h"

#define ACSegmentedControlHeight 29.0 // the height of the control. Change this if you're making controls of a different height
#define ACSegmentedControlWidth 75.0

@interface ACSegmentedControl ()

@property (nonatomic, retain) NSMutableArray *segments; // at least two (2) NSStrings are needed for a ACSegmentedControl to be displayed
@property (nonatomic, retain) UIImage *normalImageLeft;
@property (nonatomic, retain) UIImage *normalImageMiddle;
@property (nonatomic, retain) UIImage *normalImageRight;
@property (nonatomic, retain) UIImage *selectedImageLeft;
@property (nonatomic, retain) UIImage *selectedImageMiddle;
@property (nonatomic, retain) UIImage *selectedImageRight;
@property (nonatomic, retain) UIImage *unifiedBackgroundImage;
@property (nonatomic, retain) UIImage *unifiedSelectedImage;

- (void)updateUI;
- (void)deselectAllSegments;
- (void)insertSegmentWithObject:(NSObject *)object atIndex:(NSUInteger)index;
- (void)setObject:(NSObject *)object forSegmentAtIndex:(NSUInteger)index;
- (void)releaseStandImageResource;

@end

@implementation ACSegmentedControl

@synthesize segments, numberOfSegments, selectedSegmentIndex, momentary;
@synthesize normalImageLeft, normalImageMiddle, normalImageRight, selectedImageLeft, selectedImageMiddle, selectedImageRight;
@synthesize isNavigationTitleView, segmentedControlStyle, unifiedBackgroundImage, unifiedSelectedImage;

#pragma mark -
#pragma mark Initializer
- (NSString*)getImagePathStringForKey:(NSString*)key fromDictionary:(NSDictionary*)dictionary
{
	return [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",[dictionary objectForKey:key]]];
}

- (void)setupBaseInfoFromPlist
{
	[self releaseStandImageResource];
	NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"ACSegmentedControl.bundle/ACSegmentedControl.plist"]];
	NSDictionary *unifiedDict = [dictionary objectForKey:@"StyleUnified"];
	NSDictionary *tripleDict = [dictionary objectForKey:@"StyleTriple"];
	
	normalImageLeft = [[UIImage imageWithContentsOfFile:[self getImagePathStringForKey:@"normalImageLeft" fromDictionary:tripleDict]] retain];
	normalImageMiddle = [[UIImage imageWithContentsOfFile:[self getImagePathStringForKey:@"normalImageMiddle" fromDictionary:tripleDict]] retain];
	normalImageRight= [[UIImage imageWithContentsOfFile:[self getImagePathStringForKey:@"normalImageRight" fromDictionary:tripleDict]] retain];
	selectedImageLeft = [[UIImage imageWithContentsOfFile:[self getImagePathStringForKey:@"selectedImageLeft" fromDictionary:tripleDict]] retain];
	selectedImageMiddle = [[UIImage imageWithContentsOfFile:[self getImagePathStringForKey:@"selectedImageMiddle" fromDictionary:tripleDict]] retain];
	selectedImageRight = [[UIImage imageWithContentsOfFile:[self getImagePathStringForKey:@"selectedImageRight" fromDictionary:tripleDict]] retain];

	unifiedBackgroundImage = [[UIImage imageWithContentsOfFile:[self getImagePathStringForKey:@"unifiedBackgroundImage" fromDictionary:unifiedDict]] retain];
	unifiedSelectedImage = [[UIImage imageWithContentsOfFile:[self getImagePathStringForKey:@"unifiedSelectedImage" fromDictionary:unifiedDict]] retain];
}

- (id)initWithFrame:(CGRect)frame {
    if((self = [super initWithFrame:frame])) {		
		self.backgroundColor = [UIColor clearColor];
		[self setupBaseInfoFromPlist];
		selectedSegmentIndex = ACSegmentedControlNoSegment;
		segmentedControlStyle = ACSegmentedControlStyleTriple;
		momentary = NO;
    }
    return self;
}

- (id)initWithItems:(NSArray *)items {
    if((self = [super init])) {
		self.backgroundColor = [UIColor clearColor];
		[self setupBaseInfoFromPlist];
		selectedSegmentIndex = ACSegmentedControlNoSegment;
		segmentedControlStyle = ACSegmentedControlStyleTriple;
		momentary = NO;
		self.segments = [NSMutableArray arrayWithArray:items];
		self.frame = CGRectMake(0, 0, [segments count]*ACSegmentedControlWidth, ACSegmentedControlHeight);
    }
    return self;
}

#pragma mark -
#pragma mark initWithCoder for IB support

- (id)initWithCoder:(NSCoder *)decoder {
    if(self == [super initWithCoder:decoder]) {
		self.backgroundColor = [UIColor clearColor];
		[self setupBaseInfoFromPlist];
		selectedSegmentIndex = ACSegmentedControlNoSegment;
		segmentedControlStyle = ACSegmentedControlStyleTriple;
		momentary = NO;
		self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, ACSegmentedControlHeight);
	}
	
    return self;
}

#pragma mark -

- (void)updateUI {
	/*
	 Remove every UIButton from screen
	 */
	[[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
	
	/*
	 We're only displaying this element if there are at least two buttons
	 */
	if([segments count] > 1)
	{
		numberOfSegments = [segments count];
		int indexOfObject = 0;
		
		float segmentWidth = (float)self.frame.size.width / numberOfSegments;
		float lastX = 0.0;
		
		for(NSObject *object in segments)
		{
			/*
			 Calculate the frame for the current segment
			 */
			int currentSegmentWidth; 
			
			if(indexOfObject < numberOfSegments - 1)
				currentSegmentWidth = round(lastX + segmentWidth) - round(lastX) + 1;
			else
				currentSegmentWidth = round(lastX + segmentWidth) - round(lastX);
			
			CGRect segmentFrame = CGRectMake(round(lastX), 0, currentSegmentWidth, self.frame.size.height);
			lastX += segmentWidth;
			
			/*
			 Give every button the background image it needs for its current state
			 */
			UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
			if (segmentedControlStyle == ACSegmentedControlStyleTriple) {
				if(selectedSegmentIndex == indexOfObject){
					if (indexOfObject == 0) {
						[button setBackgroundImage:[selectedImageLeft stretchableImageWithLeftCapWidth:selectedImageLeft.size.width/2 topCapHeight:0] forState:UIControlStateNormal];
					}
					else if (indexOfObject == numberOfSegments - 1){
						[button setBackgroundImage:[selectedImageRight stretchableImageWithLeftCapWidth:selectedImageRight.size.width/2 topCapHeight:0] forState:UIControlStateNormal];	
					}
					else {
						[button setBackgroundImage:[selectedImageMiddle stretchableImageWithLeftCapWidth:selectedImageMiddle.size.width/2 topCapHeight:0] forState:UIControlStateNormal];
					}
					
					[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
				}
				else {
					if (indexOfObject == 0) {
						[button setBackgroundImage:[normalImageLeft stretchableImageWithLeftCapWidth:normalImageLeft.size.width/2 topCapHeight:0] forState:UIControlStateNormal];
					}
					else if (indexOfObject == numberOfSegments - 1){
						[button setBackgroundImage:[normalImageRight stretchableImageWithLeftCapWidth:normalImageRight.size.width/2 topCapHeight:0] forState:UIControlStateNormal];
					}
					else {
						[button setBackgroundImage:[normalImageMiddle stretchableImageWithLeftCapWidth:normalImageMiddle.size.width/2 topCapHeight:0] forState:UIControlStateNormal];
					}
					
					[button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
				}		
			}
			else if (segmentedControlStyle == ACSegmentedControlStyleUnified) {
				UIImageView *bgView = [[UIImageView alloc] initWithImage:[unifiedBackgroundImage stretchableImageWithLeftCapWidth:normalImageMiddle.size.width/2 topCapHeight:0]];
				bgView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
				[self addSubview:bgView];
				[self sendSubviewToBack:bgView];
				[bgView release];
				if (selectedSegmentIndex == indexOfObject) {
					[button setBackgroundImage:[unifiedSelectedImage stretchableImageWithLeftCapWidth:unifiedSelectedImage.size.width/2 topCapHeight:0] forState:UIControlStateNormal];
					[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
				}
				else {		
					[button setBackgroundImage:nil forState:UIControlStateNormal];
					[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
				}
			}
						
			button.frame = segmentFrame;
			button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
			button.titleLabel.shadowOffset = CGSizeMake(0, -1);
			button.tag = indexOfObject + 1;
			button.adjustsImageWhenHighlighted = NO;
			
			/*
			 Check if we're dealing with a string or an image
			 */
			if([object isKindOfClass:[NSString class]])
			{
				[button setTitle:(NSString *)object forState:UIControlStateNormal];
			}
			else if([object isKindOfClass:[UIImage class]])
			{
				[button setImage:(UIImage *)object forState:UIControlStateNormal];
			}
			
			[button addTarget:self action:@selector(segmentTapped:) forControlEvents:UIControlEventTouchDown];
			[self addSubview:button];
			
			++indexOfObject;
		}
		
		/*
		 Make sure the selected segment shows both its separators
		 */
		[self bringSubviewToFront:[self viewWithTag:selectedSegmentIndex + 1]];
	}
}

- (void)deselectAllSegments {
	/*
	 Deselects all segments
	 */
	for(UIView *subview in self.subviews)
	{
		if ([subview isKindOfClass:[UIButton class]]) {
			UIButton *button = (UIButton*)subview;
			if (segmentedControlStyle == ACSegmentedControlStyleTriple) {
				if(button.tag == 1)
				{
					[button setBackgroundImage:[normalImageLeft stretchableImageWithLeftCapWidth:normalImageLeft.size.width/2 topCapHeight:0] forState:UIControlStateNormal];
				}
				else if(button.tag == numberOfSegments)
				{
					[button setBackgroundImage:[normalImageRight stretchableImageWithLeftCapWidth:normalImageRight.size.width/2 topCapHeight:0] forState:UIControlStateNormal];
				}
				else
				{
					[button setBackgroundImage:[normalImageMiddle stretchableImageWithLeftCapWidth:normalImageMiddle.size.width/2 topCapHeight:0] forState:UIControlStateNormal];
				}				
				[button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
			}
			else if (segmentedControlStyle == ACSegmentedControlStyleUnified) {
				[button setBackgroundImage:nil forState:UIControlStateNormal];
				[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
			}
		}
	}
}

- (void)resetSegments {
	/*
	 Reset the index and send the action
	 */
	selectedSegmentIndex = ACSegmentedControlNoSegment;
	[self sendActionsForControlEvents:UIControlEventValueChanged];
	
	[self updateUI];
}

- (void)segmentTapped:(id)sender {
	[self deselectAllSegments];
	
	/*
	 Send the action
	 */
	UIButton *button = sender;
	[self bringSubviewToFront:button];
	
	if(selectedSegmentIndex != button.tag - 1 || programmaticIndexChange)
	{
		selectedSegmentIndex = button.tag - 1;
		programmaticIndexChange = NO;
		[self sendActionsForControlEvents:UIControlEventValueChanged];
	}
	
	/*
	 Give the tapped segment the selected look
	 */
	if (segmentedControlStyle == ACSegmentedControlStyleTriple) {
		if(button.tag == 1)
		{
			[button setBackgroundImage:[selectedImageLeft stretchableImageWithLeftCapWidth:selectedImageLeft.size.width/2 topCapHeight:0] forState:UIControlStateNormal];
		}
		else if(button.tag == numberOfSegments)
		{
			[button setBackgroundImage:[selectedImageRight stretchableImageWithLeftCapWidth:selectedImageRight.size.width/2 topCapHeight:0] forState:UIControlStateNormal];
		}
		else
		{
			[button setBackgroundImage:[selectedImageMiddle stretchableImageWithLeftCapWidth:selectedImageMiddle.size.width/2 topCapHeight:0] forState:UIControlStateNormal];
		}
		[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	}
	else if (segmentedControlStyle == ACSegmentedControlStyleUnified) {
		[button setBackgroundImage:[unifiedSelectedImage stretchableImageWithLeftCapWidth:unifiedSelectedImage.size.width/2 topCapHeight:0] forState:UIControlStateNormal];
		[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	}

	if(momentary)
		[self performSelector:@selector(deselectAllSegments) withObject:nil afterDelay:0.2];
}

#pragma mark -
#pragma mark Manipulation methods

- (void)insertSegmentWithObject:(NSObject *)object atIndex:(NSUInteger)index {
	/*
	 Making sure we don't call out of bounds
	 */
	if(index <= numberOfSegments && index >= 0)
	{
		[segments insertObject:object atIndex:index];
		[self resetSegments];
	}
}

- (void)setObject:(NSObject *)object forSegmentAtIndex:(NSUInteger)index {
	/*
	 Making sure we don't call out of bounds
	 */
	if(index < numberOfSegments && index >= 0)
	{
		[segments replaceObjectAtIndex:index withObject:object];
		[self resetSegments];
	}
}

#pragma mark -

- (void)insertSegmentWithTitle:(NSString *)title atIndex:(NSUInteger)index {
	[self insertSegmentWithObject:title atIndex:index];	
}

- (void)insertSegmentWithImage:(NSString *)image atIndex:(NSUInteger)index {
	[self insertSegmentWithObject:image atIndex:index];		
}

- (void)removeSegmentAtIndex:(NSUInteger)index {
	/*
	 Making sure we don't call out of bounds
	 If you delete a segment when only having two segments, the control won't be shown anymore
	 */
	if(index < numberOfSegments && index >= 0)
	{
		[segments removeObjectAtIndex:index];
		[self resetSegments];
	}
}

- (void)removeAllSegments {
	[segments removeAllObjects];
	
	selectedSegmentIndex = ACSegmentedControlNoSegment;
	[self updateUI];
}

- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)index {
	[self setObject:title forSegmentAtIndex:index];
}

- (void)setImage:(NSString *)image forSegmentAtIndex:(NSUInteger)index {
	[self setObject:image forSegmentAtIndex:index];
}

#pragma mark -
#pragma mark Getters

- (NSString *)titleForSegmentAtIndex:(NSUInteger)index {
	if(index < [segments count])
	{
		if([[segments objectAtIndex:index] isKindOfClass:[NSString class]])
		{
			return [segments objectAtIndex:index];
		}
	}
	
	return nil;
}

- (UIImage *)imageForSegmentAtIndex:(NSUInteger)index {
	if(index < [segments count])
	{
		if([[segments objectAtIndex:index] isKindOfClass:[UIImage class]])
		{
			return [segments objectAtIndex:index];
		}
	}
	
	return nil;
}

#pragma -
#pragma mark Setters

- (void)setSegments:(NSMutableArray *)array {
	if(array != segments)
	{
		[segments release];
		segments = [array retain];
	
		[self resetSegments];
	}
}

- (BOOL)isIpadDevice
{
	return [[[UIDevice currentDevice] model] hasPrefix:@"iPad"] && (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom);
}

- (void)setIsNavigationTitleView:(BOOL)isTitleView {
	if (isTitleView) {
		CGRect rect = self.frame;
		if (![self isIpadDevice] && UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
			self.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 23);
		}
	}
}

- (void)setSegmentedControlStyle:(ACSegmentedControlStyle)style
{
	if (style != self.segmentedControlStyle) 
		segmentedControlStyle = style;
		[self updateUI];
}

- (void)setSelectedSegmentIndex:(NSInteger)index {
	if(index != selectedSegmentIndex)
	{
		selectedSegmentIndex = index;
		programmaticIndexChange = YES;
		
		if(index >= 0 && index < numberOfSegments)
		{
			UIButton *button = (UIButton *)[self viewWithTag:index + 1];
			[self segmentTapped:button];
		}
	}
}

- (void)setFrame:(CGRect)rect {
	[super setFrame:rect];
	[self updateUI];
}

#pragma mark -
#pragma mark Image setters

- (void)setNormalImageLeft:(UIImage *)image {
	if(image != normalImageLeft)
	{
		[normalImageLeft release];
		normalImageLeft = [image retain];
	
		[self updateUI];
	}
}

- (void)setNormalImageMiddle:(UIImage *)image {
	if(image != normalImageMiddle)
	{
		[normalImageMiddle release];
		normalImageMiddle = [image retain];
	
		[self updateUI];
	}
}

- (void)setNormalImageRight:(UIImage *)image {
	if(image != normalImageRight)
	{
		[normalImageRight release];
		normalImageRight = [image retain];
	
		[self updateUI];
	}
}

- (void)setSelectedImageLeft:(UIImage *)image {
	if(image != selectedImageLeft)
	{
		[selectedImageLeft release];
		selectedImageLeft = [image retain];
	
		[self updateUI];
	}
}

- (void)setSelectedImageMiddle:(UIImage *)image {
	if(image != selectedImageMiddle)
	{
		[selectedImageMiddle release];
		selectedImageMiddle = [image retain];
	
		[self updateUI];
	}
}

- (void)setSelectedImageRight:(UIImage *)image {
	if(image != selectedImageRight)
	{
		[selectedImageRight release];
		selectedImageRight = [image retain];
	
		[self updateUI];
	}
}

- (void)setUnifiedBackgroundImage:(UIImage *)image {
	if(image != unifiedBackgroundImage)
	{
		[unifiedBackgroundImage release];
		unifiedBackgroundImage = [image retain];
		
		[self updateUI];
	}
}

- (void)setUnifiedSelectedImage:(UIImage *)image {
	if(image != unifiedSelectedImage)
	{
		[unifiedSelectedImage release];
		unifiedSelectedImage = [image retain];
		
		[self updateUI];
	}
}

#pragma mark -
- (void)releaseStandImageResource
{
	[normalImageLeft release];
	[normalImageMiddle release];
	[normalImageRight release];
	[selectedImageLeft release];
	[selectedImageMiddle release];
	[selectedImageRight release];
	[unifiedSelectedImage release];
	[unifiedBackgroundImage release];
}

- (void)dealloc {
	[segments release];
	[self releaseStandImageResource];
	[super dealloc];
}

@end
