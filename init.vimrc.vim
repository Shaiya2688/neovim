" Since currently no any required features, don't actually load anything here
if v:true | finish | endif

execute 'source ' . stdpath('config') . '/vimrc/config/init.vim'
