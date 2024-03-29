# Variables

CC=arm-none-eabi-gcc
CFLAGS=-mcpu=cortex-m4 -mthumb -nostdlib
CPPFLAGS=-DSTM32F410Rx \
	 -Ivendor/CMSIS/Device/ST/STM32F4/Include \
	 -Ivendor/CMSIS/CMSIS/Core/Include

LINKER_FILE=linker_script.ld
LDFLAGS=-T $(LINKER_FILE)

PROGRAMMER=openocd
PROGRAMMER_FLAGS=-f interface/stlink.cfg -f target/stm32f4x.cfg

# Targets

all: blink.elf

blink.elf: main.o startup.o system_stm32f4xx.o
	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $^ -o blink.elf

main.o: main.c
	$(CC) $(CFLAGS) $(CPPFLAGS) main.c -c

startup.o: startup.c
	$(CC) $(CFLAGS) $(CPPFLAGS) startup.c -c

system_stm32f4xx.o: vendor/CMSIS/Device/ST/STM32F4/Source/Templates/system_stm32f4xx.c
	$(CC) $(CFLAGS) $(CPPFLAGS) vendor/CMSIS/Device/ST/STM32F4/Source/Templates/system_stm32f4xx.c -c

# Clean

.PHONY: clean
clean:
	rm -f *.o *.elf

# Flash the board

flash: blink.elf
	$(PROGRAMMER) $(PROGRAMMER_FLAGS) -c "program blink.elf verify reset exit"