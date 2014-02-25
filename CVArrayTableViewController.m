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

- (BOOL)objectsAreMoveable
{
    return _objectsAreMoveable ?: (_objectsAreMoveable = YES);
}

#pragma mark -

- (void)reloadVisibleCells
{
    [self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark -

- (void)appendRowWithObject:(id)object
{
    [self appendRowToSection:0 withObject:object];
}

- (void)appendRowToSection:(NSUInteger)section withObject:(id)object
{
    [self insertRowAtIndexPath:[self appendRowIndexPathForSection:section] withBackingObject:object];
}

- (void)prependRowWithObject:(id)object
{
    [self prependRowToSection:0 withObject:object];
}

- (void)prependRowToSection:(NSUInteger)section withObject:(id)object
{
    [self insertRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] withBackingObject:object];
}

#pragma mark -

- (BOOL)reloadRowInSection:(NSUInteger)section withObject:(id)object forObjectPassingTest:(BOOL(^)(id obj, NSUInteger idx, BOOL *stop))predicate;
{
    if (!self.objectsAreEditable)
        return NO;

    NSUInteger rowIndex = [[self objectsForSectionIndex:section] indexOfObjectPassingTest:predicate];
    if (rowIndex == NSNotFound)
        return NO;

    [(NSMutableArray *)[self objectsForSectionIndex:section] replaceObjectAtIndex:rowIndex withObject:object];

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:section];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:[self rowAnimationBasedOnInsertionAnimationHandler]];
    if (self.insertionAnimationHandler)
        self.insertionAnimationHandler([self.tableView cellForRowAtIndexPath:indexPath], object);

    return YES;
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

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self allowOperationAtIndexPath:indexPath scopeProperty:self.objectsAreMoveable handler:self.canMoveRowHandler];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self allowOperationAtIndexPath:indexPath scopeProperty:self.objectsAreEditable handler:self.canEditRowHandler];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle != UITableViewCellEditingStyleDelete)
        return;
    
    id object = [self removeObjectAtIndexPath:indexPath];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

    if (self.didDeleteRowHandler)
        self.didDeleteRowHandler(indexPath, object);
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    id object = [self removeObjectAtIndexPath:sourceIndexPath];
    [self insertObject:object atIndexPath:destinationIndexPath];

    if (self.didMoveRowHandler)
        self.didMoveRowHandler(destinationIndexPath, object);
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.didSelectRowHandler)
        return self.didSelectRowHandler(indexPath, [self objectForIndexPath:indexPath]);

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Private

- (UITableViewRowAnimation)rowAnimationBasedOnInsertionAnimationHandler
{
    return self.insertionAnimationHandler ? UITableViewRowAnimationNone : UITableViewRowAnimationAutomatic;
}

- (id)objectForIndexPath:(NSIndexPath *)indexPath
{
    return [self objectsForSectionIndex:indexPath.section][indexPath.row];
}

- (NSArray *)objectsForSectionIndex:(NSInteger)section
{
    if (self.sections && section < self.objects.count)
        return self.objects[section];

    return self.objects;
}

#pragma mark -

- (id)removeObjectAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *editableObjects = (NSMutableArray *)[self objectsForSectionIndex:indexPath.section];
    if (indexPath.row >= [editableObjects count])
        return nil;
    
    id object = editableObjects[indexPath.row];
    [editableObjects removeObjectAtIndex:indexPath.row];
    
    return object;
}

- (BOOL)insertObject:(id)object atIndexPath:(NSIndexPath *)indexPath
{
    if (!object || !self.objectsAreEditable)
        return NO;

    NSMutableArray *editableObjects = (NSMutableArray *)[self objectsForSectionIndex:indexPath.section];
    if (indexPath.row > [editableObjects count])
        return NO;

    [editableObjects insertObject:object atIndex:indexPath.row];
    return YES;
}

#pragma mark -

- (NSIndexPath *)appendRowIndexPathForSection:(NSUInteger)section
{
    return [NSIndexPath indexPathForRow:[[self objectsForSectionIndex:section] count] inSection:section];
}

- (void)insertRowAtIndexPath:(NSIndexPath *)indexPath withBackingObject:(id)object
{
    if (![self insertObject:object atIndexPath:indexPath])
        return;

    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:[self rowAnimationBasedOnInsertionAnimationHandler]];

    if (self.insertionAnimationHandler)
        self.insertionAnimationHandler([self.tableView cellForRowAtIndexPath:indexPath], object);
}

#pragma mark -

- (UITableView *)shouldDequeueFromTableView:(UITableView *)tableView
{
    if (self.dequeueFromTableViewHandler)
        return self.dequeueFromTableViewHandler(tableView);
    return tableView;
}

#pragma mark -

- (BOOL)allowOperationAtIndexPath:(NSIndexPath *)indexPath scopeProperty:(BOOL)scope handler:(CVBoolRowAtIndexPathHandler)handler
{
    if (scope && handler)
        return handler(indexPath, [self objectForIndexPath:indexPath]);
    return scope;
}

@end
