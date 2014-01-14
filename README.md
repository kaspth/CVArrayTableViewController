## CVArrayTableViewController 

`CVArrayTableViewController` is reusable data source and delegate for `UITableView`.

## Usage

Add the dependency to your `Podfile`:

```ruby
platform :ios
pod 'CVArrayTableViewController'
...
```

Run `pod install` to install the dependencies.

Subclass `CVTableViewArrayDataSource`. Set or override `objects`, `cellIdentifier` and `cellConfigurationHandler`. 

Like this:

```objc
  #import "CVArrayTableViewController.h"
  
  ...
  @interface Subclass : CVArrayTableViewController
  @end

  // in your .m file:
  - (NSArray *)objects
  {
      return @[@"A cat", @"A hat", @"And", @"A band"];
  }
  
  - (void)viewDidLoad
  {
      self.tableViewDataSource.cellIdentifier = @"UniqueCellIdentifier";
      self.tableViewDataSource.cellConfigurationHandler = ^(UITableViewCell *cell, NSString *title) {
          cell.textLabel.text = title;
      };
  }
```

Notice the `NSString *title` above. The objects in the array are automatically passed to your `cellConfigurationHandler` as an id.
Since there's only `NSString`s in there, in this example, we can cast the object in the block definition.

## Credits

Distributed with an MIT License.

Contributions more than welcome.

Made by Kasper Timm Hansen.
GitHub: [@kaspth](https://github.com/kaspth).
Twitter: [@kaspth](https://twitter.com/kaspth).
