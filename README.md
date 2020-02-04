# fips-dawn

[WIP] don't use this yet

This makes a "Google Dawn SDK" available to fips projects under ```fips-sdks/dawn```,
similar to the Emscripten SDK or Android SDK.

The SDK will be exposed to fips projects as a "webgpu/webgpu.h" header,
and a static link library to link against.

## How to use:

1. Add the ```fips-dawn``` dependency to the fips.yml file of your project:

```yaml
---
imports:
  fips-dawn:
    git: https://github.com/fips-libs/fips-dawn
```

2. Fetch dependencies: ```./fips fetch```

3. Check if the new fips verb ```dawn``` is recognized: ```./fips help dawn```

4. Install and bootstrap the Dawn SDK: ```./fips dawn install```

5. FIXME:
