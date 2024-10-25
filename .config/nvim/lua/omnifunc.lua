vim.cmd [[
function! OpenCompletion()
    if !pumvisible() && ((v:char >= 'a' && v:char <= 'z') || (v:char >= 'A' && v:char <= 'Z'))
        call feedkeys("\<C-x>\<C-o>", "n")
    endif
endfunction
]]

vim.cmd("set omnifunc=syntaxcomplete#Complete")
vim.cmd("set completeopt+=menuone,noselect,noinsert")
vim.cmd("autocmd InsertCharPre * call OpenCompletion()")
vim.cmd("autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif")

vim.keymap.set('i', '<C-o>', '<C-x><C-o>') -- Opens Omnicomplete manually
