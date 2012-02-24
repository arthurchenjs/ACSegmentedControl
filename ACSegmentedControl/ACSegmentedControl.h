//
//  ACSegmentedControl.h
//  ACSegmentedControl
//
//  Version: 1.0
//
//  Created by Cedric Vandendriessche on 10/11/10.
//  Copyright 2010 FreshCreations. All rights reserved.
//
//	Modify by chenjianshe
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    ACSegmentedControlStyleTriple,	// Left + Middle + Right
	ACSegmentedControlStyleUnified,	// Same BackgroundImage and SelectedImage  
} ACSegmentedControlStyle;

enum {
    ACSegmentedControlNoSegment = -1 // segment index for no selected segment
};

@interface ACSegmentedControl : UIControl {
	
	NSMutableArray *segments;
	UIImage *normalImageLeft;
	UIImage *normalImageMiddle;
	UIImage *normalImageRight;
	UIImage *selectedImageLeft;
	UIImage *selectedImageMiddle;
	UIImage *selectedImageRight;
	UIImage *unifiedBackgroundImage;
	UIImage *unifiedSelectedImage;
	
	ACSegmentedControlStyle segmentedControlStyle;
	NSUInteger numberOfSegments;
	NSInteger selectedSegmentIndex;
	BOOL programmaticIndexChange;
	BOOL momentary;
	BOOL isNavigationTitleView;	
}

- (id)initWithItems:(NSArray *)items; // items can be NSStrings or UIImages.

@property (nonatomic) ACSegmentedControlStyle segmentedControlStyle; // default is ACSegmentedControlStyleTriple
@property (nonatomic, retain, readonly) NSMutableArray *segments; // at least two (2) NSStrings are needed for a ACSegmentedControl to be displayed

@property (nonatomic, readonly) NSUInteger numberOfSegments;
@property (nonatomic, getter=isMomentary) BOOL momentary; // if set, then we don't keep showing selected state after tracking ends. default is NO

@property (nonatomic) NSInteger selectedSegmentIndex;
@property (nonatomic) BOOL isNavigationTitleView; // Just for auto resize the segment height when Device orientation is Landscape

- (void)insertSegmentWithTitle:(NSString *)title atIndex:(NSUInteger)index; // insert before segment number
- (void)insertSegmentWithImage:(NSString *)image atIndex:(NSUInteger)index;
- (void)removeSegmentAtIndex:(NSUInteger)index;
- (void)removeAllSegments;

- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)index;
- (NSString *)titleForSegmentAtIndex:(NSUInteger)index;

- (void)setImage:(NSString *)image forSegmentAtIndex:(NSUInteger)index;
- (UIImage *)imageForSegmentAtIndex:(NSUInteger)index;

@end