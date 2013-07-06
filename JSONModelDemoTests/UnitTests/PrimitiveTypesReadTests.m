//
//  PrimitiveTypesReadTests.m
//  JSONModelDemo
//
//  Created by Marin Todorov on 02/12/2012.
//  Copyright (c) 2012 Underplot ltd. All rights reserved.
//

#import "PrimitiveTypesReadTests.h"
#import "PrimitivesModel.h"
#import "EnumModel.h"

@implementation PrimitiveTypesReadTests

-(void)testPrimitiveTypes
{
    PrimitivesModel* p;

    NSString* filePath = [[NSBundle bundleForClass:[JSONModel class]].resourcePath stringByAppendingPathComponent:@"primitives.json"];
    NSString* jsonContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    NSAssert(jsonContents, @"Can't fetch test data file contents. %@", filePath);
    
    NSError* err;
    p = [[PrimitivesModel alloc] initWithString: jsonContents error:&err];
    NSAssert(!err, [err localizedDescription]);
    
    NSAssert(p, @"Could not load the test data file. %@", filePath);

    [self validateLoadedPrimitives:p];
}

-(void)testPrimitiveTypesPlist
{
    PrimitivesModel* p;
    
    NSString* filePath = [[NSBundle bundleForClass:[JSONModel class]].resourcePath stringByAppendingPathComponent:@"primitives.plist"];
    NSString* jsonContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    NSAssert(jsonContents, @"Can't fetch test data file contents. %@", filePath);
    
    NSDictionary * sourceDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSAssert(sourceDict, @"Couldn't convert plist into dictionary (%@)", filePath);
    
    NSError* err;
    p = [[PrimitivesModel alloc] initWithDictionary:sourceDict error:&err];
    NSAssert(!err, [err localizedDescription]);
    
    NSAssert(p, @"Could not load the test data file. %@", filePath);
    
    [self validateLoadedPrimitives:p];
    
    // test round trip
    NSDictionary * generatedDict =  [p toDictionary];
    NSAssert(generatedDict, @"toDictionary returned nil");
    
    // this won't work until toDictionary is modified to specifically use numberWithBOOL for boolean primitives
    //STAssertEqualObjects(generatedDict, sourceDict, @"dictionary generated by toDictionary doesn't match source dictionary");
    
    // instead, manually checking contents to ignore the number vs. bool difference for now
    
    STAssertEqualObjects(generatedDict[@"shortNumber"], [NSNumber numberWithInteger:114], @"shortNumber toDictionary fail");
    STAssertEqualObjects(generatedDict[@"intNumber"], [NSNumber numberWithInteger:12], @"intNumber toDictionary fail");
    STAssertEqualObjects(generatedDict[@"longNumber"], [NSNumber numberWithInteger:12124], @"longNumber toDictionary fail");
    
    STAssertEqualsWithAccuracy([generatedDict[@"floatNumber"] doubleValue], 12.12, FLT_EPSILON, @"floatNumber toDictionary fail");
    STAssertEqualsWithAccuracy([generatedDict[@"doubleNumber"] doubleValue], 121231312.124, DBL_EPSILON, @"doubleNumber toDictionary fail");
    
    STAssertEqualObjects(generatedDict[@"boolNO"], [NSNumber numberWithBool:NO], @"boolNO toDictionary fail");
    STAssertEqualObjects(generatedDict[@"boolYES"], [NSNumber numberWithBool:YES], @"boolYES toDictionary fail");

}

- (void)validateLoadedPrimitives:(PrimitivesModel *)p
{
    NSAssert(p.shortNumber==114, @"shortNumber read fail");
    NSAssert(p.intNumber==12, @"intNumber read fail");
    NSAssert(p.longNumber==12124, @"longNumber read fail");
    
    NSAssert(fabsf(p.floatNumber-12.12)<FLT_EPSILON, @"floatNumber read fail");
    NSAssert(fabs(p.doubleNumber-121231312.124)<DBL_EPSILON, @"doubleNumber read fail");
    
    
    NSAssert(p.boolNO==NO, @"boolNO read fail");
    NSAssert(p.boolYES==YES, @"boolYES read fail");
}

-(void)testEnumerationTypes
{
    NSString* jsonContents = @"{\"statusString\":\"open\",\"nsStatus\":\"closed\",\"nsuStatus\":\"open\"}";
    
    NSError* err1;
    EnumModel* p1 = [[EnumModel alloc] initWithString: jsonContents error:&err1];
    NSAssert(!err1, [err1 localizedDescription]);
    
    NSAssert(p1, @"Could not read input json text");
    
    NSAssert(p1.status==StatusOpen, @"Status is not StatusOpen");
    NSAssert(p1.nsStatus==NSE_StatusClosed, @"nsStatus is not NSE_StatusClosed");
    NSAssert(p1.nsuStatus==NSEU_StatusOpen, @"nsuStatus is not NSEU_StatusOpen");

    NSAssert([[p1 toJSONString] isEqualToString: jsonContents], @"Exporting enum value didn't work out");
    
}

@end
