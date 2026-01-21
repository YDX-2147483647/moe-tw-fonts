just := quote(just_executable()) + " --justfile " + quote(justfile())

# List available recipes
list:
    @just --list

# Extract names from a font file
[no-cd]
[private]
@ttx file nameID:
    ttx -q -t name -o - {{ quote(file) }} \
      | yq '[ .ttFont.name.namerecord[] | select(."+@nameID" == "{{ nameID }}") ]' \
        --input-format xml --output-format tsv

# Name IDs:
# 1. Font Family name
# 5. Version string
# 6. PostScript name
# https://learn.microsoft.com/en-us/typography/opentype/spec/name#name-ids

# Inspect the version of a font file
[no-cd]
v file: (ttx file "5")

# Inspect names of a font file
[no-cd]
name file:
    # Font Family names in different languages
    @{{ just }} ttx {{ file }} "1"
    # PostScript names
    @{{ just }} ttx {{ file }} "6"

# Update hashes of font files
[group("hash")]
update-hash:
    sha256sum --binary fonts/*.ttf > fonts.sha256

# Verify hashes of font files
[group("hash")]
check-hash:
    sha256sum --check fonts.sha256
