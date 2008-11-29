function toggleCodeCollapse (eltID) {
    var elt = document.getElementById(eltID);
    if (elt.className.match(/\btmcode-collapsed\b/)) {
        elt.className = elt.className.replace(/ ?\btmcode-collapsed\b/, "");
    } else {
        elt.className += " tmcode-collapsed";
    }
}
