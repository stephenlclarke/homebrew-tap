# Pacman installs the old Kitty renderer

## Problem

The Pacman formula describes wgpu but downloads `v1.0.0`, whose dependencies still include the Kitty/terminal rendering path. Its HEAD source also selects `main`, while the published port is on `wgpu`.

## Expected result

Homebrew installs the published wgpu build and checks its help output without requiring a graphical test session.
