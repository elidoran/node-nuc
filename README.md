# NUC
[![Build Status](https://travis-ci.org/elidoran/node-nuc.svg?branch=master)](https://travis-ci.org/elidoran/node-nuc)
[![Dependency Status](https://gemnasium.com/elidoran/node-nuc.png)](https://gemnasium.com/elidoran/node-nuc)
[![npm version](https://badge.fury.io/js/nuc.svg)](http://badge.fury.io/js/nuc)

Configuration via JSON and INI file hierarchy: cli, env, local, user, system, global.

Uses specified app/module `id` and process.platform value to look for config files.
Also uses the CLI args and environment values.

Provides a flexible way to specify configuration values in multiple system places
in an intuitive hierarchy. This allows users and systems to configure values for
apps/modules in simple text files as well as override them with CLI args.

Also provides a `nuc` command, installed globally, to review configuration values
and set them at specific levels in the hierarchy.

## Install

```sh
# Install global for `nuc` command.
npm install -g nuc

# Install locally to get configuration for your module/app
npm install nuc
```

## Usage: the values object

The primary use of `nuc` is to read a hierarchy of configuration files and combine them along the way into a single object. The final object contains the "configuration" information we want.

I call that the "values" object. It's produced by the "collapse" mode which is enabled by default.

```javascript
// require module, call it, give it the ID and some defaults
// id is required, defaults are optional.
// values contains all key/value pairs combined into one object.
// later object key/value pairs override earlier ones
var nuc = require('nuc')
  , values = nuc({ id:'appid', defaults:{} })
```

## Usage: the ValueStore stack

See [ValueStore](https://github.com/elidoran/node-value-store) for a description of that module.

The `nuc` module can gather all the configuration files into a `ValueStore` instance. Each configuration source remains separate and its hierarchy is maintained.

Each one knows its "source". If it's a cli option then its source is 'cli'. Environment values are from 'env'. Files have a `file` property with the path.

The various sources in the `ValueStore` can be inspected in many ways. Check out [ValueStore](https://github.com/elidoran/node-value-store) for more on that.

To receive only the ValueStore you must enable it and disable the "collapse mode".

```javascript
var nuc = require('nuc')
  , store = nuc({ id:'someid', collapse:false, stack:true  });
```


## Usage: Have it both ways

By default, `nuc` only produces the single `values` object and returns it. I call that "collapse mode".
By default, the ValueStore isn't produced because the "stack mode" is off.

To have both, enable both, and the returned result will contain both a `values` property and a `store` property.

Because "collapse" is enabled by default, just enable "stack" and you get both.

```javascript
var nuc = require('nuc')
  , both = nuc({ id:'someid', defaults:{}, collapse:true, stack:true });
```


## Usage: CLI

The `nuc` module has a cli tool also named "nuc". You may use it locally or install it globally.

It has multiple subcommands which you may recognize from other configuration tools such as `npm config` for "npmrc".

One major difference between `nuc` and all the others is `nuc` requires an "id" be specified which is used in many ways, one of them is as part of the file names. This means different applications may have their own configuration file inside a user's home directory. They are separate.

For example, a user may have a configuration folder in their home directory at `/home/username/conf`. Inside it, there may be many files which will be loaded by `nuc` when their corresponding app "id" is used.

The help information and usage displayed by the command itself is more descriptive than the documentation here. Install it and check it out :)

The cli subcommands are:

1. version - prints the version to the console
2. usage - prints the commands which can be used with nuc. This is the default subcommand. (alias = 'use')
3. help - prints general help info, or, info about specific things when passed as an arg, such as `nuc help list` or `nuc help scope`
4. list - list the contents of the `values` object or of the `store` object. You may limit it to a single scope instead of all scopes. Uses `util.inspect` to add colors to the output. (alias = 'show').
5. get - get the value for a key for the first scope where the key exists, or, for the scope you specify.
6. set - sets the key/value pair you specify into the first configuration file found within all writable scopes, or the one scope you specify. If no file is found, then a default file location is used to write out a new file with the key/value pair. It defaults to a path in the user's home directory where they're sure to have permission to write a file. These values may be overridden by using `nuc` itself to set their configuration values with app id "nuc". Because, `nuc` uses itself for its own configuration.
7. add - similar to `set` except it combines your new value and the existing value into an array. If the key doesn't exist yet, then this command is the same as `set`.
8. remove - the opposite of `set`, it will remove the key from the first scope it is found. You may specific the scope to remove it from, or, scope 'all' to remove it from all scopes. (As I write this, I realize I haven't completed the "remove from all" functionality yet.)

TODO: list the values used by `nuc` by default and what the keys are to override them.


## Value Hierarchy

Values are loaded from multiple scopes. Items higher in this list override those below them.

1. cli  - command line arguments override all other sources of values. Provided in `process.argv`. These are read-only.
2. env  - environment values are prepared by the OS and override all but CLI args. Provided in node as `process.env`. These are read-only.
3. local - find config files in the local current working directory and up the path to root. Their accessibility depend on the user permissions.
4. user - look in user's home directory. These are read/write accessible.
5. system - system configuration directories, such as `/etc` and `c:\ProgramData`. These values are writable if the user has access to them.
6. global - where modules are installed with `npm install -g`. These values are read-only.


## Keys

The `id` specified to `nuc` is used as the base name to produce keys and file names.

1. cli key is the uppercase form of the `id`, prepended with two dashes, followed by an underscore, then the keys, an equal sign, and the value, like:

    --ID_KEY=value

Keys can be nested by using two underscores together. For example:

```javascript
// key: --ID_ONE__TWO__THREE=value is interpreted as:
result = {
  ONE: {
    TWO: {
      THREE: 'value'
    }
  }
}
```

2. env keys are the same as cli keys, without the '--' in front: `process.env.ID_ONE__TWO__THREE`.


## File names

Many files are searched for with various patterns using the `id` in it. See below for complete list.

On Windows platforms:
1. look for `ini` files.
2. `env.USERPROFILE` is used instead of `env.HOME` for 'user' scope
3. `env.ALLUSERPROFILE` is used instead of `/etc` for 'system' scope
4. ??? what should be used instead of `/usr/lib` and `/usr/local/lib` for 'global' ?

On *nix platforms:
1. look for dot files (filename starts with a dot)
2. look for files suffixed with `rc`, like: `.idrc`
3. look in `/etc`, `/usr/lib/node_modules`, and `/usr/local/lib/node_modules`

Using `'id'` for the `id` these are all the files searched for:

NOTE: This is an outdated list... but, it gives you an idea of it, so, I'll leave it for now. Look at [windows-bases](https://github.com/elidoran/node-nuc/blob/master/lib/windows-bases.coffee), [nix-bases](https://github.com/elidoran/node-nuc/blob/master/lib/nix-bases.coffee), and [path-generator](https://github.com/elidoran/node-nuc/blob/master/lib/path-generator.coffee) to get a better idea.

1. '/usr/lib/node_modules/id/id.conf'
2. '/usr/lib/node_modules/id/id.json'
3. '/usr/lib/node_modules/id/.idrc'
4. '/usr/lib/node_modules/id/idrc'
5. '/usr/local/lib/node_modules/id/id.conf'
6. '/usr/local/lib/node_modules/id/id.json'
7. '/usr/local/lib/node_modules/id/.idrc'
8. '/usr/local/lib/node_modules/id/idrc'
9. '/etc/id.conf'
10. '/etc/id.json'
11. '/etc/.idrc'
12. '/etc/idrc'
13. '/etc/id/id.conf'
14. '/etc/id/id.json'
15. '/etc/id/.idrc'
16. '/etc/id/idrc'
17. env.HOME + '/id.ini'
18. env.HOME + '/id.conf'
19. env.HOME + '/id.json'
20. env.HOME + '/.idrc'
21. env.HOME + '/idrc'
22. env.HOME + '/id/id.ini'
23. env.HOME + '/id/id.conf'
24. env.HOME + '/id/id.json'
25. env.HOME + '/id/.idrc'
26. env.HOME + '/id/idrc'
27. CWD + '/id.ini'
28. CWD + '/id.conf'
29. CWD + '/id.json'
30. CWD + '/.idrc'
31. CWD + '/idrc'
32. CWD + '/id/id.ini'
33. CWD + '/id/id.conf'
34. CWD + '/id/id.json'
35. CWD + '/id/.idrc'
36. CWD + '/id/idrc'


## Why name it nuc ?

Chance, mostly. I began the [nup](https://github.com/elidoran/node-nu) project and wanted to read my configuration from multiple
places on the system. I reviewed a bunch of modules providing configuration methods.
The one I liked the most was one I saw long ago when I first moved to node: the [npmrc](https://docs.npmjs.com/files/npmrc) stuff.
I decided I wanted to make a module I could use with any app or module I made.

So, I needed a name for this new project coming directly from the `nu` (`nup`) project. Add a 'c' for configuration, and, it
sounds like "nook", which, may be where we find all the configuration information, in the "nook and crannies"?

I basically wanted to stop thinking about a name and begin writing the code. So, `nuc` it is.

### MIT License
