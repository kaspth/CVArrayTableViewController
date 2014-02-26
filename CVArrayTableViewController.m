#import "CVArrayTableViewController.h"

@implementation CVArrayTableViewController

#pragma mark - CVArrayTableViewController

- (BOOL)hideHeadersForEmptySections
{
    return _hideHeadersForEmptySections ?: (_hideHeadersForEmptySections = NO);
}

- (BOOL)objectsAreEditable
{
    return _objectsAreEditable ?: (_objectsAreEditable = [self.objects isKindOfClass:[NSMutableArray class]]);
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.objectsAreEditable && self.canEditRowHandler)
        return self.canEditRowHandler(indexPath, [self objectForIndexPath:indexPath]);
    
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle != UITableViewCellEditingStyleDelete && !self.didDeleteRowHandler)
        return;
    
    id object = [self removeObjectAtIndexPath:indexPath];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    self.didDeleteRowHandler(indexPath, object);
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

- (id)removeObjectAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *editableObjects = (NSMutableArray *)[self objectsForSectionIndex:indexPath.section];
    if (indexPath.row >= [editableObjects count])
        return nil;
    
    id object = editableObjects[indexPath.row];
    [editableObjects removeObjectAtIndex:indexPath.row];
    
    return object;
}

- (UITableView *)shouldDequeueFromTableView:(UITableView *)tableView
{
    if (self.dequeueFromTableViewHandler)
        return self.dequeueFromTableViewHandler(tableView);
    return tableView;
}

@end
