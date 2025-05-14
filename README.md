
## Start

    git clone https://github.com/evertonse/nvim ~/.config/nvim

## Tagging

Tagging a commit (-a creates an annotated tag.)

    git tag -a v1.0.0 <commit-hash> -m "Tagging older release"

View Tags

    git tag

## Debug

    nvim -u /tmp/init.lua +"syntax off" +"filetype off" assets/speed/rmlint.sh
    :verbose autocmd BufReadPost

    nvim --startuptime startup.log -u ~/.config/nvim-min/init.lua --noplugin empty.txt

Make sure to open huge files with and without syntax, with and without treesitter.
Press C-d and C-u to go through and find places where it gets stuck for a microsec.
Try to press v to select somewhere in the middle of the file, and use 'e' and 'b' to move the select word by word and feel if there's any input lag
Also try to insert in a huge file, tressiter indent was the culprit for slow insert.


![](assets/theme1.png)

![](assets/theme2.png)

![](assets/selection_color.png)

![](assets/tsodingold.png)

![](assets/theme3.png)

![](assets/theme4.png)

![](assets/theme5.png)

![](assets/blow_theme.png)
