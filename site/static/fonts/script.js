if (!localStorage.getItem("theme")) localStorage.setItem("theme", 1);

function changeVar(variable, value) {
  document.body.style.setProperty("--" + variable, value);
}

function resetVar(variable) {
  changeVar(variable, "");
}

function changeFont(font) {
  changeVar("--font", font);
  changeVar("--italic-font", font + " Italic");
}

function changeTheme() {
  localStorage.setItem("theme", 1 - localStorage.getItem("theme"));
  refreshTheme();
}

function refreshTheme() {
  if (localStorage.getItem("theme") == 1) {
    resetVar("a");
    resetVar("b");
    resetVar("c");
    resetVar("d");
    resetVar("e");
    resetVar("f");
    resetVar("g");
    resetVar("h");

    resetVar("at");
    resetVar("bt");
    resetVar("ct");
    resetVar("dt");
    resetVar("et");
    resetVar("ft");
    resetVar("gt");
    resetVar("ht");

    document.getElementById("changeTheme").innerHTML = "dark_mode";

  } else {
    changeVar("a", "#fff");
    changeVar("b", "#ddd");
    changeVar("c", "#bbb");
    changeVar("d", "#999");
    changeVar("e", "#777");
    changeVar("f", "#555");
    changeVar("g", "#333");
    changeVar("h", "#111");

    changeVar("at", "#fff0");
    changeVar("bt", "#ddd0");
    changeVar("ct", "#bbb0");
    changeVar("dt", "#9990");
    changeVar("et", "#7770");
    changeVar("ft", "#5550");
    changeVar("gt", "#3330");
    changeVar("ht", "#1110");
    
    document.getElementById("changeTheme").innerHTML = "light_mode";
  }
}

refreshTheme();