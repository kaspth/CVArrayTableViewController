//
//  CVTableViewArrayDataSource.m
//
//  Created by Kasper Timm on 11/09/13.
//  Copyright (c) 2013 Kasper Timm Hansen. All rights reserved.
//

#import "CVTableViewArrayDataSource.h"

@interface CVTableViewArrayDataSource ()

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CVTableViewArrayDataSource

- (instancetype)initWithTableView:(UITableView *)tableView
{
    return [self initWithTableView:tableView objects:nil];
}

- (instancetype)initWithTableView:(UITableView *)tableView objects:(NSArray *)objects
{
    self = [super init];
    if (!self) return nil;

    self.tableView = tableView;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.objects = objects;

    self.hideHeadersForEmptySections = NO;

    return self;
}

#pragma mark -

- (void)setObjects:(NSArray *)objects
{
    if (_objects == objects)
        return;

    _objects = objects;
}

#pragma mark -

- (void)reloadVisibleCells
{
    [self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sections ? [self.sections count] : 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.hideHeadersForEmptySections && ![[self objectsForSectionIndex:section] count])
        return nil;

    return self.sections[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self objectsForSectionIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[self shouldDequeueFromTableView:tableView] dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];

    if (self.cellConfigurationHandler)
        self.cellConfigurationHandler(cell, [self objectForIndexPath:indexPath]);

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.didSelectRowHandler)
        return self.didSelectRowHandler(indexPath, [self objectForIndexPath:indexPath]);

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Private

- (id)objectForIndexPath:(NSIndexPath *)indexPath
{
    return [self objectsForSectionIndex:indexPath.section][indexPath.row];
}

- (NSArray *)objectsForSectionIndex:(NSInteger)section
{
    return self.sections ? self.objects[section] : self.objects;
}

- (UITableView *)shouldDequeueFromTableView:(UITableView *)tableView
{
    if (self.dequeueFromTableViewHandler)
        return self.dequeueFromTableViewHandler(tableView);
    return tableView;
}

@end
