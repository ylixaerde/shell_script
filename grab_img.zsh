#!/bin/zsh

# Vérifie le nombre d'arguments et définit les valeurs par défaut
if [[ $# -eq 0 || $# -gt 2 ]]; then
    echo "Usage: $0 <start_dir> [<output_file>]"
    exit 1
elif [[ $# -eq 1 ]]; then
    start_dir="$1"
    output_file="grab_img.out" # Utilise grab_img.out comme fichier de sortie par défaut
else
    start_dir="$1"
    output_file="$2"
fi

walk_dir () {  
    # Stocker le répertoire actuel dans une variable locale
    local current_dir="$1"
    # Parcourir les éléments dans le répertoire actuel
    for pathname in "$current_dir"/*(N); do
        # Si le chemin est un répertoire, récursivement appelez walk_dir
        if [ -d "$pathname" ]; then
            walk_dir "$pathname"
        else
            # Si le fichier a une extension jpg, jpeg, png ou gif, recherche les fichiers avec les extensions spécifiées dans le répertoire spécifié et ses sous-répertoires, puis ajoute les résultats à un fichier de sortie $output_file.
            find "$pathname" -type f ( -name '*.jpg' -o -name '*.jpeg' -o -name '*.gif' -o -name '*.png' ) >> "$output_file"
        fi
    done
}

# Réinitialise le fichier de sortie s'il existe déjà
: > "$output_file"

# Lance la fonction récursive pour parcourir les dossiers
walk_dir "$start_dir"

# Trie le fichier de sortie par ordre alphabétique
sort -o "$output_file" "$output_file"

# Affiche le résultat
cat "$output_file"

echo "Le programme a terminé avec succès."
