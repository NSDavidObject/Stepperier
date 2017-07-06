<img src="https://user-images.githubusercontent.com/3812601/27367813-cf802c8c-5603-11e7-9e63-2e8e150dec7b.png" alt="" />
<p align="center">
  <img src="https://user-images.githubusercontent.com/3812601/27369632-ac3b9144-560d-11e7-895a-87d349d9a66f.gif" alt="" />
</p>

### Requierments
  - Swift 3+
  - iOS 9.0+

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 1.1.0+ is required to build Stepperier 3.0.0+.

To integrate Stepperier into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'Stepperier', '~> 1.0.0'
end
```

Then, run the following command:

```bash
$ pod install
```
### Manually

If you prefer not to use either of the cocoapods, you can integrate Stepperier into your project manually by [downloading](https://github.com/NSDavidObject/Stepperier/archive/master.zip) the source files and integrating the [Pod](https://github.com/NSDavidObject/Stepperier/tree/master/Pod) directory in your project.

---

## Usage

### Quick Start

```swift
import Stepperier

class MyViewController: UIViewController {

    lazy var stepperier = Stepperier()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Add as subview of the view controller's view
        view.addSubview(stepperier)

        // Setup layout constraints
        stepperier.translatesAutoresizingMaskIntoConstraints = false
        stepperier.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stepperier.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        // Add value change observing
        stepperier.addTarget(self, action: #selector(stepperierValueDidChange(_:)), for: .valueChanged)
    }
    
    @IBAction func stepperierValueDidChange(_ stepper: Stepperier) {
        print("Updated value: \(stepper.value)")
    }
}
```

You may add a UIView inside your xib and set its custom class to `Stepperier` making sure the module is autofilled with the `Stepperier` module.

## Contribution

Contributions are welcomed and encouraged *♡*.

# Contact

David Elsonbaty
 - [@NSDavidObject](https://twitter.com/nsdavidobject)
 - [Website](http://elsonbaty.ca)
 - [Email](mailto:dave@elsonbaty.ca)

## Credits

- Oleg Frolov ([Github](https://github.com/Volorf), [Dribble](https://dribbble.com/Volorf))

## License

Stepperier is released under the MIT license. See LICENSE for details.
