local path = require 'pl.path'.abspath('..')
package.path = package.path .. ';' .. path .. '/?.lua'
local Trie = Trie or require 'trie'

require "busted"
-- local dbg = require 'debugger'

describe('Tire', function()
    io.write('\nTrie Tests: ')
    describe(':add()', function()
        it('should add a string to the trie', function()
            local trie = Trie:new()
            trie:add('hello')

            assert.are.same(trie.root, {
                h = {
                    e = {
                        l = {
                            l = {
                                o = 'hello'
                            }
                        }
                    }
                }
            })
        end)

        it('should add multiple strings to the trie via constructor', function()
            local trie = Trie:new({'hello', 'hey', 'howdy', 'bologna'})

            assert.are.same(trie.root, {
                h = {
                    e = {
                        l = {
                            l = {
                                o = 'hello'
                            }
                        },
                        y = 'hey'
                    },
                    o = {
                        w = {
                            d = {
                                y = 'howdy'
                            }
                        }
                    }
                },
                b = {
                    o = {
                        l = {
                            o = {
                                g ={
                                    n = {
                                        a = 'bologna'
                                    }
                                }
                            }
                        }
                    }
                }
            })
        end)
    end)

    describe(':find()', function()
        it('should return false if nothing found', function()
            local trie = Trie:new({'test'})

            assert.is_false(trie:find('bologna'))
            assert.is_equal(trie.partial_find, '')
        end)

        it('should return a partial match', function()
            local trie = Trie:new({'test'})

            assert.is_false(trie:find('team'))
            assert.is_equal(trie.partial_find, 'te')
        end)
    end)

    describe(':get_partial_matchings()', function()
        it('should return "hello" and "hey"', function()
            local trie = Trie:new({'hello', 'hey', 'howdy', 'bologna'})
            trie:find('hex')
    
            assert.are.same(trie:get_partial_matchings(), {'hello', 'hey'})
        end)

        it('should return false', function()
            local trie = Trie:new({'hello', 'hey', 'howdy', 'bologna'})
            
            assert.is_false(trie:get_partial_matchings('xxx'))
        end)
    end)
end)