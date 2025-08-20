dirToWatch=${PROJECTS_AND_ART_DIR::-3}
while inotifywait -r -e modify,create,delete,move "$dirToWatch/arch-config-private/dotfiles/.config"; do
   cp -r "$dirToWatch/arch-config-private/dotfiles/.config/." "$HOME/.config/"
done
