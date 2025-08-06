{config, pkgs, ...}:

let
  screenshot-ocr = pkgs.writeShellScriptBin "screenshot-ocr" ''
    # Capture the screen
    grim -g "$(slurp $SLURP_ARGS)" "tmp.png" 

    # Check if grim succeeded
    if [[ $? -ne 0 ]]; then
        notify-send "Error" "Failed to capture the screenshot."
        exit 1
    fi

    # Run Tesseract to extract text
    OUTPUT_TEXT=$(tesseract "tmp.png" -)

    # Check if tesseract succeeded
    if [[ $? -ne 0 ]]; then
        notify-send "Error" "Failed to run Tesseract."
        rm "tmp.png" # Clean up
        exit 1
    fi

    # Copy the extracted text to clipboard
    echo "$OUTPUT_TEXT" | wl-copy


    SAFE_TEXT=$(echo "$OUTPUT_TEXT" | sed 's/^/\\/')

    # Send notification without the image since notify-send doesn't support image + text in that way
    notify-send -a 't1' -i "dialog-information" "OCR" "$SAFE_TEXT"

    # Remove the temporary screenshot
    rm "tmp.png"
    '';

    spotify-cava = pkgs.writeShellScriptBin "spotify-cava" ''
      if [ $# -eq 0 ] ; then
          echo "usage: ./spotify.sh <spotify-title>"
          exit 1
      else
          spotifyTitle="$1"
      fi


      hyprctl dispatch focusworkspaceoncurrentmonitor 10

      if [ -z "$(hyprctl clients | grep "$spotifyTitle" | grep -v "grep" | grep -v "./spotify.sh")" ]; then
          hyprctl dispatch movecursor 0 0 

          kitty --title "spotify cava" sh -c "exit"
          kitty --title "spotify cava" sh -c "cava" &
          sleep 0.5
          hyprctl --batch "dispatch focuswindow 'initialtitle:(spotify cava)' ; dispatch togglefloating ; dispatch resizeactive exact 50% 55% ;  dispatch centerwindow 1 ; dispatch moveactive 70% 60%"
          

          spotify &
          sleep 1
          until [ ! -z "$(hyprctl clients | grep "$spotifyTitle" | grep -v "grep" | grep -v "./spotify.sh")" ] 
          do
          echo "" 
          done
          hyprctl --batch "dispatch focuswindow "initialtitle:$spotifyTitle" ; dispatch togglefloating ; dispatch resizeactive exact 50% 55% ; dispatch centerwindow 1 ; dispatch moveactive -70% -60%" 
          sleep 3
          playerctl play-pause
      fi
    '';
in

{

  home.packages = with pkgs; [
    screenshot-ocr
    spotify-cava
  ];
}