0.3.0 - Unreleased

1. added CLI sub-commands via `commander`:
    a. set - set config values into storage scopes (creates file if it doesn't exist)
    b. get - get a config value, or values, from storage scopes
    c. list - list all config values available, or from a specific scope
    d. version - show current version of `nuc`
    e. help - show generic help info, or help for a specific command (not yet...?)
2. added README docs for CLI commands
3. created separate documentation for syntax flavors: vanilla JS, ES6, and CoffeeScript

0.2.2 - Released 2016/10/04

1. fixed `deepExtend` call by swapping order of args

0.2.1 - Released 2016/10/04

1. fixed typo in README
2. fixed bug by removing file name suffix from `file-list`
3. changed prepublish/postpublish scripts to reuse compile/clean
4. updated deps
5. fixed typo in the year in this file from "1015" to "2015"

0.2.0 - Released 2015/10/18

1. added badges and Travis-CI
2. moved file paths out to platform specific files
3. began making testing platform agnostic (does windows-ish tests on MacOS)

0.1.0 - Released 2015/09/06

1. initial working version with test-packages
