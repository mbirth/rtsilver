RT Silver
=========

This is a Chrome extension which enables a few Gold features on a well-known sports tracking site.

This is done solely by messing around with their DOM. No illegal things are done.


Compilation
-----------

To compile this extension, make sure you have installed the CoffeeScript compiler.

Then just run:

```
make
```

It will compile everything and the final extension ends up in the `build/` directory.



Installation
------------

To install the extension into your Chrome or Chromium browser, go to *Menu* → *Tools* → *Extensions*,
enable *Developer Mode* and load the `build/` directory using the **Load unpacked extension…** button.



Distribution
------------

If you want to create a Chrome Extension **.crx** package, just run:

```
make crx
```

It will generate an RSA key if needed and compile everything into a `rtsilver.crx`.
That file can then be distributed.
