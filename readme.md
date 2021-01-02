`makepwa` is a CLI tool for making PWAs. You can install it globally with

```
npm install makepwa -g
```

and then use

```
makepwa new NAME [TEMPLATE]
```

to create a directory named NAME and a new PWA project inside of it. For example, `makepwa new pwa0`.

Optionally, you can also pass a TEMPLATE. For example, `makepwa new pwa0 ReactMaterial` will create a project with React and Material-UI. If you don't pass a TEMPLATE, it will create a bare project without additional dependencies.

After entering the directory with `cd pwa0`, you can use `npm start` to start a development session.
