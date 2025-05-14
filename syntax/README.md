Syntax defined in ~/.config/nvim/after/syntax/ are after /usr/local/share/nvim/runtime/syntax/. But if defined in ~/.config/nvim/syntax/ then it loaded before the share/nvim one.

Just make just to set the current syntax variable to avoid any other runtime.vim to highlight it for on top of yours.

```vim
let b:current_syntax = "c"
```
