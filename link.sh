ln -s -f $(pwd)/nvim ~/.config/nvim
ln -s -f $(pwd)/yabai ~/.config/yabai
ln -s -f $(pwd)/skhd ~/.config/skhd
ln -s -f $(pwd)/scripts ~/scripts
ln -s -f $(pwd)/kitty/kitty.conf ~/.config/kitty
ln -s -f $(pwd)/grc ~/.grc

ln -s -f $(pwd)/tmux/.tmux.conf ~/.tmux.conf
ln -s -f $(pwd)/.global-gitignore ~/.global-gitignore
ln -s -f $(pwd)/.zshrc ~/.zshrc

# nushell folder there will be removed from outside nu, otherwise it's recreated
ln -s -f "$(pwd)/nushell" "/Users/mike/Library/Application Support"
