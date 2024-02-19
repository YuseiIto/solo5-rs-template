# Comment out to use local toolchain.
USE_DOCKER := true

# Must be as same as `name` on `Cargo.toml`
LIBNAME:= my_solo5_rs_project

include ./solo5_rs.mk
