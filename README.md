XbICalendar [![Build Status](https://travis-ci.org/chenggehan/XbICalendar.svg?branch=Travis)](https://travis-ci.org/chenggehan/XbICalendar)
===========

Easy to use Objective-C Wrapper for the libical library


Status
------
Barely usable for my project.  Need ideas and some help!  Have not published the podspec yet because we are not ready for the unawary. 

## Installation

### Cocoapods
Podfile entry:

```
pod 'XbICalendar', :podspec => 'https://raw.githubusercontent.com/libical/XbICalendar/master/XbICalendar.podspec'
```
### Import the Header files into your project source files
Add `#import "XbICalendar.h"`

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

### Contributing

---
This project is very friendly to beginner's both new to iOS development and open source contributions.  If you have a question please open a new issue here or reach out via the contact information below.

We do ask that you conform to the contribution process as outlined here.

#### Create an Issue

If you find a bug in the project (and you don’t know how to fix it), have trouble following the documentation or have a question about the project – create an issue! There’s nothing to it and whatever issue you’re having, you’re likely not the only one, so others will find your issue helpful, too. For more information on how issues work, check out the github [Issues guide](https://guides.github.com/features/issues/).

#### Tackle an Issue 

When you find something that you think you can help with, let us know.  Assign yourself the issue, ask questions with issue comments. We are here to help!  

If its a complex task, propose a solution for feedback or break it down into seperate smaller issues.  Create new issues for each of the steps.

#### Fork the Project

[Fork](https://guides.github.com/activities/forking/) the repository and clone it locally. Connect your local to the original ‘upstream’ repository by adding it as a remote. Pull in changes from ‘upstream’ often so that you stay up to date so that when you submit your pull request, merge conflicts will be less likely. See more detailed instructions [here](https://help.github.com/articles/syncing-a-fork).

#### Do the Work 

Make your changes on your own local copy of the files.  Please take some time to make sure your changes are what you expect.  If you are writing new code, make sure the previous automated tests still run.  If you are adding new features in code, add complmentary tests. 

All our coding will be in Swift.  Please follow this [Swift style guide](https://github.com/raywenderlich/swift-style-guide).

If you run into problems or decide its to much for you or get busy on other things -- please let us know.

Once every thing is to your satifaction, push the changes back to your forked reposetory on github.

#### Open Pull Requests

Once you’ve opened a pull request a discussion will start around your proposed changes. Other contributors and users may chime in, but ultimately the decision is made by the maintainer(s). You may be asked to make some changes to your pull request, if so, add more commits to your branch and push them – they’ll automatically go into the existing pull request.

Wash, Repeat!


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
