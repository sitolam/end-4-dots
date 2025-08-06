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
in

{

  home.packages = with pkgs; [
    screenshot-ocr
    
  ];
}