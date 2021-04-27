local BitManipulations = {}

-- Shift 1 over by i bits, creating a number that looks like 00010000.
-- By performing an AND with num, we clear all bits other than the bit at bit i.
-- Finally, we compare that to 0. If that new value is not zero, then
-- bit i must have a 1. Otherwise, bit i is a 0.
function BitManipulations.get_bit(num, i)
    return ((num & (1 << i)) ~= 0)
end

-- shifts 1 over by i bits, creating a value like 00010000. By performing
-- an OR with num, only the value at bit i will change. All other bits of the
-- mask are zero and will not affect num.
function BitManipulations.set_bit(num, i)
    return num | (1 << i)
end

-- Operates in almost the opposite of .set_bit(). First, we create a number like
-- 11101111 by creating the reverse of it (00010000) and negating it. Then, we
-- perform and AND with num. This will clear the ith bit and leave the remainder unchanged.
function BitManipulations.clear_bit(num, i)
    local mask = ~(1 << i)
    return num & mask
end

-- Clear all bits from most significant bit through i (inclusive).
-- We create a mask with a 1 at the ith bit (1 << i). Then, we subtract 1
-- from it, giving us a sequence of 0s followed by i 1s. We then AND our number
-- with this mask to leave just the last i bits.
function BitManipulations.clear_most_significant_bit_through_i(num, i)
    local mask = (1 << i) - 1
    return num & mask
end

-- To clear all bits from i through 0 (inclusive), we take a sequence of all 1s (which is -1)
-- and shift it left by i + 1 bits. This gives us a sequence of 1s (in the most significant bits)
-- followed by i 0 bits.
function BitManipulations.clear_bits_i_through_zero(num, i)
    local mask = (-1 << (i + 1))
    return num & mask
end

-- To set the ith bit to a value v, we first clear the bit at position i by using a mask that
-- looks like 11101111. Then, we shift the intended value, v, left by i bits. This will create a number
-- with bit i equal to v and all other bits equal to 0. Finally, we OR these two numbers, updating
-- the ith bit if v is 1 and leaving it as 0 otherwise.
function BitManipulations.update_bit(num, i, bit_is_1)
    local value = bit_is_1 and 1 or 0
    local mask = ~(1 << i)
    return (num & mask) | (value << i)
end

return BitManipulations