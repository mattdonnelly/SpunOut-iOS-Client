//
//  SOMasterViewController.m
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

#import "SOCategoriesViewController.h"

#import "SOServicesViewController.h"
#import "SOHTTPRequestOperationManager.h"

static NSString * const kSOCategoryCellIdentifier = @"SOCategoryCellIdentifier";

@interface SOCategoriesViewController ()

@property (nonatomic, strong) NSMutableArray *categories;

@end

@implementation SOCategoriesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Categories";

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kSOCategoryCellIdentifier];

    [[SOHTTPRequestOperationManager manager] getCategoriesWithSuccess:^(AFHTTPRequestOperation *operation, id response) {
        _categories = [NSMutableArray arrayWithObject:@"All Services"];
        [_categories addObjectsFromArray:response[@"categories"]];
        [self.tableView reloadData];
    }
                                                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                                                              }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSOCategoryCellIdentifier forIndexPath:indexPath];

    cell.textLabel.text = _categories[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    SOServicesViewController *servicesViewController = [[SOServicesViewController alloc] initWithCategory:_categories[indexPath.row]];
    [self.navigationController pushViewController:servicesViewController animated:YES];
}

@end
