{ readFile, writeFile, copyFile, rename } = require('fs').promises

global.IO =
  read: (path) -> readFile path, 'utf-8'
  write: writeFile
  copy: copyFile
  move: rename
