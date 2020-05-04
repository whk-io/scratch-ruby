# scratch-ruby

Source Image: ruby@sha256:b0eeb50a5a53bcec81fa45e4884b53dd22907811c105b74e1bb791d506fce439

Multistage build for reducing a portable Ruby MRI down to the smallest and most secure possible container.

Please install uuid-runtime via ```sudo apt-get install uuid-runtime``` for the flatten.sh to work properly.


Current Size: 35.3MB

![Images Sizes](img/image-sizes.png "Images Sizes")

To Build:

``` sh
make
```

To run IRB:

``` sh
make irb
```
