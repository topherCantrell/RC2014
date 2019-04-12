import time

from pylint.test.test_import_graph import dest
import serial


ser = serial.Serial('COM3', 115200)


def write_byte(d):
    # We need this to slow things down for the Z80
    d = bytearray([d])
    ser.write(d)
    time.sleep(0.01)


def write_word(d):
    write_byte(d >> 8)
    write_byte(d & 0xFF)


def do_load(words):
    # LOAD file 8000
    dest = int(words[2], 16)
    with open(words[1], 'rb') as f:
        data = f.read()
        size = len(data)
        write = _byte(2)  # Command for WRITE
        write_word(dest)
        write_word(size)
        for d in data:
            write_byte(d)
        # Add an 'X' to execute the uploaded file
        if len(words) > 3 and words[3].upper() == 'X':
            write_byte(5)
            write_word(dest)


def do_read(words):
    pass


def do_write(words):
    pass


def do_in(words):
    pass


def do_out(words):
    pass


def do_help(words):
    pass


def do_execute(words):
    # EXECUTE 8000
    dest = int(words[1], 16)
    write_byte(5)
    write_word(dest)


while True:
    cmd = input('> ').strip()
    while True:
        g = cmd.replace('  ', ' ')
        if g == cmd:
            break
        cmd = g

    if not cmd:
        continue

    words = cmd.split(' ')

    cmd = words[0].upper()

    if cmd == 'LOAD':
        do_load(words)
    elif cmd == 'READ':
        do_read(words)
    elif cmd == 'WRITE':
        do_write(words)
    elif cmd == 'IN':
        do_in(words)
    elif cmd == 'OUT':
        do_out(words)
    elif cmd == 'EXECUTE':
        do_execute(words)
    elif cmd == 'HELP':
        do_help(words)
    elif cmd == 'QUIT' or cmd == 'EXIT':
        break
    else:
        print('??')
