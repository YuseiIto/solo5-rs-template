# solo5-rs-template
Solo5-rs Unikernel template


### Getting Started
1. Copy files from [The template repository](https://github.com/YuseiIto/solo5-rs-template)
2. Rename project by updating `name` on `Cargo.toml` and `LIBNAME` on `Makefile`
3. If you don't have solo5 toolchain locally, [install it](https://github.com/Solo5/solo5/blob/master/docs/building.md#building-solo5) or enable docker by adding following on Makefile.

```
USE_DOCKER = true
```

*Note: You can only build the project and can't run the artifact with dockerized toolchain.*

5. Build

Run `make` and confirm that the artifact `kernel.hvt` is generated.

4. Happy hacking!

You can start coding by updating `src/lib.rs`

For examlple, following code makes a example of simple "Hello World" unikernel.

```rust
#![feature(format_args_nl)]
#![feature(lang_items)]
#![cfg_attr(not(test), no_std)]

use solo5_rs::consoleln;

#[solo5_rs::main]
fn main() {
    consoleln!("Hello,World");
}
```

**You can find more examples at [solo5-rs/examples](https://github.com/YuseiIto/solo5-rs/tree/main/solo5-rs/examples)**

