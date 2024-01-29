#! /usr/bin/env python3
''' From The Art of Computer Programming, Vol 1, pg 161 (or so), an 
    algorithm to construct magic squares.
'''

def make_magic_array(side=9, squared=81, base=2000):
    ''' Create an magic square of given size, stored as an array in memory.
    
        Arguments:
        side -- size of one side of the resulting magic square
        squared -- the square of size (so we don't have to do * in ASM)
        base -- the address of the first element of the magic square
        
        Returns:
        a dictionary.  Key is address as an integer.  Value is data as integer.
    '''
    # initialize memory to zero values
    memory = {}
    for i in range(squared):
        memory[base + 2*i] = 0
    
    # Set a column and row pointer to the square just below center
    col = side // 2
    row = side // 2 + 1
    
    # Insert the numbers 1..n^2
    for i in range(1,squared+1):
        # Insert the number into memory, using current row/col pointers
        memory[base + 2 * (row * side + col)] = i
        
        # Update the row/col pointers to right and down, ensuring
        #   they stay within the square
        next_col = (col + 1) 
        if next_col >= side:
            next_col -= side
        next_row = (row + 1) 
        if next_row >= side:
            next_row -= side
            
        # Check if the updated row/col pointers indicate an already filled cell
        if memory[base + 2 * (next_row * side + next_col)] == 0:
            col = next_col
            row = next_row
        else: 
            row += 2  # if they do, just drop the row by 2
            if row >= side:
                row -= side
    return memory
    
def main():
    base = 2 * 16 ** 3  # i.e. $2000
    m = make_magic_array(base=base)
    for a in range(81):
        address = base + 2 * a
        data = m[address]
        print(f'M[{address:x}] = {data:x}') # Print array in hexadecimal          

if __name__ == "__main__":
    main()