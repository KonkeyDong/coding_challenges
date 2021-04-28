local path = require 'pl.path'.abspath('..')
package.path = package.path .. ';' .. path .. '/?.lua'
local BitManip = BitManipulations or require 'bit_manipulations'
local Queue = Queue or require 'queue'

-- local dbg = require 'debugger'

local SAMPLE_NUMBER = 73 -- 01001001 in binary

describe('BitManipulations', function()
    io.write('\nBitManipulations Tests: ')
    
    describe('.get_bit()', function()
        it('should return true on 1, false on 0', function()
            local queue_data = { true, false, false, true, false, false, true, false} -- 01001001 in reverse, in booleans
            local queue = Queue:new(queue_data)
            
            compare(queue, BitManip.get_bit)
        end)
    end)

    describe('.set_bit()', function()
        it('should set the bit', function()
            local queue = Queue:new({
                tonumber('01001001', 2),
                tonumber('01001011', 2),
                tonumber('01001101', 2),
                tonumber('01001001', 2),

                tonumber('01011001', 2),
                tonumber('01101001', 2),
                tonumber('01001001', 2),
                tonumber('11001001', 2)
            })

            compare(queue, BitManip.set_bit)
        end)
    end)

    describe('.clear_bit()', function()
        it('should clear the bit', function()
            local queue = Queue:new({
                tonumber('01001000', 2),
                tonumber('01001001', 2),
                tonumber('01001001', 2),
                tonumber('01000001', 2),

                tonumber('01001001', 2),
                tonumber('01001001', 2),
                tonumber('00001001', 2),
                tonumber('01001001', 2)
            })

            compare(queue, BitManip.clear_bit)
        end)
    end)

    describe('.clear_most_significant_bit_through_i()', function()
        it('should clear bits from left to i', function()
            local queue = Queue:new({
                tonumber('00000000', 2),
                tonumber('00000001', 2),
                tonumber('00000001', 2),
                tonumber('00000001', 2),

                tonumber('00001001', 2),
                tonumber('00001001', 2),
                tonumber('00001001', 2),
                tonumber('01001001', 2)
            })

            compare(queue, BitManip.clear_most_significant_bit_through_i)
        end)
    end)

    describe('.clear_bits_i_through_zero()', function()
        it('should clear bits from i to least significant bit', function()
            local queue = Queue:new({
                tonumber('01001000', 2),
                tonumber('01001000', 2),
                tonumber('01001000', 2),
                tonumber('01000000', 2),

                tonumber('01000000', 2),
                tonumber('01000000', 2),
                tonumber('00000000', 2),
                tonumber('00000000', 2)
            })

            compare(queue, BitManip.clear_bits_i_through_zero)
        end)
    end)

    describe('.update_bit()', function()
        function compare_update_bit(queue, flag)
            for i = 0, 7 do
                local result = BitManip.update_bit(SAMPLE_NUMBER, i, flag)
                local expected_result = queue:remove()
                assert.is_equal(result, expected_result)
            end
        end

        it('should set the bit to 1 if the 1s flag is true', function()
            local queue = Queue:new({
                tonumber('01001001', 2),
                tonumber('01001011', 2),
                tonumber('01001101', 2),
                tonumber('01001001', 2),

                tonumber('01011001', 2),
                tonumber('01101001', 2),
                tonumber('01001001', 2),
                tonumber('11001001', 2)
            })

            compare_update_bit(queue, true)
        end)

        it('should set the bit to 0 if the 1s flag is false', function()
            local queue = Queue:new({
                tonumber('01001000', 2),
                tonumber('01001001', 2),
                tonumber('01001001', 2),
                tonumber('01000001', 2),

                tonumber('01001001', 2),
                tonumber('01001001', 2),
                tonumber('00001001', 2),
                tonumber('01001001', 2)
            })

            compare_update_bit(queue, false)
        end)
    end)

    describe('.cleared_bits_in_range_mask()', function()
        it('should return mask 1111111100011 (8163)', function()
            local result = BitManip.clear_bits_in_range_mask(8, 2, 4)
            assert.is_equal(8163, result)
        end)

        it('should return nil if the bit_size field is less than 1', function()
            local result = BitManip.clear_bits_in_range_mask(0, 2, 4)
            assert.is_nil(result)
        end)
    end)

    describe('.decimal_to_binary()', function()
        it('should return 11111111', function()
            local result = BitManip.decimal_to_binary(255)
            assert.is_equal("11111111", result)
        end)

        it('should return nil if the number parameter is not a number', function()
            local result = BitManip.decimal_to_binary("bologna")
            assert.is_nil(result)
        end)
    end)

    describe('.binary_to_decimal', function()
        it('should return 255 from input "11111111"', function()
            local result = BitManip.binary_to_decimal("11111111")
            assert.is_equal(255, result)
        end)

        it('should return nil if input is not a string', function()
            local result = BitManip.binary_to_decimal(255)
            assert.is_nil(result)
        end)
    end)
end)

function compare(queue, func)
    for i = 0, 7 do
        local result = func(SAMPLE_NUMBER, i)
        local expected_result = queue:remove()
        assert.is_equal(result, expected_result)
    end
end