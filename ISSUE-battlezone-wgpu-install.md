# Battlezone installs the old Kitty renderer

## Problem

The Battlezone formula downloads v1.0.0 and describes Kitty terminals. That release predates the native wgpu port, and checking only executable permissions does not verify the renderer or command startup.

## Expected result

A normal Homebrew installation or upgrade installs the published wgpu build. Informational commands validate the installed program without a display.
