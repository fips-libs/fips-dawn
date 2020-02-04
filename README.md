# fips-dawn

[WIP] don't use this yet

This makes a locally compiled [Google Dawn SDK](https://dawn.googlesource.com/dawn)
available to fips projects as a header ```dawn/webgpu.h``` and static libraries.

## How to use:

1. Add the ```fips-dawn``` dependency to the fips.yml file of your project:

```yaml
---
imports:
  fips-dawn:
    git: https://github.com/fips-libs/fips-dawn
```

2. Fetch dependencies: ```./fips fetch```

3. Check if the new fips verb ```dawn``` is recognized: ```./fips help dawn```,
    you should see:

    ```sh
    fips dawn install
    fips dawn uninstall
        install and manage Google Dawn SDK 
    ```

4. Install and build the Dawn SDK: ```./fips dawn install```, this will 
    take a little while.

5. Use the Dawn SDK headers and libraries in your project:

    In C or C++ code:
    ```c
    #include "dawn/webgpu.h
    ```

    As lib dependency in CMakeLists.txt files:

    ```cmake
        fips_libs(libdawn_native)
    ```

    A Debug or Release build of the libraries will be automatically selected
    depending on the cmake build mode.




