<template>
  <div>
    <div class="lead">Kiel instruisto</div>
    <div class="form-group row">
      <label class="col-5 col-form-label" for="instruisto">
        Mi estas instruisto
      </label>
      <div class="col-7">
        <div class="form-group form-check">
          <input
            id="instruisto"
            type="checkbox"
            class="form-check-input"
            name="user[instruisto]"
            value="true"
            :checked="this.instruistoChecked"
            v-model="instruistoChecked"
          />
        </div>
      </div>
    </div>
    <div v-if="instruistoChecked">
      <div class="form-group row">
        <label class="col-5 col-form-label">Nivelo</label>
        <div class="col-7">
          <div class="btn-group btn-group-toggle mb-1" data-toggle="buttons">
            <label class="btn button-checkbox--main" :class="{ active: baza }">
              <input type="checkbox" name="nivelo[baza]" :checked="baza" />
              Baza
            </label>
            <label class="btn button-checkbox--main" :class="{ active: meza }">
              <input type="checkbox" name="nivelo[meza]" :checked="meza" />
              Meza
            </label>
            <label class="btn button-checkbox--main" :class="{ active: supera }">
              <input type="checkbox" name="nivelo[supera]" :checked="supera" />
              Supera
            </label>
          </div>
        </div>
      </div>
      <div class="form-group row">
        <label class="col-md-5 col-form-label" for="instru_sperto">
          Sperto
        </label>
        <div class="col-md-7">
          <div class="form-group">
            <textarea
              id="instru_sperto"
              name="instru_sperto"
              class="form-control"
              rows="3"
              placeholder="Skribu pri via sperto kiel instruisto."
              v-model="sperto"
            ></textarea>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'InstruadoForm',
  props: {
    instruo: {
      type: Object,
      required: true,
    },
  },
  data() {
    return {
      instruistoChecked: false,
      baza: true,
      meza: false,
      supera: false,
      sperto: '',
    }
  },
  mounted() {
    if (this.instruo.instruisto !== undefined) {
      this.instruistoChecked = this.instruo.instruisto === 'true'
    }

    if (this.instruo.nivelo !== undefined) {
      this.baza = this.instruo.nivelo.includes('baza')
      this.meza = this.instruo.nivelo.includes('meza')
      this.supera = this.instruo.nivelo.includes('supera')
    }

    if (this.instruo.sperto !== undefined) {
      this.sperto = this.instruo.sperto
    }
  },
}
</script>

<style scoped></style>
