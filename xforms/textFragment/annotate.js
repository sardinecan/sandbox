document.addEventListener('mouseup', () => handleSelection());
function handleSelection() {
    const selection = window.getSelection();

    // Vérifie s'il y a une sélection active
    if (!selection || selection.toString().trim() === "") {
        console.log("Aucune sélection.");
        return;
    }

    try {
        const selectedText = selection.toString().trim();
        const range = selection.getRangeAt(0);

        const previousChars = getPreviousCharactersFromSelection(range, 5);

        console.log("Texte sélectionné :", selectedText);
        console.log("5 caractères précédents :", previousChars);

        XsltForms_xmlevents.dispatch(document.getElementById("index"), "getSelectionInfo", null, null, null, null, {
            selectedText: encodeURI(selectedText),
            prefix: encodeURI(previousChars)
        })

    } catch (error) {
        console.error("Erreur lors de la récupération des caractères :", error);
    }
}

/**
             * Récupère les caractères précédents d'une sélection.
             * @param {Range} range - La plage (range) de la sélection.
             * @param {number} charCount - Nombre de caractères à récupérer.
             * @returns {string} Les caractères précédents.
             */
function getPreviousCharactersFromSelection(range, charCount) {
    const startContainer = range.startContainer;
    const startOffset = range.startOffset;

    // Si le conteneur de départ est un nœud texte
    if (startContainer.nodeType === Node.TEXT_NODE) {
        return getPreviousCharacters(startContainer, startOffset, charCount);
    } else {
        // Si le conteneur n'est pas texte, commence à l'offset 0
        return getPreviousCharacters(startContainer, 0, charCount);
    }
}

/**
             * Récupère un certain nombre de caractères précédents à partir d'un nœud et d'un offset.
             * Parcourt les nœuds précédents si nécessaire.
             * @param {Node} node - Le nœud à partir duquel commencer.
             * @param {number} offset - La position dans ce nœud.
             * @param {number} charCount - Nombre de caractères à récupérer.
             * @returns {string} Les caractères récupérés.
             */
function getPreviousCharacters(node, offset, charCount) {
    let chars = "";
    let remainingChars = charCount;
    let currentNode = node;
    let currentOffset = offset;

    while (currentNode && remainingChars > 0) {
        if (currentNode.nodeType === Node.TEXT_NODE) {
            const text = currentNode.textContent.slice(0, currentOffset);
            const slice = text.slice(-remainingChars);
            chars = slice + chars;
            remainingChars -= slice.length;
        }

        // Passe au nœud précédent ou remonte dans l'arbre DOM
        const previousSibling = currentNode.previousSibling;

        if (previousSibling) {
            currentNode = previousSibling;
            currentOffset = previousSibling.nodeType === Node.TEXT_NODE
                ? previousSibling.textContent.length
                : 0;
        } else {
            const parentNode = currentNode.parentNode;

            // Arrête la remontée si on atteint la racine
            if (!parentNode || parentNode === document) {
                break;
            }

            currentNode = parentNode;
            currentOffset = 0;
        }
    }

    return chars;
}
