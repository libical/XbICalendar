XbICalendar
===========

Easy to use Objective-C Wrapper for the libical library


Status
------
Barely usable for my project.  Need ideas and some help!  Have not published the podspec yet because we are not ready for the unawary. 

## Installation

### Cocoapods
Podfile entry:

```
pod 'XbICalendar', :podspec => 'https://raw.githubusercontent.com/ahalls/XbICalendar/master/XbICalendar.podspec'
```
### Import the Header files into your project source files
Add '#import "XbICalendar.h"'

### Example Usage
```objc
#import "XBICalendar.h"
...
    NSString *path = [bundle pathForResource:@"invite" ofType:@"ics"];
    XbICVCalendar * vCalendar =  [XbICVCalendar vCalendarFromFile:path];
    
    NSArray * events = [vCalendar componentsOfKind:ICAL_VEVENT_COMPONENT];
    XbICVEvent * event = events[0];
  
    NSString description = [event description];

``` 

## Guidelines for contributions

* Fork XbICalendar and create a feature branch. Develop your feature.
* Open a pull request.


License
=======

XbICalendar is distributed under two licenses. The same as the underlying
libical project.

You may choose the terms of either:

 * The Mozilla Public License (MPL) v1.0
 
 or
 
 * The GNU Library General Public License (LGPL) v2.1

----------------------------------------------------------------------

Software distributed under these licenses is distributed on an "AS
IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
implied. See the License for the specific language governing rights
and limitations under the License.
Libical is distributed under both the LGPL and the MPL. The MPL
notice, reproduced below, covers the use of either of the licenses. 

----------------------------------------------------------------------
