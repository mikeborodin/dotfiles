ln -s -f $(pwd)/nvim ~/.config/nvim
ln -s -f $(pwd)/wezterm ~/.config/wezterm
ln -s -f $(pwd)/skhd ~/.config/skhd
ln -s -f $(pwd)/scripts ~/scripts
ln -s -f $(pwd)/kitty/kitty.conf ~/.config/kitty
ln -s -f $(pwd)/grc ~/.grc
ln -s -f $(pwd)/.global-gitignore ~/.global-gitignore
ln -s -f $(pwd)/.zshrc ~/.zshrc
ln -s -f $(pwd)/mise ~/.config/mise

ln -s -f $(pwd)/environment-launch-agent.plist ~/Library/LaunchAgents/environment-launch-agent.plist

# nushell folder there will be removed from outside nu, otherwise it's recreated
ln -s -f "$(pwd)/nushell" "/Users/mike/Library/Application Support"
