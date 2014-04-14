#import <Foundation/Foundation.h>

typedef void(^CVConfigureTableViewCellHandler)(id cell, id object);
typedef void(^CVTableViewRowAtIndexPathHandler)(NSIndexPath *indexPath, id object);
typedef UITableView *(^CVDequeueFromTableViewHandler)(UITableView *tableView);
typedef BOOL(^CVBoolRowAtIndexPathHandler)(NSIndexPath *indexPath, id object);
typedef void(^CVCellAnimationHandler)(UITableViewCell *cell, id object);
typedef NSString *(^CVStringCopyHandler)(id cell, id object);

@interface CVArrayTableViewController : UITableViewController

///@brief Set this to an array of NSStrings for the section titles
///@discussion Setting this changes the expectations to what is in the objects array.
///@see objects
@property (nonatomic, strong) NSArray *sections;

///@brief YES if headers should be hidden, NO otherwise. Default is NO.
///@discussion Handy when a search result returns no matches, and no table headers should be shown.
@property (nonatomic) BOOL hideHeadersForEmptySections;

///@brief The data objects the cells display
///@discussion If sections are set this should be an array with the number of sections other arrays in it. Those arrays have the objects for a section.
@property (nonatomic, strong) NSArray *objects;
@property (nonatomic, copy) NSString *cellIdentifier;

@property (nonatomic, copy) CVConfigureTableViewCellHandler cellConfigurationHandler;

///@brief The block to call when a row is selected
///@discussion if not set, the row will be deselected automatically.
@property (nonatomic, copy) CVTableViewRowAtIndexPathHandler didSelectRowHandler;

///@brief Use this to act as the delegate of a tableView which doesn't have a reference to the cell with the passed in cellIdentifier.
///@discussion Ideal for UISearchResultsDataSource to reuse the cells from another tableView.
@property (nonatomic, copy) CVDequeueFromTableViewHandler dequeueFromTableViewHandler;

///@brief YES if objects are a mutable array, NO otherwise.
///@discussion Set to NO if data source shouldn't support editing.
@property (nonatomic) BOOL objectsAreEditable;

///@brief Called if objectsAreEditable is YES and the user about to edit a row, e.g. swiping reveal delete button.
@property (nonatomic, copy) CVBoolRowAtIndexPathHandler canEditRowHandler;

///@brief Called if objectsAreEditable is YES and the user deleted a row.
@property (nonatomic, copy) CVTableViewRowAtIndexPathHandler didDeleteRowHandler;

///@brief YES if all objects are moveable, NO otherwise. Default is YES.
@property (nonatomic) BOOL objectsAreMoveable;

///@brief Called if objectsAreMoveable is YES and the user tries to move a row.
@property (nonatomic, copy) CVBoolRowAtIndexPathHandler canMoveRowHandler;

///@brief Called if objectsAreMoveable is YES and the user moved a row.
///@param indexPath The destination indexPath for object.
///@param object The object that was moved.
@property (nonatomic, copy) CVTableViewRowAtIndexPathHandler didMoveRowHandler;

///@brief Called when a row is about to be inserted in the tableView.
@property (nonatomic, copy) CVCellAnimationHandler insertionAnimationHandler;

///@brief Called when the user taps a copy menu item.
///@return The string to be added to the general pasteboard.
@property (nonatomic, copy) CVStringCopyHandler stringForCopyHandler;

///@brief Appends object to the first section array and inserts the row last.
/// Only if objectsAreEditable is YES.
- (void)appendRowWithObject:(id)object;

///@brief Appends object to the section array specified by section and inserts the row last.
/// Only if objectsAreEditable is YES.
///@param section The section to append the row to.
- (void)appendRowToSection:(NSUInteger)section withObject:(id)object;

///@brief Prepends object to the first section array and inserts the row first.
/// Only if objectsAreEditable is YES.
- (void)prependRowWithObject:(id)object;

///@brief Prepends object to the section array specified by section and inserts the row first.
/// Only if objectsAreEditable is YES.
///@param section The section to prepend the row to.
- (void)prependRowToSection:(NSUInteger)section withObject:(id)object;

///@brief Reloads row for the object found via predicate if objectsAreEditable is YES.
///@discussion The insertionAnimationHandler will be run if it is set.
///@return YES if row existed and was reloaded, NO otherwise.
- (BOOL)reloadRowInSection:(NSUInteger)section withObject:(id)object passingTest:(BOOL(^)(id obj, NSUInteger idx, BOOL *stop))predicate;

@end
