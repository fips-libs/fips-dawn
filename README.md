# fips-dawn

[WIP] don't use this yet

This makes a locally compiled [Google Dawn SDK](https://dawn.googlesource.com/dawn)
available to fips projects as a header `webgpu/webgpu.h` and static libraries
`webgpu_dawn`, `webgpu_glfw` and `webgpu_cpp`.

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

4. Install and build the Dawn SDK: ```./fips dawn install```, this will  take a little while.

5. In your toplevel CMakeLists.txt files, before fips_setup(), define the
   variable USE_DAWN_SDK (if your build targets are not actually using
   the DAWN SDK it's better to set this to OFF so that no additional
   library search paths will be added to the project):

   ```cmake
       set(USE_DAWN_SDK ON)
   ```

6. Use the Dawn SDK headers and libraries in your project:

    In C or C++ code:
    ```c
    #include <webgpu/webgpu.h>
    ```

    As lib dependency in CMakeLists.txt files:

    ```cmake
        fips_libs(webgpu_dawn)
    ```

    (and optionally also `webgpu_glfw` and `webgpu_cpp`)

    A Debug or Release build of the libraries will be automatically selected
    depending on the cmake build mode.
