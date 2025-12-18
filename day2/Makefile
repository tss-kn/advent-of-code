AS := nasm
LD := x86_64-elf-ld

QEMU := qemu-system-x86_64
QEMU_FLAGS := -s -S

build: clean build_dir
	$(AS) -f bin init.asm -o build/obj/init.bin
	$(AS) -f elf32 -g -F dwarf day2.asm -o build/obj/day2.o

	$(LD) -m elf_i386 -T link.ld build/obj/day2.o -o build/obj/day2.elf
	x86_64-elf-objcopy -O binary build/obj/day2.elf build/obj/day2.bin

	cat build/obj/init.bin build/obj/day2.bin > build/day2.bin

run: 
	$(QEMU) build/day2.bin

debug:
	$(QEMU) $(QEMU_FLAGS) build/day2.bin	

build_dir:
	@mkdir -p build/obj

clean:
	rm -rf build