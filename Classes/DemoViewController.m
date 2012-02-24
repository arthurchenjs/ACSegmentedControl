//
//  DemoViewController.m
//  Demo
//
//  Created by chenjianshe on 12-2-22.
//  Copyright 2012 NetDragon WebSoft Inc. All rights reserved.
//

#import "DemoViewController.h"
#import "ACSegmentedControl.h"
@implementation DemoViewController



/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	ACSegmentedControl *segmentControl = [[ACSegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"A", @"b", nil]];
	[segmentControl addTarget:self action:@selector(switchSegmented:) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:segmentControl];
	[segmentControl release];
	
	ACSegmentedControl *segmentControlonNav = [[ACSegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"A", @"b", @"C", nil]];
	[segmentControlonNav addTarget:self action:@selector(switchSegmented:) forControlEvents:UIControlEventValueChanged];
	segmentControlonNav.isNavigationTitleView = YES;//will change the heigth when it is a navigation title view
	segmentControlonNav.frame = CGRectMake(50, 50, 200, 30);
	[self.view addSubview:segmentControlonNav];
	[segmentControlonNav release];
	
	ACSegmentedControl *segmentU = [[ACSegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"A", @"b", @"c", @"d", nil]];
	[segmentU addTarget:self action:@selector(switchSegmented:) forControlEvents:UIControlEventValueChanged];
	
	segmentU.frame = CGRectMake(20, 200, 300, 30);
	segmentU.segmentedControlStyle = ACSegmentedControlStyleUnified;
	segmentU.selectedSegmentIndex = 1;
	
	[self.view addSubview:segmentU];
	[segmentU release];
	
}

- (void)switchSegmented:(id)sender
{
	ACSegmentedControl *segment = (ACSegmentedControl*)sender;
	NSLog(@"segmentControl.selectedSegmentIndex:%d",segment.selectedSegmentIndex);
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
