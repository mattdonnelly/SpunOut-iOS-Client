//
//  SOHelpAPI.m
//
//  Created by Matt Donnelly on 05/10/2013.
//  Copyright (c) 2013 SpunOut.ie (http://spunout.ie)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "SOHTTPRequestOperationManager.h"

#define BASE_URL @"http://www.whoismytd.com/v1"

#define SOSuccessBlockWithJSONOperation                                            \
    ^(AFHTTPRequestOperation *operation, id responseObject) {                      \
        if (success) success((AFHTTPRequestOperation *)operation, responseObject); \
    }

#define SOFailureBlockWithJSONOperation                                            \
    ^(AFHTTPRequestOperation *operation, NSError *error) {                         \
        if (failure) failure((AFHTTPRequestOperation *)operation, error);          \
    }

@implementation SOHTTPRequestOperationManager

+ (instancetype)manager
{
    static SOHTTPRequestOperationManager *sharedInstance;

    static dispatch_once_t once;
    dispatch_once(&once, ^ {
        sharedInstance = [[self alloc] init];
    });

    return sharedInstance;
}

- (instancetype)init
{
    NSURL *baseURL = [NSURL URLWithString:BASE_URL];
    self = [super initWithBaseURL:baseURL];
    if (self)
    {
        self.shouldUseCredentialStorage = NO;
    }

    return self;
}

#pragma mark - Categories

- (void)getCategoriesWithSuccess:(SOHTTPRequestSuccess)success
                         failure:(SOHTTPRequestFailure)failure
{
    [self GET:@"categories"
   parameters:nil
      success:SOSuccessBlockWithJSONOperation
      failure:SOFailureBlockWithJSONOperation];
}

- (void)searchCategoriesWithQuery:(NSString *)query
                          success:(SOHTTPRequestSuccess)success
                          failure:(SOHTTPRequestFailure)failure
{
    NSParameterAssert(query);

    [self GET:[NSString stringWithFormat:@"categories/search/%@", query]
   parameters:@{@"page": @(1)}
      success:SOSuccessBlockWithJSONOperation
      failure:SOFailureBlockWithJSONOperation];
}

#pragma mark - Sevices

- (void)getAllServicesWithSuccess:(SOHTTPRequestSuccess)success
                          failure:(SOHTTPRequestFailure)failure
{
    [self GET:@""
   parameters:nil
      success:SOSuccessBlockWithJSONOperation
      failure:SOFailureBlockWithJSONOperation];
}

- (void)getAllServicesAtPage:(NSInteger)page
					 success:(SOHTTPRequestSuccess)success
                     failure:(SOHTTPRequestFailure)failure
{
	[self GET:@""
   parameters:@{@"page": @(page)}
      success:SOSuccessBlockWithJSONOperation
      failure:SOFailureBlockWithJSONOperation];
}

- (void)getServicesInCategory:(NSString *)category
                      success:(SOHTTPRequestSuccess)success
                      failure:(SOHTTPRequestFailure)failure
{
    NSParameterAssert(category);

    [self GET:[NSString stringWithFormat:@"search/by_category/%@", category]
   parameters:nil
      success:SOSuccessBlockWithJSONOperation
      failure:SOFailureBlockWithJSONOperation];
}

- (void)getServiceWithID:(NSInteger)serviceID
                 success:(SOHTTPRequestSuccess)success
                 failure:(SOHTTPRequestFailure)failure
{
    [self GET:[NSString stringWithFormat:@"service/%d", serviceID]
   parameters:nil
      success:SOSuccessBlockWithJSONOperation
      failure:SOFailureBlockWithJSONOperation];
}

- (void)searchServicesWithQuery:(NSString *)query
                        success:(SOHTTPRequestSuccess)success
                        failure:(SOHTTPRequestFailure)failure
{
    NSParameterAssert(query);

    [self GET:[NSString stringWithFormat:@"search/%@", query]
   parameters:nil
      success:SOSuccessBlockWithJSONOperation
      failure:SOFailureBlockWithJSONOperation];
}

- (void)getServicesNearLatitude:(double)lat
                      longitude:(double)lon
                        success:(SOHTTPRequestSuccess)success
                        failure:(SOHTTPRequestFailure)failure
{
    [self GET:@"nearme"
   parameters:@{@"latitude": @(lat),
                @"longitude": @(lon)}
      success:SOSuccessBlockWithJSONOperation
      failure:SOFailureBlockWithJSONOperation];
}

- (void)getServicesNearLatitude:(double)lat
                      longitude:(double)lon
                      threshold:(NSInteger)threshold
                           unit:(NSString *)unit
                        success:(SOHTTPRequestSuccess)success
                        failure:(SOHTTPRequestFailure)failure
{
    NSParameterAssert([unit isEqualToString:@"miles"] || [unit isEqualToString:@"kms"]);

    [self GET:@"nearme"
   parameters:@{@"latitude": @(lat),
                @"longitude": @(lon),
                @"threshold": @(threshold),
                @"unit": unit}
      success:SOSuccessBlockWithJSONOperation
      failure:SOFailureBlockWithJSONOperation];
}

@end
