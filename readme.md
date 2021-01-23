## Introduction

`makepwa` is a CLI tool for making PWAs. You can install it globally with

```
npm install makepwa -g
```

and then use

```
makepwa new NAME [TEMPLATE]
```

to create a directory named NAME and a new PWA project inside of it. For example, `makepwa new pwa0`.

Optionally, you can also pass a TEMPLATE. For example, `makepwa new pwa0 ReactMaterial` will create a project with React and Material-UI. Without a TEMPLATE, it will create a bare project without additional dependencies.

After entering the directory with `cd pwa0`, you can use `npm start` and `npm run build`.

## `npm start`

is for starting a development session. This command will:

- create the `./dist.dev` directory with a distribution optimized for development;
- watch for changes to the sources(in the `./src` directory) and update the distribution continuously;
- run Browsersync at 3000 port on all available network interfaces;

## `npm run build`

is a one-off command which creates the `./dist` directory with a distribution optimized for production.

## Service workers

The default service worker implements a race between Cache and Network(it tries to get response from both and returns the earliest response). Also, if the request to Network was successful, Cache gets updated.

This behavior would intervene with development(we would have to reload our browser twice to see every change). Because of this, by default, the service worker gets built only for production.

If you would like to make it available during development(for example, to implement a different strategy), you can run `makepwa sw extract`. This will add `./src/workers/sw.coffee` and `./src/scripts/register_sw.coffee` to your project.

## Icons

If you add a square SVG icon to `./src/icons/icon.svg`, all the necessary icons will be generated from it. Otherwise, a default SVG icon will be used for that.
