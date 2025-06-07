# Vim Basics Cheat Sheet

## Modes
- **Normal Mode**: Press `Esc`
- **Insert Mode**: Press `i`, `I`, `a`, `A`, `o`, or `O`
- **Visual Mode**: Press `v` (character), `V` (line), or `Ctrl+v` (block)
- **Command-Line Mode**: Press `:` in Normal mode

---

## Navigation
- `h` – move left
- `l` – move right
- `j` – move down
- `k` – move up
- `w` – jump to start of next word
- `b` – jump to start of previous word
- `e` – jump to end of word
- `0` – beginning of line
- `^` – first non-blank character of line
- `$` – end of line
- `gg` – go to top of file
- `G` – go to bottom of file
- `:n` – go to line number `n`

---

## Editing Text
- `i` – insert before cursor
- `a` – append after cursor
- `I` – insert at beginning of line
- `A` – append at end of line
- `o` – open new line below and insert
- `O` – open new line above and insert
- `r<char>` – replace a single character
- `R` – enter Replace mode (overwrite)

---

## Deleting
- `x` – delete character under cursor
- `X` – delete character before cursor
- `dd` – delete current line
- `dw` – delete from cursor to end of word
- `d$` or `D` – delete from cursor to end of line
- `d0` – delete from cursor to beginning of line
- `dgg` – delete to start of file
- `dG` – delete to end of file
- `100dd` – delete 100 lines starting from current line

---

## Copy & Paste (Yank & Put)
- `yy` – yank current line
- `yw` – yank word
- `y$` – yank to end of line
- `5yy` – yank 5 lines
- `p` – paste after cursor
- `P` – paste before cursor
- `5p` – paste 5 times

---

## Undo / Redo
- `u` – undo
- `U` – undo entire line
- `Ctrl+r` – redo

---

## Search
- `/pattern` – search forward
- `?pattern` – search backward
- `n` – repeat search forward
- `N` – repeat search backward

---

## Replace
- `:%s/old/new/g` – replace all instances in file
- `:s/old/new/g` – replace all on current line
- `:.,$s/foo/bar/g` – replace from current line to end of file

---

## Saving / Exiting
- `:w` – write (save)
- `:q` – quit
- `:wq` or `:x` – write and quit
- `:q!` – quit without saving
- `ZZ` – write and quit (same as `:wq`)

---

## Buffers and Tabs
- `:e filename` – open file
- `:ls` – list buffers
- `:b#` – switch to buffer `#`
- `:tabnew` – open a new tab
- `gt` – go to next tab
- `gT` – go to previous tab

---

## Visual Mode Commands
- `v` – start visual mode (character)
- `V` – start visual mode (line)
- `Ctrl+v` – visual block mode
- `d` – delete selection
- `y` – yank selection
- `>` or `<` – indent/outdent selection
- `:` – run command on selection (e.g., `:'<,'>s/foo/bar/g`)

---

## Miscellaneous
- `.` – repeat last command
- `:%y+` – yank entire file to system clipboard (with clipboard support)
- `:set number` – show line numbers
- `:set relativenumber` – show relative numbers
- `:syntax on` – enable syntax highlighting
- `:noh` – clear search highlighting
- `:help` – open help

