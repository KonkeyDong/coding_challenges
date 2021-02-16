# Coding Questions

Various coding problems solved (primarily) in [Lua](https://www.lua.org/).

# Why Lua?

This gives me a chance to learn something new. I may never use `Lua` in a work environment, but it is useful to learn if I ever work on embedded applications in C/C++. It's also a small and simple langauge.

[Learn Lua in 15 minutes](http://tylerneylon.com/a/learn-lua/).

# Stack

* [Lua 5.3.6](https://www.lua.org/ftp/)
   * Download `lua-5.3.6.tar.gz` and extract.
   * Follow the steps [here](https://www.lua.org/manual/5.3/readme.html) to install.
* `luarocks 3.5.0` - Package manager.
   * Install instructions:
      ```bash
         wget https://luarocks.org/releases/luarocks-3.5.0.tar.gz
         tar zxpf luarocks-3.5.0.tar.gz
         cd luarocks-3.5.0
         ./configure --lua-version=5.3 && make && sudo make install
         sudo luarocks install socket
         lua
      ``` 
      ... Which will open a `Lua` prompt. Require the package to see if `Lua` returns `true`:
      ```lua
         Lua 5.3.6  Copyright (C) 1994-2020 Lua.org, PUC-Rio
         > require "socket"
         -- true or table hash number
      ```

   * Install the following packages using `sudo luarocks install <package>`:
      * [debugger](https://github.com/slembcke/debugger.lua)
      * [ldoc](https://luarocks.org/modules/steved/ldoc)
      * [luafilesystem](https://luarocks.org/modules/hisham/luafilesystem)
      * [penlight](https://luarocks.org/modules/tieske/penlight) - various functionality such as access to [functional programming techniques](https://lunarmodules.github.io/Penlight/manual/07-functional.md.html), a [pretty printer](https://lunarmodules.github.io/Penlight/libraries/pl.pretty.html), and [list comprehension](https://lunarmodules.github.io/Penlight/libraries/pl.comprehension.html).
      * [busted](https://github.com/Olivine-Labs/busted) - Unit testing framework that looks similar to [Jest](https://jestjs.io/en/).
   * View if your packages are installed: `luarocks list`.
   * Use `luarocks --version` to verify that you're using `luarocks 3.5.0`.
