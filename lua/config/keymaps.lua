local utils = _utils
-- Add any keymaps here

--[[ Maps for Plugin Manager ]]
vim.keymap.set('n', '<C-F9>', require("config.plugin-setup").open_plugin_manager, { desc = "Open Plugin Manager" })
vim.keymap.set('n', '<F33>', require("config.plugin-setup").open_plugin_manager, { desc = "Open Plugin Manager" })  -- <C-F9> will be converted to <F33> if Neovim is not under gui running


--[[ Maps for Syntax Highlight ]]
vim.keymap.set('n', '<Leader>h', utils.hl.show_synstack, { desc = "Show Syntax Stack Under Cursor" })


--[[ Maps for Mouse Modes ]]
vim.keymap.set({'n', 'v'}, '<C-w><C-m>', utils.mouse.mode_toggle, { desc = "Toggle Mouse Mode" })
vim.keymap.set({'n', 'v'}, '<C-w>m', utils.mouse.mode_toggle, { desc = "Toggle Mouse Mode" })


--[[ Maps for Fold ]]
vim.keymap.set('n', '<Leader>f', utils.fold.column_toggle, { desc = "Toggle Fold Column" })


--[[ Maps for Window ]]
-- Move to window using <Alt> + Arrow keys
vim.keymap.set('n', '<A-Left>', "<C-w><Left>", { desc = "Go to Left Window" })
vim.keymap.set('n', '<A-Right>', "<C-w><Right>", { desc = "Go to Right Window" })
vim.keymap.set('n', '<A-Up>', "<C-w><Up>", { desc = "Go to Upper Window" })
vim.keymap.set('n', '<A-Down>', "<C-w><Down>", { desc = "Go to Lower Window" })
vim.keymap.set('n', '<A-Left>', "<C-w><Left>", { desc = "Go to Left Window" })
-- Resize window using <Shift> + <Alt> + Arrow keys
vim.keymap.set('n', '<S-A-Left>', "<C-w><", { desc = "Decrease Window Width" })
vim.keymap.set('n', '<S-A-Right>', "<C-w>>", { desc = "Increase Window Width" })
vim.keymap.set('n', '<S-A-Up>', "<C-w>+", { desc = "Increase Window Height" })
vim.keymap.set('n', '<S-A-Down>', "<C-w>-", { desc = "Decrease Window Height" })
-- Create a new window Horizontally or Vertically using <C-w> + 'n' or 'N'
vim.keymap.set('n', '<C-w>n', "<Cmd>new<Cr>", { desc = "New Window (Horizontally)" })
vim.keymap.set('n', '<C-w>N', "<Cmd>vnew<Cr>", { desc = "New Window (Vertically)" })
-- Split window Horizontally or Vertically using <C-w> + 's' or 'v'
vim.keymap.set('n', '<C-w>s', "<Cmd>split<Cr>", { desc = "Split Window (Horizontally)" })
vim.keymap.set('n', '<C-w>v', "<Cmd>vsplit<Cr>", { desc = "Split Window (Vertically)" })
-- Exchange window using <C-w> + <C-x>/'H'/'J'/'K'/'L' keys


--[[ Maps for multiple Tab Pages ]]
-- New tab page
-- Create a tab page using <C-w> + 't'
vim.keymap.set('n', '<C-w><C-t>', "<Cmd>tabnew<Cr>", { desc = "New Tab Page" })
vim.keymap.set('n', '<C-w>t', "<Cmd>tabnew<Cr>", { desc = "New Tab Page" })
-- Switch to next/previous tab page using gt/gT or <C-S-Down>/<C-S-Up>
-- switch to the specified tab page using {number}gt or {number}<C-S-Down>
-- Switch to last accesed tab page using g<Tab>
-- Move tab page
vim.keymap.set('n', '>', "<Cmd>silent! +tabmove<Cr>", { desc = "Move Tab Page to Right" })
vim.keymap.set('n', '<', "<Cmd>silent! -tabmove<Cr>", { desc = "Move Tab Page to Left" })


--[[ Maps for Buffers ]]
-- Switch to alternate buffer using <C-^> (Mostly is the previously edited buffer, which with '#' flag in result of the command ':ls!' )
vim.keymap.set('n', '[b', "<Cmd>bprevious<Cr>", { desc = "Prev Buffer" })
vim.keymap.set('n', ']b', "<Cmd>bnext<Cr>", { desc = "Next Buffer" })


--[[ Maps for Buffer contents ]]
-- Move lines
vim.keymap.set('n', '<C-Down>', "<Cmd>execute 'move .+' . (v:count1)<Cr>", { desc = "Move Down" })
vim.keymap.set('n', '<C-Up>', "<Cmd>execute 'move .-' . (v:count1 + 1)<Cr>", { desc = "Move Up" })
vim.keymap.set('i', '<C-Down>', "<Esc><Cmd>move .+1<Cr>gi", { desc = "Move Down" })
vim.keymap.set('i', '<C-Up>', "<Esc><Cmd>move .-2<Cr>gi", { desc = "Move Up" })
-- Move selected virsual block
vim.keymap.set('v', '<C-Down>', ":<C-u>execute \"'<,'>move '>+\" . (v:count1)<Cr>gv", { desc = "Move Down" })
vim.keymap.set('v', '<C-Up>', ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<Cr>gv", { desc = "Move Up" })
vim.keymap.set('v', '>', ">gv", { desc = "Move Right" })
vim.keymap.set('v', '<', "<gv", { desc = "Move Left" })


--[[ Maps for Terminal ]]
-- Close or Open terminal in new window using <C-_> or <C-/>
vim.keymap.set({ 'n', 't' }, '<C-_>', function()
	local cmd
	if vim.opt.buftype:get() ~= 'terminal' then
		cmd = "horizontal terminal" .. ((vim.fn.executable('bash') and " bash") or "")
	else
		cmd = "quit"
	end
	vim.cmd(cmd)
end, { desc = "Open / Close Terminal", silent = true })
-- Open terminal in new tab page or floating window, should using above key combined with <C-t> or <C-f>
vim.keymap.set('n', '<C-_><C-t>', "<Cmd>execute 'tab terminal' . (executable('bash') ? ' bash' : '')<Cr>", { desc = "Open Terminal in New Tab Page", silent = true })
-- TODO: support floating terminal
vim.keymap.set('n', '<C-_><C-f>', "<Cmd>execute 'tab terminal' . (executable('bash') ? ' bash' : '')<Cr>", { desc = "Open Terminal in Float Window", silent = true })
-- Enter terminal normal mode using '<Esc> twice or scroll the mouse wheel
vim.keymap.set('t', '<Esc><Esc>', "<C-\\><C-n>", { desc = 'Enter Terminal Normal Mode' })
-- Exit terminal normal mode using 'i'/'I'/'a'/'A' keys


if true then return {} end


--[[

"Help key map for show defined commands"
"TODO: <C-Fxx>/<S-Fxx>/<A-Fxx> not support in nvim
nmap <silent> <C-F1> :call HelpCmdInfo()<cr>

"select block shortcuts setting
nmap <Space>q	vab
nmap <Space>w	vaB
nmap <Space>e	v%



"Quickfix window shortcuts setting
nn <silent> <F5> :if !JumpWinInvalid()\|cp\|endif<cr>
nn <silent> <F6> :if !JumpWinInvalid()\|cn\|endif<cr>
nn <silent> <F8> :call QuickfixWinToggle()<cr>

"search shortcuts setting
vn <silent> <F2> "9y:call TextStr_Search("t0", @9)<cr>
nn <silent> <F2> :call TextStr_Search("t0", expand("<cword>"))<cr>
vn <silent> <C-F2> "9y:call JumpStack_DoJump('TextStr_Search', "t0", @9)<cr>
nn <silent> <C-F2> :call JumpStack_DoJump('TextStr_Search', "t0", expand("<cword>"))<cr>
vn <silent> <F3> "9y:call JumpStack_DoJump('TextStr_Search', "t1", @9)<cr>
nn <silent> <F3> :call JumpStack_DoJump('TextStr_Search', "t1", expand("<cword>"))<cr>
nn <silent> <C-F3> :call JumpStack_DoJump('TextStr_Search', "t1")<cr>
vn <silent> <F4> "9y:call JumpStack_DoJump('TextStr_Search', "t2", @9)<cr>
nn <silent> <F4> :call JumpStack_DoJump('TextStr_Search', "t2", expand("<cword>"))<cr>
nn <silent> <C-F4> :call JumpStack_DoJump('TextStr_Search', "t2")<cr>

"TAGS file setting
"auto loading tags and cscope.out
autocmd VimEnter,BufRead * call UpdateTagConnection()
"update tags and cscope.out associated with current edit file
nmap <leader>t :call UpdateTagFile()<CR>

"VIM cscope setting
"for quickfix use <C-b> to search previous, <C-f> to search next, <C-t> to go back search, <C-l> to toggle results window on/off
"TODO: cscope not support in nvim
nmap <silent> ffs :call JumpStack_DoJump('Cscope_Search', "s", expand("<cword>"))<cr>
nmap <silent> ffg :call Cscope_Search("g", expand("<cword>"))<cr>
nmap <silent> ffc :call JumpStack_DoJump('Cscope_Search', "c", expand("<cword>"))<cr>
nmap <silent> ffi :call JumpStack_DoJump('Cscope_Search', "i", expand("<cword>"))<cr>
nmap <silent> fff :call JumpStack_DoJump('Cscope_Search', "f", expand("<cword>"))<cr>
nmap <silent> fft :call JumpStack_DoJump('Cscope_Search', "t", expand("<cword>"))<cr>
nmap <silent> ffe :call JumpStack_DoJump('Cscope_Search', "e", expand("<cword>"))<cr>
nmap <silent> ffa :call JumpStack_DoJump('Cscope_Search', "a", expand("<cword>"))<cr>
nmap <silent> ffd :call JumpStack_DoJump('Cscope_Search', "d", expand("<cword>"))<cr>
vmap <silent> ffs "9y:call JumpStack_DoJump('Cscope_Search', "s", @9)<cr>
vmap <silent> ffg "9y:call Cscope_Search("g", @9)<cr>
vmap <silent> ffc "9y:call JumpStack_DoJump('Cscope_Search', "c", @9)<cr>
vmap <silent> ffi "9y:call JumpStack_DoJump('Cscope_Search', "i", @9)<cr>
vmap <silent> fff "9y:call JumpStack_DoJump('Cscope_Search', "f", @9)<cr>
vmap <silent> fft "9y:call JumpStack_DoJump('Cscope_Search', "t", @9)<cr>
vmap <silent> ffe "9y:call JumpStack_DoJump('Cscope_Search', "e", @9)<cr>
vmap <silent> ffa "9y:call JumpStack_DoJump('Cscope_Search', "a", @9)<cr>
vmap <silent> ffd "9y:call JumpStack_DoJump('Cscope_Search', "d", @9)<cr>
nmap <silent> ffrs :call JumpStack_DoJump('Cscope_Search', "s")<cr>
nmap <silent> ffrg :call Cscope_Search("g")<cr>
nmap <silent> ffrc :call JumpStack_DoJump('Cscope_Search', "c")<cr>
nmap <silent> ffri :call JumpStack_DoJump('Cscope_Search', "i")<cr>
nmap <silent> ffrf :call JumpStack_DoJump('Cscope_Search', "f")<cr>
nmap <silent> ffrt :call JumpStack_DoJump('Cscope_Search', "t")<cr>
nmap <silent> ffre :call JumpStack_DoJump('Cscope_Search', "e")<cr>
nmap <silent> ffra :call JumpStack_DoJump('Cscope_Search', "a")<cr>
nmap <silent> ffrd :call JumpStack_DoJump('Cscope_Search', "d")<cr>

"VIM tags setting
let g:jumpstack_disable_default_tag_highlight = 0
" set <C-]> check &cst option, g<C-]> use default tags file, use g<LeftMouse> as an alternative to <C-LeftMouse> for some terminals
nn <silent> <C-]> :call Tag_Search(v:false)<CR>
nn <silent> g<C-]> :call Tag_Search(v:true)<CR>
nn <silent> <C-LeftMouse> <LeftMouse>:call Tag_Search(v:false)<CR>
nn <silent> g<LeftMouse> <LeftMouse>:call Tag_Search(v:false)<CR>
vn <silent> <C-]> "9y:call Tag_Search(v:false, @9)<CR>
vn <silent> g<C-]> "9y:call Tag_Search(v:true, @9)<CR>
vn <silent> <C-LeftMouse> "9y:call Tag_Search(v:false, @9)<CR>
vn <silent> g<LeftMouse> "9y:call Tag_Search(v:false, @9)<CR>
map <silent> <C-RightMouse> :<c-u>call JumpStack_GoBack()<cr>
map <silent> g<RightMouse> :<c-u>call JumpStack_GoBack()<cr>
map <silent> <C-t> :<c-u>call JumpStack_GoBack()<cr>
nn <silent> <C-l> :call JumpStack_Select()<cr>
nn <silent> <c-b> :call JumpStack_Previous()<cr>
nn <silent> <c-f> :call JumpStack_Next()<cr>
set autochdir "$PWD is auto change to directory of jump


nmap <silent> <F9> :PlugStatus<cr>
nmap <silent> <C-F9> :PlugInstall<cr>
nmap <silent> <S-F9> :PlugUpdate<cr>
nmap <silent> <A-F9> :PlugClean<cr>

au BufNewFile,BufReadPost * call LoadingFileTypeSetting()


nmap <silent> <leader>5 :RainbowToggle<cr>
nmap <silent> , :call TagbarToggleSingleWin()<cr>

"Plug 'ctrlpvim/ctrlp.vim' <c-p>? for help
let g:ctrlp_map = '<c-p>'

"Plug 'airblade/vim-gitgutter' | Plug 'tpope/vim-fugitive'
let g:gitgutter_enabled = 1
" let g:gitgutter_preview_win_floating = 1

nmap <silent> <S-F8> :SrcExplToggle<cr>
let g:SrcExpl_prevDefKey = "<S-F5>"    "Set \"<S-F5>\" key for displaying the previous definition in the jump list
let g:SrcExpl_nextDefKey = "<S-F6>"    "Set \"<S-F6>\" key for displaying the next definition in the jump list

]]



-- DO NOT USE `LazyVim.safe_keymap_set` IN YOUR OWN CONFIG!!
-- use `vim.keymap.set` instead
local map = LazyVim.safe_keymap_set




--keywordprg
map("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })


-- lazy
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- location list
map("n", "<leader>xl", function()
  local success, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = "Location List" })

-- quickfix list
map("n", "<leader>xq", function()
  local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = "Quickfix List" })



-- lazygit
if vim.fn.executable("lazygit") == 1 then
  map("n", "<leader>gg", function() Snacks.lazygit( { cwd = LazyVim.root.git() }) end, { desc = "Lazygit (Root Dir)" })
  map("n", "<leader>gG", function() Snacks.lazygit() end, { desc = "Lazygit (cwd)" })
  map("n", "<leader>gf", function() Snacks.picker.git_log_file() end, { desc = "Git Current File History" })
  map("n", "<leader>gl", function() Snacks.picker.git_log({ cwd = LazyVim.root.git() }) end, { desc = "Git Log" })
  map("n", "<leader>gL", function() Snacks.picker.git_log() end, { desc = "Git Log (cwd)" })
end

map("n", "<leader>gb", function() Snacks.picker.git_log_line() end, { desc = "Git Blame Line" })
map({ "n", "x" }, "<leader>gB", function() Snacks.gitbrowse() end, { desc = "Git Browse (open)" })
map({"n", "x" }, "<leader>gY", function()
  Snacks.gitbrowse({ open = function(url) vim.fn.setreg("+", url) end, notify = false })
end, { desc = "Git Browse (copy)" })



-- LazyVim Changelog
map("n", "<leader>L", function() LazyVim.news.changelog() end, { desc = "LazyVim Changelog" })

-- floating terminal
map("n", "<leader>fT", function() Snacks.terminal() end, { desc = "Terminal (cwd)" })
map("n", "<leader>ft", function() Snacks.terminal(nil, { cwd = LazyVim.root() }) end, { desc = "Terminal (Root Dir)" })
map("n", "<c-/>",      function() Snacks.terminal(nil, { cwd = LazyVim.root() }) end, { desc = "Terminal (Root Dir)" })
map("n", "<c-_>",      function() Snacks.terminal(nil, { cwd = LazyVim.root() }) end, { desc = "which_key_ignore" })

-- Terminal Mappings
map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
map("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })


