import Vue from "vue/dist/vue.esm";
import InstruadoForm from "../components/uzantoj/InstruadoForm";
import PrelegoForm from '../components/uzantoj/PrelegoForm'

document.addEventListener("DOMContentLoaded", () => {
  if (document.getElementById("profilo")) {
    const featured = new Vue({
      el: "#profilo",
      components: {
        InstruadoForm,
        PrelegoForm
      },
    });
  }
});
