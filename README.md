# mainframer-test

To install Mainframer, please follow this tutorial or compile it from scratch:

https://github.com/buildfoundation/mainframer/blob/3.x/docs/getting-started/local-machine.md#installation

You will need to setup the ssh access between your remote and local machine. You don't need Mainframer in the remote machine.

Mainframer works with `rsync` to sync the data between the machines. To test it you can:

```
./mainframer 'echo "It works" > success.txt'
$ cat success.txt
```

When running in an Android project:

```
./mainframer ./gradlew build
```