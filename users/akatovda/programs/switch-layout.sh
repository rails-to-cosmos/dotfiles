if [[ -n "$1" ]]; then
    setxkbmap $1
else
    layout=$(setxkbmap -query | grep layout | awk '{print $2}')

    case $layout in
        us)
            setxkbmap ru
            ;;
        ru)
            setxkbmap us
            ;;
        *)
            setxkbmap us
            ;;
    esac
fi
