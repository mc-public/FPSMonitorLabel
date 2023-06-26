# FPSMonitorLabel

`FPSMonitorLabel` provides you with a label view to display the current refresh rate of iOS devices.

## Supported platforms

`FPSMonitorLabel` supports iOS 8.0 and above.

## Useage

### UIKit 

For `iOS 8.0` and above, FPSMonitorLabel provides a `UILabel` subclass that can be used to display the FPS rate. 

The simplest usage example is shown below.

```
import FPSMonitorLabel
let label = FPSMonitorUILabel()
label.updateFPSInternal = 0.5
label.start()
```

### SwiftUI

For `iOS 13.0` and above, FPSMonitorLabel provides a `SwiftUI` view that can be used to display the FPS rate.

The simplest usage example is shown below.

```
import FPSMonitorLabel
struct ContentView: View {
    var body: some View {
        //Here:
        FPSMonitorLabel(updateInternalConst: 0.5)
    }
}
```
