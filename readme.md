`makepwa` is a CLI tool for making PWAs. You can install it globally with

```
npm install makepwa -g
```

and then use

```
makepwa new pwa0
```

to create the directory named "pwa0" and a new project inside of it.

After entering the directory with `cd pwa0`, you can use `makepwa build` and `makepwa watch`.

`makepwa build` creates the `dist` directory with a compiled bundle.

`makepwa watch` does `makepwa build` first, and then watch for changes and rebuild the project continuously.
