//
//  SOServiceDetailViewController.m
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

#import <AFNetworking/UIImageView+AFNetworking.h>

#import "SOServiceDetailViewController.h"
#import "SOHTTPRequestOperationManager.h"
#import "SOServiceDetailTableViewCell.h"

static NSString * const kSOServiceDetailCellIdentifier = @"SOServiceDetailCellIdentifier";

@interface SOServiceDetailViewController ()

@property (nonatomic, strong) NSMutableDictionary *service;

@end

@implementation SOServiceDetailViewController

- (instancetype)initWithService:(NSDictionary *)service
{
    self = [super init];
    if (self)
    {
        _service = [service mutableCopy];
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = _service[@"title"];
    self.view.backgroundColor = [UIColor whiteColor];

    [self.tableView registerClass:[SOServiceDetailTableViewCell class] forCellReuseIdentifier:@"SOServiceDetailCell"];

    [self flattenServiceDictionary];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Data Flattening

/**
 *  The JSON returned from the server can contain arrays and lists, so in order for it to be displayed
 *  correctly in the table view, it needs to be flattened into a single dictionary
 *
 *  Probably could have devised a much nicer solution if I had time but they dont call it a hackathon 
 *  for nothing
 */

NS_INLINE void addDict(__strong NSMutableDictionary **service, NSDictionary *dict, NSString *originalKey)
{
    for (id key in dict)
    {
        id object = dict[key];

        if ([object isKindOfClass:[NSDictionary class]])
        {
            addDict(service, object, key);
        }
        else if ([object isKindOfClass:[NSArray class]])
        {
            addArray(service, object, [NSString stringWithFormat:@"%@-%@", originalKey, key]);
        }
        else
        {
            (*service)[key] = object;
        }
    }

    [*service removeObjectForKey:originalKey];
}

NS_INLINE void addArray(__strong NSMutableDictionary **service, NSArray *array, NSString *originalKey)
{
    for (int i = 0; i < array.count; i++)
    {
        id object = array[i];
        NSString *key = [NSString stringWithFormat:@"%@-%d", originalKey, i];

        if ([object isKindOfClass:[NSDictionary class]])
        {
            addDict(service, object, key);
        }
        else if ([object isKindOfClass:[NSArray class]])
        {
            addArray(service, object, key);
        }
        else
        {
            (*service)[key] = object;
        }
    }

    [*service removeObjectForKey:[[originalKey componentsSeparatedByString:@"-"] lastObject]];
}

- (void)flattenServiceDictionary
{
    for (id key in _service.allKeys)
    {
        id object = _service[key];

        if ([object isKindOfClass:[NSDictionary class]])
        {
            addDict(&_service, object, key);
        }
        else if ([object isKindOfClass:[NSArray class]])
        {
            addArray(&_service, object, key);
        }
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_service allKeys].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SOServiceDetailCell" forIndexPath:indexPath];

    NSString *key = [_service allKeys][indexPath.row];
    cell.textLabel.text = key;

    cell.detailTextLabel.text = [_service[key] description];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
