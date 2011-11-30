//
//  SharedStore.m
//  YouSpin
//
//  Created by nepal on 10/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SharedStore.h"

@implementation SharedStore
static SharedStore* _store = nil;

@synthesize backColorForViews;
@synthesize navigationBarColor;
@synthesize districtArray;
@synthesize complainTypeArray;
@synthesize districtName;
@synthesize districtCode;
@synthesize complainTypeTitle;
@synthesize complainTypeCode;
@synthesize districtTableIndex;
@synthesize complainTypeTableIndex;


+(SharedStore*)store
{
	@synchronized([SharedStore class])
	{
		if (!_store)
			[[self alloc] init];
		return _store;
	}
	
	return nil;
}

+(id)alloc
{
	@synchronized([SharedStore class])
	{
		NSAssert(_store == nil, @"Attempted to allocate a second instance of a singleton.");
		_store = [super alloc];
		return _store;
	}
	
	return nil;
}

- (id)init
{
    self = [super init];
    if (self != nil) {
        // Initialization code here.
		self.backColorForViews = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
		self.navigationBarColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.5];
        self.districtArray = [[NSMutableArray alloc] init];
        self.complainTypeArray = [[NSMutableArray alloc] init];
        self.districtName = [[NSString alloc] init];
        self.districtCode = [[NSString alloc] init];
        self.complainTypeTitle = [[NSString alloc] init];
        self.complainTypeCode = [[NSString alloc] init];
        districtName = @"";
        districtCode = @"";
        complainTypeTitle = @"";
        complainTypeCode = @"";
        districtTableIndex = -1;
        complainTypeTableIndex = -1;
    }
    
    return self;
}

@end
