# NUC

Configuration via JSON and INI file hierarchy: CLI, ENV, local, user, system, global.

Uses specified app/module `id` and process.platform value to look for config files.
Also uses the CLI args and environment values.

Provides a flexible way to specify configuration values in multiple system places
in an inuitive hierarchy. This allows users and systems to configure values for
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

## Usage

```coffeescript
# require module, call it, give it the ID and JSON specified defaults
# id is required, defaults are optional.
# values contains the entire object graph of key/value pairs
values = (require 'nuc') id:'appid', defaults:require './defaults'
```

## Value Hierarchy

Values are loaded from multiple places. Items in list override those below them.

1. CLI  - command line arguments override all other sources of values
2. ENV  - environment values are prepared by the OS and override all but CLI args
3. local - find config files in the local CWD
4. user - look in user's home directory
5. system - shared user directory or module installation location


## Keys

The `id` specified to `nuc` is used as the base name to produce keys and file names.

1. CLI key is the uppercase form of the `id`, prepended with two dashes, followed by an underscore, then the keys, an equal sign, and the value, like:
    --ID_KEY=value
Keys can be nested by using two underscores together. For example:
```coffeescript
# key: --ID_ONE__TWO__THREE=value is interpreted as:
result =
  ONE:
    TWO:
      THREE: 'value'
```

2. ENV key is the same as CLI keys, without the '--' in front.

## File names

Many files are searched for with various patterns using the `id` in it. See below for complete list.

On Windows platforms:
1. look for `ini` files.
2. `env.USERPROFILE` is used instead of `env.HOME`
3. `env.ALLUSERPROFILE` is used instead of `/usr/lib` and `/usr/local/lib`.

On *nix platforms:
1. look for dot files (filename starts with a dot)
2. look for files suffixed with `rc`, like: `.idrc`
3. look in `/etc`, `/usr/lib/node_modules`, and `/usr/local/lib/node_modules`

Using `'id'` for the `id` these are all the files searched for:

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

Chance, mostly. I began the [nup](https://github.com/elidoran/node-nu) project and wanted to read configuration from multiple
places on the system. I reviewed a bunch of modules providing configuration methods.
The one I liked the most was one I saw long ago when I first moved to node: the [npmrc](https://docs.npmjs.com/files/npmrc) stuff.
So, I decided I wanted to make a module I could use with any app or module I made.

So, I needed a name for this new project coming directly from the `nu` (`nup`) project. Add a 'c' for configuration, and, it
sounds like "nook", which, may be where we find all the configuration information, in the "nook and crannies"?

I basically wanted to stop thinking about a name and begin writing the code. So, `nuc` it is.

### MIT License
