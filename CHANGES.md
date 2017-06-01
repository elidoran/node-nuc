## 0.5.2 - Released 2017/06/01

1. only include `options.defaults` to `buildValueStore` when they exist.

## 0.5.1 - Released 2017/05/29

1. added missing `findId` to `set.coffee`
2. renamed "compile" script to "build"

## 0.5.0 - Released 2017/05/29

1. fix `options.defaults` provided to `buildValueStore`
2. ignore usual directories in `.npmignore`
3. update Travis CI to cache `node_modules`, drop 0.12, add 7, publish coverage
4. add linting and coverage deps and scripts
5. change node engine to 4+
6. add coverage badge (coverage is still low, no command testing)
7. set `__source` via `Object.defineProperty()` (should prolly be exported by `value-store`)
8. adapt tests for `__source` being non-enumerable
9. include objects only when they have some keys
10. change sections in this file to use headers instead of bold text


## 0.4.0 - Released 2016/11/02

1. update `findId()` to look in for some environment variables, in cli args, and prevent looking for '.nuc.name'
2. updated get/set to use new `findId`.
3. added testing for `findId`


## 0.3.2 - Released 2016/10/23

1. added missing null check
2. removed random process.env key assignment

## 0.3.1 - Released 2016/10/23

1. published without the random files in the project root

## 0.3.0 - Released 2016/10/22

1. added CLI sub-commands: get, set, add, remove, list, help, usage, version
2. major revision to library to support new CLI
3. generate paths using functions instead of explicit lists, allows overrides
4. added README docs for CLI commands (barely)


## 0.2.2 - Released 2016/10/04

1. fixed `deepExtend` call by swapping order of args

## 0.2.1 - Released 2016/10/04

1. fixed typo in README
2. fixed bug by removing file name suffix from `file-list`
3. changed prepublish/postpublish scripts to reuse compile/clean
4. updated deps
5. fixed typo in the year in this file from "1015" to "2015"

## 0.2.0  - Released 2015/10/18

1. added badges and Travis-CI
2. moved file paths out to platform specific files
3. began making testing platform agnostic (does windows-ish tests on MacOS)


## 0.1.0 - Released 2015/09/06

1. initial working version with test-packages
