import time
import serial
from tkinter.test.support import destroy_default_root


ser = serial.Serial('COM3', 115200)


def write_byte(d):
    # We need this to slow things down for the Z80
    d = bytearray([d])
    ser.write(d)
    time.sleep(0.01)
    
def read_byte():
    a = ser.read()
    return int(a[0])

def write_word(d):
    write_byte(d >> 8)
    write_byte(d & 0xFF)


def do_load(words):
    # LOAD file 8000
    dest = int(words[2], 16)
    with open(words[1], 'rb') as f:
        data = f.read()
        size = len(data)
        write_byte(2) # Command for WRITE
        write_word(dest)
        write_word(size)
        for d in data:
            write_byte(d)
        # Add an 'X' to execute the uploaded file
        if len(words) > 3 and words[3].upper() == 'X':
            print('executing')
            write_byte(5)
            write_word(dest)


def do_read(words):
    # READ dst [num]    
    dest = int(words[1], 16)
    if len(words)>2:
        num = int(words[2],16)
    else:
        num = 1
    
    write_byte(1)
    write_word(dest)
    write_word(num)    
    for i in range(num):
        v = read_byte()
        #print(v)
        print('{:02X} '.format(v),end='')
    print()
        


def do_write(words):
    # WRITE dst a b c d ...
    dest = int(words[1], 16)    
    num = len(words)-2
    if num>0:        
        write_byte(2)
        write_word(dest)
        write_word(num)    
        for w in words[2:]:
            write_byte(int(w,16))            


def do_in(words):
    # IN port
    dest = int(words[1],16)
    write_byte(3)
    write_byte(dest)
    v = read_byte()
    print('{:02X}'.format(v))


def do_out(words):
    # OUT port value
    dest = int(words[1],16)
    write_byte(4)
    write_byte(dest)
    write_byte(int(words[2],16))
    

def do_help(words):
    pass


def do_execute(words):
    # EXECUTE 8000
    dest = int(words[1], 16)
    write_byte(5)
    write_word(dest)
    
def do_ping(words):
    write_byte(65)
    while True:
        a = read_byte()
        print(a)


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
        do_ping(words)
        print('??')
