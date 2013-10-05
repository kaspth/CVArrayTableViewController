## CVTableViewArrayDataSource

`CVTableViewArrayDataSource` is reusable data source and delegate for `UITableView`.

## Usage

Add the dependency to your `Podfile`:

```ruby
platform :ios
pod 'CVTableViewArrayDataSource'
...
```

Run `pod install` to install the dependencies.

Create an instance of `CVTableViewArrayDataSource` with a reference to your table view. Set `cellIdentifier` and `cellConfigurationHandler`. 

(Remember to have a strong reference to your instance, `UITableView` doesn't retain dataSources or delegates.)

Like this:

```objc
  #import "CVTableViewArrayDataSource.h"
  
  ...
  
  self.tableViewDataSource = [[CVTableViewArrayDataSource alloc] initWithTableView:self.tableView objects:@[@"A cat", @"A hat", @"And", @"A band"]];
  
  self.tableViewDataSource.cellIdentifier = @"UniqueCellIdentifier";
  self.tableViewDataSource.cellConfigurationHandler = ^(UITableViewCell *cell, NSString *title) {
      cell.textLabel.text = title;
  };
```

Notice the `NSString *title` above. The objects in the array are automatically passed to your `cellConfigurationHandler` as an id.
Since there's only `NSString`s in there, in this example, we can cast the object in the block definition.

## Credits

Distributed with an MIT License.

Contributions more than welcome.

Made by Kasper Timm Hansen.
GitHub: [@kaspth](https://github.com/kaspth).
Twitter: [@kaspth](https://twitter.com/kaspth).
