//
//  SOServicesViewController.m
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

#import "SOServicesViewController.h"

#import "SOHTTPRequestOperationManager.h"
#import "SOServiceDetailViewController.h"

static NSString * const kSOServiceCellIdentifier = @"SOServiceCellIdentifier";

@interface SOServicesViewController ()

@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSMutableArray *services;

@end

@implementation SOServicesViewController

- (instancetype)initWithCategory:(NSString *)category
{
    self = [super init];
    if (self)
    {
        _category = category;
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = _category;

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kSOServiceCellIdentifier];

    if ([_category isEqualToString:@"All Services"])
    {
        [[SOHTTPRequestOperationManager manager] getAllServicesWithSuccess:^(AFHTTPRequestOperation *operation, id response) {
            _services = response[@"services"];
            [self.tableView reloadData];
        }
                                                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                                                                   }];
    }
    else
    {
        [[SOHTTPRequestOperationManager manager] getServicesInCategory:self.category
                                                               success:^(AFHTTPRequestOperation *operation, id response) {
                                                                   _services = response[@"services"];
                                                                   [self.tableView reloadData];
                                                               }
                                                               failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                                                               }];
    }
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
    return _services.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSOServiceCellIdentifier forIndexPath:indexPath];

    cell.textLabel.text = _services[indexPath.row][@"title"];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    SOServiceDetailViewController *detailViewController = [[SOServiceDetailViewController alloc] initWithService:_services[indexPath.row]];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
