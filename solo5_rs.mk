ifndef LIBNAME
	$(error Set LIBNAME before importing solo5_rs.mk)
endif

ifndef HVT_ARGS
	HVT_ARGS:= --mem=1024
endif

ifdef USE_DOCKER
DOCKER_PREFIX:= docker run -v `pwd`:`pwd` -w `pwd` solo5:latest
endif

CC:=  $(DOCKER_PREFIX) x86_64-solo5-none-static-cc
LD:= $(DOCKER_PREFIX) x86_64-solo5-none-static-ld
HVT:=  solo5-hvt
ELFTOOL := $(DOCKER_PREFIX) solo5-elftool
KERNEL_PATH := kernel.hvt
CARGO := cargo +nightly
CARGO_FLAGS := -Zbuild-std --target x86_64-unknown-none
LIB_KERNEL := target/x86_64-unknown-none/debug/lib$(LIBNAME).a
DOCKER := docker

ifdef USE_DOCKER
	SOLO5_DIR := /workspace/solo5
	REQUIRE_DOCKER := .image-built
endif

BINDINGS := $(SOLO5_DIR)/bindings/lib.o


kernel: manifest.o $(LIB_KERNEL) $(REQUIRE_DOCKER)
	$(LD) -z solo5-abi=hvt -o $(KERNEL_PATH) $(LIB_KERNEL) manifest.o 

$(LIB_KERNEL): src/**.rs src/*.rs Cargo.toml
	$(CARGO) build $(CARGO_FLAGS) 

manifest.c: manifest.json  $(REQUIRE_DOCKER)
	$(ELFTOOL) gen-manifest manifest.json manifest.c

manifest.o: manifest.c  $(REQUIRE_DOCKER)
	$(CC) -z solo5-api=hvt -c -o manifest.o manifest.c

.PHONY: build # yet another alias for 'make kernel'
build: kernel


image: .image-built
.image-built: Dockerfile
	$(DOCKER) build -t solo5:latest .
	touch .image-built

.PHONY: run
run: ${BLOCK}
	$(HVT) $(HVT_ARGS) -- $(KERNEL_PATH) $(RUN_ARGS)

.PHONY: dev
dev: kernel run

.PHONY: clean
clean:
	cargo clean
	rm -f *.hvt manifest.c manifest.o .image-built Cargo.lock
