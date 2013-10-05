//
//  SOHelpAPI.h
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

#import <AFNetworking/AFHTTPRequestOperationManager.h>

typedef void (^SOHTTPRequestSuccess)(AFHTTPRequestOperation *operation, id response);
typedef void (^SOHTTPRequestFailure)(AFHTTPRequestOperation *operation, NSError *error);

@interface SOHTTPRequestOperationManager : AFHTTPRequestOperationManager

#pragma mark - Categories

- (void)getCategoriesWithSuccess:(SOHTTPRequestSuccess)success
                         failure:(SOHTTPRequestFailure)failure;

- (void)searchCategoriesWithQuery:(NSString *)query
                          success:(SOHTTPRequestSuccess)success
                          failure:(SOHTTPRequestFailure)failure;

#pragma mark - Sevices

- (void)getAllServicesWithSuccess:(SOHTTPRequestSuccess)success
                          failure:(SOHTTPRequestFailure)failure;

- (void)getAllServicesAtPage:(NSInteger)page
                     success:(SOHTTPRequestSuccess)success
                     failure:(SOHTTPRequestFailure)failure;

- (void)getServicesInCategory:(NSString *)category
                      success:(SOHTTPRequestSuccess)success
                      failure:(SOHTTPRequestFailure)failure;

- (void)getServiceWithID:(NSInteger)serviceID
                 success:(SOHTTPRequestSuccess)success
                 failure:(SOHTTPRequestFailure)failure;

- (void)searchServicesWithQuery:(NSString *)query
                        success:(SOHTTPRequestSuccess)success
                        failure:(SOHTTPRequestFailure)failure;

#pragma mark - Near Me

- (void)getServicesNearLatitude:(double)lat
                      longitude:(double)lon
                        success:(SOHTTPRequestSuccess)success
                        failure:(SOHTTPRequestFailure)failure;

- (void)getServicesNearLatitude:(double)lat
                      longitude:(double)lon
                      threshold:(NSInteger)threshold
                           unit:(NSString *)unit
                        success:(SOHTTPRequestSuccess)success
                        failure:(SOHTTPRequestFailure)failure;

@end
