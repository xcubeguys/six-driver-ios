#LSGMarqueeView

LSGMarqueeView is a marquee view used on iOS.It is a view expansion which contains a `lable`.We can custom the animation duration by setting the `duration` variable,The default `duration` value is `5.0f`.


![LSGMarqueeView](LSGMarqueeView.gif)


#Getting Started

**Using [CocoaPods](http://cocoapods.org)**

1.Add the pod `LSGMarqueeView` to your [Podfile](http://guides.cocoapods.org/using/the-podfile.html).
```ruby
pod 'LSGMarqueeView', '~> 2.0.0'
```
2.Run `pod install` from Terminal, then open your app's `.xcworkspace` file to launch Xcode.

3.`#import LSGMarqueeView.h` wherever you want to use the API.

**Manually from GitHub**

1.Download the `LSGMarqueeView.h` and `LSGMarqueeView.m` files in th [Source directory](https://github.com/wangzz/LSGMarqueeView/tree/master/LSGMarqueeView)

2.Add both files to your Xcode project.

3.`#import LSGMarqueeView.h` wherever you want to use the API.

#Example Usage

**Example location**

Check out the [example project](https://github.com/wangzz/LSGMarqueeView/tree/master/LSGMarqueeViewDemo) included in the repository. It contains a few demos of the API in use for various scenarios. 

**Usage**

The way to create a LSGMarqueeView is:

```objc
LSGMarqueeView *marqueeView = [[LSGMarqueeView alloc] initWithFrame:CGRectMake(60, 100, 200, 40)];
marqueeView.lable.text = @"Good good study day day up.It is a LSGMarqueeView demo";
marqueeView.duration = 7.0f;
marqueeView.backgroundColor = [UIColor whiteColor];
[marqueeView showInView:self.view];
```

#License
MIT
