import Vue from "vue/dist/vue.esm";
import PartoprenantaButono from '../components/eventoj/partoprenantoj/PartoprenantaButono'

document.addEventListener("DOMContentLoaded", () => {
  if (document.getElementById("partoprenantoj")) {
    const featured = new Vue({
      el: "#partoprenantoj",
      components: {
        PartoprenantaButono
      },
    });
  }
});
