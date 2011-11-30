//
//  SharedStore.h
//  YouSpin
//
//  Created by nepal on 10/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SERVER_STRING @"http://apps.mobilenepal.net"
#define STATUS_REPORTED @"reported" 
#define STATUS_UNREPORTED @"unreported" 

@interface SharedStore : NSObject{
	UIColor *backColorForViews;
    UIColor *navigationBarColor;
    
    NSMutableArray *districtArray;
    NSMutableArray *complainTypeArray;
    
    NSString *districtName;
    NSString *districtCode;
    NSString *complainTypeTitle;
    NSString *complainTypeCode;
    
    NSInteger districtTableIndex;
    NSInteger complainTypeTableIndex;
}
+(SharedStore*)store;

//---------  PROPERTIES ---------
@property (nonatomic, retain) UIColor *backColorForViews;
@property (nonatomic, retain) UIColor *navigationBarColor;
@property (nonatomic, retain) NSMutableArray *districtArray;
@property (nonatomic, retain) NSMutableArray *complainTypeArray;
@property(nonatomic,retain) NSString *districtName;
@property(nonatomic,retain) NSString *districtCode;
@property(nonatomic,retain) NSString *complainTypeTitle;
@property(nonatomic,retain) NSString *complainTypeCode;
@property(nonatomic, assign) NSInteger districtTableIndex;
@property(nonatomic, assign) NSInteger complainTypeTableIndex;



//---------  CUSTOM METHODS ---------


@end
